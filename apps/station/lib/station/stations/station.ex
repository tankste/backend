defmodule Tankste.Station.Stations.Station do
  use Ecto.Schema

  import Ecto.Changeset

  # TODO: define fields & validations (required fields) independend of the MTS-K schema

  schema "stations" do
    has_many :prices, Tankste.Station.Prices.Price
    belongs_to :origin, Tankste.Station.Origins.Origin
    field :external_id, :string
    field :name, :string
    field :brand, :string
    field :location_latitude, :float
    field :location_longitude, :float
    field :address_street, :string
    field :address_house_number, :string
    field :address_post_code, :string
    field :address_city, :string
    field :address_country, :string
    field :is_open, :boolean, virtual: true
    field :last_changes_at, :utc_datetime
    field :status, :string, default: "available"

    timestamps()
  end

  def changeset(station, attrs) do
    station
    |> cast(attrs, [:external_id, :origin_id, :name, :brand, :location_latitude, :location_longitude, :address_street, :address_house_number, :address_post_code, :address_city, :address_country, :last_changes_at, :status])
    |> validate_required([:external_id, :origin_id, :name, :location_latitude, :location_longitude, :last_changes_at])
    # available: the station is available and publich visibility
    # disabled: this story should not be visible, for technical reasons
    # closed: station business has closed, don't show this station anymore
    |> validate_inclusion(:status, ~w(available disabled closed))
    |> unique_constraint(:origin_id_and_external_id)
  end
end
