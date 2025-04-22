defmodule Tankste.FillWeb.ProcessorSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Tankste.FillWeb.StationQueue, []},
      {Tankste.FillWeb.PriceQueue, []},
      {Tankste.FillWeb.HolidayQueue, []},
      station_processors(processor_instances(:station)),
      price_processors(processor_instances(:price)),
      holiday_processors(processor_instances(:holiday))
    ]
    |> List.flatten()

    Supervisor.init(children, strategy: :rest_for_one)
  end

  defp station_processors(instances) do
    0..instances - 1
    |> Enum.map(fn i ->
        id = "station_processor_#{i}" |> String.to_atom()
        Supervisor.child_spec({Tankste.FillWeb.StationProcessor, []}, id: id)
      end)
  end

  defp price_processors(instances) do
    0..instances - 1
    |> Enum.map(fn i ->
        id = "price_processor_#{i}" |> String.to_atom()
        Supervisor.child_spec({Tankste.FillWeb.PriceProcessor, []}, id: id)
      end)
  end

  defp holiday_processors(instances) do
    0..instances - 1
    |> Enum.map(fn i ->
        id = "holiday_processor_#{i}" |> String.to_atom()
        Supervisor.child_spec({Tankste.FillWeb.HolidayProcessor, []}, id: id)
      end)
  end

  defp processor_instances(key), do: processor_config() |> Keyword.get(key, instances_default(key))

  defp instances_default(:station), do: 1
  defp instances_default(:price), do: 10
  defp instances_default(:holiday), do: 1

  defp processor_config(), do: Application.get_env(:fill_web, :processor)
end
