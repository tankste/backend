defmodule Tankste.Sponsor.Transactions.Transaction do
  use Ecto.Schema

  import Ecto.Changeset

  # TODO: define fields & validations (required fields) independend of the MTS-K schema

  schema "transactions" do
    field :type, :string
    field :category, :string
    field :value, :float
    field :comment, :string

    timestamps()
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:type, :category, :value, :comment])
    |> validate_required([:type, :category, :value])
    |> validate_inclusion(:type, ~w(domain server license work sponsor))
    |> validate_inclusion(:category, ~w(github google apple fixed variable))
  end
end
