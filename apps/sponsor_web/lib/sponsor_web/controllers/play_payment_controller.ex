defmodule Tankste.SponsorWeb.PlayPaymentController do
  use Tankste.SponsorWeb, :controller

  alias Tankste.Sponsor.PlayReceipts
  alias Tankste.Sponsor.Purchases
  alias Tankste.Sponsor.Transactions
  alias Tankste.Sponsor.Comments
  alias Tankste.Sponsor.Sponsorships
  alias Tankste.SponsorWeb.ChangesetView

  def notify(conn, %{"message" => message_params}) do
    case Map.get(message_params, "data") do
      nil ->
        conn
        |> send_resp(204, "")
      data ->
        IO.puts "Purchase notification result ==>"
        data
        |> Base.decode64!()
        |> Poison.decode!()
        |> IO.inspect
        |> Map.get("subscriptionNotification")
        |> handle_subscription_notification()
        |> IO.inspect

        conn
        |> send_resp(204, "")
    end
  end
  def notify(conn, _) do
    conn
    |> put_status(422)
    |> put_view(ChangesetView)
    |> render("errors.json", validations: [message: {"invalid value", [validation: :invalid]}])
  end

  # (2) SUBSCRIPTION_RENEWED - An active subscription was renewed.
  # (7) SUBSCRIPTION_RESTARTED - User has reactivated their subscription from Play > Account > Subscriptions (requires opt-in for subscription restoration).
  # (1) SUBSCRIPTION_RECOVERED - A subscription was recovered from account hold.
  #
  # Availble types: https://developer.android.com/google/play/billing/rtdn-reference
  defp handle_subscription_notification(%{"notificationType" => type, "subscriptionId" => product_id, "purchaseToken" => secret}) when type in [2, 7, 1] do
    with {:ok, subscription} <- PlayReceipts.verify_and_acknowledge_subscription(product_id, secret),
      {:ok, purchase} <- Purchases.create(%{"product" => product_from_google_id(product_id), "provider" => "play_store", "type" => "subscription"}),
      {:ok, _receipt} <- PlayReceipts.create(%{"purchase_id" => purchase.id, "product_id" => product_from_google_id(product_id), "token" => subscription[:order_id], "secret" => secret}),
      {:ok, _sponsorship} <- update_sponsorship(subscription[:external_id], product_from_google_id(product_id)),
      {:ok, _transaction} <- Transactions.create(%{"type" => "sponsor", "category" => "google", "value" => value_from_product(purchase.product)}),
      {:ok, _comment} <- update_comment(subscription[:external_id], product_from_google_id(product_id))
    do
      :ok
    else
      error ->
        error
    end
  end
  defp handle_subscription_notification(_), do: :ok

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

  defp product_from_google_id("app.tankste.sponsor.sub.monthly.1"), do: "sponsor_subscription_monthly_1"
  defp product_from_google_id("app.tankste.sponsor.sub.monthly.2"), do: "sponsor_subscription_monthly_2"
  defp product_from_google_id("app.tankste.sponsor.sub.yearly.12"), do: "sponsor_subscription_yearly_12"
  defp product_from_google_id(_), do: nil

  defp value_from_product("sponsor_subscription_monthly_1"), do: 1
  defp value_from_product("sponsor_subscription_monthly_2"), do: 2
  defp value_from_product("sponsor_subscription_yearly_12"), do: 12
  defp value_from_product(_), do: 0
end
