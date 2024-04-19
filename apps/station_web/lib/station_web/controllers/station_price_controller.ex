defmodule Tankste.StationWeb.StationPriceController do
  use Tankste.StationWeb, :controller

  import Tankste.StationWeb.StationController, only: [load_station: 2, station_info: 1]

  alias Tankste.Station.Prices

  plug :load_station, [station_id: "station_id"]

  def index(conn, %{"station_id" => station_id}) do
    prices = Prices.list(station_id: station_id)
    prices = case station_info(conn).is_open do
        true ->
          prices
        _ ->
          []
      end

    render(conn, "index.json", prices: prices)
  end
end
