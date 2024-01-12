defmodule Tankste.FillWeb.HealthController do
  use Tankste.FillWeb, :controller

  alias Tankste.Station.Origins
  alias Tankste.Station.Stations
  alias Tankste.Station.Prices
  alias Tankste.Station.OpenTimes
  alias Tankste.Station.Markers
  alias Tankste.Station.Areas
  alias Tankste.Station.Holidays

  # TODO: add query limits do prevent fetching too much data
  def show(conn, _params) do
    Origins.list()
    Stations.list()
    Prices.list()
    OpenTimes.list()
    Markers.list()
    Areas.list()
    Holidays.list()

    conn
    |> text("OK")
  end
end
