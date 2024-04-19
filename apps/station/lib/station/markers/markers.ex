defmodule Tankste.Station.Markers do

  alias Tankste.Station.Markers.Marker
  alias Tankste.Station.Stations
  alias Tankste.Station.StationInfos
  alias Tankste.Station.OpenTimes
  alias Tankste.Station.Repo

  @station_distance_comparing_meters 20_000 # 20 kilometers
  @station_area_radius_degrees 0.3 # ~ 30 kilomters

  def gen_by_boundary(boundary) do
    reduced_boundary = min_max_boundary(boundary)

    scope_station_infos = StationInfos.list(boundary: reduced_boundary |> boundary_with_padding())
      |> Enum.sort_by(fn si -> si.priority end, :desc)
      |> Enum.uniq_by(fn si -> si.station_id end)
      |> Repo.preload([:station, :open_times, station_areas: [area: [:holidays]]])
      |> Enum.filter(fn si -> si.station.status == "available" end)
      |> Enum.map(fn si -> %{si | is_open: OpenTimes.is_open(si)} end)
      |> Repo.preload(station: [:prices])

      comparing_station_infos = scope_station_infos
        |> Enum.filter(fn si -> si.is_open end)

        scope_station_infos
      |> Enum.filter(fn si -> in_boundary({si.location_latitude, si.location_longitude}, reduced_boundary) end)
      |> Enum.map(fn si -> gen_marker(si, comparing_station_infos) end)
  end

  def gen_by_station_id(station_id) do
    station_info = StationInfos.list(station_id: station_id)
      |> Enum.sort_by(fn si -> si.priority end, :desc)
      |> Repo.preload(:station)
      |> Enum.filter(fn si -> si.station.status == "available" end)
      |> Enum.at(0)
      |> Repo.preload([:open_times, station_areas: [area: [:holidays]]])

    station_info = station_info
      |> Map.put(:is_open, OpenTimes.is_open(station_info))
      |> Repo.preload(station: [:prices])

    scope_boundary = [{station_info.location_latitude, station_info.location_longitude}, {station_info.location_latitude, station_info.location_longitude}]
      |> boundary_with_padding()

    comparing_station_infos = StationInfos.list(boundary: scope_boundary)
      |> Enum.sort_by(fn si -> si.priority end, :desc)
      |> Enum.uniq_by(fn si -> si.station_id end)
      |> Repo.preload([:station, :open_times, station_areas: [area: [:holidays]]])
      |> Enum.filter(fn si -> si.station.status == "available" end)
      |> Enum.map(fn si -> %{si | is_open: OpenTimes.is_open(si)} end)
      |> Enum.filter(fn s -> s.is_open end)
      |> Repo.preload(station: [:prices])

      gen_marker(station_info, comparing_station_infos)
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

  defp gen_marker(station_info, comparing_station_infos) do
    near_station_infos = comparing_station_infos
      |> Enum.filter(fn si -> Geocalc.within?(@station_distance_comparing_meters, [si.location_longitude, si.location_latitude], [station_info.location_longitude, station_info.location_latitude]) end)

    case station_info.is_open do
      true ->
        %Marker{
          id: station_info.station_id,
          station_id: station_info.station_id,
          label: station_info.brand || station_info.name,
          latitude: station_info.location_latitude,
          longitude: station_info.location_longitude,
          e5_price: get_price(station_info, "e5"),
          e5_price_comparison: get_price_comparison(station_info, "e5", near_station_infos),
          e10_price: get_price(station_info, "e10"),
          e10_price_comparison: get_price_comparison(station_info, "e10", near_station_infos),
          diesel_price: get_price(station_info, "diesel"),
          diesel_price_comparison: get_price_comparison(station_info, "diesel", near_station_infos),
          currency: station_info.currency
        }
      _ ->
        %Marker{
          id: station_info.station_id,
          station_id: station_info.station_id,
          label: station_info.brand || station_info.name,
          latitude: station_info.location_latitude,
          longitude: station_info.location_longitude,
          e5_price: nil,
          e5_price_comparison: "not_available",
          e10_price: nil,
          e10_price_comparison: "not_available",
          diesel_price: nil,
          diesel_price_comparison: "not_available",
          currency: station_info.currency
        }
    end
  end

  defp get_price(station_info, type) do
    case Enum.find(station_info.station.prices, fn p -> p.type == type end) do
    nil ->
      nil
    price ->
      price.price
    end
  end

  defp get_price_comparison(station_info, type, near_station_infos) do
    near_prices = near_station_infos
      |> Enum.flat_map(fn si -> si.station.prices end)
      |> Enum.filter(fn p -> p.type == type end)
      |> Enum.map(fn p -> p.price end)

    case get_price(station_info, type) do
      nil ->
        "not_available"
      price_value ->
        min_price = near_prices
          |> Enum.min()

        cond do
          min_price + get_price_medium_threshold_value(station_info.currency) >= price_value -> "cheap"
          min_price + get_price_expensive_threshold_value(station_info.currency) >= price_value -> "medium"
          true -> "expensive"
        end
    end
  end

  defp get_price_medium_threshold_value("eur"), do: 0.04
  defp get_price_medium_threshold_value("isk"), do: 6.01
  defp get_price_medium_threshold_value(_), do: 0.00

  defp get_price_expensive_threshold_value("eur"), do: 0.10
  defp get_price_expensive_threshold_value("isk"), do: 15.03
  defp get_price_expensive_threshold_value(_), do: 0.00
end
