defmodule Tankste.Station.Repo.Migrations.CreateStationPrices do
  use Ecto.Migration

  def up do
    create table(:station_open_times) do
      add :station_id, references(:stations, on_delete: :delete_all), null: false
      add :origin, :string, null: false
      add :day, :string, null: false
      add :start_time, :time, null: false
      add :end_time, :time, null: false

      timestamps()
    end
  end

  def down do
    drop table(:station_open_times)
  end
end
