defmodule Tankste.FillWeb.MarkerProcessor do
  use GenServer

  alias Tankste.Station.Stations
  alias Tankste.Station.Markers
  alias Tankste.Station.Repo

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{stations: [], all_stations: [], current_markers: [], processing: false}, name: __MODULE__)
  end

  def update() do
    GenServer.cast(__MODULE__, :update)
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
  def handle_cast(:update, %{:processing => processing}) do
    stations = Stations.list()
      |> Repo.preload(:prices)
    {:noreply, %{stations: stations, all_stations: stations, current_markers: Markers.list(), processing: processing}}
  end
  def handle_cast(:process, %{:stations => []}), do: {:noreply, %{stations: [], all_stations: [], current_markers: [], processing: false}}
  def handle_cast(:process, %{:stations => [station|stations], :all_stations => all_stations, :current_markers => current_markers}) do
    case upsert_marker(station, all_stations, current_markers) do
      {:ok, updated_marker} ->
        GenServer.cast(__MODULE__, :process) # Process next item
        {:noreply, %{stations: stations, all_stations: all_stations, current_markers: Enum.filter(current_markers, fn cm -> cm.id != updated_marker.id end) ++ [updated_marker], processing: true}}
      {:error, changeset} ->
        IO.inspect(changeset)
    end
  end

  defp upsert_marker(station, all_stations, current_markers) do
    near_stations = all_stations
      |> Enum.filter(fn s -> Geocalc.within?(20_000, [s.location_longitude, s.location_latitude], [station.location_longitude, station.location_latitude]) end)

    case Enum.find(current_markers, fn m -> m.station_id == station.id end) do
      nil ->
        Markers.insert(%{
          station_id: station.id,
          label: station.brand,
          latitude: station.location_latitude,
          longitude: station.location_longitude,
          e5_price: get_price(station, "e5"),
          e5_price_comparison: get_price_comparison(station, "e5", near_stations),
          e10_price: get_price(station, "e10"),
          e10_price_comparison: get_price_comparison(station, "e10", near_stations),
          diesel_price: get_price(station, "diesel"),
          diesel_price_comparison: get_price_comparison(station, "diesel", near_stations)
        })
      marker ->
        Markers.update(marker, %{
          station_id: station.id,
          label: station.brand,
          latitude: station.location_latitude,
          longitude: station.location_longitude,
          e5_price: get_price(station, "e5"),
          e5_price_comparison: get_price_comparison(station, "e5", near_stations),
          e10_price: get_price(station, "e10"),
          e10_price_comparison: get_price_comparison(station, "e10", near_stations),
          diesel_price: get_price(station, "diesel"),
          diesel_price_comparison: get_price_comparison(station, "diesel", near_stations)
        })
    end
  end

  defp get_price(station, type) do
    case Enum.find(station.prices, fn p -> p.type == type end) do
      nil ->
        nil
      price ->
        price.price
    end
  end

  defp get_price_comparison(station, type, near_stations) do
    near_prices = near_stations
      |> Enum.flat_map(fn s -> s.prices end)
      |> Enum.filter(fn p -> p.type == type end)
      |> Enum.map(fn p -> p.price end)

    case get_price(station, type) do
      nil ->
        nil
      price_value ->
        min_price = near_prices
          |> Enum.min()

        cond do
          min_price + 0.04 >= price_value -> "cheap"
          min_price + 0.10 >= price_value -> "medium"
          true -> "expensive"
        end
    end
  end
end
