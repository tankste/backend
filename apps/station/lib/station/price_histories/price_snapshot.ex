defmodule Tankste.Station.PriceSnapshots.PriceSnapshot do
  use Ecto.Schema

  import Ecto.Changeset

  schema "station_price_snapshots" do
    belongs_to :station, Tankste.Station.Stations.Station
    field :snapshot_date, :utc_datetime
    field :petrol_price, :float
    field :petrol_super_e5_price, :float
    field :petrol_super_e10_price, :float
    field :petrol_super_plus_price, :float
    field :petrol_shell_power_price, :float
    field :petrol_aral_ultimate_price, :float
    field :diesel_price, :float
    field :diesel_truck_price, :float
    field :diesel_shell_power_price, :float
    field :diesel_aral_ultimate_price, :float
    field :lpg_price, :float

    timestamps()
  end

  def changeset(station, attrs) do
    station
    |> cast(attrs, [:station_id, :snapshot_date, :petrol_price, :petrol_super_e5_price, :petrol_super_e10_price, :petrol_super_plus_price, :petrol_shell_power_price, :petrol_aral_ultimate_price, :diesel_price, :diesel_truck_price, :diesel_shell_power_price, :diesel_aral_ultimate_price, :lpg_price])
    |> validate_required([:station_id])
  end

  def price(nil, _), do: nil
  def price(price_snapshot, :petrol), do: price_snapshot.petrol_price
  def price(price_snapshot, :petrol_super_e5), do: price_snapshot.petrol_super_e5_price
  def price(price_snapshot, :petrol_super_e10), do: price_snapshot.petrol_super_e10_price
  def price(price_snapshot, :petrol_super_plus), do: price_snapshot.petrol_super_plus_price
  def price(price_snapshot, :petrol_shell_power), do: price_snapshot.petrol_shell_power_price
  def price(price_snapshot, :petrol_aral_ultimate), do: price_snapshot.petrol_aral_ultimate_price
  def price(price_snapshot, :diesel), do: price_snapshot.diesel_price
  def price(price_snapshot, :diesel_truck), do: price_snapshot.diesel_truck_price
  def price(price_snapshot, :diesel_shell_power), do: price_snapshot.diesel_shell_power_price
  def price(price_snapshot, :diesel_aral_ultimate), do: price_snapshot.diesel_aral_ultimate_price
  def price(price_snapshot, :lpg), do: price_snapshot.lpg_price
end
