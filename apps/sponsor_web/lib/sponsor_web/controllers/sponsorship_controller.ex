defmodule Tankste.SponsorWeb.SponsorshipController do
  use Tankste.SponsorWeb, :controller

  alias Tankste.Sponsor.Sponsorships
  alias Tankste.Sponsor.Sponsorships.Sponsorship

  def show(conn, %{"id" => device_id}) do
    sponsorship = case Sponsorships.get_by_device_id(device_id) do
        nil ->
          %Sponsorship{
            device_id: device_id,
            active_subscription_id: nil,
            active_subscription_expiration: nil,
            value: 0.0
          }
        spnsrshp ->
          spnsrshp
      end

    render(conn, "show.json", sponsorship: sponsorship)
  end
end
