defmodule Tankste.Station.Markers.Marker do
  use Ecto.Schema

  import Ecto.Changeset

  schema "station_markers" do
    belongs_to :station, Tankste.Station.Stations.Station
    field :label, :string
    field :latitude, :float
    field :longitude, :float
    field :e5_price, :float
    field :e5_price_comparison, :string
    field :e10_price, :float
    field :e10_price_comparison, :string
    field :diesel_price, :float
    field :diesel_price_comparison, :string

    timestamps()
  end

  def changeset(marker, attrs) do
    marker
    |> cast(attrs, [:station_id, :label, :latitude, :longitude, :e5_price, :e5_price_comparison, :e10_price, :e10_price_comparison, :diesel_price, :diesel_price_comparison])
    |> validate_required([:station_id, :label, :latitude, :longitude])
  end
end
