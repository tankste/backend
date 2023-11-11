defmodule Tankste.FillWeb.StationProcessor do
  use GenServer

  alias Tankste.Station.Stations

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def update(stations) do
    GenServer.cast(__MODULE__, {:update, stations})
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:update, stations}, state) do
    upsert_stations(stations)
    {:noreply, state}
  end

  defp upsert_stations(new_stations, existing_stations \\ nil)
  defp upsert_stations([], _), do: :ok
  defp upsert_stations(new_stations, nil) do
    existing_stations = Stations.list(external_id: Enum.map(new_stations, fn s -> s["externalId"] end))
    upsert_stations(new_stations, existing_stations)
  end
  defp upsert_stations([new_station|new_stations], existing_stations) do
    result = case Enum.find(existing_stations, fn s -> s.external_id == new_station["externalId"] end) do
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
          last_changes_at: DateTime.utc_now()
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
          last_changes_at: DateTime.utc_now()
        })
    end

    case result do
      {:ok, _station} ->
        upsert_stations(new_stations, existing_stations)
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
