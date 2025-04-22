defmodule Tankste.Station.PriceSnapshotJob do
  use Quantum, otp_app: :station

  alias Tankste.Station.Stations
  alias Tankste.Station.PriceSnapshots
  alias Tankste.Station.Repo

  def run() do
    snapshot_date = DateTime.utc_now()

    stations = Stations.list(status: "available")
      |> Repo.preload(:prices)
      |> Enum.map(fn s ->
        prices = Enum.sort_by(s.prices, fn p -> p.priority end, :desc)
        |> Enum.uniq_by(fn p -> p.type end)

        Map.put(s, :prices, prices)
      end)

    create_price_snapshots(snapshot_date, stations)
  end

  defp create_price_snapshots(_, []), do: :ok
  defp create_price_snapshots(snapshot_date, [station|stations]) do
    IO.inspect PriceSnapshots.insert(%{
      station_id: station.id,
      snapshot_date: snapshot_date,
      petrol_price: station |> price("petrol"),
      petrol_super_e5_price: station |> price("e5"),
      petrol_super_e10_price: station |> price("e10"),
      petrol_super_plus_price: station |> price("petrol_super_plus"),
      petrol_shell_power_price: station |> price("petrol_shell_power"),
      petrol_aral_ultimate_price: station |> price("petrol_aral_ultimate"),
      diesel_price: station |> price("diesel"),
      diesel_truck_price: station |> price("diesel_truck"),
      diesel_shell_power_price: station |> price("diesel_shell_power"),
      diesel_aral_ultimate_price: station |> price("diesel_aral_ultimate"),
      lpg_price: station |> price("lpg")
    })

    create_price_snapshots(snapshot_date, stations)
  end

  defp price(station, type) do
    case station.prices |> Enum.find(fn p -> p.type == type end) do
      nil -> nil
      price -> price.price
    end
  end
end
