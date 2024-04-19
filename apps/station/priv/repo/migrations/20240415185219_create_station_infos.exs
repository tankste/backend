defmodule Tankste.Station.Repo.Migrations.CreateStationInfos do
  use Ecto.Migration

  def up do
    create table(:station_infos) do
      add :station_id, references(:stations, on_delete: :delete_all), null: false
      add :external_id, :string, null: false
      add :origin_id, references(:origins, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :brand, :string, null: true
      add :location_latitude, :float, null: false
      add :location_longitude, :float, null: false
      add :address_street, :string, null: true
      add :address_house_number, :string, null: true
      add :address_post_code, :string, null: true
      add :address_city, :string, null: true
      add :address_country, :string, null: true
      add :currency, :string, null: false, default: "eur"
      add :last_changes_at, :utc_datetime, null: false

      timestamps()
    end

    flush()

    Tankste.Station.Repo.all(Tankste.Station.Stations.StationLegacy)
      |> Enum.map(fn s ->
        %{
          id: s.id,
          station_id: s.id,
          external_id: s.external_id,
          origin_id: s.origin_id,
          brand: s.brand,
          name: s.name,
          location_latitude: s.location_latitude,
          location_longitude: s.location_longitude,
          address_street: s.address_street,
          address_house_number: s.address_house_number,
          address_post_code: s.address_post_code,
          address_city: s.address_city,
          address_country: s.address_country,
          currency: s.currency,
          last_changes_at: s.last_changes_at,
          inserted_at: s.inserted_at,
          updated_at: s.updated_at,
        }
        end)
      |> Enum.chunk_every(2000)
      |> Enum.each(fn stations ->
        Tankste.Station.Repo.insert_all(Tankste.Station.StationInfos.StationInfo, stations)
      end)

    flush()

    alter table(:stations) do
      remove :external_id
      remove :origin_id, references(:origins, on_delete: :delete_all)
      remove :name
      remove :brand
      remove :location_latitude
      remove :location_longitude
      remove :address_street
      remove :address_house_number
      remove :address_post_code
      remove :address_city
      remove :address_country
      remove :currency
      remove :last_changes_at
    end
  end

  def down do
    drop table(:stations)

    flush()

    create table(:stations) do
      add :external_id, :string, null: false
      add :origin_id, references(:origins, on_delete: :delete_all)
      add :name, :string, null: false
      add :brand, :string, null: true
      add :location_latitude, :float, null: false
      add :location_longitude, :float, null: false
      add :address_street, :string, null: true
      add :address_house_number, :string, null: true
      add :address_post_code, :string, null: true
      add :address_city, :string, null: true
      add :address_country, :string, null: true
      add :currency, :string, null: false, default: "eur"
      add :last_changes_at, :utc_datetime, null: false
      add :status, :string, null: false, default: "available"
    end

    flush()

    stations = Tankste.Station.Repo.all(Tankste.Station.StationInfos.StationInfo)
      |> Enum.map(fn s ->
        %{
          id: s.id,
          external_id: s.external_id,
          origin_id: s.origin_id,
          brand: s.brand,
          location_latitude: s.location_latitude,
          location_longitude: s.location_longitude,
          address_street: s.address_street,
          address_house_number: s.address_house_number,
          address_post_code: s.address_post_code,
          address_city: s.address_city,
          address_country: s.address_country,
          currency: s.currency,
          last_changes_at: s.last_changes_at
        }
      end)
    Tankste.Station.Repo.insert_all(Tankste.Station.Stations.StationLegacy, stations)

    flush()

    drop table(:station_infos)
  end
end
