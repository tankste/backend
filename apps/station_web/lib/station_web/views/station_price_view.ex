defmodule Tankste.StationWeb.StationPriceView do
  use Tankste.StationWeb, :view

  def render("index.json", %{station_prices: station_prices}) do
    render_many(station_prices, Tankste.StationWeb.PriceView, "price.json")
  end

  def render("show.json", %{station_price: station_price}) do
    render_one(station_price, Tankste.StationWeb.PriceView, "price.json")
  end
end
