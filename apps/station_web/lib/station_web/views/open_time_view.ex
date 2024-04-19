defmodule Tankste.StationWeb.OpenTimeView do
  use Tankste.StationWeb, :view

  def render("open_time.json", %{open_time: open_time}) do
    %{
      "id" => open_time.id,
      "stationInfoId" => open_time.station_info_id,
      "originId" => open_time.origin_id,
      "day" => open_time.day,
      "startTime" => open_time.start_time,
      "endTime" => open_time.end_time,
      "isToday" => open_time.is_today,
      "createdAt" => open_time.inserted_at,
      "updatedAt" => open_time.updated_at
    }
	end
end
