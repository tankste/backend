defmodule Tankste.Station.Prices.Price do
  use Ecto.Schema

  import Ecto.Changeset

  # TODO: define fields & validations (required fields) independend of the MTS-K schema

  schema "station_prices" do
    belongs_to :station, Tankste.Station.Stations.Station
    field :origin, :string
    field :e5_price, :float
    field :e10_price, :float
    field :diesel_price, :float
    field :last_changes_at, :utc_datetime

    timestamps()
  end

  def changeset(station, attrs) do
    station
    |> cast(attrs, [:station_id, :origin, :e5_price, :e10_price, :diesel_price, :last_changes_at])
    |> validate_required([:station_id, :origin, :last_changes_at])
  end
end
