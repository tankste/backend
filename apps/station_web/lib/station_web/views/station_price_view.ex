defmodule Tankste.StationWeb.StationPriceView do
  use Tankste.StationWeb, :view

  def render("index.json", %{prices: prices}) do
    render_many(prices, Tankste.StationWeb.PriceView, "price.json")
  end

  def render("show.json", %{price: price}) do
    render_one(price, Tankste.StationWeb.PriceView, "price.json")
  end
end
