defmodule Tankste.Station.Repo.Migrations.AddStationInfoPriority do
  use Ecto.Migration

  def up do
    alter table(:station_infos) do
      add :priority, :integer, null: false, default: 0
    end
  end

  def down do
    alter table(:station_infos) do
      remove :priority
    end
  end
end
