defmodule Tankste.CockpitWeb.MenuComponents do
  use Phoenix.Component

  alias Tankste.Report.Reports

  def open_reports_badge(assigns) do
    reports_count = Reports.list(status: "open") |> Enum.count()

    case reports_count do
      0 -> ~H""
      _ ->
        ~H"""
        <span class="inline-flex items-center justify-center w-6 h-6 ms-2 text-xs font-semibold text-red-800 bg-red-200 rounded-full">
          <%= reports_count %>
        </span>
        """
    end
  end
end
