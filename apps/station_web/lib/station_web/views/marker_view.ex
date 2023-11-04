defmodule Tankste.StationWeb.MarkerView do
  use Tankste.StationWeb, :view

  def render("index.json", %{markers: markers}) do
    render_many(markers, Tankste.StationWeb.MarkerView, "marker.json")
  end

  def render("marker.json", %{marker: marker}) do
    %{
      "id" => marker.id,
      "name" => marker.name,
      "brand" => marker.brand,
      "latitude" => marker.latitude,
      "longitude" => marker.longitude,
      "e5Price" => marker.e5_price,
      "e5PriceState" => to_string(marker.e5_price_state),
      "e10Price" => marker.e10_price,
      "e10PriceState" => to_string(marker.e10_price_state),
      "dieselPrice" => marker.diesel_price,
      "dieselPriceState" => to_string(marker.diesel_price_state)
    }
	end
end
