defmodule Tankste.Sponsor.Purchases do
  import Ecto.Query, warn: false

  alias Tankste.Sponsor.Repo
  alias Tankste.Sponsor.Purchases.Purchase

  def create(attrs \\ %{}) do
    %Purchase{}
    |> Purchase.changeset(attrs)
    |> Repo.insert()
  end

  def delete(%Purchase{} = purchase) do
    Repo.delete(purchase)
  end
end
