defmodule Tankste.FillWeb.MarkerProcessor do
  use GenStage

  alias Tankste.Station.Stations
  alias Tankste.Station.Markers
  alias Tankste.Station.Repo

  @station_distance_comparing_meters 20_000 # 20 kilometers
  @station_area_radius_degrees 0.3 # ~ 30 kilomters

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, [])
  end

  def init(_args) do
    {:consumer, [], subscribe_to: [{Tankste.FillWeb.MarkerQueue, [max_demand: 100]}]}
  end

  def handle_events(stations, _from, _state) do
    stations = stations
    |> Repo.preload(:prices)

    process_stations(stations)
  end

  defp process_stations([]), do: {:noreply, [], []}
  defp process_stations([station|stations]) do
    case upsert_marker(station) do
      {:ok, nil} ->
        process_stations(stations)
      {:ok, _updated_marker} ->
        process_stations(stations)
      {:error, changeset} ->
        IO.inspect(changeset)
        {:stop, :failed, []}
    end
  end

  def upsert_marker(%{:status => status} = station, _) when status != "available" do
    case Markers.get_by_station_id(station.id) do
      nil ->
        {:ok, nil}
      marker ->
        Markers.delete(marker)
    end
  end
  def upsert_marker(station) do
    near_stations = Stations.list(boundary: [{station.location_latitude - @station_area_radius_degrees, station.location_longitude - @station_area_radius_degrees}, {station.location_latitude + @station_area_radius_degrees, station.location_longitude + @station_area_radius_degrees}])
    |> Enum.filter(fn s -> Geocalc.within?(@station_distance_comparing_meters, [s.location_longitude, s.location_latitude], [station.location_longitude, station.location_latitude]) end)
    |> Repo.preload(:prices)

    case Markers.get_by_station_id(station.id) do
      nil ->
        Markers.insert(%{
          station_id: station.id,
          label: station.brand || station.name,
          latitude: station.location_latitude,
          longitude: station.location_longitude,
          e5_price: get_price(station, "e5"),
          e5_price_comparison: get_price_comparison(station, "e5", near_stations),
          e10_price: get_price(station, "e10"),
          e10_price_comparison: get_price_comparison(station, "e10", near_stations),
          diesel_price: get_price(station, "diesel"),
          diesel_price_comparison: get_price_comparison(station, "diesel", near_stations)
        })
      marker ->
        Markers.update(marker, %{
          station_id: station.id,
          label: station.brand || station.name,
          latitude: station.location_latitude,
          longitude: station.location_longitude,
          e5_price: get_price(station, "e5"),
          e5_price_comparison: get_price_comparison(station, "e5", near_stations),
          e10_price: get_price(station, "e10"),
          e10_price_comparison: get_price_comparison(station, "e10", near_stations),
          diesel_price: get_price(station, "diesel"),
          diesel_price_comparison: get_price_comparison(station, "diesel", near_stations)
        })
    end
  end

  defp get_price(station, type) do
    case Enum.find(station.prices, fn p -> p.type == type end) do
      nil ->
        nil
      price ->
        price.price
    end
  end

  defp get_price_comparison(station, type, near_stations) do
    near_prices = near_stations
      |> Enum.flat_map(fn s -> s.prices end)
      |> Enum.filter(fn p -> p.type == type end)
      |> Enum.map(fn p -> p.price end)

    case get_price(station, type) do
      nil ->
        "not_available"
      price_value ->
        min_price = near_prices
          |> Enum.min()

        cond do
          min_price + 0.04 >= price_value -> "cheap"
          min_price + 0.10 >= price_value -> "medium"
          true -> "expensive"
        end
    end
  end
end
