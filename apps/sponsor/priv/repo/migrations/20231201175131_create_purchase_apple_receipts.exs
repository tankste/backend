defmodule Tankste.Sponsor.Repo.Migrations.CreatePurchaseAppleReceipts do
  use Ecto.Migration

  def up do
    create table(:purchase_apple_receipts, primary_key: false) do
      add :purchase_id, references(:purchases, on_delete: :delete_all), null: false, primary_key: true
      add :product_id, :string, null: false
      add :data, :text, null: false

      timestamps()
    end
  end

  def down do
    drop table(:purchase_apple_receipts)
  end
end
