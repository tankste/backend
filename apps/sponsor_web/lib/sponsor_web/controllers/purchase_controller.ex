defmodule Tankste.SponsorWeb.PurchaseController do
  use Tankste.SponsorWeb, :controller

  alias Tankste.Sponsor.Purchases
  alias Tankste.Sponsor.AppleReceipts
  alias Tankste.Sponsor.PlayReceipts
  alias Tankste.Sponsor.Transactions

  def create(conn, %{"provider" => "apple_store"} = purchase_params) do
    case AppleReceipts.verify(purchase_params["data"]) do
      :ok ->
        #TODO
        conn
        # |> create_apple_purchase(purchase_params)
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

  # defp create_apple_purchase(conn, purchase_params) do
  #   with {:ok, purchase} <- Purchases.create(%{"user_id" => current_session_member(conn).id, "product" => product_from_apple_id(purchase_params["productId"]), "provider" => "apple_store"}),
  #     {:ok, _receipt} <- AppleReceipts.create(%{"purchase_id" => purchase.id, "product_id" => purchase_params["productId"], "data" => purchase_params["data"]}),
  #     {:ok, _membership} <- Memberships.create(%{"member_id" => current_session_member(conn).id, "family_id" => purchase_family_id_from_product(conn, purchase.product), "purchase_id" => purchase.id, "type" => membership_type_from_product(purchase.product), "start_date" =>  Date.utc_today(), "origin" => "purchase"})
  #   do
  #     conn
  #     |> render("show.json", purchase: purchase)
  #   else
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(422)
  #       |> put_view(ChangesetView)
  #       |> render("errors.json", changeset: changeset)
  #   end
  # end

  # defp product_from_apple_id(_product), do: nil

  defp verify_play_product(conn, purchase_params) do
    case PlayReceipts.verify_and_acknowledge_and_consume_product(purchase_params["productId"], purchase_params["secret"]) do
      :ok ->
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
      :ok ->
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
    with {:ok, purchase} <- Purchases.create(%{"product" => product_from_google_id(purchase_params["productId"]), "provider" => "play_store", "type" => type_from_product(product_from_google_id(purchase_params["productId"]))}),
      {:ok, _receipt} <- PlayReceipts.create(%{"purchase_id" => purchase.id, "product_id" => purchase_params["productId"], "token" => purchase_params["token"], "secret" => purchase_params["secret"]}),
      {:ok, _transaction} <- Transactions.create(%{"type" => "sponsor", "category" => "google", "value" => value_from_product(purchase.product)})
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

  defp product_from_google_id("app.tankste.sponsor.product.10"), do: "sponsor_single_10"
  defp product_from_google_id("app.tankste.sponsor.sub.monthly.1"), do: "sponsor_subscription_monthly_1"
  defp product_from_google_id("app.tankste.sponsor.sub.monthly.2"), do: "sponsor_subscription_monthly_2"
  defp product_from_google_id(_), do: nil

  defp value_from_product("sponsor_single_10"), do: 10
  defp value_from_product("sponsor_subscription_monthly_1"), do: 1
  defp value_from_product("sponsor_subscription_monthly_2"), do: 2
  defp value_from_product(_), do: 0

  defp type_from_product("sponsor_subscription_monthly_1"), do: "subscription"
  defp type_from_product("sponsor_subscription_monthly_2"), do: "subscription"
  defp type_from_product("sponsor_single_10"), do: "single"
  defp type_from_product(_), do: nil
end
