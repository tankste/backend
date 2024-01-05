defmodule Tankste.StationWeb.OriginController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Origins

  def index(conn, _params) do
    origins = Origins.list()
    render(conn, "index.json", origins: origins)
  end

  def show(conn, %{"id" => origin_id}) do
    origin = Origins.get(origin_id)
    render(conn, "show.json", origin: origin)
  end
end
