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
      {Tankste.FillWeb.MarkerQueue, []},
      station_processors(processor_instances(:station)),
      price_processors(processor_instances(:price)),
      marker_processors(processor_instances(:marker)),
    ]
    |> List.flatten()

    Supervisor.init(children, strategy: :rest_for_one)
  end

  defp station_processors(instances) do
    0..instances
    |> Enum.map(fn i ->
        id = "station_processor_#{i}" |> String.to_atom()
        Supervisor.child_spec({Tankste.FillWeb.StationProcessor, []}, id: id)
      end)
  end

  defp price_processors(instances) do
    0..instances
    |> Enum.map(fn i ->
        id = "price_processor_#{i}" |> String.to_atom()
        Supervisor.child_spec({Tankste.FillWeb.PriceProcessor, []}, id: id)
      end)
  end

  defp marker_processors(instances) do
    0..instances
    |> Enum.map(fn i ->
        id = "marker_processor_#{i}" |> String.to_atom()
        Supervisor.child_spec({Tankste.FillWeb.MarkerProcessor, []}, id: id)
      end)
  end

  defp processor_instances(:station), do: processor_config() |> Keyword.get(:password, 5)
  defp processor_instances(:price), do: processor_config() |> Keyword.get(:password, 10)
  defp processor_instances(:marker), do: processor_config() |> Keyword.get(:marker, 10)

  defp processor_config(), do: Application.get_env(:fill_web, :processor)
end
