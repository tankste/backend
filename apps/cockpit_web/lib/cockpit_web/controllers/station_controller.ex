defmodule Tankste.CockpitWeb.StationController do
  use Tankste.CockpitWeb, :controller

  import Tankste.CockpitWeb.AuthPlug

  alias Tankste.Station.Repo
  alias Tankste.Station.Stations
  alias Tankste.Station.StationInfos

  plug :load_current_user
  plug :require_current_user

  # TODO: clean up paging logic, too messy output today
  def index(conn, params) do
    search = Map.get(params, "search")

    all_station_infos = StationInfos.list(search: search)
    |> Enum.sort_by(fn si -> si.priority end, :desc)
    |> Enum.uniq_by(fn si -> si.station_id end)

    page = Map.get(params, "page", "0") |> String.to_integer()
    page_start = page * 50
    page_end = page_start + 49

    page_station_infos = all_station_infos |> Enum.slice(page_start..page_end) |> Repo.preload([:station])
    page_count = (page_station_infos |> length())
    stations_count = all_station_infos |> length()

    render(
      conn,
      :index,
      page_station_infos: page_station_infos,
      stations_count: stations_count,
      page_start: page_start,
      page_end: page_start + page_count - 1,
      previous_page: case page do
          0 -> nil
          _ -> page - 1
        end,
      next_page: case page_start + page_count do
          ^stations_count ->
            nil
          _ -> page + 1
        end,
      search: search || ""
    )
  end

  def show(conn, %{"id" => id}) do
    station = Stations.get(id)
    station_infos = StationInfos.list(station_id: id) |> Repo.preload([:origin]) |> Enum.sort_by(fn si -> si.priority end, :desc)
    render(conn, :show, station: station, station_infos: station_infos)
  end

  def edit(conn, %{"id" => id}) do
    station = Stations.get(id)
    changeset = Stations.change(station)
    render(conn, :edit, station: station, changeset: changeset)
  end

  def update(conn, %{"id" => id, "station" => station_params}) do
    station = Stations.get(id)
    case Stations.update(station, %{:status => station_params["status"]}) do
      {:ok, station} ->
        conn
        |> put_flash(:info, gettext("Station status updated successfully."))
        |> redirect(to: ~p"/stations/#{station.id}")
      {:error, changeset} ->
        render(conn, :edit, station: station, changeset: changeset)
    end
  end
end
