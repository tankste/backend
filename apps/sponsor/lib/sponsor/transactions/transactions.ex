defmodule Tankste.Sponsor.Transactions do
  import Ecto.Query, warn: false

  alias Tankste.Sponsor.Repo
  alias Tankste.Sponsor.Transactions.Transaction

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([t], t.id == ^id)
    |> Repo.one()
  end

  defp query(_opts) do
    from(t in Transaction,
      select: t)
  end

  def create(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Transaction{} = transaction, attrs \\ %{}) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end
end
