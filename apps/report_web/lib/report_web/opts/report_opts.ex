defmodule Tankste.ReportWeb.ReportOpts do

  def opts(params) do
    []
    |> Kernel.++(opts_origin_id(params))
    |> Kernel.++(opts_status(params))
    |> Kernel.++(opts_field(params))
    |> Kernel.++(opts_reported_to_origin_date(params))
  end

  defp opts_origin_id(%{"originId" => origin_ids}) when is_list(origin_ids) do
    [origin_id: origin_ids]
  end
  defp opts_origin_id(%{"originId" => origin_id}) when is_binary(origin_id) or is_integer(origin_id) do
    [origin_id: origin_id]
  end
  defp opts_origin_id(_), do: []

  defp opts_status(%{"status" => states}) when is_list(states) do
    [status: states]
  end
  defp opts_status(%{"status" => status}) when is_binary(status) do
    [status: status]
  end
  defp opts_status(_), do: []

  defp opts_field(%{"field" => fields}) when is_list(fields) do
    [field: fields]
  end
  defp opts_field(%{"field" => field}) when is_binary(field) do
    [field: field]
  end
  defp opts_field(_), do: []

  defp opts_reported_to_origin_date(%{"reportedToOriginDate" => "null"}) do
    [reported_to_origin_date: :null]
  end
  defp opts_reported_to_origin_date(_), do: []
end
