defmodule Tankste.FillWeb.StationProcessor do
  use GenStage

  alias Tankste.Station.Stations
  alias Tankste.Station.StationInfos
  alias Tankste.Station.StationInfos.StationInfo
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

  defp upsert_station(new_station_info) do
    result = case StationInfos.get_by_external_id(new_station_info["originId"], new_station_info["externalId"]) do
        nil ->
          case Stations.create() do
            {:ok, station} ->
              StationInfos.create(%{
                station_id: station.id,
                external_id: new_station_info["externalId"],
                origin_id: new_station_info["originId"],
                name: new_station_info["name"],
                brand: new_station_info["brand"],
                location_latitude: new_station_info["locationLatitude"],
                location_longitude: new_station_info["locationLongitude"],
                address_street: new_station_info["addressStreet"],
                address_house_number: new_station_info["addressHouseNumber"],
                address_post_code: new_station_info["addressPostCode"],
                address_city: new_station_info["addressCity"],
                address_country: new_station_info["addressCountry"],
                currency: new_station_info["currency"],
                last_changes_at: new_station_info["lastChangesDate"] || DateTime.utc_now()
              })
            {:error, changeset} ->
              {:error, changeset}
          end
        station_info ->
          StationInfos.update(station_info, %{
            name: new_station_info["name"],
            brand: new_station_info["brand"],
            location_latitude: new_station_info["locationLatitude"],
            location_longitude: new_station_info["locationLongitude"],
            address_street: new_station_info["addressStreet"],
            address_house_number: new_station_info["addressHouseNumber"],
            address_post_code: new_station_info["addressPostCode"],
            address_city: new_station_info["addressCity"],
            address_country: new_station_info["addressCountry"],
            currency: new_station_info["currency"],
            last_changes_at: last_changes_date(station_info, new_station_info)
          })
      end

    # # TODO: remove old open times, remove old areas
    case result do
      {:ok, station_info} ->
        case upsert_open_times(station_info.id, new_station_info["openTimes"]) do
          :ok ->
            case upsert_areas(station_info.id, new_station_info["areaKeys"]) do
              :ok ->
                {:ok, station_info}
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

  defp last_changes_date(station_info, %{"lastChangesDate" => nil} = new_station_info) do
    changeset = StationInfo.changeset(station_info, %{
      name: new_station_info["name"],
      brand: new_station_info["brand"],
      location_latitude: new_station_info["locationLatitude"],
      location_longitude: new_station_info["locationLongitude"],
      address_street: new_station_info["addressStreet"],
      address_house_number: new_station_info["addressHouseNumber"],
      address_post_code: new_station_info["addressPostCode"],
      address_city: new_station_info["addressCity"],
      address_country: new_station_info["addressCountry"],
      currency: new_station_info["currency"]
    })

    case changeset do
      %Ecto.Changeset{changes: %{}} ->
        station_info.last_changes_at
      _ ->
        DateTime.utc_now()
    end
  end
  defp last_changes_date(_station_info, %{"lastChangesDate" => last_changes}) do
    last_changes
  end
  defp last_changes_date(station_info, new_station_info), do: last_changes_date(station_info, new_station_info |> Map.put("lastChangesDate", nil))

  defp upsert_open_times(station_info_id, new_open_times, existing_open_times \\ nil)
  defp upsert_open_times(_, [], _), do: :ok
  defp upsert_open_times(station_info_id, new_open_times, nil) do
    existing_open_times = OpenTimes.list(station_info_id: station_info_id)
    upsert_open_times(station_info_id, new_open_times, existing_open_times)
  end
  defp upsert_open_times(station_info_id, [new_open_time|new_open_times], existing_open_times) do
    result = case Enum.find(existing_open_times, fn ot -> ot.day == new_open_time["day"] end) do
        nil ->
          OpenTimes.insert(%{
            station_info_id: station_info_id,
            day: new_open_time["day"],
            start_time: new_open_time["startTime"],
            end_time: new_open_time["endTime"]
          })
        open_time ->
          OpenTimes.update(open_time, %{
            day: new_open_time["day"],
            start_time: new_open_time["startTime"],
            end_time: new_open_time["endTime"]
          })
      end

    case result do
      {:ok, _open_time} ->
        upsert_open_times(station_info_id, new_open_times, existing_open_times)
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp upsert_areas(station_info_id, new_area_keys, existing_areas \\ nil)
  defp upsert_areas(station_info_id, new_area_keys, nil) do
    existing_areas = StationAreas.list(station_info_id: station_info_id)
    upsert_areas(station_info_id, new_area_keys, existing_areas)
  end
  defp upsert_areas(_station_info_id, [], _existing_areas), do: :ok
  defp upsert_areas(station_info_id, [new_area_key|new_area_keys], existing_areas) do
    case new_area_key |> Areas.get_by_key(new_area_key) do
      nil ->
        {:error, :invalid_area_key}
      area ->
        result = case Enum.find(existing_areas, fn sa -> sa.area_id == area.id end) do
            nil ->
              StationAreas.create(%{
                station_info_id: station_info_id,
                area_id: area.id
              })
            station_area ->
              # Only n-2-n table. No update needed.
              {:ok, station_area}
          end

        case result do
          {:ok, _station_area} ->
            upsert_areas(station_info_id, new_area_keys, existing_areas)
          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end
end
