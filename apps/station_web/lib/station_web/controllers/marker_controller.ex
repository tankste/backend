defmodule Tankste.StationWeb.MarkerController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Markers
  alias Tankste.Station.OpenTimes

  # TODO: limit requests to max ~0.2 degree
  # TODO: fall back request
  def index(conn, %{"boundary" => boundary_param}) do
    boundary = boundary_param
      |> Enum.map(fn b -> b |> String.split(",") |> Enum.map(&String.to_float/1) end)
      |> Enum.map(fn b -> List.to_tuple(b) end)

    markers = Markers.list(boundary: boundary)
      |> Enum.map(&override_states/1)

    render(conn, "index.json", markers: markers)
  end

  defp override_states(marker) do
    case in_open_time(marker) do
      true ->
        marker
      false ->
        marker
        |> Map.put(:e5_price, nil)
        |> Map.put(:e5_price_comparison, "not_available")
        |> Map.put(:e10_price, nil)
        |> Map.put(:e10_price_comparison, "not_available")
        |> Map.put(:diesel_price, nil)
        |> Map.put(:diesel_price_comparison, "not_Available")
    end
  end

  defp in_open_time(marker) do
    OpenTimes.list(station_id: marker.station_id, day: Date.utc_today() |> Date.day_of_week() |> day())
    |> Enum.any?(fn t -> t.start_time == t.end_time or (t.start_time <= Time.utc_now() && t.end_time >= Time.utc_now()) end)
  end

  defp day(1), do: "monday"
  defp day(2), do: "tuesday"
  defp day(3), do: "wednesday"
  defp day(4), do: "thursday"
  defp day(5), do: "friday"
  defp day(6), do: "saturday"
  defp day(7), do: "sunday"
  defp day(_), do: nil
end
