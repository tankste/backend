defmodule Tankste.Sponsor.Comments.Comment do
  use Ecto.Schema

  import Ecto.Changeset

  schema "comments" do
    field :device_id, :string
    field :name, :string
    field :comment, :string
    field :value, :float

    timestamps()
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:device_id, :name, :comment, :value])
    |> validate_required([:device_id, :value])
  end
end
