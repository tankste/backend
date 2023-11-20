defmodule Tankste.Sponsor.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Tankste.Sponsor.Repo,
      {Phoenix.PubSub, name: Tankste.Sponsor.PubSub},
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Tankste.Sponsor.Supervisor)
  end
end
