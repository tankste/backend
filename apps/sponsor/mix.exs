defmodule Tankste.Sponsor.MixProject do
  use Mix.Project

  def project do
    [
      app: :sponsor,
      version: File.read!("../../version.txt"),
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Tankste.Sponsor.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix_pubsub, "~> 2.1.1"},
      {:ecto_sql, "~> 3.11"},
      {:myxql, "~> 0.6.3"},
      {:goth, "~> 1.4.2"},
      {:google_api_android_publisher, "~> 0.30.1"},
      {:jason, "~> 1.4.1"},
      {:httpoison, "~> 2.1.0"},
    ]
  end
end
