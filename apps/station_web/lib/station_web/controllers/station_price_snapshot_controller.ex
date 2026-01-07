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
    diese_hvo100
    diesel_truck
    diesel_shell_power
    diesel_aral_ultimate
    lpg
  )

  def index(conn, %{"station_id" => station_id, "type" => type}) when type in @allowed_types do
    price_snapshots = PriceSnapshots.list(station_id, DateTime.utc_now() |> DateTime.add(-30, :day))
    price_snapshot_response = Enum.map(price_snapshots, fn price_snapshot ->
        %{
          station_id: price_snapshot.station_id,
          type: type,
          price: Map.get(price_snapshot, String.to_atom(type <> "_price")),
          snapshot_date: price_snapshot.snapshot_date
        }
    end)
    |> Enum.filter(fn ps -> ps.price != nil end)

    render(conn, "index.json", price_snapshots: price_snapshot_response)
  end
  def index(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json")
  end
end
