defmodule Tankste.Sponsor.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def up do
    create table(:transactions) do
      add :type, :string, null: false
      add :category, :string, null: false
      add :value, :float, null: false
      add :comment, :string, null: true

      timestamps()
    end
  end

  def down do
    drop table(:transactions)
  end
end
