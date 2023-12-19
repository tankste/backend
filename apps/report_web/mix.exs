defmodule Tankste.ReportWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :report_web,
      version: File.read!("../../version.txt"),
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        report_web: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent],
          runtime_config_path: "./config/runtime.exs"
        ],
      ]
    ]
  end

  def application do
    [
      mod: {Tankste.ReportWeb.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:report, in_umbrella: true},
      {:station, in_umbrella: true},
      {:plug_cowboy, "~> 2.6.0"},
      {:phoenix, "~> 1.6.15"},
      {:phoenix_html, "~> 3.2.0"},
      {:phoenix_live_reload, "~> 1.4.0", only: :dev},
      {:jason, "~> 1.4.0"},
    ]
  end
end
