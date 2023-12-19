defmodule Tankste.ReportWeb.HealthController do
  use Tankste.ReportWeb, :controller

  alias Tankste.Report.Reports

  def show(conn, _params) do
    Reports.list()

    conn
    |> text("OK")
  end
end
