defmodule Tankste.Station.Prices.Price do
  use Ecto.Schema

  import Ecto.Changeset

  # TODO: define fields & validations (required fields) independend of the MTS-K schema

  schema "station_prices" do
    belongs_to :station, Tankste.Station.Stations.Station
    belongs_to :origin, Tankste.Station.Origins.Origin
    field :type, :string
    field :price, :float
    field :currency, :string, default: "eur"
    field :last_changes_at, :utc_datetime

    timestamps()
  end

  def changeset(station, attrs) do
    station
    |> cast(attrs, [:station_id, :origin_id, :type, :price, :currency, :last_changes_at])
    |> validate_required([:station_id, :origin_id, :type, :price])
    |> validate_inclusion(:type, ~w(e5 e10 diesel))
    |> validate_inclusion(:currency, ~w(eur isk))
    |> unique_constraint([:station_id, :type])
  end
end
