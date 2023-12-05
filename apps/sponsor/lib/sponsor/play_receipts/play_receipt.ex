defmodule Tankste.Sponsor.PlayReceipts.PlayReceipt do
  use Ecto.Schema

  import Ecto.Changeset

  schema "purchase_play_receipts" do
    belongs_to :purchase, Tankste.Sponsor.Purchases.Purchase
    field :product_id, :string
    field :token, :string
    field :secret, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:purchase_id, :product_id, :token, :secret])
    |> validate_required([:purchase_id, :product_id, :token, :secret])
  end
end
