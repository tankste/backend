defmodule Tankste.Station.Repo.Migrations.PriceAddLabel do
  use Ecto.Migration

  def up do
    alter table(:station_prices) do
      add :label, :string, null: true
    end
  end

  def down do
    alter table(:station_prices) do
      remove :label
    end
  end
end
