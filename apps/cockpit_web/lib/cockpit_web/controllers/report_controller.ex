defmodule Tankste.CockpitWeb.ReportController do
  use Tankste.CockpitWeb, :controller

  alias Tankste.Report.Reports

  def index(conn, _params) do
    reports = Reports.list()
    render(conn, :index, reports: reports)
  end
end
