defmodule Tankste.Report.Repo.Migrations.AddReportsOriginId do
  use Ecto.Migration

  def up do
    alter table(:reports) do
      add :origin_id, :integer, null: false, default: 1
      remove :origin
    end
  end

  def down do
    alter table(:reports) do
      add :origin, :string, null: false, default: "mts-k"
      remove :origin_id
    end
  end
end
