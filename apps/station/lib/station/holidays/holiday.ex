defmodule Tankste.Station.Holidays.Holiday do
  use Ecto.Schema

  import Ecto.Changeset

  schema "holidays" do
    belongs_to :origin, Tankste.Station.Origins.Origin
    belongs_to :area, Tankste.Station.Areas.Area
    field :date, :date
    field :name, :string

    timestamps()
  end

  def changeset(open_time, attrs) do
    open_time
    |> cast(attrs, [:origin_id, :area_id, :date, :name])
    |> validate_required([:origin_id, :area_id, :date, :name])
  end
end
