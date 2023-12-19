defmodule Tankste.ReportWeb.ReportController do
  use Tankste.ReportWeb, :controller

  alias Tankste.Report.Reports
  alias Tankste.Station.Stations
  alias Tankste.ReportWeb.ChangesetView

  plug :load_report when action in [:show, :update, :delete]

  # TODO: protect update endpoint by secret

  # TODO: add filter for crawlers
  def index(conn, _params) do
    reports = Reports.list()
    render(conn, "index.json", reports: reports)
  end

  def show(conn, %{"id" => id}) do
    report = Reports.get(id)
    render(conn, "show.json", report: report)
  end

  def create(conn, params) do
    # TODO: origin from station
    # TODO: wrong_value from station
    case Reports.create(%{"device_id" => params["deviceId"], "station_id" => params["stationId"], "origin" => origin_of_station(params["stationId"]), "field" => params["field"], "wrong_value" => value_of_station_field(params["stationId"], params["field"]), "correct_value" => params["correctValue"], "status" => "open"}) do
      {:ok, report} ->
        conn
        |> put_status(:created)
        |> render("show.json", report: report)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ChangesetView)
        |> render("errors.json", changeset: changeset)
    end
  end

  defp origin_of_station(station_id) do
    case Stations.get(station_id) do
      nil ->
        nil
      station ->
        station.origin
    end
  end

  defp value_of_station_field(station_id, "name") do
    case Stations.get(station_id) do
      nil ->
        nil
      station ->
        station.name
    end
  end
  defp value_of_station_field(station_id, "brand") do
    case Stations.get(station_id) do
      nil ->
        nil
      station ->
        station.brand
    end
  end
  defp value_of_station_field(station_id, "location_latitude") do
    case Stations.get(station_id) do
      nil ->
        nil
      station ->
        station.location_latitude
    end
  end
  defp value_of_station_field(station_id, "location_longitude") do
    case Stations.get(station_id) do
      nil ->
        nil
      station ->
        station.location_longitude
    end
  end
  defp value_of_station_field(station_id, "address_street") do
    case Stations.get(station_id) do
      nil ->
        nil
      station ->
        station.address_street
    end
  end
  defp value_of_station_field(station_id, "address_house_number") do
    case Stations.get(station_id) do
      nil ->
        nil
      station ->
        station.address_house_number
    end
  end
  defp value_of_station_field(station_id, "address_post_code") do
    case Stations.get(station_id) do
      nil ->
        nil
      station ->
        station.address_post_code
    end
  end
  defp value_of_station_field(station_id, "address_city") do
    case Stations.get(station_id) do
      nil ->
        nil
      station ->
        station.address_city
    end
  end
  defp value_of_station_field(station_id, "address_country") do
    case Stations.get(station_id) do
      nil ->
        nil
      station ->
        station.address_country
    end
  end
  defp value_of_station_field(_, _), do: nil

  def update(conn, params) do
    case Reports.update(report(conn), %{"reported_to_origin_date" => params["reportedToOriginDate"]}) do
      {:ok, report} ->
        conn
        |> render("show.json", report: report)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ChangesetView)
        |> render("errors.json", changeset: changeset)
    end
  end

  def load_report(conn, opts \\ []) do
    report_id_key = Keyword.get(opts, :report_id, "id")
    report_id = Map.get(conn.params, report_id_key, 0)

    case Reports.get(report_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.json")
        |> halt

      report ->
        conn
        |> assign(:report, report)
    end
  end

  def report(conn), do: Map.get(conn.assigns, :report)
end
