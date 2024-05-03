defmodule Tankste.CockpitWeb.StationController do
  use Tankste.CockpitWeb, :controller

  alias Tankste.Station.Repo
  alias Tankste.Station.StationInfos

  def index(conn, _params) do
    station_infos = StationInfos.list()
    |> Enum.sort_by(fn si -> si.priority end, :desc)
    |> Enum.uniq_by(fn si -> si.station_id end)
    |> Repo.preload([:station])

    render(conn, :index, station_infos: station_infos)
  end
end
