defmodule Tankste.StationWeb.PriceView do
  use Tankste.StationWeb, :view

  def render("price.json", %{price: price}) do
    %{
      "id" => price.id,
      "stationId" => price.station_id,
      "originId" => price.origin_id,
      "type" => case price.type do # needed for apps with app version lower 2.2.0
        "petrol_super_e5" -> "e5"
        "petrol_super_e10" -> "e10"
        other -> other
      end,
      "label" => price.label,
      "price" => price.price,
      "lastChangesAt" => price.last_changes_at,
      "createdAt" => price.inserted_at,
      "updatedAt" => price.updated_at
    }
	end
end
