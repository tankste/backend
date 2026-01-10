defmodule Tankste.Station.PriceSnapshots do
  import Ecto.Query, warn: false

  alias Tankste.Station.PriceSnapshots.PriceSnapshot

  def list(station_id, from) do
    {safe_station_id, _} = Integer.parse(station_id)

    credentials_encoded = Base.encode64(credentials())
    headers = [
      {"Authorization", "Basic #{credentials_encoded}"}
    ]
    params = [
      {"query", "SELECT station_id, timestamp, petrol_price, petrol_super_e5_price, petrol_super_e5_additive_price, petrol_super_e10_price, petrol_super_e10_additive_price, petrol_super_plus_price, petrol_super_plus_additive_price, diesel_price, diesel_additive_price, diesel_hvo100_price, diesel_hvo100_additive_price, diesel_truck_price, diesel_hvo100_truck_price, lpg_price, adblue_price FROM station_prices WHERE station_id = #{safe_station_id} AND timestamp >= '#{DateTime.to_iso8601(from)}'"}
    ]
    case HTTPoison.get("https://#{host()}/exec", headers, params: params) do
      {:ok, %{status_code: 200, body: body}} ->
        parse_response(body)
      err ->
        IO.puts("List price snapshots failed")
        IO.inspect err
        {:error, :failed}
    end
  end

  defp parse_response(body) do
    case Jason.decode(body) do
      {:ok, result} ->
        result["dataset"]
        |> Enum.map(fn row ->
          {:ok, date, _} = DateTime.from_iso8601(Enum.at(row, 1))
          %PriceSnapshot{
            station_id: Enum.at(row, 0),
            snapshot_date: date |> DateTime.truncate(:second),
            petrol_price: Enum.at(row, 2),
            petrol_super_e5_price: Enum.at(row, 3),
            petrol_super_e5_additive_price: Enum.at(row, 4),
            petrol_super_e10_price: Enum.at(row, 5),
            petrol_super_e10_additive_price: Enum.at(row, 6),
            petrol_super_plus_price: Enum.at(row, 7),
            petrol_super_plus_additive_price: Enum.at(row, 8),
            diesel_price: Enum.at(row, 9),
            diesel_additive_price: Enum.at(row, 10),
            diesel_hvo100_price: Enum.at(row, 11),
            diesel_hvo100_additive_price: Enum.at(row, 12),
            diesel_truck_price: Enum.at(row, 13),
            diesel_hvo100_truck_price: Enum.at(row, 14),
            lpg_price: Enum.at(row, 15),
            adblue_price: Enum.at(row, 16)
          }
        end)
      err ->
        IO.puts("Parce list of price snapshots failed")
        IO.inspect err
        {:error, :failed}
    end
  end

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
      {:ok, %{status_code: 200, body: _body}} ->
        :ok
      err ->
        IO.puts("Create price snapshot failed")
        IO.inspect err
        {:error, :failed}
    end
  end
  def create(attrs) do
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
      {:ok, %{status_code: 200, body: _body}} ->
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
