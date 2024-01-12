defmodule Tankste.FillWeb.HolidayQueue do
  use GenStage

  def start_link(_args) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add(holidays) do
    GenServer.cast(__MODULE__, {:add, holidays})
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
  def handle_cast({:add, holidays}, state) when is_list(holidays) do
    {:noreply, holidays, state}
  end

  @impl true
  def handle_demand(demand, state) do
    holidays = Enum.take(state, demand)
    state = Enum.drop(state, demand)
    {:noreply, holidays, state}
  end
end
