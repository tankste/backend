defmodule Tankste.Sponsor.Repo.Migrations.CreatePurchasePlayReceipts do
  use Ecto.Migration

  def up do
    create table(:purchase_play_receipts, primary_key: false) do
      add :purchase_id, references(:purchases, on_delete: :delete_all), null: false, primary_key: true
      add :product_id, :string, null: false
      add :token, :text, null: false
      add :secret, :text, null: false

      timestamps()
    end
  end

  def down do
    drop table(:purchase_play_receipts)
  end
end
