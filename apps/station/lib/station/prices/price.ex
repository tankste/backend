defmodule Tankste.Station.Prices.Price do
  use Ecto.Schema

  import Ecto.Changeset

  # TODO: define fields & validations (required fields) independend of the MTS-K schema

  schema "station_prices" do
    belongs_to :station, Tankste.Station.Stations.Station
    belongs_to :origin, Tankste.Station.Origins.Origin
    field :type, :string
    field :price, :float
    field :priority, :integer, default: 0
    field :last_changes_at, :utc_datetime

    timestamps()
  end

  def changeset(station, attrs) do
    station
    |> cast(attrs, [:station_id, :origin_id, :type, :price, :last_changes_at, :priority])
    |> validate_required([:station_id, :origin_id, :type, :price])
    # petrol: Benzin (91 Oktan)
    # (e5) petrol_super_e5: Benzin E5 (95 Oktan)
    # (e10) petrol_super_e10: Benzin E10 (95 Oktan)
    # petrol_super_plus: Benzin (98 Oktan)
    # petrol_shell_power: Shell V-Power Racing (100 Oktan)
    # petrol_aral_ultimate: Aral Ultimate (102 Oktan)
    # diesel: Diesel (PKW)
    # diesel_truck: Diesel (LKW)
    # diesel_shell_power: Shell V-Power Diesel
    # diesel_aral_ultimate: Ultimate Diesel von Aral
    # lpg: Autogas
    |> validate_inclusion(:type, ~w(petrol e5 e10 petrol_super_plus petrol_shell_power petrol_aral_ultimate diesel diesel_truck diesel_shell_power diesel_aral_ultimate lpg))
    |> unique_constraint([:station_id, :type])
  end
end
