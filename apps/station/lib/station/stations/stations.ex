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

  defp query(opts) do
    external_id = Keyword.get(opts, :external_id, nil)

    from(s in Station,
      select: s)
    |> query_where_external_id(external_id)
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
