defmodule Tankste.StationWeb.OpenTimeView do
  use Tankste.StationWeb, :view

  def render("open_time.json", %{open_time: open_time}) do
    %{
      "id" => open_time.id,
      "stationId" => open_time.station_id,
      "origin" => open_time.origin,
      "day" => open_time.day,
      "startTime" => open_time.start_time,
      "endTime" => open_time.end_time,
      "createdAt" => open_time.inserted_at,
      "updatedAt" => open_time.updated_at
    }
	end
end
