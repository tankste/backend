defmodule Tankste.FillWeb.StationProcessor do
  use GenStage

  alias Tankste.Station.Stations
  alias Tankste.Station.Stations.Station
  alias Tankste.Station.Areas
  alias Tankste.Station.StationAreas
  alias Tankste.Station.OpenTimes

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, [])
  end

  @impl true
  def init(_args) do
    {:consumer, [], subscribe_to: [{Tankste.FillWeb.StationQueue, [max_demand: 1_000]}]}
  end

  @impl true
  def handle_events(stations, _from, _state) do
    process_stations(stations)
  end

  defp process_stations([]) do
    {:noreply, [], []}
  end
  defp process_stations([station|stations]) do
    case upsert_station(station) do
      {:ok, _updated_station} ->
        process_stations(stations)
      {:error, changeset} ->
        IO.inspect(changeset)
        {:stop, :failed, []}
    end
  end

  defp upsert_station(new_station) do
    result = case Stations.get_by_external_id(new_station["externalId"]) do
        nil ->
          Stations.insert(%{
            external_id: new_station["externalId"],
            origin_id: new_station["originId"],
            name: new_station["name"],
            brand: new_station["brand"],
            location_latitude: new_station["locationLatitude"],
            location_longitude: new_station["locationLongitude"],
            address_street: new_station["addressStreet"],
            address_house_number: new_station["addressHouseNumber"],
            address_post_code: new_station["addressPostCode"],
            address_city: new_station["addressCity"],
            address_country: new_station["addressCountry"],
            currency: new_station["currency"],
            last_changes_at: new_station["lastChangesDate"] || DateTime.utc_now()
          })
        station ->
          Stations.update(station, %{
            name: new_station["name"],
            brand: new_station["brand"],
            location_latitude: new_station["locationLatitude"],
            location_longitude: new_station["locationLongitude"],
            address_street: new_station["addressStreet"],
            address_house_number: new_station["addressHouseNumber"],
            address_post_code: new_station["addressPostCode"],
            address_city: new_station["addressCity"],
            address_country: new_station["addressCountry"],
            currency: new_station["currency"],
            last_changes_at: last_changes_date(station, new_station)
          })
      end

    # # TODO: remove old open times, remove old areas
    case result do
      {:ok, station} ->
        case upsert_open_times(station.id, new_station["originId"], new_station["openTimes"]) do
          :ok ->
            case upsert_areas(station.id, new_station["areaKeys"]) do
              :ok ->
                {:ok, station}
              {:error, changeset} ->
                {:error, changeset}
            end
          {:error, changeset} ->
            {:error, changeset}
        end
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp last_changes_date(station, %{"lastChangesDate" => nil} = new_station) do
    changeset = Station.changeset(station, %{
      name: new_station["name"],
      brand: new_station["brand"],
      location_latitude: new_station["locationLatitude"],
      location_longitude: new_station["locationLongitude"],
      address_street: new_station["addressStreet"],
      address_house_number: new_station["addressHouseNumber"],
      address_post_code: new_station["addressPostCode"],
      address_city: new_station["addressCity"],
      address_country: new_station["addressCountry"],
      currency: new_station["currency"]
    })

    case changeset do
      %Ecto.Changeset{changes: %{}} ->
        station.last_changes_at
      _ ->
        DateTime.utc_now()
    end
  end
  defp last_changes_date(_station, %{"lastChangesDate" => last_changes}) do
    last_changes
  end
  defp last_changes_date(station, new_station), do: last_changes_date(station, new_station |> Map.put("lastChangesDate", nil))

  defp upsert_open_times(station_id, origin_id, new_open_times, existing_open_times \\ nil)
  defp upsert_open_times(_, _, [], _), do: :ok
  defp upsert_open_times(station_id, origin_id, new_open_times, nil) do
    existing_open_times = OpenTimes.list(station_id: station_id)
    upsert_open_times(station_id, origin_id, new_open_times, existing_open_times)
  end
  defp upsert_open_times(station_id, origin_id, [new_open_time|new_open_times], existing_open_times) do
    result = case Enum.find(existing_open_times, fn ot -> ot.day == new_open_time["day"] end) do
        nil ->
          OpenTimes.insert(%{
            station_id: station_id,
            origin_id: origin_id,
            day: new_open_time["day"],
            start_time: new_open_time["startTime"],
            end_time: new_open_time["endTime"]
          })
        open_time ->
          OpenTimes.update(open_time, %{
            station_id: station_id,
            origin_id: origin_id,
            day: new_open_time["day"],
            start_time: new_open_time["startTime"],
            end_time: new_open_time["endTime"]
          })
      end

    case result do
      {:ok, _open_time} ->
        upsert_open_times(station_id, origin_id, new_open_times, existing_open_times)
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp upsert_areas(station_id, new_area_keys, existing_areas \\ nil)
  defp upsert_areas(station_id, new_area_keys, nil) do
    existing_areas = StationAreas.list(station_id: station_id)
    upsert_areas(station_id, new_area_keys, existing_areas)
  end
  defp upsert_areas(_station_id, [], _existing_areas), do: :ok
  defp upsert_areas(station_id, [new_area_key|new_area_keys], existing_areas) do
    case new_area_key |> Areas.get_by_key(new_area_key) do
      nil ->
        {:error, :invalid_area_key}
      area ->
        result = case Enum.find(existing_areas, fn sa -> sa.area_id == area.id end) do
            nil ->
              StationAreas.create(%{
                station_id: station_id,
                area_id: area.id
              })
            station_area ->
              # Only n-2-n table. No update needed.
              {:ok, station_area}
          end

        case result do
          {:ok, _station_area} ->
            upsert_areas(station_id, new_area_keys, existing_areas)
          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end
end
