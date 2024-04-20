defmodule Tankste.Station.Repo.Migrations.RemoveOldStationIndexes do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE station_info_areas DROP CONSTRAINT station_areas_station_id_fkey"
    execute "ALTER TABLE station_info_open_times DROP CONSTRAINT station_open_times_station_id_fkey"
  end

  def down do
    # Can not rollback this
  end
end
