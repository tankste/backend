defmodule Tankste.CockpitWeb.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Tankste.CockpitWeb.Telemetry,
      {Phoenix.PubSub, name: Tankste.CockpitWeb.PubSub},
      # # Start the Finch HTTP client for sending emails
      # {Finch, name: Tankste.CockpitWeb.Finch},
      # Start a worker by calling: Tankste.CockpitWeb.Worker.start_link(arg)
      # {Tankste.CockpitWeb.Worker, arg},
      # Start to serve requests, typically the last entry
      Tankste.CockpitWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Tankste.CockpitWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    Tankste.CockpitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
