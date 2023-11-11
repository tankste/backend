defmodule Tankste.StationWeb.MarkerController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Stations
  alias Tankste.Station.Prices
  alias Tankste.StationWeb.Marker

  # TODO: limit requests to max ~0.2 degree
  # TODO: fall back request
  def index(conn, %{"boundary" => boundary_param}) do
    boundary = boundary_param
      |> Enum.map(fn b -> b |> String.split(",") |> Enum.map(&String.to_float/1) end)
      |> Enum.map(fn b -> List.to_tuple(b) end)

    stations = Stations.list(boundary: boundary)

    prices = Prices.list(station_id: Enum.map(stations, fn s -> s.id end))

    markers = Enum.map(stations, fn station ->
      case Enum.find(prices, fn p -> p.station_id == station.id end) do
        nil ->
          %Marker{
            id: station.id,
            label: station.brand || station.name,
            latitude: station.location_latitude,
            longitude: station.location_longitude,
            e5_price: nil,
            e5_price_state: :none,
            e10_price: nil,
            e10_price_state: :none,
            diesel_price: nil,
            diesel_price_state: :none
          }
        price ->
          %Marker{
            id: station.id,
            label: station.brand || station.name,
            latitude: station.location_latitude,
            longitude: station.location_longitude,
            e5_price: price.e5_price,
            e5_price_state: price.e5_price_comparison,
            e10_price: price.e10_price,
            e10_price_state: price.e10_price_comparison,
            diesel_price: price.diesel_price,
            diesel_price_state: price.diesel_price_comparison
          }
      end
    end)

    render(conn, "index.json", markers: markers)
  end
end
