defmodule Tankste.CockpitWeb.HealthController do
  use Tankste.CockpitWeb, :controller

  # alias Tankste.Report.Reports
  # alias Tankste.Station.Stations
  # alias Tankste.Station.OpenTimes
  # alias Tankste.Station.Prices

  def show(conn, _params) do
    # Reports.list(limit: 10)
    # Stations.list(limit: 10)
    # OpenTimes.list(limit: 10)
    # Prices.list(limit: 10)

    conn
    |> text("OK")
  end
end
