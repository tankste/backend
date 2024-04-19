defmodule Tankste.StationWeb.StationController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Stations
  alias Tankste.Station.StationInfos
  alias Tankste.Station.OpenTimes

  plug :load_station when action in [:show]

  def show(conn, _params) do
    conn
    |> put_view(Tankste.StationWeb.StationInfoView)
    |> render("show.json", station_info: station_info(conn))
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
        case StationInfos.get_by_station_id(station_id) do
          nil ->
            conn
            |> put_status(:not_found)
            |> put_view(ErrorView)
            |> render("404.json")
            |> halt

          station_info ->
            station_info = station_info
            |> Map.put(:is_open, OpenTimes.is_open(station_info))

            conn
            |> assign(:station, station)
            |> assign(:station_info, station_info)
        end
    end
  end

  def station(conn), do: Map.get(conn.assigns, :station)

  def station_info(conn), do: Map.get(conn.assigns, :station_info)
end
