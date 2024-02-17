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
    field = Keyword.get(opts, :field, nil)
    status = Keyword.get(opts, :status, nil)
    reported_to_origin_date = Keyword.get(opts, :reported_to_origin_date, nil)
    limit = Keyword.get(opts, :limit, nil)

    from(r in Report,
      select: r)
    |> query_where_field(field)
    |> query_where_status(status)
    |> query_where_reported_to_origin_date(reported_to_origin_date)
    |> query_limit(limit)
  end

  defp query_where_field(query, nil), do: query
  defp query_where_field(query, []), do: query
  defp query_where_field(query, fields) when is_list(fields) do
    query
    |> where([r], r.field in ^fields)
  end
  defp query_where_field(query, field) do
    query
    |> where([r], r.field == ^field)
  end

  defp query_where_status(query, nil), do: query
  defp query_where_status(query, []), do: query
  defp query_where_status(query, states) when is_list(states) do
    query
    |> where([r], r.status in ^states)
  end
  defp query_where_status(query, status) do
    query
    |> where([r], r.status == ^status)
  end

  defp query_where_reported_to_origin_date(query, nil), do: query
  defp query_where_reported_to_origin_date(query, :null) do
    query
    |> where([r], is_nil(r.reported_to_origin_date))
  end
  defp query_where_reported_to_origin_date(query, date) do
    query
    |> where([r], r.reported_to_origin_date == ^date)
  end

  defp query_limit(query, nil), do: query
  defp query_limit(query, limit) do
    query
    |> limit([r], ^limit)
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
