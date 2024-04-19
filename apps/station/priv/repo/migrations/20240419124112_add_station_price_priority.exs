defmodule Tankste.Station.Repo.Migrations.AddPricePriority do
  use Ecto.Migration

  def up do
    alter table(:station_prices) do
      add :priority, :integer, null: false, default: 0
    end
  end

  def down do
    alter table(:station_prices) do
      remove :priority
    end
  end
end
