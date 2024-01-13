defmodule Tankste.Station.StationAreas.StationArea do
  use Ecto.Schema

  import Ecto.Changeset

  # TODO: ecto supports n-2-n tables, refactore afterwards and use the benefits of this
  schema "station_areas" do
    belongs_to :station, Tankste.Station.Stations.Station
    belongs_to :area, Tankste.Station.Areas.Area

    timestamps()
  end

  def changeset(open_time, attrs) do
    open_time
    |> cast(attrs, [:station_id, :area_id])
    |> validate_required([:station_id, :area_id])
  end
end
