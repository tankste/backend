defmodule Tankste.Station.Repo.Migrations.CreateOpenTimesIndexes do
  use Ecto.Migration

  def up do
    create index(:station_open_times, [:station_id, :day])
    create index(:holidays, [:date, :area_id])
  end

  def down do
    drop index(:holidays, [:date, :area_id])
    drop index(:station_open_times, [:station_id, :day])
  end
end
