defmodule Tankste.Sponsor.Purchases.Purchase do
  use Ecto.Schema

  import Ecto.Changeset

  schema "purchases" do
    has_one :apple_receipts, Tankste.Sponsor.AppleReceipts.AppleReceipt
    has_one :play_receipts, Tankste.Sponsor.PlayReceipts.PlayReceipt
    field :secret, :string
    field :product, :string
    field :provider, :string
    field :type, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:secret, :product, :provider, :type])
    |> validate_required([:secret, :product, :provider, :type])
    |> validate_inclusion(:product, ~w(sponsor_single_10 sponsor_subscription_monthly_1 sponsor_subscription_monthly_2))
    |> validate_inclusion(:provider, ~w(apple_store play_store))
    |> validate_inclusion(:type, ~w(single subscription))
  end
end
