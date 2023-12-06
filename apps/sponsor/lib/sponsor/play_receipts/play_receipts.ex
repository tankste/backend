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

  def verify_and_acknowledge_and_consume_product(product_id, secret) do
    with :ok <- verify_product(product_id, secret),
      :ok <- acknowledge_product(product_id, secret),
      :ok <- consume_product(product_id, secret)
    do
      :ok
    else
      error ->
        IO.inspect(error)
        {:error, :failed}
    end
  end

  defp verify_product(product_id, secret) do
    result = AndroidPublisher.V3.Api.Purchases.androidpublisher_purchases_products_get(
      android_publisher_connection(),
      "app.tankste",
      product_id,
      secret
    )
    IO.inspect result
    case result do
      {:ok, _} ->
        :ok
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp acknowledge_product(product_id, secret) do
    result = AndroidPublisher.V3.Api.Purchases.androidpublisher_purchases_products_acknowledge(
        android_publisher_connection(),
        "app.tankste",
        product_id,
        secret
      )

    case result do
      {:ok, product} ->
        {:ok, [order_id: product["orderId"], external_id: product["obfuscatedExternalAccountId"]]}
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp consume_product(product_id, secret) do
    result = android_publisher_connection()
    |> GoogleApi.AndroidPublisher.V3.Connection.post("/androidpublisher/v3/applications/app.tankste/purchases/products/#{product_id}/tokens/#{secret}:consume", %{})

    case result do
      {:ok, _} ->
        :ok
      {:error, reason} ->
        {:error, reason}
    end
  end

  def verify_and_acknowledge_subscription(product_id, secret) do
    with :ok <- verify_subscription(product_id, secret),
      :ok <- acknowledge_subscription(product_id, secret)
    do
      :ok
    else
      error ->
        IO.inspect(error)
        {:error, :failed}
    end
  end

  defp verify_subscription(product_id, secret) do
    result = AndroidPublisher.V3.Api.Purchases.androidpublisher_purchases_subscriptions_get(
      android_publisher_connection(),
      "app.tankste",
      product_id,
      secret
    )
    IO.inspect result
    case result do
      {:ok, subscription} ->
        {:ok, [order_id: subscription["orderId"], external_id: subscription["obfuscatedExternalAccountId"]]}
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp acknowledge_subscription(product_id, secret) do
    result = AndroidPublisher.V3.Api.Purchases.androidpublisher_purchases_subscriptions_acknowledge(
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

  defp android_publisher_connection() do
    {:ok, auth_token} = Goth.fetch(Tankste.Sponsor.Goth)
    AndroidPublisher.V3.Connection.new(auth_token.token)
  end
end
