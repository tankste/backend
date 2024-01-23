defmodule Tankste.StationWeb.MarkerController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Markers
  alias Tankste.Station.Markers.Marker
  alias Tankste.Station.Stations
  alias Tankste.Station.OpenTimes
  alias Tankste.Station.StationAreas
  alias Tankste.Station.Holidays
  alias Tankste.Station.Repo

  @station_distance_comparing_meters 20_000 # 20 kilometers
  @station_area_radius_degrees 0.3 # ~ 30 kilomters

  def index(conn, %{"boundary" => boundary_param}) do
    boundary = boundary_param
      |> Enum.map(fn b -> b |> String.split(",") |> Enum.map(&String.to_float/1) end)
      |> Enum.map(fn b -> List.to_tuple(b) end)

    markers = Stations.list(boundary: boundary)
      |> Repo.preload(:prices)
      |> Enum.map(&gen_marker/1)
      |> Enum.map(&override_states/1)

    render(conn, "index.json", markers: markers)
  end

  # # TODO: limit requests to max ~0.2 degree
  # # TODO: fall back request
  # def index(conn, %{"boundary" => boundary_param}) do
  #   boundary = boundary_param
  #     |> Enum.map(fn b -> b |> String.split(",") |> Enum.map(&String.to_float/1) end)
  #     |> Enum.map(fn b -> List.to_tuple(b) end)

  #   markers = Markers.list(boundary: boundary)
  #     |> Enum.map(&override_states/1)

  #   render(conn, "index.json", markers: markers)
  # end

  defp override_states(marker) do
    case is_open(marker) do
      true ->
        marker
      false ->
        marker
        |> Map.put(:e5_price, nil)
        |> Map.put(:e5_price_comparison, "not_available")
        |> Map.put(:e10_price, nil)
        |> Map.put(:e10_price_comparison, "not_available")
        |> Map.put(:diesel_price, nil)
        |> Map.put(:diesel_price_comparison, "not_Available")
    end
  end

  # TODO: use time zone based on station location
  defp is_open(marker) do
    case StationAreas.list(station_id: marker.station_id) do
      [] ->
        is_in_open_time(marker, :today)
      station_areas ->
        case Holidays.list(date: DateTime.now!("Europe/Berlin") |> DateTime.to_date(), area_id: station_areas |> Enum.map(fn sa -> sa.area_id end)) do
          [] ->
            is_in_open_time(marker, :today)
          _holidays ->
            is_in_open_time(marker, :holiday)
        end
    end
  end

  # TODO: use time zone based on station location
  defp is_in_open_time(marker, :today) do
    now = DateTime.now!("Europe/Berlin")
    time_now = now |> DateTime.to_time()
    OpenTimes.list(station_id: marker.station_id, day: now |> DateTime.to_date() |> Date.day_of_week() |> day())
    |> Enum.any?(fn t -> t.start_time == t.end_time or (t.start_time <= time_now && t.end_time >= time_now) end)
  end
  defp is_in_open_time(marker, :holiday) do
    time_now =  DateTime.now!("Europe/Berlin") |> DateTime.to_time()
    OpenTimes.list(station_id: marker.station_id, day: "public_holiday")
    |> Enum.any?(fn t -> t.start_time == t.end_time or (t.start_time <= time_now && t.end_time >= time_now) end)
  end

  defp day(1), do: "monday"
  defp day(2), do: "tuesday"
  defp day(3), do: "wednesday"
  defp day(4), do: "thursday"
  defp day(5), do: "friday"
  defp day(6), do: "saturday"
  defp day(7), do: "sunday"
  defp day(_), do: nil

  # Runtime calculation parts

  defp gen_marker(station) do
    near_stations = Stations.list(boundary: [{station.location_latitude - @station_area_radius_degrees, station.location_longitude - @station_area_radius_degrees}, {station.location_latitude + @station_area_radius_degrees, station.location_longitude + @station_area_radius_degrees}])
    |> Enum.filter(fn s -> Geocalc.within?(@station_distance_comparing_meters, [s.location_longitude, s.location_latitude], [station.location_longitude, station.location_latitude]) end)
    |> Repo.preload(:prices)

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
