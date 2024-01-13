defmodule Tankste.StationWeb.StationOpenTimeController do
  use Tankste.StationWeb, :controller

  import Tankste.StationWeb.StationController, only: [load_station: 2]

  alias Tankste.Station.OpenTimes

  plug :load_station, [station_id: "station_id"]

  def index(conn, %{"station_id" => station_id}) do
    open_times = OpenTimes.list(station_id: station_id)
    render(conn, "index.json", open_times: open_times)
  end
end
