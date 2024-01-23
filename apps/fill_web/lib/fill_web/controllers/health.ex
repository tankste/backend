defmodule Tankste.FillWeb.HealthController do
  use Tankste.FillWeb, :controller

  alias Tankste.Station.Origins
  alias Tankste.Station.Stations
  alias Tankste.Station.Prices
  alias Tankste.Station.OpenTimes
  alias Tankste.Station.Areas
  alias Tankste.Station.Holidays

  def show(conn, _params) do
    Origins.list(limit: 10)
    Stations.list(limit: 10)
    Prices.list(limit: 10)
    OpenTimes.list(limit: 10)
    Areas.list(limit: 10)
    Holidays.list(limit: 10)

    conn
    |> text("OK")
  end
end
