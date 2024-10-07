defmodule Tankste.CockpitWeb.StationInfoController do
  use Tankste.CockpitWeb, :controller

  import Tankste.CockpitWeb.AuthPlug

  alias Tankste.Station.Stations
  alias Tankste.Station.StationInfos
  alias Tankste.Station.Origins

  plug :load_current_user
  plug :require_current_user

  def show(conn, %{"station_id" => station_id, "id" => station_info_id}) do
    station = Stations.get(station_id)
    station_info = StationInfos.get(station_info_id)
    max_priority = StationInfos.list(station_id: station_id) |> Enum.map(fn si -> si.priority end) |> Enum.max()
    origin = Origins.get(station_info.origin_id)
    render(conn, :show, station: station, station_info: station_info, origin: origin, max_priority: max_priority)
  end

  def edit(conn, %{"station_id" => station_id, "id" => station_info_id}) do
    station = Stations.get(station_id)
    station_info = StationInfos.get(station_info_id)
    changeset = StationInfos.change(station_info)
    render(conn, :edit, station: station, station_info: station_info, changeset: changeset)
  end

  def update(conn, %{"station_id" => station_id, "id" => station_info_id, "station_info" => station_info_params}) do
    station = Stations.get(station_id)
    station_info = StationInfos.get(station_info_id)
    case StationInfos.update(station_info, %{
        :priority => station_info_params["priority"],
        :name => station_info_params["name"],
        :brand => station_info_params["brand"],
        :location_latitude => station_info_params["location_latitude"],
        :location_longitude => station_info_params["location_longitude"],
        :address_street => station_info_params["address_street"],
        :address_house_number => station_info_params["address_house_number"],
        :address_post_code => station_info_params["address_post_code"],
        :address_city => station_info_params["address_city"],
        :address_country => station_info_params["address_country"],
        :currency => station_info_params["currency"],
      }) do
      {:ok, station} ->
        conn
        |> put_flash(:info, gettext("Station info updated successfully."))
        |> redirect(to: ~p"/stations/#{station.id}/infos/#{station_info.id}")
      {:error, changeset} ->
        render(conn, :edit, station: station, changeset: changeset)
    end
  end
end
