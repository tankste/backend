defmodule Tankste.Sponsor.Repo.Migrations.PurchasesRemoveSecret do
  use Ecto.Migration

  def up do
    alter table(:purchases) do
      remove :secret
    end
  end

  def down do
    alter table(:purchases) do
      add :secret, :string, default: "", null: false
    end
  end
end
