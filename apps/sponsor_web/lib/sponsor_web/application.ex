defmodule Tankste.SponsorWeb.Application do
  use Application

  def start(_type, _args) do
    children = [
      Tankste.SponsorWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Tankste.SponsorWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Tankste.SponsorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
