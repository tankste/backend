defmodule Tankste.Station.PriceSnapshots do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.PriceSnapshots.PriceSnapshot

  def create(price_snapshots) when is_list(price_snapshots) do
    # TODO: VERY HACKY x.x
    line_break = """

    """

    header = price_snapshots |> Enum.at(0) |> Map.keys() |> Enum.join(",")
    values = price_snapshots
    |> Enum.map(fn attrs ->
      attrs |> Map.values() |> Enum.join(",")
    end)
    |> Enum.join(line_break)

    data = """
    #{header}
    #{values}
    """

    credentials_encoded = Base.encode64(credentials())
    headers = [
      {"Authorization", "Basic #{credentials_encoded}"},
      {"Content-Type", "multipart/form-data"}
    ]
    case HTTPoison.post("https://#{host()}/imp?create=false&name=#{table()}", {:multipart, [{"data", data}]}, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        :ok
      err ->
        IO.puts("Create price snapshot failed")
        IO.inspect err
        {:error, :failed}
    end
  end

  def create(attrs \\ %{}) do
    header = attrs |> Map.keys() |> Enum.join(",")
    value = attrs |> Map.values() |> Enum.join(",")

    data = """
    #{header}
    #{value}
    """

    credentials_encoded = Base.encode64(credentials())
    headers = [
      {"Authorization", "Basic #{credentials_encoded}"},
      {"Content-Type", "multipart/form-data"}
    ]
    case HTTPoison.post("https://#{host()}/imp?create=false&name=#{table()}", {:multipart, [{"data", data}]}, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        :ok
      err ->
        IO.puts("Create price snapshot failed")
        IO.inspect err
        {:error, :failed}
    end
  end

  defp host(), do: stats_config() |> Keyword.fetch!(:host)

  defp credentials(), do: stats_config() |> Keyword.fetch!(:credentials)

  defp table(), do: stats_config() |> Keyword.fetch!(:table)

  defp stats_config(), do: Application.get_env(:station, :stats)
end
