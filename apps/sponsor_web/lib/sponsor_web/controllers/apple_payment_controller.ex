defmodule Tankste.SponsorWeb.ApplePaymentController do
  use Tankste.SponsorWeb, :controller

  alias Tankste.Sponsor.AppleReceipts
  alias Tankste.Sponsor.Purchases
  alias Tankste.Sponsor.Transactions
  alias Tankste.Sponsor.Comments
  alias Tankste.Sponsor.Sponsorships
  alias Tankste.SponsorWeb.ChangesetView

  def notify(conn, %{"signedPayload" => payload}) do
    File.write("/tmp/apple-payment.txt", payload)

    notification = payload
      |> String.split(".")
      |> Enum.at(1)
      |> Base.url_decode64!(padding: false)
      |> Poison.decode!()

    transaction = notification
      |> Map.get("data")
      |> Map.get("signedTransactionInfo")
      |> String.split(".")
      |> Enum.at(1)
      |> Base.url_decode64!(padding: false)
      |> Poison.decode!()

    handle_subscription_notification(notification["notificationType"], transaction, payload)

    conn
    |> send_resp(204, "")
  end
  def notify(conn, _) do
    conn
    |> put_status(422)
    |> put_view(ChangesetView)
    |> render("errors.json", validations: [signedPayload: {"invalid value", [validation: :invalid]}])
  end

  # DID_RENEW - An active subscription was renewed.
  #
  # Availble types: https://developer.apple.com/documentation/appstoreservernotifications/notificationtype#possibleValues
  defp handle_subscription_notification("DID_RENEW", %{"productId" => product_id, "appAccountToken" => device_id}, data) do
    with {:ok, purchase} <- Purchases.create(%{"device_id" => device_id, "product" => product_from_apple_id(product_id), "provider" => "apple_store", "type" => "subscription"}),
      {:ok, _receipt} <- AppleReceipts.create(%{"purchase_id" => purchase.id, "product_id" => product_id, "data" => data}),
      {:ok, _sponsorship} <- update_sponsorship(device_id, purchase.product),
      {:ok, _transaction} <- Transactions.create(%{"type" => "sponsor", "category" => "apple", "value" => value_from_product(product_id)}),
      {:ok, _comment} <- update_comment(device_id, value_from_product(purchase.product))
    do
      :ok
    else
      error ->
        error
    end
  end
  defp handle_subscription_notification(_, _, _), do: :ok

  defp update_sponsorship(device_id, product) do
    case Sponsorships.get_by_device_id(device_id) do
      nil ->
        {:ok, nil}
      sponsorship ->
        # TODO: set updated subscription expiration date
        Sponsorships.update(sponsorship, %{"value" => sponsorship.value + value_from_product(product)})
    end
  end

  defp update_comment(device_id, product) do
    case Comments.get_by_device_id(device_id) do
      nil ->
        {:ok, nil}
      comment ->
        Comments.update(comment, %{"value" => comment.value + value_from_product(product)})
    end
  end

  defp product_from_apple_id("app.tankste.sponsor.sub.monthly.1"), do: "sponsor_subscription_monthly_1"
  defp product_from_apple_id("app.tankste.sponsor.sub.monthly.2"), do: "sponsor_subscription_monthly_2"
  defp product_from_apple_id("app.tankste.sponsor.sub.yearly.12"), do: "sponsor_subscription_yearly_12"
  defp product_from_apple_id(_), do: nil

  defp value_from_product("sponsor_subscription_monthly_1"), do: 1
  defp value_from_product("sponsor_subscription_monthly_2"), do: 2
  defp value_from_product("sponsor_subscription_yearly_12"), do: 12
  defp value_from_product(_), do: 0
end
