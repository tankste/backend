defmodule Tankste.StationWeb.StationPriceController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Prices

  # TODO: load station by plug

  def index(conn, %{"station_id" => station_id}) do
    prices = Prices.list(station_id: station_id)
    render(conn, "index.json", prices: prices)
  end
end
