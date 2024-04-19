defmodule Tankste.Station.Repo.Migrations.OpenTimesToStationInfo do
  use Ecto.Migration

  def up do
    rename table(:station_open_times), :station_id, to: :station_info_id
    alter table(:station_open_times) do
      remove :origin_id, references(:origins, on_delete: :delete_all)
    end
    rename table(:station_open_times), to: table(:station_info_open_times)
  end

  def down do
    rename table(:station_info_open_times), to: table(:station_open_times)
    rename table(:station_open_times), :station_info_id, to: :station_id
    alter table(:station_open_times) do
      add :origin_id, references(:origins, on_delete: :delete_all), null: false, default: 1
    end
  end
end
