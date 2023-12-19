defmodule Tankste.Report.Reports do
  import Ecto.Query, warn: false

  alias Tankste.Report.Repo
  alias Tankste.Report.Reports.Report

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([r], r.id == ^id)
    |> Repo.one()
  end

  defp query(opts) do
    from(r in Report,
      select: r)
  end

  def create(attrs \\ %{}) do
    %Report{}
    |> Report.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Report{} = report, attrs \\ %{}) do
    report
    |> Report.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Report{} = report) do
    Repo.delete(report)
  end
end
