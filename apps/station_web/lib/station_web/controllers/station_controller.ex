defmodule Tankste.StationWeb.StationController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Stations
  alias Tankste.Station.OpenTimes

  plug :load_station when action in [:show]

  def show(conn, _params) do
    render(conn, "show.json", station: station(conn))
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
        station = station
          |> Map.put(:is_open, OpenTimes.is_open(station.id))

        conn
        |> assign(:station, station)
    end
  end

  def station(conn), do: Map.get(conn.assigns, :station)
end
