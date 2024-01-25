defmodule Tankste.ReportWeb.ReportView do
  use Tankste.ReportWeb, :view

  def render("index.json", %{reports: reports}) do
    render_many(reports, Tankste.ReportWeb.ReportView, "report.json")
  end

  def render("show.json", %{report: report}) do
    render_one(report, Tankste.ReportWeb.ReportView, "report.json")
  end

  def render("report.json", %{report: report}) do
    %{
      "id" => report.id,
      "stationId" => report.station_id,
      "deviceId" => report.device_id,
      "originId" => report.origin_id,
      "field" => report.field,
      "wrongValue" => report.wrong_value,
      "correctValue" => report.correct_value,
      "reportedToOriginDate" => report.reported_to_origin_date,
      "status" => report.status,
      "createdAt" => report.inserted_at,
      "updatedAt" => report.updated_at
    }
	end
end
