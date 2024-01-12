defmodule Tankste.StationWeb.StationPriceController do
  use Tankste.StationWeb, :controller

  import Tankste.StationWeb.StationController, only: [load_station: 2]

  alias Tankste.Station.Prices
  alias Tankste.Station.OpenTimes

  plug :load_station, [station_id: "station_id"]

  def index(conn, %{"station_id" => station_id}) do
    prices = Prices.list(station_id: station_id)
    prices = case in_open_time(station_id) do
        true ->
          prices
        false ->
          []
      end

    render(conn, "index.json", prices: prices)
  end

  defp in_open_time(station_id) do
    OpenTimes.list(station_id: station_id, day: Date.utc_today() |> Date.day_of_week() |> day())
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
