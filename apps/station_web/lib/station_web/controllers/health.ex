defmodule Tankste.StationWeb.HealthController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Stations

  def show(conn, _params) do
    Stations.list()

    conn
    |> text("OK")
  end
end
