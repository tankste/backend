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

  defp query(_opts) do
    from(h in Holiday,
      select: h)
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
