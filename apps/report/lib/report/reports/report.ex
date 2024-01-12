defmodule Tankste.Report.Reports.Report do
  use Ecto.Schema

  import Ecto.Changeset

  schema "reports" do
    field :station_id, :integer
    field :device_id, :string
    field :origin_id, :integer
    field :field, :string
    field :wrong_value, :string
    field :correct_value, :string
    field :reported_to_origin_date, :utc_datetime
    field :status, :string

    timestamps()
  end

  def changeset(station, attrs) do
    station
    |> cast(attrs, [:station_id, :device_id, :origin_id, :field, :wrong_value, :correct_value, :reported_to_origin_date, :status])
    |> validate_required([:station_id, :device_id, :origin_id, :field, :wrong_value, :correct_value, :status])
    |> validate_inclusion(:field, ~w(name brand location_latitude location_longitude address_street address_house_number address_post_code address_city address_country open_times_state open_times price_e5 price_e10 price_diesel note))
    |> validate_inclusion(:status, ~w(open corrected invalid ignored))
  end
end
