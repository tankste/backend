defmodule Tankste.FillWeb.PriceProcessor do
  use GenServer

  alias Tankste.Station.Stations
  alias Tankste.Station.Prices

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def update(prices) do
    GenServer.cast(__MODULE__, {:update, prices})
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:update, prices}, state) do
    upsert_prices(prices)
    Prices.calculate_price_comparisons()
    {:noreply, state}
  end

  defp upsert_prices(new_prices, existing_prices \\ nil)
  defp upsert_prices([], _), do: :ok
  # TODO: refactore this
  defp upsert_prices(new_prices, nil) do
    stations = Stations.list(external_id: Enum.map(new_prices, fn p -> p["externalId"] end))
    new_prices = Enum.map(new_prices, fn p ->
      case Enum.find(stations, fn s -> s.external_id == p["externalId"] end) do
        nil ->
          nil
        station ->
          Map.put(p, "stationId", station.id)
      end
    end)
    |> Enum.filter(fn p -> p != nil end)
    existing_prices = Prices.list(station_id: Enum.map(new_prices, fn p -> p["stationId"] end))
    upsert_prices(new_prices, existing_prices)
  end
  defp upsert_prices([new_price|new_prices], existing_prices) do
    result = case Enum.find(existing_prices, fn p -> p.station_id == new_price["stationId"] end) do
      nil ->
        Prices.insert(%{
          origin: "mtk-s",
          station_id: new_price["stationId"],
          e5_price: new_price["e5Price"],
          e10_price: new_price["e10Price"],
          diesel_price: new_price["dieselPrice"],
          last_changes_at: DateTime.utc_now()
        })
      price ->
        Prices.update(price, %{
          origin: "mtk-s",
          station_id: new_price["stationId"],
          e5_price: new_price["e5Price"],
          e10_price: new_price["e10Price"],
          diesel_price: new_price["dieselPrice"],
          last_changes_at: DateTime.utc_now()
        })
    end

    case result do
      {:ok, _price} ->
        upsert_prices(new_prices, existing_prices)
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
