defmodule Tankste.FillWeb.StationController do
  use Tankste.FillWeb, :controller

  alias Tankste.FillWeb.StationProcessor

  # def index(conn, _params) do
  #   stations = Tankste.Station.Stations.list()
  #   render(conn, "index.json", stations: stations)
  # end

  # TODO: auth + param validating
  # TODO: crawler header for origin
  # TODO: crawler token

  def update(conn, %{"_json" => stations}) when is_list(stations) do
    StationProcessor.update(stations)
    conn
    |> put_status(:no_content)
    |> send_resp(204, "")
  end
  def update(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json")
  end

  def delete(conn, _params) do
    # externalIds = []
    conn
  end
end
