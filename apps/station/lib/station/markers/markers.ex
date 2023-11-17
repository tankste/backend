defmodule Tankste.Station.Markers do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.Markers.Marker

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([m], m.id == ^id)
    |> Repo.one()
  end

  defp query(opts) do
    boundary = Keyword.get(opts, :boundary, nil)

    from(m in Marker,
      select: m)
    |> query_where_in_boundary(boundary)
  end

  defp query_where_in_boundary(query, nil), do: query
  defp query_where_in_boundary(query, []), do: query
  defp query_where_in_boundary(query, boundary) when is_list(boundary) do
    min_lat = boundary |> Enum.map(fn c -> latitude(c) end) |> Enum.min()
    max_lat = boundary |> Enum.map(fn c -> latitude(c) end) |> Enum.max()
    min_lng = boundary |> Enum.map(fn c -> longitude(c) end) |> Enum.min()
    max_lng = boundary |> Enum.map(fn c -> longitude(c) end) |> Enum.max()

    query
    |> where([m], m.latitude >= ^min_lat)
    |> where([m], m.latitude <= ^max_lat)
    |> where([m], m.longitude >= ^min_lng)
    |> where([m], m.longitude <= ^max_lng)
  end

  defp latitude({latitude, _}), do: latitude
  defp longitude({_, longitude}), do: longitude

  def insert(attrs \\ %{}) do
    %Marker{}
    |> Marker.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Marker{} = marker, attrs \\ %{}) do
    marker
    |> Marker.changeset(attrs)
    |> Repo.update()
  end
end
