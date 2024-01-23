defmodule Tankste.StationWeb.StationMarkerController do
  use Tankste.StationWeb, :controller

  import Tankste.StationWeb.StationController, only: [load_station: 2, station: 1]

  alias Tankste.Station.Markers

  plug :load_station, [station_id: "station_id"]

  def show(conn, _params) do
    marker = conn
      |> station()
      |> Map.get(:id)
      |> Markers.gen_by_station_id()
    render(conn, "show.json", marker: marker)
  end
end
