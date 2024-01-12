defmodule Tankste.Station.Stations do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.Stations.Station

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([s], s.id == ^id)
    |> Repo.one()
  end

  def get_by_external_id(external_id, opts \\ []) do
    query(opts)
    |> where([s], s.external_id == ^external_id)
    |> Repo.one()
  end

  defp query(opts) do
    external_id = Keyword.get(opts, :external_id, nil)
    boundary = Keyword.get(opts, :boundary, nil)
    status = Keyword.get(opts, :status, nil)

    from(s in Station,
      select: s)
    |> query_where_external_id(external_id)
    |> query_where_in_boundary(boundary)
    |> query_where_status(status)
  end

  defp query_where_external_id(query, nil), do: query
  defp query_where_external_id(query, []), do: query
  defp query_where_external_id(query, external_ids) when is_list(external_ids) do
    query
    |> where([s], s.external_id in ^external_ids)
  end
  defp query_where_external_id(query, external_id) do
    query
    |> where([s], s.external_id == ^external_id)
  end

  defp query_where_in_boundary(query, nil), do: query
  defp query_where_in_boundary(query, []), do: query
  defp query_where_in_boundary(query, boundary) when is_list(boundary) do
    min_lat = boundary |> Enum.map(fn c -> latitude(c) end) |> Enum.min()
    max_lat = boundary |> Enum.map(fn c -> latitude(c) end) |> Enum.max()
    min_lng = boundary |> Enum.map(fn c -> longitude(c) end) |> Enum.min()
    max_lng = boundary |> Enum.map(fn c -> longitude(c) end) |> Enum.max()

    query
    |> where([s], s.location_latitude >= ^min_lat)
    |> where([s], s.location_latitude <= ^max_lat)
    |> where([s], s.location_longitude >= ^min_lng)
    |> where([s], s.location_longitude <= ^max_lng)
  end

  defp latitude({latitude, _}), do: latitude
  defp longitude({_, longitude}), do: longitude

  defp query_where_status(query, nil), do: query
  defp query_where_status(query, []), do: query
  defp query_where_status(query, status) when is_list(status) do
    query
    |> where([s], s.status in ^status)
  end
  defp query_where_status(query, status) do
    query
    |> where([s], s.status == ^status)
  end

  def insert(attrs \\ %{}) do
    %Station{}
    |> Station.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Station{} = station, attrs \\ %{}) do
    station
    |> Station.changeset(attrs)
    |> Repo.update()
  end
end
