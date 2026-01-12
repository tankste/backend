defmodule Tankste.Station.PriceSnapshotJob do
  use Quantum, otp_app: :station

  alias Tankste.Station.Stations
  alias Tankste.Station.PriceSnapshots
  alias Tankste.Station.Repo

  def run() do
    snapshot_timestamp = DateTime.utc_now() |> DateTime.to_unix(:microsecond)

    stations = Stations.list(status: "available")
      |> Repo.preload(:prices)
      |> Enum.map(fn s ->
        prices = Enum.sort_by(s.prices, fn p -> p.priority end, :desc)
        |> Enum.uniq_by(fn p -> p.type end)

        Map.put(s, :prices, prices)
      end)

    generate_price_snapshots(snapshot_timestamp, stations)
    |> PriceSnapshots.create()
  end

  defp generate_price_snapshots(_, []), do: []
  defp generate_price_snapshots(snapshot_timestamp, [station|stations]) do
    [
        %{
        station_id: station.id,
        timestamp: snapshot_timestamp,
        petrol_price: station |> price("petrol"),
        petrol_super_e5_price: station |> price("petrol_super_e5"),
        petrol_super_e5_additive_price: station |> price("petrol_super_e5_additive"),
        petrol_super_e10_price: station |> price("petrol_super_e10"),
        petrol_super_e10_additive_price: station |> price("petrol_super_e10_additive"),
        petrol_super_plus_price: station |> price("petrol_super_plus"),
        petrol_super_plus_additive_price: station |> price("petrol_super_plus_additive"),
        diesel_price: station |> price("diesel"),
        diesel_additive_price: station |> price("diesel_additive"),
        diesel_hvo100_price: station |> price("diesel_hvo100"),
        diesel_hvo100_additive_price: station |> price("diesel_hvo100_additive"),
        diesel_truck_price: station |> price("diesel_truck"),
        diesel_hvo100_truck_price: station |> price("diesel_hvo100_truck"),
        lpg_price: station |> price("lpg"),
        adblue_price: station |> price("adblue"),
      }
    ] ++ generate_price_snapshots(snapshot_timestamp, stations)
  end

  defp price(station, type) do
    case station.prices |> Enum.find(fn p -> p.type == type end) do
      nil -> nil
      price -> price.price
    end
  end
end
