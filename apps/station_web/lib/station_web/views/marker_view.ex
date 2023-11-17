defmodule Tankste.StationWeb.MarkerView do
  use Tankste.StationWeb, :view

  def render("index.json", %{markers: markers}) do
    render_many(markers, Tankste.StationWeb.MarkerView, "marker.json")
  end

  def render("marker.json", %{marker: marker}) do
    %{
      "id" => marker.id,
      "label" => marker.label,
      "latitude" => marker.latitude,
      "longitude" => marker.longitude,
      "e5Price" => marker.e5_price,
      "e5PriceState" => marker.e5_price_comparison,
      "e10Price" => marker.e10_price,
      "e10PriceState" => marker.e10_price_comparison,
      "dieselPrice" => marker.diesel_price,
      "dieselPriceState" => marker.diesel_price_comparison,
      "createdAt" => marker.inserted_at,
      "updatedAt" => marker.updated_at
    }
	end
end
