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
    Origins.list()
    Stations.list()
    Prices.list()
    OpenTimes.list()
    Markers.list()
    Holidays.list()

    conn
    |> text("OK")
  end
end
