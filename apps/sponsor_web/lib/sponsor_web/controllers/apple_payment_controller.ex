defmodule Tankste.SponsorWeb.ApplePaymentController do
  use Tankste.SponsorWeb, :controller

  def notify(conn, params) do
    IO.inspect(conn)
    IO.inspect(params)
  end
end
