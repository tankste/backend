defmodule Tankste.StationWeb.StationController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Stations

  # TODO: remove this endpoint
  def index(conn, _params) do
    stations = Stations.list(status: "available")
    render(conn, "index.json", stations: stations)
  end

  def show(conn, %{"id" => station_id}) do
    station = Stations.get(station_id, status: "available")
    render(conn, "show.json", station: station)
  end
end
