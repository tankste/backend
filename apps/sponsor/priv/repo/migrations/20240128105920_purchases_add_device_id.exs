defmodule Tankste.Sponsor.Repo.Migrations.PurchasesAddDeviceId do
  use Ecto.Migration

  def up do
    alter table(:purchases) do
      add :device_id, :string, default: "", null: false
    end
  end

  def down do
    alter table(:purchases) do
      remove :device_id
    end
  end
end
