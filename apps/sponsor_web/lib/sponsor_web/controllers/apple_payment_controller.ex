defmodule Tankste.SponsorWeb.ApplePaymentController do
  use Tankste.SponsorWeb, :controller

  def notify(conn, %{"signedPayload" => payload}) do
    payload
    |> String.split(".")
    |> Enum.at(1)
    |> Base.decode64!()
    |> Poison.decode!()
    |> IO.inspect

    conn
    |> send_resp(204, "")
  end
  def notify(conn, _) do
    conn
    |> put_status(422)
    |> put_view(ChangesetView)
    |> render("errors.json", validations: [signedPayload: {"invalid value", [validation: :invalid]}])
  end
end
