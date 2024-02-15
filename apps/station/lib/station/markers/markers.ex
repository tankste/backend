defmodule Tankste.Station.Markers do

  alias Tankste.Station.Markers.Marker
  alias Tankste.Station.Stations
  alias Tankste.Station.OpenTimes
  alias Tankste.Station.Repo

  @station_distance_comparing_meters 20_000 # 20 kilometers
  @station_area_radius_degrees 0.3 # ~ 30 kilomters

  # def gen_by_boundary(boundary) do
  #   reduced_boundary = min_max_boundary(boundary)

  #   scope_stations = Stations.list(status: "available", boundary: reduced_boundary |> boundary_with_padding())
  #   |> Repo.preload(:open_times)
  #   |> Enum.map(fn s -> %{s | is_open: OpenTimes.is_open(s)} end)
  #   |> Repo.preload(:prices)

  #   comparing_stations = scope_stations
  #     |> Enum.filter(fn s -> s.is_open end)

  #   scope_stations
  #     |> Enum.filter(fn s -> in_boundary({s.location_latitude, s.location_longitude}, reduced_boundary) end)
  #     |> Enum.map(fn s -> gen_marker(s, comparing_stations) end)
  # end

  def gen_by_boundary(boundary) do
    {time, reduced_boundary} = :timer.tc(fn -> min_max_boundary(boundary) end)
    # IO.puts("reduced_boundary: #{time / 1_000_000}")

    {time, scope_stations} = :timer.tc(fn -> Stations.list(status: "available", boundary: reduced_boundary |> boundary_with_padding()) end)
    # IO.puts("scope_stations_1: #{time / 1_000_000}")

    {time, scope_stations} = :timer.tc(fn -> scope_stations |> Repo.preload(:open_times) end)
    # IO.puts("scope_stations_2: #{time / 1_000_000}")

    {time, scope_stations} = :timer.tc(fn -> scope_stations |> Enum.map(fn s -> %{s | is_open: OpenTimes.is_open(s)} end) end)
    # IO.puts("scope_stations_3: #{time / 1_000_000}")

    {time, scope_stations} = :timer.tc(fn -> scope_stations |> Repo.preload(:prices) end)
    # IO.puts("scope_stations_4: #{time / 1_000_000}")

    {time, comparing_stations} = :timer.tc(fn ->
      scope_stations
      |> Enum.filter(fn s -> s.is_open end)
    end)
    IO.puts("comparing_stations: #{time / 1_000_000}")

    {time, result} = :timer.tc(fn ->
      scope_stations
      |> Enum.filter(fn s -> in_boundary({s.location_latitude, s.location_longitude}, reduced_boundary) end)
      |> Enum.map(fn s -> gen_marker(s, comparing_stations) end)
    end)
    IO.puts("result: #{time / 1_000_000}")

    result
  end

  def gen_by_station_id(station_id) do
    station = Stations.get(station_id, status: "available")
    station = station
      |> Map.put(:is_open, OpenTimes.is_open(station))
      |> Repo.preload(:prices)

    scope_boundary = [{station.location_latitude, station.location_longitude}, {station.location_latitude, station.location_longitude}]
      |> boundary_with_padding()

    comparing_stations = Stations.list(status: "available", boundary: scope_boundary)
      |> Enum.map(fn s -> %{s | is_open: OpenTimes.is_open(s)} end)
      |> Enum.filter(fn s -> s.is_open end)
      |> Repo.preload(:prices)

      gen_marker(station, comparing_stations)
  end

  defp min_max_boundary(boundary) do
      min_lat = boundary |> Enum.map(fn c -> latitude_param(c) end) |> Enum.min()
      max_lat = boundary |> Enum.map(fn c -> latitude_param(c) end) |> Enum.max()
      min_lng = boundary |> Enum.map(fn c -> longitude_param(c) end) |> Enum.min()
      max_lng = boundary |> Enum.map(fn c -> longitude_param(c) end) |> Enum.max()

      [{min_lat, min_lng }, {max_lat, max_lng}]
  end

  defp in_boundary({latitude, longitude}, [{min_lat, min_lng}, {max_lat, max_lng}]) do
    latitude >= min_lat and latitude <= max_lat and longitude >= min_lng and longitude <= max_lng
  end

  defp boundary_with_padding([{min_lat, min_lng}, {max_lat, max_lng}]) do
    [{min_lat - @station_area_radius_degrees, min_lng - @station_area_radius_degrees}, {max_lat + @station_area_radius_degrees, max_lng + @station_area_radius_degrees}]
  end

  defp latitude_param({latitude, _}), do: latitude
  defp longitude_param({_, longitude}), do: longitude

  defp gen_marker(station, comparing_stations) do
    near_stations = comparing_stations
      |> Enum.filter(fn s -> Geocalc.within?(@station_distance_comparing_meters, [s.location_longitude, s.location_latitude], [station.location_longitude, station.location_latitude]) end)

    case station.is_open do
      true ->
        %Marker{
          id: station.id,
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
        }
      _ ->
        %Marker{
          id: station.id,
          station_id: station.id,
          label: station.brand || station.name,
          latitude: station.location_latitude,
          longitude: station.location_longitude,
          e5_price: nil,
          e5_price_comparison: "not_available",
          e10_price: nil,
          e10_price_comparison: "not_available",
          diesel_price: nil,
          diesel_price_comparison: "not_available"
        }
    end
  end

  # TODO: don't compare with closed stations!!!1!1!
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
