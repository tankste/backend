defmodule Tankste.FillWeb.PriceProcessor do
  use GenStage

  alias Tankste.FillWeb.MarkerQueue
  alias Tankste.Station.Stations
  alias Tankste.Station.Prices
  alias Tankste.Station.Repo

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, [])
  end

  @impl true
  def init(_args) do
    {:consumer, [], subscribe_to: [{Tankste.FillWeb.PriceQueue, [max_demand: 100]}]}
  end

  @impl true
  def handle_events(prices, _from, _state) do
    process_prices(prices)
  end

  defp process_prices([]) do
    {:noreply, [], []}
  end
  defp process_prices([price|prices]) do
    case upsert_price(price) do
      {:ok, []} ->
        IO.inspect "No price was updated:"
        IO.inspect price
        process_prices(prices)
      {:ok, updated_prices} ->
        station = updated_prices |> Enum.at(0) |> Map.get(:station_id) |> Stations.get()
        # TODO: filter on database instead of fetch all items
        Stations.list()
        |> Enum.filter(fn s -> Geocalc.within?(20_000, [s.location_longitude, s.location_latitude], [station.location_longitude, station.location_latitude]) end)
        |> MarkerQueue.add()

        process_prices(prices)
      {:error, :no_external_id} ->
        process_prices(prices)
      {:error, :no_station} ->
        process_prices(prices)
      {:error, changeset} ->
        IO.inspect(changeset)
        {:stop, :failed, []}
    end
  end

  defp upsert_price(%{"externalId" => nil}), do: {:error, :no_external_id}
  defp upsert_price(%{"externalId" => external_id} = new_price) do
    case Stations.get_by_external_id(external_id) do
      nil ->
        {:error, :no_station}
      station ->
        Repo.transaction(fn ->
          with {:ok, e5Price} <- upsert_price_type(Prices.get_by_station_id_and_type(station.id, "e5"), new_price["originId"], station.id, "e5", new_price["e5Price"], new_price["e5LastChangeDate"]),
            {:ok, e10Price} <- upsert_price_type(Prices.get_by_station_id_and_type(station.id, "e10"), new_price["originId"], station.id, "e10", new_price["e10Price"], new_price["e10LastChangeDate"]),
            {:ok, dieselPrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station.id, "diesel"), new_price["originId"], station.id, "diesel", new_price["dieselPrice"], new_price["dieselLastChangeDate"]) do
              [e5Price, e10Price, dieselPrice]
              |> Enum.filter(fn price -> price != nil end)
          else
            {:error, changeset} ->
              {:error, changeset}
          end
        end)
    end
  end

  defp upsert_price_type(nil, _origin_id, _station_id, _type, nil, _last_changes_at), do: {:ok, nil}
  defp upsert_price_type(existing_price, _origin_id, _station_id, _type, nil, _last_changes_at) when not is_nil(existing_price) do
    Prices.delete(existing_price)
  end
  defp upsert_price_type(nil,  origin_id, station_id, type, price_value, last_changes_at) do
    Prices.insert(%{
      origin_id: origin_id,
      station_id: station_id,
      type: type,
      price: price_value,
      last_changes_at: last_changes_at || DateTime.utc_now()
    })
  end
  defp upsert_price_type(existing_price, origin_id, station_id, type, price_value, last_changes_at) do
    Prices.update(existing_price, %{
      origin_id: origin_id,
      station_id: station_id,
      type: type,
      price: price_value,
      last_changes_at: last_price_change(existing_price, price_value, last_changes_at)
    })
  end

  defp last_price_change(existing_price, price_value, nil) do
    case existing_price.price do
      ^price_value ->
        existing_price.last_changes_at
      _ ->
        DateTime.utc_now()
    end
  end
  defp last_price_change(_, _, last_changes_at), do: last_changes_at
end
