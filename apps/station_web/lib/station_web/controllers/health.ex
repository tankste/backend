defmodule Tankste.StationWeb.HealthController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Origins
  alias Tankste.Station.Stations
  alias Tankste.Station.Prices
  alias Tankste.Station.OpenTimes
  alias Tankste.Station.Markers
  alias Tankste.Station.Holidays

  # TODO: add query limits do prevent fetching too much data
  def show(conn, _params) do
    Origins.list(limit: 10)
    Stations.list(limit: 10)
    Prices.list(limit: 10)
    OpenTimes.list(limit: 10)
    Holidays.list(limit: 10)

    conn
    |> text("OK")
  end
end
