defmodule Tankste.StationWeb.StationPriceController do
  use Tankste.StationWeb, :controller

  import Tankste.StationWeb.StationController, only: [load_station: 2]

  alias Tankste.Station.Prices
  alias Tankste.Station.OpenTimes
  alias Tankste.Station.StationAreas
  alias Tankste.Station.Holidays

  plug :load_station, [station_id: "station_id"]

  def index(conn, %{"station_id" => station_id}) do
    prices = Prices.list(station_id: station_id)
    prices = case is_open(station_id) do
        true ->
          prices
        false ->
          []
      end

    render(conn, "index.json", prices: prices)
  end

  # TODO: use time zone based on station location
  defp is_open(station_id) do
    case StationAreas.list(station_id: station_id) do
      [] ->
        is_in_open_time(station_id, :today)
      station_areas ->
        case Holidays.list(date: DateTime.now!("Europe/Berlin") |> DateTime.to_date(), area_id: station_areas |> Enum.map(fn sa -> sa.area_id end)) do
          [] ->
            is_in_open_time(station_id, :today)
          _holidays ->
            is_in_open_time(station_id, :holiday)
        end
    end
  end

  # TODO: use time zone based on station location
  defp is_in_open_time(station_id, :today) do
    now = DateTime.now!("Europe/Berlin")
    time_now = now |> DateTime.to_time()
    OpenTimes.list(station_id: station_id, day: now |> DateTime.to_date() |> Date.day_of_week() |> day())
    |> Enum.any?(fn t -> t.start_time == t.end_time or (t.start_time <= time_now && t.end_time >= time_now) end)
  end
  defp is_in_open_time(station_id, :holiday) do
    time_now =  DateTime.now!("Europe/Berlin") |> DateTime.to_time()
    OpenTimes.list(station_id: station_id, day: "public_holiday")
    |> Enum.any?(fn t -> t.start_time == t.end_time or (t.start_time <= time_now && t.end_time >= time_now) end)
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
