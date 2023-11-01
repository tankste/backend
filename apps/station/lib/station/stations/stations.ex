defmodule Tankste.Station.Stations do
  import Ecto.Query, warn: false

  alias Ecto.Changeset
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
    from(s in Station,
      select: s)
  end
end
