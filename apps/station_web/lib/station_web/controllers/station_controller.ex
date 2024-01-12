defmodule Tankste.StationWeb.StationController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Stations

  plug :load_station when action in [:show]

  def show(conn, %{"id" => station_id}) do
    station = Stations.get(station_id, status: "available")
    render(conn, "show.json", station: station)
  end

  def load_station(conn, opts \\ []) do
    station_id_key = Keyword.get(opts, :station_id, "id")
    station_id = Map.get(conn.params, station_id_key, 0)

    case Stations.get(station_id, status: "available") do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.json")
        |> halt

      station ->
        conn
        |> assign(:station, station)
    end
  end

  def station(conn), do: Map.get(conn.assigns, :station)
end
