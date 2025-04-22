defmodule Tankste.StationWeb.StationPriceSnapshotView do
  use Tankste.StationWeb, :view

  def render("index.json", %{price_snapshots: price_snapshots}) do
    render_many(price_snapshots, Tankste.StationWeb.PriceSnapshotView, "price_snapshot.json")
  end

  def render("show.json", %{price_snapshot: price_snapshot}) do
    render_one(price_snapshot, Tankste.StationWeb.PriceSnapshotView, "price_snapshot.json")
  end
end
