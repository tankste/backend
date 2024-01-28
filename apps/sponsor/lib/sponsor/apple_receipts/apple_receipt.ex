defmodule Tankste.Sponsor.AppleReceipts.AppleReceipt do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

  schema "purchase_apple_receipts" do
    belongs_to :purchase, Tankste.Sponsor.Purchases.Purchase
    field :product_id, :string
    field :transaction_id, :string
    field :data, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:purchase_id, :product_id, :transaction_id, :data])
    |> validate_required([:purchase_id, :product_id, :transaction_id, :data])
  end
end
