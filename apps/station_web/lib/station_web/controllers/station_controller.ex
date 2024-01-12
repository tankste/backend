defmodule Tankste.StationWeb.StationController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Stations

  def show(conn, %{"id" => station_id}) do
    station = Stations.get(station_id, status: "available")
    render(conn, "show.json", station: station)
  end
end
