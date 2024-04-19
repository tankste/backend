defmodule Tankste.Station.OpenTimes.OpenTime do
  use Ecto.Schema

  import Ecto.Changeset

  # TODO: define fields & validations (required fields) independend of the MTS-K schema

  schema "station_info_open_times" do
    belongs_to :station_info, Tankste.Station.StationInfos.StationInfo
    field :day, :string
    field :origin_id, :integer, virtual: true
    field :start_time, :time
    field :end_time, :time
    field :is_today, :boolean, virtual: true

    timestamps()
  end

  def changeset(open_time, attrs) do
    open_time
    |> cast(attrs, [:station_info_id, :day, :start_time, :end_time])
    |> validate_required([:station_info_id, :day, :start_time, :end_time])
    |> validate_inclusion(:day, ~w(monday tuesday wednesday thursday friday saturday sunday public_holiday))
  end
end
