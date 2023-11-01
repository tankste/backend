defmodule Tankste.StationWeb.StationController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Stations

  def index(conn, _params) do
    stations = Tankste.Station.Stations.list()
    render(conn, "index.json", stations: stations)
  end
end
