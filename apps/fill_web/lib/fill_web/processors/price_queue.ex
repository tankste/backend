defmodule Tankste.FillWeb.PriceQueue do
  use GenStage

  def start_link(_args) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add(prices) do
    GenServer.cast(__MODULE__, {:add, prices})
  end

  @impl true
  def init(_args) do
    {:producer, [], [buffer_size: :infinity]}
  end

  def handle_info(_, state) do
    {:noreply, [], state}
  end

  def handle_cast({:add, prices}, state) when is_list(prices) do
    {:noreply, prices, state}
  end

  def handle_demand(demand, state) do
    prices = Enum.take(state, demand)
    state = Enum.drop(state, demand)
    {:noreply, prices, state}
  end
end
