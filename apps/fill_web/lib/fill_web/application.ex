defmodule Tankste.FillWeb.Application do
  use Application

  def start(_type, _args) do
    children = [
      Tankste.FillWeb.Endpoint,
      Tankste.FillWeb.StationProcessor,
      Tankste.FillWeb.PriceProcessor
    ]

    opts = [strategy: :one_for_one, name: Tankste.FillWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Tankste.FillWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
