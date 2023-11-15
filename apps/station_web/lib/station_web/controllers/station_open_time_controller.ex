defmodule Tankste.StationWeb.StationOpenTimeController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.OpenTimes

  # TODO: load station by plug

  def index(conn, %{"station_id" => station_id}) do
    open_times = OpenTimes.list(station_id: station_id)
    render(conn, "index.json", open_times: open_times)
  end
end
