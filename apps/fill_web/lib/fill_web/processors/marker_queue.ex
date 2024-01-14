defmodule Tankste.FillWeb.MarkerQueue do
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

  @impl true
  def handle_info(_, state) do
    {:noreply, [], state}
  end

  @impl true
  def handle_cast({:add, stations}, state) when is_list(stations) do
    {:noreply, stations, state}
  end

  @impl true
  def handle_cast({:add, station}, state) do
    {:noreply, [station], state}
  end

  @impl true
  def handle_demand(demand, state) do
    state = state |> Enum.uniq_by(fn s -> s.id end)

    stations = Enum.take(state, demand)
    state = Enum.drop(state, demand)
    {:noreply, stations, state}
  end
end
