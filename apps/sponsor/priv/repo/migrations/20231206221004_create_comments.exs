defmodule Tankste.Sponsor.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def up do
    create table(:comments) do
      add :device_id, :string, null: false
      add :name, :string, null: true
      add :comment, :string, null: true
      add :value, :float, null: false

      timestamps()
    end
  end

  def down do
    drop table(:comments)
  end
end
