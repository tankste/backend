defmodule Tankste.Station.Origins do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.Origins.Origin

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([o], o.id == ^id)
    |> Repo.one()
  end

  defp query(_opts) do
    from(o in Origin,
      select: o)
  end

  def insert(attrs \\ %{}) do
    %Origin{}
    |> Origin.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Origin{} = origin, attrs \\ %{}) do
    origin
    |> Origin.changeset(attrs)
    |> Repo.update()
  end
end
