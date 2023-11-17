defmodule Tankste.FillWeb.PriceProcessor do
  use GenServer

  alias Tankste.Station.Stations
  alias Tankste.Station.Prices
  alias Tankste.Station.Repo
  alias Tankste.FillWeb.MarkerProcessor

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{prices: [], stations: [], current_prices: [], processing: false}, name: __MODULE__)
  end

  def add(prices) do
    GenServer.cast(__MODULE__, {:add, prices})
    process()
  end

  defp process() do
    case GenServer.call(__MODULE__, :get_processing, :infinity) do
      false ->
        GenServer.cast(__MODULE__, :process)
      true ->
        :ok
    end
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get_processing, _from, %{:processing => processing} = state) do
    {:reply, processing, state}
  end

  @impl true
  def handle_cast({:add, add_prices}, %{:prices => prices, :processing => processing}) do
    add_external_ids = Enum.map(add_prices, fn ap -> ap["externalId"] end)
    {:noreply, %{prices: Enum.filter(prices, fn p -> p["externalId"] not in add_external_ids end) ++ add_prices, stations: Stations.list(), current_prices: Prices.list(), processing: processing}}
  end
  def handle_cast(:process, %{:prices => []}) do
    MarkerProcessor.update()
    {:noreply, %{prices: [], stations: [], current_prices: [], processing: false}}
  end
  def handle_cast(:process, %{:prices => [price|prices], :stations => stations, :current_prices => current_prices}) do
    case upsert_price(price, stations, current_prices) do
      {:ok, updated_prices} ->
        updated_ids = Enum.map(updated_prices, fn up -> up.id end)
        GenServer.cast(__MODULE__, :process) # Process next item
        {:noreply, %{prices: prices, stations: stations, current_prices: Enum.filter(current_prices, fn cp -> cp.id not in updated_ids end) ++ updated_prices, processing: true}}
      {:error, :no_station} ->
        # IO.inspect("No station with external ID #{price["externalId"]}")
        GenServer.cast(__MODULE__, :process) # Process next item
        {:noreply, %{prices: prices, stations: stations, current_prices: current_prices, processing: true}}
      {:error, changeset} ->
        IO.inspect(changeset)
    end
  end

  defp upsert_price(new_price, stations, current_prices) do
    case Enum.find(stations, fn station -> station.external_id == new_price["externalId"] end) do
      nil ->
        {:error, :no_station}
      station ->
        Repo.transaction(fn ->
          with {:ok, e5Price} <- upsert_price_type(current_prices |> Enum.find(fn p -> p.station_id == station.id and p.type == "e5" end), station.id, "e5", new_price["e5Price"], new_price["e5LastChangeDate"]),
            {:ok, e10Price} <- upsert_price_type(current_prices |> Enum.find(fn p -> p.station_id == station.id and p.type == "e10" end), station.id, "e10", new_price["10Price"], new_price["e10LastChangeDate"]),
            {:ok, dieselPrice} <- upsert_price_type(current_prices |> Enum.find(fn p -> p.station_id == station.id and p.type == "diesel" end), station.id, "diesel", new_price["dieselPrice"], new_price["dieselLastChangeDate"]) do
              [e5Price, e10Price, dieselPrice]
              |> Enum.filter(fn price -> price != nil end)
          else
            {:error, changeset} ->
              {:error, changeset}
          end
        end)
    end
  end

  defp upsert_price_type(_existing_price, _station_id, _type, nil, _last_changes_at), do: {:ok, nil}
  defp upsert_price_type(nil, station_id, type, price_value, last_changes_at) do
    Prices.insert(%{
      origin: "mtk-s",
      station_id: station_id,
      type: type,
      price: price_value,
      last_changes_at: last_changes_at
    })
  end
  defp upsert_price_type(existing_price, station_id, type, price_value, last_changes_at) do
    Prices.update(existing_price, %{
      origin: "mtk-s",
      station_id: station_id,
      type: type,
      price: price_value,
      last_changes_at: last_changes_at
    })
  end
end
