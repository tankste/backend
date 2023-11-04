defmodule Tankste.StationWeb.MarkerController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Stations
  alias Tankste.Station.Prices
  alias Tankste.StationWeb.Marker

  def index(conn, _params) do
    stations = Stations.list()
      |> Enum.slice(0, 5)

    prices = Prices.list(station_id: Enum.map(stations, fn s -> s.id end))

    markers = Enum.map(stations, fn station ->
      case Enum.find(prices, fn p -> p.station_id == station.id end) do
        nil ->
          %Marker{
            id: station.id,
            name: station.name,
            brand: station.brand,
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
            name: station.name,
            brand: station.brand,
            latitude: station.location_latitude,
            longitude: station.location_longitude,
            e5_price: price.e5_price,
            e5_price_state: price.e5_price_comparison,
            e10_price: price.e10_price,
            e10_price_state: :e10_price_comparison,
            diesel_price: price.diesel_price,
            diesel_price_state: :diesel_price_comparison
          }
      end
    end)

    render(conn, "index.json", markers: markers)
  end
end
