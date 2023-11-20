defmodule Tankste.SponsorWeb.HealthController do
  use Tankste.SponsorWeb, :controller

  alias Tankste.Sponsor.Transactions

  def show(conn, _params) do
    Transactions.list()

    conn
    |> text("OK")
  end
end
