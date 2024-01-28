defmodule Tankste.Sponsor.Repo.Migrations.PurchaseAppleReceiptsAddProductId do
  use Ecto.Migration

  def up do
    alter table(:purchase_apple_receipts) do
      add :transaction_id, :string, default: "", null: false
    end
  end

  def down do
    alter table(:purchase_apple_receipts) do
      remove :transaction_id
    end
  end
end
