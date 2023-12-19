defmodule Tankste.Report.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Tankste.Report.Repo,
      {Phoenix.PubSub, name: Tankste.Report.PubSub},
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Tankste.Report.Supervisor)
  end
end
