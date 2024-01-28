defmodule Tankste.Sponsor.AppleReceipts do
  import Ecto.Query, warn: false

  alias Tankste.Sponsor.Repo
  alias Tankste.Sponsor.AppleReceipts.AppleReceipt

  def get_by_transaction_id(transaction_id, opts \\ []) do
    query(opts)
    |> where([ar], ar.transaction_id == ^transaction_id)
    |> Repo.one()
  end

  defp query(_opts) do
    from(ar in AppleReceipt,
      select: ar)
  end

  def create(attrs \\ %{}) do
    %AppleReceipt{}
    |> AppleReceipt.changeset(attrs)
    |> Repo.insert()
  end

  def verify(receipt_data, environment \\ :production) do
    body = %{
        "exclude-old-transactions" => true,
        "password" => password(),
        "receipt-data" => receipt_data
      }
      |> Jason.encode!()

    case HTTPoison.post("#{store_url(environment)}verifyReceipt", body) do
      {:ok, %{status_code: 200, body: body}} ->
        result = Jason.decode!(body)
        case result["status"] do
          0 ->
            :ok
          21007 ->
            IO.puts("Use sandbox environment to verify receipt!")
            verify(receipt_data, :sandbox)
          status ->
            IO.puts("Receipt status is invalid! Status: #{status}.")
            {:error, :invalid_status}
        end
      _ ->
        IO.puts("Requesting app store for validation receipt failed!")
        {:error, :failed}
    end
  end

  defp store_url(:production), do: "https://buy.itunes.apple.com/"
  defp store_url(:sandbox), do: "https://sandbox.itunes.apple.com/"

  defp password(), do: apple_config() |> Keyword.fetch!(:password)

  defp apple_config(), do: Application.get_env(:sponsor, :apple)
end
