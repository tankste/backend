defmodule Tankste.StationWeb.PriceSnapshotView do
  use Tankste.StationWeb, :view

  def render("price_snapshot.json", %{price_snapshot: price_snapshot}) do
    %{
      "id" => price_snapshot.id,
      "stationId" => price_snapshot.station_id,
      "type" => price_snapshot.type,
      "price" => price_snapshot.price,
      "snapshotDate" => price_snapshot.snapshot_date
    }
	end
end
