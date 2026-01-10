defmodule Tankste.FillWeb.PriceProcessor do
  use GenStage

  alias Tankste.Station.StationInfos
  alias Tankste.Station.Prices

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, [])
  end

  @impl true
  def init(_args) do
    {:consumer, [], subscribe_to: [{Tankste.FillWeb.PriceQueue, [max_demand: 1_000]}]}
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
      {:ok, _updated_prices} ->
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

  defp upsert_price(%{"originId" => nil}), do: {:error, :no_origin_id}
  defp upsert_price(%{"externalId" => nil}), do: {:error, :no_external_id}
  defp upsert_price(%{"originId" => origin_id, "externalId" => external_id} = new_price) do
    case StationInfos.get_by_external_id(origin_id, external_id) do
      nil ->
        {:error, :no_station}
      station_info ->
        with {:ok, petrolPrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "petrol"), origin_id, station_info.station_id, "petrol", new_price["petrolPrice"], new_price["petrolLabel"], new_price["petrolLastChangeDate"]),
          {:ok, petrolSuperE5Price} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "petrol_super_e5"), origin_id, station_info.station_id, "petrol_super_e5", new_price["petrolSuperE5Price"], new_price["petrolSuperE5Label"], new_price["petrolSuperE5LastChangeDate"]),
          {:ok, petrolSuperE5AdditivePrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "petrol_super_e5_additive"), origin_id, station_info.station_id, "petrol_super_e5_additive", new_price["petrolSuperE5AdditivePrice"], new_price["petrolSuperE5AdditiveLabel"], new_price["petrolSuperE5AdditiveLastChangeDate"]),
          {:ok, petrolSuperE10Price} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "petrol_super_e10"), origin_id, station_info.station_id, "petrol_super_e10", new_price["petrolSuperE10Price"], new_price["petrolSuperE10Label"], new_price["petrolSuperE10LastChangeDate"]),
          {:ok, petrolSuperE10AdditivePrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "petrol_super_e10_additive"), origin_id, station_info.station_id, "petrol_super_e10_additive", new_price["petrolSuperE10AdditivePrice"], new_price["petrolSuperE10AdditiveLabel"], new_price["petrolSuperE10AdditiveLastChangeDate"]),
          {:ok, petrolSuperPlusPrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "petrol_super_plus"), origin_id, station_info.station_id, "petrol_super_plus", new_price["petrolSuperPlusPrice"], new_price["petrolSuperPlusLabel"], new_price["petrolSuperPlusLastChangeDate"]),
          {:ok, petrolSuperPlusAdditivePrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "petrol_super_plus_additive"), origin_id, station_info.station_id, "petrol_super_plus_additive", new_price["petrolSuperPlusAdditivePrice"], new_price["petrolSuperPlusAdditiveLabel"], new_price["petrolSuperPlusAdditiveLastChangeDate"]),
          {:ok, dieselPrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "diesel"), origin_id, station_info.station_id, "diesel", new_price["dieselPrice"], new_price["dieselLabel"], new_price["dieselLastChangeDate"]),
          {:ok, dieselAdditivePrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "diesel_additive"), origin_id, station_info.station_id, "diesel_additive", new_price["dieselAdditivePrice"], new_price["dieselAdditiveLabel"], new_price["dieselAdditiveLastChangeDate"]),
          {:ok, dieselHvo100Price} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "diesel_hvo100"), origin_id, station_info.station_id, "diesel_hvo100", new_price["dieselHvo100Price"], new_price["dieseHvo100lLabel"], new_price["dieselHvo100LastChangeDate"]),
          {:ok, dieselHvo100AdditivePrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "diesel_hvo100_additive"), origin_id, station_info.station_id, "diesel_hvo100_additive", new_price["dieselHvo100AdditivePrice"], new_price["dieselHvo100AdditiveLabel"], new_price["dieselHvo100AdditiveLastChangeDate"]),
          {:ok, dieselTruckPrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "diesel_truck"), origin_id, station_info.station_id, "diesel_truck", new_price["dieselTruckPrice"], new_price["dieselTruckLabel"], new_price["dieselTruckLastChangeDate"]),
          {:ok, dieselHvo100TruckPrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "diesel_hvo100_truck"), origin_id, station_info.station_id, "diesel_hvo100_truck", new_price["dieselHvo100TruckPrice"], new_price["dieselHvo100TruckLabel"], new_price["dieselHvo100TruckLastChangeDate"]),
          {:ok, lpgPrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "lpg"), origin_id, station_info.station_id, "lpg", new_price["lpgPrice"], new_price["lpgLabel"], new_price["lpgLastChangeDate"]),
          {:ok, adbluePrice} <- upsert_price_type(Prices.get_by_station_id_and_type(station_info.station_id, "adblue"), origin_id, station_info.station_id, "adblue", new_price["adbluePrice"], new_price["adblueLabel"], new_price["adblueLastChangeDate"]) do
            prices = [petrolPrice, petrolSuperE5Price, petrolSuperE5AdditivePrice, petrolSuperE10Price, petrolSuperE10AdditivePrice, petrolSuperPlusPrice, petrolSuperPlusAdditivePrice, dieselPrice, dieselAdditivePrice, dieselHvo100Price, dieselHvo100AdditivePrice, dieselTruckPrice, dieselHvo100TruckPrice, lpgPrice, adbluePrice]
            |> Enum.filter(fn price -> price != nil end)
            {:ok, prices}
        else
          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end

  defp upsert_price_type(nil, _origin_id, _station_id, _type, nil, _label, _last_changes_at), do: {:ok, nil}
  defp upsert_price_type(existing_price, _origin_id, _station_id, _type, nil, _label, _last_changes_at) when not is_nil(existing_price) do
    Prices.delete(existing_price)
  end
  defp upsert_price_type(nil, origin_id, station_id, type, price_value, label, last_changes_at) do
    Prices.insert(%{
      origin_id: origin_id,
      station_id: station_id,
      type: type,
      label: label,
      price: price_value,
      last_changes_at: last_changes_at || DateTime.utc_now()
    })
  end
  defp upsert_price_type(existing_price, origin_id, station_id, type, price_value, label, last_changes_at) do
    Prices.update(existing_price, %{
      origin_id: origin_id,
      station_id: station_id,
      type: type,
      label: label,
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
