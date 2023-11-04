defmodule Tankste.Station.Prices do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.Prices.Price

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([p], p.id == ^id)
    |> Repo.one()
  end

  def get_by_station_id(station_id, opts \\ []) do
    query(opts)
    |> where([p], p.station_id == ^station_id)
    |> Repo.one()
  end

  defp query(opts) do
    station_id = Keyword.get(opts, :station_id, nil)

    from(p in Price,
      select: p)
    |> query_where_station_id(station_id)
  end

  defp query_where_station_id(query, nil), do: query
  defp query_where_station_id(query, []), do: query
  defp query_where_station_id(query, station_ids) when is_list(station_ids) do
    query
    |> where([p], p.station_id in ^station_ids)
  end
  defp query_where_station_id(query, station_id) do
    query
    |> where([p], p.station_id == ^station_id)
  end

  def insert(attrs \\ %{}) do
    %Price{}
    |> Price.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Price{} = price, attrs \\ %{}) do
    price
    |> Price.changeset(attrs)
    |> Repo.update()
  end
end
