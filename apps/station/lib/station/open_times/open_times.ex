defmodule Tankste.Station.OpenTimes do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.OpenTimes.OpenTime

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([ot], ot.id == ^id)
    |> Repo.one()
  end

  def get_by_station_id(station_id, opts \\ []) do
    query(opts)
    |> where([ot], ot.station_id == ^station_id)
    |> Repo.one()
  end

  defp query(opts) do
    station_id = Keyword.get(opts, :station_id, nil)

    from(ot in OpenTime,
      select: ot)
    |> query_where_station_id(station_id)
  end

  defp query_where_station_id(query, nil), do: query
  defp query_where_station_id(query, []), do: query
  defp query_where_station_id(query, station_ids) when is_list(station_ids) do
    query
    |> where([ot], ot.station_id in ^station_ids)
  end
  defp query_where_station_id(query, station_id) do
    query
    |> where([ot], ot.station_id == ^station_id)
  end

  def insert(attrs \\ %{}) do
    %OpenTime{}
    |> OpenTime.changeset(attrs)
    |> Repo.insert()
  end

  def update(%OpenTime{} = open_time, attrs \\ %{}) do
    open_time
    |> OpenTime.changeset(attrs)
    |> Repo.update()
  end
end
