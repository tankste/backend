defmodule Tankste.StationWeb.StationPriceController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Prices

  # TODO: load station by plug

  def show(conn, %{"station_id" => station_id}) do
    case Prices.get_by_station_id(station_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.json")
      station_price ->
        render(conn, "show.json", station_price: station_price)
    end
  end
end
