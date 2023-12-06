defmodule Tankste.Sponsor.Comments do
  import Ecto.Query, warn: false

  alias Tankste.Sponsor.Repo
  alias Tankste.Sponsor.Comments.Comment

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([c], c.id == ^id)
    |> Repo.one()
  end

  def get_by_device_id(device_id, opts \\ []) do
    query(opts)
    |> where([c], c.device_id == ^device_id)
    |> Repo.one()
  end

  defp query(_opts) do
    from(c in Comment,
      select: c)
  end

  def create(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Comment{} = comment, attrs \\ %{}) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end
end
