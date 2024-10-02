defmodule Tankste.CockpitWeb.ReportController do
  use Tankste.CockpitWeb, :controller

  import Tankste.CockpitWeb.AuthPlug

  alias Tankste.Report.Reports
  alias Tankste.Station.Stations
  alias Tankste.Station.StationInfos
  alias Tankste.Station.Repo

  plug :load_current_user
  plug :require_current_user

  def index(conn, _params) do
    reports = Reports.list(sort: [{:desc, :inserted_at}])
    render(conn, :index, reports: reports)
  end

  def show(conn, %{"id" => id}) do
    report = Reports.get(id)
    station = Stations.get(report.station_id)
    station_info = StationInfos.get_by_station_id(report.station_id)
    render(conn, :show, report: report, station: station, station_info: station_info)
  end
end
