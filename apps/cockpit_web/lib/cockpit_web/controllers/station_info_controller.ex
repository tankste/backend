defmodule Tankste.CockpitWeb.StationInfoController do
  use Tankste.CockpitWeb, :controller

  import Tankste.CockpitWeb.AuthPlug

  alias Tankste.Station.Stations
  alias Tankste.Station.StationInfos
  alias Tankste.Station.Origins

  plug :load_current_user
  plug :require_current_user

  def show(conn, %{"station_id" => station_id, "id" => station_info_id}) do
    station = Stations.get(station_id)
    station_info = StationInfos.get(station_info_id)
    max_priority = StationInfos.list(station_id: station_id) |> Enum.map(fn si -> si.priority end) |> Enum.max()
    origin = Origins.get(station_info.origin_id)
    render(conn, :show, station: station, station_info: station_info, origin: origin, max_priority: max_priority)
  end
end
