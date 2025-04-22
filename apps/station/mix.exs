defmodule Tankste.Station.MixProject do
  use Mix.Project

  def project do
    [
      app: :station,
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
      mod: {Tankste.Station.Application, []},
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
      {:geocalc, "~> 0.8"},
      {:tzdata, "~> 1.1"},
      {:quantum, "~> 3.5"}
    ]
  end
end
