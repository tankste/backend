defmodule Tankste.Station.Repo.Migrations.CreateIndexes do
  use Ecto.Migration

  def up do
    create unique_index(:stations, [:origin_id, :external_id])
    create index(:stations, [:external_id])
    create index(:stations, [:location_latitude])
    create index(:stations, [:location_longitude])
    create index(:stations, [:location_latitude, :location_longitude])
    create index(:stations, [:location_longitude, :location_latitude])
    create index(:station_open_times, [:station_id])
    create unique_index(:station_prices, [:station_id, :type])
    create index(:station_areas, [:station_id])
    create unique_index(:station_markers, [:station_id])
    create unique_index(:areas, [:key])
    create index(:holidays, [:origin_id, :area_id])
  end

  def down do
    drop unique_index(:stations, [:origin_id, :external_id])
    drop index(:stations, [:external_id])
    drop index(:stations, [:location_latitude])
    drop index(:stations, [:location_longitude])
    drop index(:stations, [:location_latitude, :location_longitude])
    drop index(:stations, [:location_longitude, :location_latitude])
    drop index(:station_open_times, [:station_id])
    drop unique_index(:station_prices, [:station_id, :type])
    drop index(:station_areas, [:station_id])
    drop unique_index(:station_markers, [:station_id])
    drop unique_index(:areas, [:key])
    drop index(:holidays, [:origin_id, :area_id])
  end
end
