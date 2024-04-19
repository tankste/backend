defmodule Tankste.Station.Repo.Migrations.StationAreasToStationInfo do
  use Ecto.Migration

  def up do
    rename table(:station_areas), :station_id, to: :station_info_id
    rename table(:station_areas), to: table(:station_info_areas)
  end

  def down do
    rename table(:station_info_areas), to: table(:station_areas)
    rename table(:station_areas), :station_info_id, to: :station_id
  end
end
