defmodule Tankste.SponsorWeb.PlayPaymentController do
  use Tankste.SponsorWeb, :controller

  alias Tankste.Sponsor.PlayReceipts
  alias Tankste.Sponsor.Transactions

  def notify(conn, params) do
    IO.inspect conn
    IO.inspect params
    case Map.get(params, "data") do
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

  # (2) SUBSCRIPTION_RENEWED - An active subscription was renewed.
  # (7) SUBSCRIPTION_RESTARTED - User has reactivated their subscription from Play > Account > Subscriptions (requires opt-in for subscription restoration).
  # (1) SUBSCRIPTION_RECOVERED - A subscription was recovered from account hold.
  #
  # Availble types: https://developer.android.com/google/play/billing/rtdn-reference
  defp handle_subscription_notification(%{"notificationType" => type, "subscriptionId" => product_id, "purchaseToken" => secret}) when type in [2, 7, 1] do
    with :ok <- PlayReceipts.verify_and_acknowledge_subscription(product_id, secret),
      {:ok, _transaction} <- Transactions.create(%{"type" => "sponsor", "category" => "google", "value" => value_from_product(product_from_google_id(product_id))})
    do
      :ok
    else
      error ->
        error
    end
  end
  defp handle_subscription_notification(_), do: :ok

  defp product_from_google_id("app.tankste.sponsor.sub.monthly.1"), do: "sponsor_subscription_monthly_1"
  defp product_from_google_id("app.tankste.sponsor.sub.monthly.2"), do: "sponsor_subscription_monthly_2"
  defp product_from_google_id(_), do: nil

  defp value_from_product("sponsor_subscription_monthly_1"), do: 1
  defp value_from_product("sponsor_subscription_monthly_2"), do: 2
  defp value_from_product(_), do: 0
end
