defmodule Tankste.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: File.read!("version.txt"),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp deps do
    []
  end
end
