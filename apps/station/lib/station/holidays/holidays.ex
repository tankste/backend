defmodule Tankste.Station.Holidays do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.Holidays.Holiday

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([a], a.id == ^id)
    |> Repo.one()
  end

  def get_by_date_and_area_id(date, area_id, opts \\ []) do
    query(opts)
    |> where([h], h.date == ^date and h.area_id == ^area_id)
    |> Repo.one()
  end

  defp query(opts) do
    date = Keyword.get(opts, :date, nil)
    area_id = Keyword.get(opts, :area_id, nil)

    from(h in Holiday,
      select: h)
    |> query_where_date(date)
    |> query_where_area_id(area_id)
  end

  defp query_where_date(query, nil), do: query
  defp query_where_date(query, []), do: query
  defp query_where_date(query, date) when is_list(date) do
    query
    |> where([h], h.date in ^date)
  end
  defp query_where_date(query, date) do
    query
    |> where([h], h.date == ^date)
  end

  defp query_where_area_id(query, nil), do: query
  defp query_where_area_id(query, []), do: query
  defp query_where_area_id(query, area_id) when is_list(area_id) do
    query
    |> where([h], h.area_id in ^area_id)
  end
  defp query_where_area_id(query, area_id) do
    query
    |> where([h], h.area_id == ^area_id)
  end

  def create(attrs \\ %{}) do
    %Holiday{}
    |> Holiday.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Holiday{} = holiday, attrs \\ %{}) do
    holiday
    |> Holiday.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Holiday{} = holiday) do
    Repo.delete(holiday)
  end
end
