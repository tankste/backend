defmodule Tankste.Station.StationAreas.StationArea do
  use Ecto.Schema

  import Ecto.Changeset

  # TODO: ecto supports n-2-n tables, refactore afterwards and use the benefits of this
  schema "station_info_areas" do
    belongs_to :station_info, Tankste.Station.StationInfos.StationInfo
    belongs_to :area, Tankste.Station.Areas.Area

    timestamps()
  end

  def changeset(open_time, attrs) do
    open_time
    |> cast(attrs, [:station_info_id, :area_id])
    |> validate_required([:station_info_id, :area_id])
  end
end
