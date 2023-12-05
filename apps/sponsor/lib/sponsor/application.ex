defmodule Tankste.Sponsor.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Goth, name: Tankste.Sponsor.Goth, source: {:service_account, goth_source(), scopes: ["https://www.googleapis.com/auth/androidpublisher"]}},
      Tankste.Sponsor.Repo,
      {Phoenix.PubSub, name: Tankste.Sponsor.PubSub},
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Tankste.Sponsor.Supervisor)
  end

  defp goth_source() do
    Application.get_env(:sponsor, :goth)
    |> Keyword.fetch!(:source)
  end
end
