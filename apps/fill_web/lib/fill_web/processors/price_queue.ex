defmodule Tankste.FillWeb.PriceQueue do
  use GenStage

  def start_link(_args) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add(prices) do
    GenServer.cast(__MODULE__, {:add, prices})
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
  def handle_cast({:add, prices}, {queue, pending_demand}) when is_list(prices) do
    queue = prices
      |> Enum.reduce(queue, fn(p, q) -> :queue.in(p, q) end)

    dispatch_prices(queue, pending_demand, [])
  end

  @impl true
  def handle_cast({:add, price}, {queue, pending_demand}) do
    queue = :queue.in(price, queue)
    dispatch_prices(queue, pending_demand, [])
  end

  @impl true
  def handle_demand(incoming_demand, {queue, pending_demand}) do
    dispatch_prices(queue, incoming_demand + pending_demand, [])
  end

  defp dispatch_prices(queue, 0, prices) do
    {:noreply, Enum.reverse(prices), {queue, 0}}
  end
  defp dispatch_prices(queue, demand, prices) do
    case :queue.out(queue) do
      {{:value, price}, queue} ->
        dispatch_prices(queue, demand - 1, [price | prices])
      {:empty, queue} ->
        {:noreply, Enum.reverse(prices), {queue, demand}}
    end
  end
end
