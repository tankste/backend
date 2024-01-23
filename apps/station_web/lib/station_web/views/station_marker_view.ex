defmodule Tankste.StationWeb.StationMarkerView do
  use Tankste.StationWeb, :view

  def render("show.json", %{marker: marker}) do
    render_one(marker, Tankste.StationWeb.MarkerView, "marker.json")
  end
end
