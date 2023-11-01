defmodule Tankste.Station.Stations.Station do
  use Ecto.Schema

  schema "stations" do
    field :external_id, :string
    field :origin, :string
    field :name, :string
    field :brand, :string
    field :location_latitude, :float
    field :location_longitude, :float
    field :address_street, :string
    field :address_house_number, :string
    field :address_post_code, :string
    field :address_city, :string
    field :address_country, :string
    field :last_changes_at, :utc_datetime

    timestamps()
  end
end
