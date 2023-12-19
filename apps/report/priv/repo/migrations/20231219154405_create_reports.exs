defmodule Tankste.Report.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def up do
    create table(:reports) do
      add :station_id, :integer, null: false
      add :device_id, :string, null: false
      add :origin, :string, null: false
      add :field, :string, null: false
      add :wrong_value, :string, null: false
      add :correct_value, :string, null: false
      add :reported_to_origin_date, :utc_datetime, null: true
      add :status, :string, null: false

      timestamps()
    end
  end

  def down do
    drop table(:reports)
  end
end
