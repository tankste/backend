defmodule Tankste.CockpitWeb.OpenTimeController do
  use Tankste.CockpitWeb, :controller

  import Tankste.CockpitWeb.AuthPlug

  alias Tankste.Station.Stations
  alias Tankste.Station.StationInfos
  alias Tankste.Station.OpenTimes

  plug :load_current_user
  plug :require_current_user

  def new(conn, %{"station_id" => station_id, "station_info_id" => station_info_id}) do
    station = Stations.get(station_id)
    station_info = StationInfos.get(station_info_id)
    changeset = OpenTimes.change()
    render(conn, :new, station: station, station_info: station_info, changeset: changeset)
  end

  def create(conn, %{"station_id" => station_id, "station_info_id" => station_info_id, "open_time" => open_time_params}) do
    station = Stations.get(station_id)
    station_info = StationInfos.get(station_info_id)

    case OpenTimes.create(%{
        :station_info_id => station_info.id,
        :day => open_time_params["day"],
        :start_time => open_time_params["start_time"],
        :end_time => open_time_params["end_time"]
      }) do
      {:ok, _open_time} ->
        conn
        |> put_flash(:info, gettext("Open time create successfully."))
        |> redirect(to: ~p"/stations/#{station.id}/infos/#{station_info.id}")
      {:error, changeset} ->
        render(conn, :new, station: station, station_info: station_info, changeset: changeset)
    end
  end

  def edit(conn, %{"station_id" => station_id, "station_info_id" => station_info_id, "id" => open_time_id}) do
    station = Stations.get(station_id)
    station_info = StationInfos.get(station_info_id)
    open_time = OpenTimes.get(open_time_id)
    changeset = OpenTimes.change(open_time)
    render(conn, :edit, station: station, station_info: station_info, open_time: open_time, changeset: changeset)
  end

  def update(conn, %{"station_id" => station_id, "station_info_id" => station_info_id, "id" => open_time_id, "open_time" => open_time_params}) do
    station = Stations.get(station_id)
    station_info = StationInfos.get(station_info_id)
    open_time = OpenTimes.get(open_time_id)
    case OpenTimes.update(open_time, %{
      :day => open_time_params["day"],
      :start_time => open_time_params["start_time"],
      :end_time => open_time_params["end_time"]
      }) do
      {:ok, _open_time} ->
        conn
        |> put_flash(:info, gettext("Open time updated successfully."))
        |> redirect(to: ~p"/stations/#{station.id}/infos/#{station_info.id}")
      {:error, changeset} ->
        render(conn, :edit, station: station, station_info: station_info, open_time: open_time, changeset: changeset)
    end
  end
end
