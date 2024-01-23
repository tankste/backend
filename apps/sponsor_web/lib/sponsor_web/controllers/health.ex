defmodule Tankste.SponsorWeb.HealthController do
  use Tankste.SponsorWeb, :controller

  alias Tankste.Sponsor.Transactions
  alias Tankste.Sponsor.Sponsorships
  alias Tankste.Sponsor.Comments
  # alias Tankste.Sponosr.Purchases
  # alias Tankste.Sponsor.GoogleReceipts
  # alias Tankste.Sponsor.AppleReceipts

  def show(conn, _params) do
    Transactions.list(limit: 10)
    Sponsorships.list(limit: 10)
    Comments.list(limit: 10)
    # TODO: make list() available
    # Purchases.list(limit: 10)
    # GoogleReceipts.list(limit: 10)
    # AppleReceipts.list(limit: 10)

    conn
    |> text("OK")
  end
end
