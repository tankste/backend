defmodule Tankste.Station.Repo.Migrations.CreateAreas do
  use Ecto.Migration

  def up do
    create table(:areas) do
      add :key, :string, null: false
      add :name, :string, null: false

      timestamps()
    end
  end

  def down do
    drop table(:areas)
  end
end
