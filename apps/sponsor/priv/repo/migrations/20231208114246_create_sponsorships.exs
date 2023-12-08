defmodule Tankste.Sponsor.Repo.Migrations.CreateSponsorships do
  use Ecto.Migration

  def up do
    create table(:sponsorships) do
      add :device_id, :string, null: false
      add :active_subscription_id, :string, null: true
      add :active_subscription_expiration, :date, null: true
      add :value, :float, null: false

      timestamps()
    end
  end

  def down do
    drop table(:sponsorships)
  end
end
