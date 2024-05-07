defmodule Tankste.CockpitWeb.ReportController do
  use Tankste.CockpitWeb, :controller

  import Tankste.CockpitWeb.AuthPlug

  alias Tankste.Report.Reports

  plug :load_current_user
  plug :require_current_user

  def index(conn, _params) do
    reports = Reports.list()
    render(conn, :index, reports: reports)
  end
end
