defmodule Tankste.SponsorWeb.BalanceView do
  use Tankste.SponsorWeb, :view

  def render("show.json", %{balance: balance}) do
    render_one(balance, Tankste.SponsorWeb.BalanceView, "balance.json")
  end

  def render("balance.json", %{balance: balance}) do
    %{
      earned: balance.earned,
      spentFixed: balance.spent_fixed,
      spentVariable: balance.spent_variable,
      balance: balance.balance,
    }
	end
end
