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

  # TODO: should be external ID + origin
  def get_by_external_id(external_id, opts \\ []) do
    query(opts)
    |> where([s], s.external_id == ^external_id)
    |> limit(1)
    |> Repo.one()
  end

  defp query(opts) do
    id = Keyword.get(opts, :id, nil)
    status = Keyword.get(opts, :status, nil)

    from(s in Station,
      select: s)
    |> query_where_id(id)
    |> query_where_status(status)
  end

  defp query_where_id(query, nil), do: query
  defp query_where_id(query, []), do: query
  defp query_where_id(query, id) when is_list(id) do
    query
    |> where([s], s.id in ^id)
  end
  defp query_where_id(query, id) do
    query
    |> where([s], s.id == ^id)
  end

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

  def change(%Station{} = station, attrs \\ %{}) do
    station
    |> Station.changeset(attrs)
  end

  def create(attrs \\ %{}) do
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
