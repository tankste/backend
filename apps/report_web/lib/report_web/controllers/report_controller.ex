defmodule Tankste.ReportWeb.ReportController do
  use Tankste.ReportWeb, :controller

  import Tankste.ReportWeb.OriginTokenPlug

  alias Tankste.ReportWeb.ReportOpts
  alias Tankste.Report.Reports
  alias Tankste.Station.StationInfos
  alias Tankste.Station.OpenTimes
  alias Tankste.Station.Prices
  alias Tankste.ReportWeb.ChangesetView

  plug :load_report when action in [:show, :update, :delete]
  plug :load_origin when action in [:update]
  plug :require_current_origin when action in [:update]

  def index(conn, params) do
    reports = ReportOpts.opts(params)
      |> Reports.list()
    render(conn, "index.json", reports: reports)
  end

  def show(conn, %{"id" => id}) do
    report = Reports.get(id)
    render(conn, "show.json", report: report)
  end

  def create(conn, params) do
    case Reports.create(%{"device_id" => params["deviceId"], "station_id" => params["stationId"], "origin_id" => origin_of_station_field(params["stationId"], params["field"]), "field" => params["field"], "wrong_value" => value_of_station_field(params["stationId"], params["field"]), "correct_value" => params["correctValue"], "status" => "open"}) do
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

  defp origin_of_station_field(station_id, "name"), do: station_info_origin(station_id)
  defp origin_of_station_field(station_id, "brand"), do: station_info_origin(station_id)
  defp origin_of_station_field(station_id, "availability"), do: station_info_origin(station_id)
  defp origin_of_station_field(station_id, "location_latitude"), do: station_info_origin(station_id)
  defp origin_of_station_field(station_id, "location_longitude"), do: station_info_origin(station_id)
  defp origin_of_station_field(station_id, "address_street"), do: station_info_origin(station_id)
  defp origin_of_station_field(station_id, "address_house_number"), do: station_info_origin(station_id)
  defp origin_of_station_field(station_id, "address_post_code"), do: station_info_origin(station_id)
  defp origin_of_station_field(station_id, "address_city"), do: station_info_origin(station_id)
  defp origin_of_station_field(station_id, "address_country"), do: station_info_origin(station_id)
  defp origin_of_station_field(station_id, "open_times"), do: station_info_origin(station_id)
  defp origin_of_station_field(station_id, "open_times_state"), do: station_info_origin(station_id)
  defp origin_of_station_field(station_id, "price_e5"), do: price_origin(station_id, "e5")
  defp origin_of_station_field(station_id, "price_e10"), do: price_origin(station_id, "e10")
  defp origin_of_station_field(station_id, "price_diesel"), do: price_origin(station_id, "diesel")
  defp origin_of_station_field(station_id, "note"), do: station_info_origin(station_id)
  defp origin_of_station_field(_, _), do: nil

  defp station_info_origin(station_id) do
    case get_station_info(station_id) do
      nil ->
        nil
      station_info ->
        station_info.origin_id
    end
  end

  defp price_origin(station_id, type) do
    case Prices.list(station_id: station_id) do
      nil ->
        nil
      [] ->
        nil
      prices ->
        case prices |> Enum.find(fn p -> p.type == type end) do
          nil ->
            nil
          price ->
            price.origin_id
        end
    end
  end

  defp value_of_station_field(station_id, "name") do
    case get_station_info(station_id) do
      nil ->
        nil
      station_info ->
        station_info.name
    end
  end
  defp value_of_station_field(station_id, "brand") do
    case get_station_info(station_id) do
      nil ->
        nil
        station_info ->
          station_info.brand
    end
  end
  defp value_of_station_field(station_id, "location_latitude") do
    case get_station_info(station_id) do
      nil ->
        nil
      station_info ->
        Float.to_string(station_info.location_latitude)
    end
  end
  defp value_of_station_field(station_id, "location_longitude") do
    case get_station_info(station_id) do
      nil ->
        nil
      station_info ->
        Float.to_string(station_info.location_longitude)
    end
  end
  defp value_of_station_field(station_id, "address_street") do
    case get_station_info(station_id) do
      nil ->
        nil
      station_info ->
        station_info.address_street
    end
  end
  defp value_of_station_field(station_id, "address_house_number") do
    case get_station_info(station_id) do
      nil ->
        nil
      station_info ->
        station_info.address_house_number
    end
  end
  defp value_of_station_field(station_id, "address_post_code") do
    case get_station_info(station_id) do
      nil ->
        nil
      station_info ->
        station_info.address_post_code
    end
  end
  defp value_of_station_field(station_id, "address_city") do
    case get_station_info(station_id) do
      nil ->
        nil
      station_info ->
        station_info.address_city
    end
  end
  defp value_of_station_field(station_id, "address_country") do
    case get_station_info(station_id) do
      nil ->
        nil
      station_info ->
        station_info.address_country
    end
  end
  defp value_of_station_field(station_id, "open_times_state") do
    case get_station_info(station_id) do
      nil ->
        nil
      station_info ->
        OpenTimes.is_open(station_info)
        |> to_string()
    end
  end
  defp value_of_station_field(station_id, "open_times") do
    case get_station_info(station_id) do
      nil ->
        nil
      station_info ->
        case OpenTimes.list(station_info_id: station_info.station_id) do
          nil ->
            nil
          [] ->
            nil
          open_times ->
            open_times
            |> Enum.map(fn ot -> "#{ot.day}: #{ot.start_time} - #{ot.end_time}" end)
            |> Enum.join(", ")
        end
    end
  end
  defp value_of_station_field(station_id, "price_e5") do
    case Prices.list(station_id: station_id) do
      nil ->
        nil
      [] ->
        nil
      prices ->
        case prices |> Enum.find(fn p -> p.type == "e5" end) do
          nil ->
            nil
          price ->
            Float.to_string(price |> Map.get(:price))
        end
    end
  end
  defp value_of_station_field(station_id, "price_e10") do
    case Prices.list(station_id: station_id) do
      nil ->
        nil
      [] ->
        nil
      prices ->
        case prices |> Enum.find(fn p -> p.type == "e10" end) do
          nil ->
            nil
          price ->
            Float.to_string(price |> Map.get(:price))
        end
    end
  end
  defp value_of_station_field(station_id, "price_diesel") do
    case Prices.list(station_id: station_id) do
      nil ->
        nil
      [] ->
        nil
      prices ->
        case prices |> Enum.find(fn p -> p.type == "diesel" end) do
          nil ->
            nil
          price ->
            Float.to_string(price |> Map.get(:price))
      end
    end
  end
  defp value_of_station_field(_, "availability"), do: "available"
  defp value_of_station_field(_, "note") do
    "-"
  end
  defp value_of_station_field(_, _), do: nil

  defp get_station_info(station_id) do
    StationInfos.list(station_id: station_id)
    |> Enum.max_by(fn si -> si.priority end)
  end

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
