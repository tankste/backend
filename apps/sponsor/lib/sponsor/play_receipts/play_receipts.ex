defmodule Tankste.Sponsor.PlayReceipts do
  import Ecto.Query, warn: false

  alias Tankste.Sponsor.Repo
  alias Tankste.Sponsor.PlayReceipts.PlayReceipt
  alias GoogleApi.AndroidPublisher

  def create(attrs \\ %{}) do
    %PlayReceipt{}
    |> PlayReceipt.changeset(attrs)
    |> Repo.insert()
  end

  def verify_and_acknowledge_and_consume(product_id, secret) do
    with :ok <- verify_purchase(product_id, secret),
      :ok <- acknowledge_purchase(product_id, secret),
      :ok <- consume_purchase(product_id, secret)
    do
      :ok
    else
      error ->
        IO.inspect(error)
        {:error, :failed}
    end
  end

  defp verify_purchase(product_id, secret) do
    result = AndroidPublisher.V3.Api.Purchases.androidpublisher_purchases_products_get(
      android_publisher_connection(),
      "app.tankste",
      product_id,
      secret
    )

    case result do
      {:ok, _} ->
        :ok
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp acknowledge_purchase(product_id, secret) do
    result = AndroidPublisher.V3.Api.Purchases.androidpublisher_purchases_products_acknowledge(
        android_publisher_connection(),
        "app.tankste",
        product_id,
        secret
      )

    case result do
      {:ok, _} ->
        :ok
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp consume_purchase(product_id, secret) do
    result = android_publisher_connection()
    |> GoogleApi.AndroidPublisher.V3.Connection.post("/androidpublisher/v3/applications/app.tankste/purchases/products/#{product_id}/tokens/#{secret}:consume", %{})

    case result do
      {:ok, _} ->
        :ok
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp android_publisher_connection() do
    {:ok, auth_token} = Goth.fetch(Tankste.Sponsor.Goth)
    AndroidPublisher.V3.Connection.new(auth_token.token)
  end
end
