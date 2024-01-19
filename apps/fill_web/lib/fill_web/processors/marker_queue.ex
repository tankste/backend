defmodule Tankste.FillWeb.MarkerQueue do
  use GenStage

  def start_link(_args) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add(stations) do
    GenServer.cast(__MODULE__, {:add, stations})
  end

  @impl true
  def init(:ok) do
    {:producer, {:queue.new, 0}, [buffer_size: :infinity, dispatcher: {GenStage.DemandDispatcher, max_demand: 1_000}]}
  end

  @impl true
  def handle_info(_, state) do
    {:noreply, [], state}
  end

  @impl true
  def handle_cast({:add, stations}, {queue, pending_demand}) when is_list(stations) do
    queued_station_ids = :queue.to_list(queue)
      |> Enum.map(fn s -> s.id end)

    queue = stations
      |> Enum.filter(fn s -> s.id not in queued_station_ids end)
      |> Enum.reduce(queue, fn(s, q) -> :queue.in(s, q) end)

    dispatch_stations(queue, pending_demand, [])
  end

  @impl true
  def handle_cast({:add, station}, {queue, pending_demand}) do
    queued_station_ids = :queue.to_list(queue)
      |> Enum.map(fn s -> s.id end)

    queue = case station.id in queued_station_ids do
        false ->
          :queue.in(station, queue)
        _ ->
          queue
      end

    dispatch_stations(queue, pending_demand, [])
  end

  @impl true
  def handle_demand(incoming_demand, {queue, pending_demand}) do
    dispatch_stations(queue, incoming_demand + pending_demand, [])
  end

  defp dispatch_stations(queue, 0, stations) do
    {:noreply, Enum.reverse(stations), {queue, 0}}
  end
  defp dispatch_stations(queue, demand, stations) do
    case :queue.out(queue) do
      {{:value, station}, queue} ->
        dispatch_stations(queue, demand - 1, [station | stations])
      {:empty, queue} ->
        {:noreply, Enum.reverse(stations), {queue, demand}}
    end
  end
end
