defmodule Tankste.FillWeb.HealthController do
  use Tankste.FillWeb, :controller

  alias Tankste.Station.Stations

  def show(conn, _params) do
    Stations.list()

    conn
    |> text("OK")
  end
end
