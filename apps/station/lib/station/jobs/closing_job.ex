defmodule Tankste.Station.ClosingJob do
  use Quantum, otp_app: :station

  alias Tankste.Station.Stations
  alias Tankste.Station.Repo

  def run() do
    stations = Stations.list()
      |> Repo.preload(:prices)
      |> Enum.map(fn s ->
        prices = Enum.sort_by(s.prices, fn p -> p.priority end, :desc)
        |> Enum.uniq_by(fn p -> p.type end)

        Map.put(s, :prices, prices)
      end)

    stations
    |> Enum.filter(fn s -> s.status == "available" end)
    |> close_outdated_stations()

    stations
    |> Enum.filter(fn s -> s.status == "auto_closed" end)
    |> open_reactive_stations()
  end

  defp close_outdated_stations([]), do: :ok
  defp close_outdated_stations([station|stations]) do
    case station |> last_changed_price_date() |> is_outdated?() do
      true ->
        Stations.update(station, %{status: "auto_closed"})
      _ ->
        :ok
    end

    close_outdated_stations(stations)
  end

  defp open_reactive_stations([]), do: :ok
  defp open_reactive_stations([station|stations]) do
    case station |> last_changed_price_date() |> is_outdated?() do
      false ->
        Stations.update(station, %{status: "available"})
      _ ->
        :ok
    end

    open_reactive_stations(stations)
  end

  defp last_changed_price_date(station) do
    station
    |> Map.get(:prices, [])
    |> Enum.max_by(
      fn p -> p.last_changes_at end,
      fn d1, d2 -> DateTime.compare(d1, d2) == :lt or DateTime.compare(d1, d2) == :eq end,
      fn -> nil end
    )
  end

  defp is_outdated?(nil), do: true
  defp is_outdated?(last_changed_price) do
    threshold = DateTime.now!("Europe/Berlin") |> DateTime.add(-7, :day)
    case  DateTime.compare(threshold, last_changed_price.last_changes_at) do
      :gt -> true
      _ -> false
    end
  end
end
