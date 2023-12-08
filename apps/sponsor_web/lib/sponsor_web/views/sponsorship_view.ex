defmodule Tankste.SponsorWeb.SponsorshipView do
  use Tankste.SponsorWeb, :view

  def render("index.json", %{sponsorships: sponsorships}) do
    render_many(sponsorships, Tankste.SponsorWeb.SponsorshipView, "sponsorship.json")
  end

  def render("show.json", %{sponsorship: sponsorship}) do
    render_one(sponsorship, Tankste.SponsorWeb.SponsorshipView, "sponsorship.json")
  end

  def render("sponsorship.json", %{sponsorship: sponsorship}) do
    %{
      "id" => sponsorship.id,
      "activeSubscriptionId" => active_subscription_id_from_product_id(sponsorship.active_subscription_id),
      "subscriptionExpirationDate" => sponsorship.active_subscription_expiration,
      "value" => sponsorship.value
    }
	end

  defp active_subscription_id_from_product_id("sponsor_subscription_monthly_1"), do: "app.tankste.sponsor.sub.monthly.1"
  defp active_subscription_id_from_product_id("sponsor_subscription_monthly_2"), do: "app.tankste.sponsor.sub.monthly.2"
  defp active_subscription_id_from_product_id("sponsor_subscription_yearly_12"), do: "app.tankste.sponsor.sub.yearly.12"
  defp active_subscription_id_from_product_id(_), do: nil
end
