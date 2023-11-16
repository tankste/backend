defmodule Tankste.Station.Repo.Migrations.CreateStationPrices do
  use Ecto.Migration

  def up do
    create table(:station_prices) do
      add :station_id, references(:stations, on_delete: :delete_all), null: false
      add :origin, :string, null: false
      add :type, :string, null: false
      add :price, :float, null: false
      add :last_changes_at, :utc_datetime, null: true

      timestamps()
    end
  end

  def down do
    drop table(:station_prices)
  end
end
