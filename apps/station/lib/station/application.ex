defmodule Tankste.Station.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Tankste.Station.Repo,
      {Phoenix.PubSub, name: Tankste.Station.PubSub},
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Tankste.Station.Supervisor)
  end
end
