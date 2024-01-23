defmodule Tankste.Station.OpenTimes.OpenTime do
  use Ecto.Schema

  import Ecto.Changeset

  # TODO: define fields & validations (required fields) independend of the MTS-K schema

  schema "station_open_times" do
    belongs_to :station, Tankste.Station.Stations.Station
    belongs_to :origin, Tankste.Station.Origins.Origin
    field :day, :string
    field :start_time, :time
    field :end_time, :time
    field :is_today, :boolean, virtual: true

    timestamps()
  end

  def changeset(open_time, attrs) do
    open_time
    |> cast(attrs, [:station_id, :origin_id, :day, :start_time, :end_time])
    |> validate_required([:station_id, :origin_id, :day, :start_time, :end_time])
    |> validate_inclusion(:day, ~w(monday tuesday wednesday thursday friday saturday sunday public_holiday))
  end
end
