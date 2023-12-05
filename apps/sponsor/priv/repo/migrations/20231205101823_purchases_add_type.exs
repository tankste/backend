defmodule Tankste.Sponsor.Repo.Migrations.PurchasesAddType do
  use Ecto.Migration

  def up do
    alter table(:purchases) do
      add :type, :string, default: "single", null: false
    end
  end

  def down do
    alter table(:purchases) do
      remove :type
    end
  end
end
