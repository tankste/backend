defmodule Tankste.Station.StationInfos do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.StationInfos.StationInfo

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([si], si.id == ^id)
    |> Repo.one()
  end

  def get_by_external_id(origin_id, external_id, opts \\ []) do
    query(opts)
    |> where([si], si.origin_id == ^origin_id and si.external_id == ^external_id)
    |> limit(1)
    |> Repo.one()
  end

  def get_by_station_id(station_id, opts \\ []) do
    query(opts)
    |> where([si], si.station_id == ^station_id)
    # TODO: order by origin priority or by specific field
    |> limit(1)
    |> Repo.one()
  end

  defp query(opts) do
    id = Keyword.get(opts, :id, nil)
    station_id = Keyword.get(opts, :station_id, nil)
    external_id = Keyword.get(opts, :external_id, nil)
    boundary = Keyword.get(opts, :boundary, nil)
    search = Keyword.get(opts, :search, nil)

    from(si in StationInfo,
      select: si)
    |> query_where_id(id)
    |> query_where_station_id(station_id)
    |> query_where_external_id(external_id)
    |> query_where_in_boundary(boundary)
    |> query_where_search(search)
  end

  defp query_where_id(query, nil), do: query
  defp query_where_id(query, []), do: query
  defp query_where_id(query, id) when is_list(id) do
    query
    |> where([si], si.id in ^id)
  end
  defp query_where_id(query, id) do
    query
    |> where([si], si.id == ^id)
  end

  defp query_where_station_id(query, nil), do: query
  defp query_where_station_id(query, []), do: query
  defp query_where_station_id(query, station_ids) when is_list(station_ids) do
    query
    |> where([si], si.station_id in ^station_ids)
  end
  defp query_where_station_id(query, station_id) do
    query
    |> where([si], si.station_id == ^station_id)
  end

  defp query_where_external_id(query, nil), do: query
  defp query_where_external_id(query, []), do: query
  defp query_where_external_id(query, external_ids) when is_list(external_ids) do
    query
    |> where([si], si.external_id in ^external_ids)
  end
  defp query_where_external_id(query, external_id) do
    query
    |> where([si], si.external_id == ^external_id)
  end

  defp query_where_in_boundary(query, nil), do: query
  defp query_where_in_boundary(query, []), do: query
  defp query_where_in_boundary(query, boundary) when is_list(boundary) do
    min_lat = boundary |> Enum.map(fn c -> latitude(c) end) |> Enum.min()
    max_lat = boundary |> Enum.map(fn c -> latitude(c) end) |> Enum.max()
    min_lng = boundary |> Enum.map(fn c -> longitude(c) end) |> Enum.min()
    max_lng = boundary |> Enum.map(fn c -> longitude(c) end) |> Enum.max()

    query
    |> where([si], si.location_latitude >= ^min_lat)
    |> where([si], si.location_latitude <= ^max_lat)
    |> where([si], si.location_longitude >= ^min_lng)
    |> where([si], si.location_longitude <= ^max_lng)
  end

  defp latitude({latitude, _}), do: latitude
  defp longitude({_, longitude}), do: longitude

  defp query_where_search(query, nil), do: query
  defp query_where_search(query, ""), do: query
  defp query_where_search(query, search) when is_integer(search) do
    query
    |> where([si], si.station_id == ^search or like(si.external_id, ^"%#{search}%") or like(si.name, ^"%#{search}%") or like(si.brand, ^"%#{search}%") or like(si.brand, ^"%#{search}%") or like(si.address_street, ^"%#{search}%"))
  end
  defp query_where_search(query, search) do
    query
    |> where([si], like(si.external_id, ^"%#{search}%") or like(si.name, ^"%#{search}%") or like(si.brand, ^"%#{search}%") or like(si.brand, ^"%#{search}%") or like(si.address_street, ^"%#{search}%"))
  end

  def change(%StationInfo{} = station_info, attrs \\ %{}) do
    station_info
    |> StationInfo.changeset(attrs)
  end

  def create(attrs \\ %{}) do
    %StationInfo{}
    |> StationInfo.changeset(attrs)
    |> Repo.insert()
  end

  def update(%StationInfo{} = station_info, attrs \\ %{}) do
    station_info
    |> StationInfo.changeset(attrs)
    |> Repo.update()
  end
end
