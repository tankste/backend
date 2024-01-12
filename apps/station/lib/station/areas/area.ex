defmodule Tankste.Station.Areas.Area do
  use Ecto.Schema

  import Ecto.Changeset

  schema "areas" do
    field :key, :string
    field :name, :string

    timestamps()
  end

  def changeset(open_time, attrs) do
    open_time
    |> cast(attrs, [:key, :name])
    |> validate_required([:key, :name])
  end
end
