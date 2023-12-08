defmodule Tankste.Sponsor.Sponsorships.Sponsorship do
  use Ecto.Schema

  import Ecto.Changeset

  schema "sponsorships" do
    field :device_id, :string
    field :active_subscription_id, :string
    field :active_subscription_expiration, :date
    field :value, :float

    timestamps()
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:device_id, :active_subscription_id, :active_subscription_expiration, :value])
    |> validate_required([:device_id, :value])
  end
end
