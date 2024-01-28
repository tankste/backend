defmodule Tankste.SponsorWeb.ApplePaymentTransactionDeviceController do
  use Tankste.SponsorWeb, :controller

  alias Tankste.Sponsor.Purchases
  alias Tankste.Sponsor.AppleReceipts

  def show(conn, %{"transaction_id" => transaction_id}) do
    case AppleReceipts.get_by_transaction_id(transaction_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.json")
        |> halt()
      receipt ->
        case Purchases.get(receipt.purchase_id) do
          nil ->
            conn
            |> put_status(:not_found)
            |> put_view(ErrorView)
            |> render("404.json")
            |> halt()
          purchase ->
            conn
            |> put_status(:ok)
            |> render("show.json", device: %{:id => purchase.device_id})
        end
    end
  end
  def show(conn, _params) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.json")
    |> halt()
  end
end
