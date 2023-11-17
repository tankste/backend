defmodule Tankste.StationWeb.PriceView do
  use Tankste.StationWeb, :view

  def render("price.json", %{price: price}) do
    %{
      "id" => price.id,
      "stationId" => price.station_id,
      "origin" => price.origin,
      "type" => price.type,
      "lastChangesAt" => price.last_changes_at,
      "createdAt" => price.inserted_at,
      "updatedAt" => price.updated_at
    }
	end
end
