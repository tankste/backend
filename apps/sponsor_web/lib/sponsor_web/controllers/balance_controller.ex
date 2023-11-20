defmodule Tankste.SponsorWeb.BalanceController do
  use Tankste.SponsorWeb, :controller

  alias Tankste.Sponsor.Balances

  def show(conn, _params) do
    balance = Balances.get()
    render(conn, "show.json", balance: balance)
  end
end
