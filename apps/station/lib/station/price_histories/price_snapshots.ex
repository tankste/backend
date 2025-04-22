defmodule Tankste.Station.PriceSnapshots do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.PriceSnapshots.PriceSnapshot

  @spec list(keyword()) :: any()
  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([p], p.id == ^id)
    |> Repo.one()
  end

  defp query(opts) do
    station_id = Keyword.get(opts, :station_id, nil)
    type = Keyword.get(opts, :type, nil)
    # TODO: limit

    from(ps in PriceSnapshot,
      select: ps)
    |> query_where_station_id(station_id)
    |> query_where_type(type)
  end

  defp query_where_station_id(query, nil), do: query
  defp query_where_station_id(query, []), do: query
  defp query_where_station_id(query, station_ids) when is_list(station_ids) do
    query
    |> where([ps], ps.station_id in ^station_ids)
  end
  defp query_where_station_id(query, station_id) do
    query
    |> where([ps], ps.station_id == ^station_id)
  end

  defp query_where_type(query, nil), do: query
  defp query_where_type(query, []), do: query
  defp query_where_type(query, types) when is_list(types) do
    query
    |> where([ps], ps.type in ^types)
  end
  defp query_where_type(query, type) do
    query
    |> where([ps], ps.type == ^type)
  end

  def insert(attrs \\ %{}) do
    %PriceSnapshot{}
    |> PriceSnapshot.changeset(attrs)
    |> Repo.insert()
  end
end
