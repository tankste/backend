defmodule Tankste.SponsorWeb.PurchaseController do
  use Tankste.SponsorWeb, :controller

  alias Tankste.Sponsor.Purchases
  alias Tankste.Sponsor.AppleReceipts
  alias Tankste.Sponsor.PlayReceipts

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
    case PlayReceipts.verify_and_acknowledge_and_consume(purchase_params["productId"], purchase_params["secret"]) do
      :ok ->
        conn
        |> create_play_purchase(purchase_params)
      _ ->
        conn
        |> put_status(422)
        |> put_view(ChangesetView)
        |> render("errors.json", validations: [data: {"can not verified", [validation: :not_verified]}])
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

  defp create_play_purchase(conn, purchase_params) do
    with {:ok, purchase} <- Purchases.create(%{"secret" => gen_secret(), "product" => product_from_google_id(purchase_params["productId"]), "provider" => "play_store"}),
      {:ok, _receipt} <- PlayReceipts.create(%{"purchase_id" => purchase.id, "product_id" => purchase_params["productId"], "token" => purchase_params["token"], "secret" => purchase_params["secret"]})
    do
      conn
      |> render("show.json", purchase: purchase)
    else
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(ChangesetView)
        |> render("errors.json", changeset: changeset)
    end
  end

  defp product_from_google_id("app.tankste.sponsor.product.10"), do: "sponsor_single_10"
  defp product_from_google_id(_), do: nil

  defp gen_secret() do
    Enum.take_random('0123456789abcdefghijklmopqrstvwxyzABCDEFGHIJKLMNOPQRSTVWXYZ', 32)
    |> List.to_string()
  end
end
