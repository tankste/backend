defmodule Tankste.Station.Repo.Migrations.CreateStationPrices do
  use Ecto.Migration

  def up do
    create table(:station_prices) do
      add :station_id, references(:stations, on_delete: :delete_all), null: false
      add :origin, :string, null: false
      add :e5_price, :float, null: true
      add :e10_price, :float, null: true
      add :diesel_price, :float, null: true
      add :last_changes_at, :utc_datetime, null: false

      timestamps()
    end
  end

  def down do
    drop table(:station_prices)
  end
end
