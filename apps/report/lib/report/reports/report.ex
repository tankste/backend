defmodule Tankste.Report.Reports.Report do
  use Ecto.Schema

  import Ecto.Changeset

  schema "reports" do
    field :station_id, :integer
    field :device_id, :string
    field :origin, :string
    field :field, :string
    field :wrong_value, :string
    field :correct_value, :string
    field :reported_to_origin_date, :utc_datetime
    field :status, :string

    timestamps()
  end

  def changeset(station, attrs) do
    station
    |> cast(attrs, [:station_id, :device_id, :origin, :field, :wrong_value, :correct_value, :reported_to_origin_date, :status])
    |> validate_required([:station_id, :device_id, :origin, :field, :wrong_value, :correct_value, :status])
    |> validate_inclusion(:status, ~w(open corrected invalid ignored))
  end
end
