defmodule Tankste.StationWeb.StationPriceSnapshotController do
  use Tankste.StationWeb, :controller

  import Tankste.StationWeb.StationController, only: [load_station: 2]

  alias Tankste.Station.PriceSnapshots
  alias Tankste.Station.PriceSnapshots.PriceSnapshot

  plug :load_station, [station_id: "station_id"]

  @allowed_types ~w(
    petrol
    petrol_super_e5
    petrol_super_e10
    petrol_super_plus
    petrol_shell_power
    petrol_aral_ultimate
    diesel
    diesel_truck
    diesel_shell_power
    diesel_aral_ultimate
    lpg
  )

  def index(conn, %{"station_id" => station_id, "type" => type}) when type in @allowed_types do
    price_snapshots = PriceSnapshots.list(
        station_id: station_id,
        start: DateTime.utc_now() |> DateTime.add(-7, :day)
      )
      |> Enum.map(fn price_snapshot ->
        %{
          id: price_snapshot.id,
          station_id: price_snapshot.station_id,
          type: type,
          price: PriceSnapshot.price(price_snapshot, type |> String.to_atom()),
          snapshot_date: price_snapshot.snapshot_date
        }
      end)
      |> Enum.filter(fn price_snapshot -> not is_nil(price_snapshot.price) end)

    render(conn, "index.json", price_snapshots: price_snapshots)
  end
  def index(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json")
  end
end
