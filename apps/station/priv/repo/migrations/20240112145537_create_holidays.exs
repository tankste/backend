defmodule Tankste.Station.Repo.Migrations.CreateHolidays do
  use Ecto.Migration

  def up do
    create table(:holidays) do
      add :origin_id, references(:origins, on_delete: :delete_all), null: false
      add :area_id, references(:areas, on_delete: :delete_all), null: false
      add :date, :date, null: false
      add :name, :string, null: false

      timestamps()
    end
  end

  def down do
    drop table(:holidays)
  end
end
