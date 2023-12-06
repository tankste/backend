defmodule Tankste.SponsorWeb.PurchaseView do
  use Tankste.SponsorWeb, :view

  def render("index.json", %{purchases: purchases}) do
    render_many(purchases, Tankste.SponsorWeb.PurchaseView, "purchase.json")
  end

  def render("show.json", %{purchase: purchase}) do
    render_one(purchase, Tankste.SponsorWeb.PurchaseView, "purchase.json")
  end

  def render("purchase.json", %{purchase: purchase}) do
    %{
      "id" => purchase.id,
      "product" => purchase.product,
      "provider" => purchase.provider,
      "type" => purchase.type
    }
	end
end
