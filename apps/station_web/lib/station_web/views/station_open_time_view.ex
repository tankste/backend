defmodule Tankste.StationWeb.StationOpenTimeView do
  use Tankste.StationWeb, :view

  def render("index.json", %{open_times: open_times}) do
    render_many(open_times, Tankste.StationWeb.OpenTimeView, "open_time.json")
  end

  def render("show.json", %{open_time: open_time}) do
    render_one(open_time, Tankste.StationWeb.OpenTimeView, "open_time.json")
  end
end
