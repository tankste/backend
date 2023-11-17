defmodule Tankste.FillWeb.StationProcessor do
  use GenServer

  alias Tankste.Station.Stations
  alias Tankste.Station.OpenTimes
  alias Tankste.FillWeb.MarkerProcessor

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{stations: [], processing: false}, name: __MODULE__)
  end

  def add(stations) do
    GenServer.cast(__MODULE__, {:add, stations})
    process()
  end

  defp process() do
    case GenServer.call(__MODULE__, :get_processing) do
      false ->
        GenServer.cast(__MODULE__, :process)
      true ->
        :ok
    end
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get_processing, _from, %{:processing => processing} = state) do
    {:reply, processing, state}
  end

  @impl true
  def handle_cast({:add, add_stations}, %{:stations => stations, :processing => processing}) do
    # TODO: filter duplicated queue entries by externalId
    {:noreply, %{stations: stations ++ add_stations, processing: processing}}
  end
  def handle_cast(:process, %{:stations => []}) do
    MarkerProcessor.update()
    {:noreply, %{stations: [], processing: false}}
  end
  def handle_cast(:process, %{:stations => [station|stations]}) do
    upsert_station(station)
    GenServer.cast(__MODULE__, :process) # Process next item
    {:noreply, %{stations: stations, processing: true}}
  end

  defp upsert_station(new_station) do
    result = case Stations.get_by_external_id(new_station["externalId"]) do
        nil ->
          Stations.insert(%{
            external_id: new_station["externalId"],
            origin: "mtk-s",
            name: new_station["name"],
            brand: new_station["brand"],
            location_latitude: new_station["locationLatitude"],
            location_longitude: new_station["locationLongitude"],
            address_street: new_station["addressStreet"],
            address_house_number: new_station["addressHouseNumber"],
            address_post_code: new_station["addressPostCode"],
            address_city: new_station["addressCity"],
            address_country: new_station["addressCountry"],
            last_changes_at: new_station["lastChangesDate"]
          })
        station ->
          Stations.update(station, %{
            external_id: new_station["externalId"],
            origin: "mtk-s",
            name: new_station["name"],
            brand: new_station["brand"],
            location_latitude: new_station["locationLatitude"],
            location_longitude: new_station["locationLongitude"],
            address_street: new_station["addressStreet"],
            address_house_number: new_station["addressHouseNumber"],
            address_post_code: new_station["addressPostCode"],
            address_city: new_station["addressCity"],
            address_country: new_station["addressCountry"],
            last_changes_at: new_station["lastChangesDate"]
          })
      end

    case result do
      {:ok, station} ->
        case upsert_open_times(station.id, new_station["openTimes"]) do
          :ok ->
            :ok
          {:error, changeset} ->
            IO.inspect(changeset)
            {:error, changeset}
        end
      {:error, changeset} ->
        IO.inspect(changeset)
        {:error, changeset}
    end
  end

  defp upsert_open_times(station_id, new_open_times, existing_open_times \\ nil)
  defp upsert_open_times(_, [], _), do: :ok
  defp upsert_open_times(station_id, new_open_times, nil) do
    existing_open_times = OpenTimes.list(station_id: station_id)
    upsert_open_times(station_id, new_open_times, existing_open_times)
  end
  defp upsert_open_times(station_id, [new_open_time|new_open_times], existing_open_times) do
    result = case Enum.find(existing_open_times, fn ot -> ot.day == new_open_time["day"] end) do
        nil ->
          OpenTimes.insert(%{
            station_id: station_id,
            origin: "mtk-s",
            day: new_open_time["day"],
            start_time: new_open_time["startTime"],
            end_time: new_open_time["endTime"]
          })
        open_time ->
          OpenTimes.update(open_time, %{
            station_id: station_id,
            origin: "mtk-s",
            day: new_open_time["day"],
            start_time: new_open_time["startTime"],
            end_time: new_open_time["endTime"]
          })
      end

    case result do
      {:ok, _open_time} ->
        upsert_open_times(station_id, new_open_times, existing_open_times)
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
