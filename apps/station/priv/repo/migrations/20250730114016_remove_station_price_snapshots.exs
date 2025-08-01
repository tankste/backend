defmodule Tankste.Station.Repo.Migrations.RemoveStationPriceSnapshots do
  use Ecto.Migration

  def up do
    drop table(:station_price_snapshots)
  end

  def down do
    create table(:station_price_snapshots) do
      add :station_id, references(:stations, on_delete: :delete_all), null: false
      add :snapshot_date, :utc_datetime, null: false
      add :petrol_price, :float, null: true
      add :petrol_super_e5_price, :float, null: true
      add :petrol_super_e10_price, :float, null: true
      add :petrol_super_plus_price, :float, null: true
      add :petrol_shell_power_price, :float, null: true
      add :petrol_aral_ultimate_price, :float, null: true
      add :diesel_price, :float, null: true
      add :diesel_truck_price, :float, null: true
      add :diesel_shell_power_price, :float, null: true
      add :diesel_aral_ultimate_price, :float, null: true
      add :lpg_price, :float, null: true

      timestamps()
    end
  end
end
