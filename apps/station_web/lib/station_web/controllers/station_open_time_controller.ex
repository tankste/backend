defmodule Tankste.StationWeb.StationOpenTimeController do
  use Tankste.StationWeb, :controller

  import Tankste.StationWeb.StationController, only: [load_station: 2, station_info: 1]

  alias Tankste.Station.OpenTimes

  plug :load_station, [station_id: "station_id"]

  def index(conn, _params) do
    open_times = OpenTimes.list(station_info_id: station_info(conn).id)
    open_times = open_times
      |> Enum.map(fn ot -> Map.put(ot, :origin_id, station_info(conn).origin_id) end)
      |> Enum.map(fn ot -> Map.put(ot, :is_today, OpenTimes.is_today(ot, open_times)) end)

    render(conn, "index.json", open_times: open_times)
  end
end
