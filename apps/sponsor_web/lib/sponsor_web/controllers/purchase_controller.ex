defmodule Tankste.SponsorWeb.PurchaseController do
  use Tankste.SponsorWeb, :controller

  alias Tankste.Sponsor.Purchases
  alias Tankste.Sponsor.AppleReceipts
  alias Tankste.Sponsor.PlayReceipts
  alias Tankste.Sponsor.Transactions
  alias Tankste.Sponsor.Comments
  alias Tankste.Sponsor.Sponsorships

  def create(conn, %{"provider" => "apple_store"} = purchase_params) do
    case AppleReceipts.verify(purchase_params["data"]) do
      :ok ->
        conn
        |> create_apple_purchase(purchase_params)
      _ ->
        conn
        |> put_status(422)
        |> put_view(ChangesetView)
        |> render("errors.json", validations: [data: {"can not verified", [validation: :not_verified]}])
    end
  end
  def create(conn, %{"provider" => "play_store"} = purchase_params) do
    case type_from_product(product_from_google_id(purchase_params["productId"])) do
      "single" ->
        conn
        |> verify_play_product(purchase_params)
      "subscription" ->
        conn
        |> verify_play_subscription(purchase_params)
      _ ->
        conn
        |> put_status(422)
        |> put_view(ChangesetView)
        |> render("errors.json", validations: [product: {"invalid value", [validation: :invalid]}])
    end
  end
  def create(conn, _purchase_params) do
    conn
    |> put_status(422)
    |> put_view(ChangesetView)
    |> render("errors.json", validations: [provider: {"invalid value", [validation: :invalid]}])
  end

  defp create_apple_purchase(conn, purchase_params) do
    with {:ok, purchase} <- Purchases.create(%{"device_id" => purchase_params["deviceId"], "product" => product_from_apple_id(purchase_params["productId"]), "provider" => "apple_store", "type" => type_from_product(product_from_apple_id(purchase_params["productId"]))}),
      {:ok, _receipt} <- AppleReceipts.create(%{"purchase_id" => purchase.id, "product_id" => purchase_params["productId"], "transaction_id" => purchase_params["transactionId"], "data" => purchase_params["data"]}),
      {:ok, _sponsorship} <- upsert_sponsorship(purchase_params["deviceId"], purchase.product),
      {:ok, _transaction} <- Transactions.create(%{"type" => "sponsor", "category" => "apple", "value" => value_from_product(purchase.product)}),
      {:ok, _comment} <- upsert_comment(purchase_params["deviceId"], value_from_product(purchase.product))
    do
      conn
      |> render("show.json", purchase: purchase)
    else
      {:error, changeset} ->
        IO.inspect(changeset)
        conn
        |> put_status(422)
        |> put_view(ChangesetView)
        |> render("errors.json", changeset: changeset)
    end
  end

  defp product_from_apple_id("app.tankste.sponsor.product.10"), do: "sponsor_single_10"
  defp product_from_apple_id("app.tankste.sponsor.sub.monthly.1"), do: "sponsor_subscription_monthly_1"
  defp product_from_apple_id("app.tankste.sponsor.sub.monthly.2"), do: "sponsor_subscription_monthly_2"
  defp product_from_apple_id("app.tankste.sponsor.sub.yearly.12"), do: "sponsor_subscription_yearly_12"
  defp product_from_apple_id(_), do: nil

  defp verify_play_product(conn, purchase_params) do
    case PlayReceipts.verify_and_acknowledge_and_consume_product(purchase_params["productId"], purchase_params["secret"]) do
      {:ok, _} ->
        conn
        |> create_play_purchase(purchase_params)
      error ->
        IO.inspect(error)
        conn
        |> put_status(422)
        |> put_view(ChangesetView)
        |> render("errors.json", validations: [data: {"can not verified", [validation: :not_verified]}])
    end
  end

  defp verify_play_subscription(conn, purchase_params) do
    case PlayReceipts.verify_and_acknowledge_subscription(purchase_params["productId"], purchase_params["secret"]) do
      {:ok, _} ->
        conn
        |> create_play_purchase(purchase_params)
      error ->
        IO.inspect(error)
        conn
        |> put_status(422)
        |> put_view(ChangesetView)
        |> render("errors.json", validations: [data: {"can not verified", [validation: :not_verified]}])
    end
  end

  defp create_play_purchase(conn, purchase_params) do
    with {:ok, purchase} <- Purchases.create(%{"device_id" => purchase_params["deviceId"], "product" => product_from_google_id(purchase_params["productId"]), "provider" => "play_store", "type" => type_from_product(product_from_google_id(purchase_params["productId"]))}),
      {:ok, _receipt} <- PlayReceipts.create(%{"purchase_id" => purchase.id, "product_id" => purchase_params["productId"], "token" => purchase_params["token"], "secret" => purchase_params["secret"]}),
      {:ok, _sponsorship} <- upsert_sponsorship(purchase_params["deviceId"], purchase.product),
      {:ok, _transaction} <- Transactions.create(%{"type" => "sponsor", "category" => "google", "value" => value_from_product(purchase.product)}),
      {:ok, _comment} <- upsert_comment(purchase_params["deviceId"], value_from_product(purchase.product))
    do
      conn
      |> render("show.json", purchase: purchase)
    else
      {:error, changeset} ->
        IO.inspect(changeset)
        conn
        |> put_status(422)
        |> put_view(ChangesetView)
        |> render("errors.json", changeset: changeset)
    end
  end

  defp upsert_sponsorship(device_id, product_id) do
    {subscription_id, expiration_date} = case type_from_product(product_id) do
        "subscription" ->
          {product_id, Date.add(Date.utc_today(), expiration_days_from_product(product_id))}
        _ ->
          {nil, nil}
      end

    case Sponsorships.get_by_device_id(device_id) do
      nil ->
        Sponsorships.create(%{"device_id" => device_id, "value" => value_from_product(product_id), "active_subscription_id" => subscription_id, "active_subscription_expiration" => expiration_date})
      sponsorship ->
        Sponsorships.update(sponsorship, %{"value" => sponsorship.value + value_from_product(product_id), "active_subscription_id" => subscription_id, "active_subscription_expiration" => expiration_date})
    end
  end

  defp upsert_comment(device_id, value) do
    case Comments.get_by_device_id(device_id) do
      nil ->
        Comments.create(%{"device_id" => device_id, "value" => value})
      comment ->
        Comments.update(comment, %{"value" => comment.value + value})
    end
  end

  defp product_from_google_id("app.tankste.sponsor.product.10"), do: "sponsor_single_10"
  defp product_from_google_id("app.tankste.sponsor.sub.monthly.1"), do: "sponsor_subscription_monthly_1"
  defp product_from_google_id("app.tankste.sponsor.sub.monthly.2"), do: "sponsor_subscription_monthly_2"
  defp product_from_google_id("app.tankste.sponsor.sub.yearly.12"), do: "sponsor_subscription_yearly_12"
  defp product_from_google_id(_), do: nil

  defp value_from_product("sponsor_single_10"), do: 10
  defp value_from_product("sponsor_subscription_monthly_1"), do: 1
  defp value_from_product("sponsor_subscription_monthly_2"), do: 2
  defp value_from_product("sponsor_subscription_yearly_12"), do: 12
  defp value_from_product(_), do: 0

  defp type_from_product("sponsor_subscription_monthly_1"), do: "subscription"
  defp type_from_product("sponsor_subscription_monthly_2"), do: "subscription"
  defp type_from_product("sponsor_subscription_yearly_12"), do: "subscription"
  defp type_from_product("sponsor_single_10"), do: "single"
  defp type_from_product(_), do: nil

  defp expiration_days_from_product("sponsor_subscription_monthly_1"), do: 30
  defp expiration_days_from_product("sponsor_subscription_monthly_2"), do: 60
  defp expiration_days_from_product("sponsor_subscription_yearly_12"), do: 365
  defp expiration_days_from_product(_), do: nil
end
