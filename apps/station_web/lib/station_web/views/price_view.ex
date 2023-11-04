defmodule Tankste.StationWeb.PriceView do
  use Tankste.StationWeb, :view

  def render("price.json", %{price: price}) do
    %{
      "id" => price.id,
      "stationId" => price.station_id,
      "origin" => price.origin,
      "e5Price" => price.e5_price,
      "e5PriceComparison" => price.e5_price_comparison,
      "e10Price" => price.e10_price,
      "e10PriceComparison" => price.e10_price_comparison,
      "dieselPrice" => price.diesel_price,
      "dieselPriceComparison" => price.diesel_price_comparison,
      "lastChangesAt" => price.last_changes_at,
      "createdAt" => price.inserted_at,
      "updatedAt" => price.updated_at
    }
	end
end
