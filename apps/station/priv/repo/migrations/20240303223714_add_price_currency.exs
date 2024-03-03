defmodule Tankste.Station.Repo.Migrations.AddPriceCurrency do
  use Ecto.Migration

  def up do

    alter table(:station_prices) do
      add :currency, :string, null: false, default: "eur"
    end
  end

  def down do
    alter table(:station_prices) do
      remove :currency
    end
  end
end
