defmodule Tankste.StationWeb.StationPriceController do
  use Tankste.StationWeb, :controller

  import Tankste.StationWeb.StationController, only: [load_station: 2, station_info: 1]

  alias Tankste.Station.Prices
  alias Tankste.Station.Prices.Price

  plug :load_station, [station_id: "station_id"]

  def index(conn, %{"station_id" => station_id}) do
    prices = Prices.list(station_id: station_id) |> Enum.filter(fn p -> not Price.is_outdated?(p) end)
    prices = case station_info(conn).is_open do
        true ->
          prices
          |> Enum.sort_by(fn p -> p.priority end, :desc)
          |> Enum.uniq_by(fn p -> p.type end)
        _ ->
          []
      end

    render(conn, "index.json", prices: prices)
  end
end
