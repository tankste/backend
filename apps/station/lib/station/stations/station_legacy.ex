# Keep this for migration stuff
defmodule Tankste.Station.Stations.StationLegacy do
  use Ecto.Schema

  schema "stations" do
    field :origin_id, :integer
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
    field :currency, :string, default: "eur"
    field :last_changes_at, :utc_datetime
    field :status, :string, default: "available"

    timestamps()
  end
end
