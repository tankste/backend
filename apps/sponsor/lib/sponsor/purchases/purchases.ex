defmodule Tankste.Sponsor.Purchases do
  import Ecto.Query, warn: false

  alias Tankste.Sponsor.Repo
  alias Tankste.Sponsor.Purchases.Purchase

  def get(id, opts \\ []) do
    query(opts)
    |> where([p], p.id == ^id)
    |> Repo.one()
  end

  defp query(_opts) do
    from(p in Purchase,
      select: p)
  end

  def create(attrs \\ %{}) do
    %Purchase{}
    |> Purchase.changeset(attrs)
    |> Repo.insert()
  end

  def delete(%Purchase{} = purchase) do
    Repo.delete(purchase)
  end
end
