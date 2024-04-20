defmodule Tankste.Station.Repo.Migrations.CreateStationInfoIndexes do
  use Ecto.Migration

  def up do
    create unique_index(:station_infos, [:origin_id, :external_id])
    create index(:station_infos, [:external_id])
    create index(:station_infos, [:location_latitude])
    create index(:station_infos, [:location_longitude])
    create index(:station_infos, [:location_latitude, :location_longitude])
    create index(:station_infos, [:location_longitude, :location_latitude])
    create index(:station_info_open_times, [:station_info_id])
    create index(:station_info_areas, [:station_info_id])
  end

  def down do
    drop unique_index(:station_infos, [:origin_id, :external_id])
    drop index(:station_infos, [:external_id])
    drop index(:station_infos, [:location_latitude])
    drop index(:station_infos, [:location_longitude])
    drop index(:station_infos, [:location_latitude, :location_longitude])
    drop index(:station_infos, [:location_longitude, :location_latitude])
    drop index(:station_info_open_times, [:station_info_id])
    drop index(:station_info_areas, [:station_info_id])
  end
end
