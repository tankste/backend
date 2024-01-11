defmodule Tankste.FillWeb.StationQueue do
  use GenStage

  def start_link(_args) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add(stations) do
    GenServer.cast(__MODULE__, {:add, stations})
  end

  @impl true
  def init(_args) do
    {:producer, [], [buffer_size: :infinity]}
  end

  def handle_info(_, state) do
    {:noreply, [], state}
  end

  def handle_cast({:add, stations}, state) when is_list(stations) do
    {:noreply, stations, state}
  end

  def handle_demand(demand, state) do
    stations = Enum.take(state, demand)
    state = Enum.drop(state, demand)
    {:noreply, stations, state}
  end
end
