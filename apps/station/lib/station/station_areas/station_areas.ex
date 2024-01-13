# TODO: ecto supports n-2-n tables, refactore afterwards and use the benefits of this
defmodule Tankste.Station.StationAreas do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.StationAreas.StationArea

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([sa], sa.id == ^id)
    |> Repo.one()
  end

  def get_by_station_id_and_area_id(station_id, area_id, opts \\ []) do
    query(opts)
    |> where([sa], sa.station_id == ^station_id and sa.area_id == ^area_id)
    |> Repo.one()
  end

  defp query(opts) do
    station_id = Keyword.get(opts, :station_id, nil)

    from(sa in StationArea,
      select: sa)
    |> query_where_station_id(station_id)
  end

  defp query_where_station_id(query, nil), do: query
  defp query_where_station_id(query, []), do: query
  defp query_where_station_id(query, station_ids) when is_list(station_ids) do
    query
    |> where([sa], sa.station_id in ^station_ids)
  end
  defp query_where_station_id(query, station_id) do
    query
    |> where([sa], sa.station_id == ^station_id)
  end

  def create(attrs \\ %{}) do
    %StationArea{}
    |> StationArea.changeset(attrs)
    |> Repo.insert()
  end

  def delete(%StationArea{} = station_area) do
    Repo.delete(station_area)
  end
end
