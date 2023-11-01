defmodule Tankste.StationWeb.Application do
  use Application

  def start(_type, _args) do
    children = [
      Tankste.StationWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Tankste.StationWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Tankste.StationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
