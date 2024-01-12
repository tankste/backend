defmodule Tankste.Station.Repo.Migrations.AddStationStatus do
  use Ecto.Migration

  def up do

    alter table(:stations) do
      add :status, :string, null: false, default: "available"
    end
  end

  def down do
    alter table(:stations) do
      remove :status
    end
  end
end
