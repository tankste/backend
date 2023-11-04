defmodule Tankste.StationWeb.PriceView do
  use Tankste.StationWeb, :view

  def render("price.json", %{price: price}) do
    %{
      "id" => price.id,
      "stationId" => price.station_id,
      "origin" => price.origin,
      "e5Price" => price.e5_price,
      "e10Price" => price.e10_price,
      "dieselPrice" => price.diesel_price,
      "lastChangesAt" => price.last_changes_at,
      "createdAt" => price.inserted_at,
      "updatedAt" => price.updated_at
    }
	end
end
