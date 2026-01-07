defmodule Tankste.Station.Repo.Migrations.AddOriginPriceOutdatedAfterDays do
  use Ecto.Migration

  def up do
    alter table(:origins) do
      add :price_outdated_after_days, :integer, null: true
    end
  end

  def down do
    alter table(:origins) do
      remove :price_outdated_after_days
    end
  end
end
