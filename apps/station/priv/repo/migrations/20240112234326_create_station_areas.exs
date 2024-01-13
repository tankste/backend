defmodule Tankste.Station.Repo.Migrations.CreateStationAreas do
  use Ecto.Migration

  def up do
    create table(:station_areas) do
      add :station_id, references(:stations, on_delete: :delete_all), null: false
      add :area_id, references(:areas, on_delete: :delete_all), null: false

      timestamps()
    end
  end

  def down do
    drop table(:station_areas)
  end
end
