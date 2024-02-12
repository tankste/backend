defmodule Tankste.Sponsor.Purchases.Purchase do
  use Ecto.Schema

  import Ecto.Changeset

  schema "purchases" do
    has_one :apple_receipts, Tankste.Sponsor.AppleReceipts.AppleReceipt
    has_one :play_receipts, Tankste.Sponsor.PlayReceipts.PlayReceipt
    field :device_id, :string
    field :product, :string
    field :provider, :string
    field :type, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:device_id, :product, :provider, :type])
    |> validate_required([:device_id, :product, :provider, :type])
    |> validate_inclusion(:product, ~w(sponsor_single_1 sponsor_single_2 sponsor_single_10 sponsor_subscription_monthly_1 sponsor_subscription_monthly_2 sponsor_subscription_yearly_12))
    |> validate_inclusion(:provider, ~w(apple_store play_store))
    |> validate_inclusion(:type, ~w(single subscription))
  end
end
