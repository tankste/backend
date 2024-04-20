# TODO: While data has no plural, I named it to "info(s)".
# But I think there is a better naming. And "infos" is also wrong
defmodule Tankste.Station.StationInfos.StationInfo do
  use Ecto.Schema

  import Ecto.Changeset

  schema "station_infos" do
    has_many :open_times, Tankste.Station.OpenTimes.OpenTime
    has_many :station_areas, Tankste.Station.StationAreas.StationArea
    belongs_to :station, Tankste.Station.Stations.Station
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
    field :currency, :string, default: "eur"
    field :priority, :integer, default: 0
    field :last_changes_at, :utc_datetime

    timestamps()
  end

  def changeset(station, attrs) do
    station
    |> cast(attrs, [:station_id, :external_id, :origin_id, :name, :brand, :location_latitude, :location_longitude, :address_street, :address_house_number, :address_post_code, :address_city, :address_country, :currency, :priority, :last_changes_at])
    |> validate_required([:station_id, :external_id, :origin_id, :name, :location_latitude, :location_longitude, :last_changes_at])
    |> unique_constraint([:origin_id, :external_id])
    |> validate_inclusion(:currency, ~w(eur isk))
  end
end
