defmodule Tankste.Station.Areas do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.Areas.Area

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([a], a.id == ^id)
    |> Repo.one()
  end

  def get_by_key(key, opts \\ []) do
    query(opts)
    |> where([a], a.key == ^key)
    |> Repo.one()
  end

  defp query(opts) do
    from(a in Area,
      select: a)
  end

  def create(attrs \\ %{}) do
    %Area{}
    |> Area.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Area{} = area, attrs \\ %{}) do
    area
    |> Area.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Area{} = area) do
    Repo.delete(area)
  end
end
