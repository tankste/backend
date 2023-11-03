defmodule Tankste.Station.Repo.Migrations.CreateStations do
  use Ecto.Migration

  def up do
    create table(:stations) do
      add :external_id, :string, null: false
      add :origin, :string, null: false
      add :name, :string, null: false
      add :brand, :string, null: true
      add :location_latitude, :float, null: false
      add :location_longitude, :float, null: false
      add :address_street, :string, null: true
      add :address_house_number, :string, null: true
      add :address_post_code, :string, null: true
      add :address_city, :string, null: true
      add :address_country, :string, null: true
      add :last_changes_at, :utc_datetime, null: false

      timestamps()
    end
  end

  def down do
    drop table(:stations)
  end
end
