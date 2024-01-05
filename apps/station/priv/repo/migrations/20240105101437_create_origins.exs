defmodule Tankste.Station.Repo.Migrations.CreateOrigins do
  use Ecto.Migration

  def up do
    create table(:origins) do
      add :name, :string, null: false
      add :short_name, :string, null: false
      add :icon_image_url, :string, null: false
      add :image_url, :string, null: false
      add :website_url, :string, null: true

      timestamps()
    end

    flush()

    Tankste.Station.Repo.insert!(
      %Tankste.Station.Origins.Origin{
        name: "Markttransparenzstelle für Kraftstoffe",
        short_name: "MTS-K",
        icon_image_url: "https://tankste.app/assets/images/mts-k/icon.png",
        image_url: "https://tankste.app/assets/images/mts-k/logo.png",
        website_url: "https://www.bundeskartellamt.de/DE/Wirtschaftsbereiche/Mineral%C3%B6l/MTS-Kraftstoffe/mtskraftstoffe_node.html",
      }
    )

    alter table(:stations) do
      add :origin_id, references(:origins, on_delete: :delete_all), null: false, default: 1
      remove :origin
    end

    alter table(:station_prices) do
      add :origin_id, references(:origins, on_delete: :delete_all), null: false, default: 1
      remove :origin
    end

    alter table(:station_open_times) do
      add :origin_id, references(:origins, on_delete: :delete_all), null: false, default: 1
      remove :origin
    end
  end

  def down do
    alter table(:stations) do
      add :origin, :string, null: false, default: "mts-k"
      remove :origin_id, references(:origins, on_delete: :delete_all)
    end

    alter table(:station_prices) do
      add :origin, :string, null: false, default: "mts-k"
      remove :origin_id, references(:origins, on_delete: :delete_all)
    end

    alter table(:station_open_times) do
      add :origin, :string, null: false, default: "mts-k"
      remove :origin_id, references(:origins, on_delete: :delete_all)
    end

    drop table(:origins)
  end
end
