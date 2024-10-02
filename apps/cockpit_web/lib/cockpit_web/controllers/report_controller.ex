defmodule Tankste.CockpitWeb.ReportController do
  use Tankste.CockpitWeb, :controller

  import Tankste.CockpitWeb.AuthPlug

  alias Tankste.Report.Reports
  alias Tankste.Station.Stations
  alias Tankste.Station.StationInfos
  alias Tankste.Station.Origins
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
    origin = Origins.get(report.origin_id)
    render(conn, :show, report: report, station: station, station_info: station_info, origin: origin)
  end

  def edit(conn, %{"id" => id}) do
    report = Reports.get(id)
    changeset = Reports.change(report)
    render(conn, :edit, report: report, changeset: changeset)
  end

  def update(conn, %{"id" => id, "report" => report_params}) do
    report = Reports.get(id)
    case Reports.update(report, %{:status => report_params["status"]}) do
      {:ok, report} ->
        conn
        |> put_flash(:info, gettext("Report status updated successfully."))
        |> redirect(to: ~p"/reports/#{report.id}")
      {:error, changeset} ->
        render(conn, :edit, report: report, changeset: changeset)
    end
  end
end
