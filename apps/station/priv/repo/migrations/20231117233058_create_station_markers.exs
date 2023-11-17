defmodule Tankste.Station.Repo.Migrations.CreateStationMarkers do
  use Ecto.Migration

  def up do
    create table(:station_markers) do
      add :station_id, references(:stations, on_delete: :delete_all), null: false
      add :label, :string, null: false
      add :latitude, :float, null: false
      add :longitude, :float, null: false
      add :e5_price, :float, null: true
      add :e5_price_comparison, :string, null: true
      add :e10_price, :float, null: true
      add :e10_price_comparison, :string, null: true
      add :diesel_price, :float, null: true
      add :diesel_price_comparison, :string, null: true

      timestamps()
    end
  end

  def down do
    drop table(:station_markers)
  end
end
