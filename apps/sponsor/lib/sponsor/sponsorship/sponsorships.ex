defmodule Tankste.Sponsor.Sponsorships do
  import Ecto.Query, warn: false

  alias Tankste.Sponsor.Repo
  alias Tankste.Sponsor.Sponsorships.Sponsorship

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([s], s.id == ^id)
    |> Repo.one()
  end

  def get_by_device_id(device_id, opts \\ []) do
    query(opts)
    |> where([s], s.device_id == ^device_id)
    |> Repo.one()
  end

  defp query(_opts) do
    from(s in Sponsorship,
      select: s)
  end

  def create(attrs \\ %{}) do
    %Sponsorship{}
    |> Sponsorship.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Sponsorship{} = sponsorship, attrs \\ %{}) do
    sponsorship
    |> Sponsorship.changeset(attrs)
    |> Repo.update()
  end
end
