defmodule Tankste.Sponsor.Repo.Migrations.CreatePurchases do
  use Ecto.Migration

  def up do
    create table(:purchases) do
      add :secret, :string, null: false
      add :product, :string, null: false
      add :provider, :string, null: false

      timestamps()
    end
  end

  def down do
    drop table(:purchases)
  end
end
