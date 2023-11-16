defmodule Tankste.Station.Prices do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.Prices.Price

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([p], p.id == ^id)
    |> Repo.one()
  end

  def get_by_station_id(station_id, opts \\ []) do
    query(opts)
    |> where([p], p.station_id == ^station_id)
    |> Repo.one()
  end

  defp query(opts) do
    station_id = Keyword.get(opts, :station_id, nil)
    type = Keyword.get(opts, :type, nil)

    from(p in Price,
      select: p)
    |> query_where_station_id(station_id)
    |> query_where_type(type)
  end

  defp query_where_station_id(query, nil), do: query
  defp query_where_station_id(query, []), do: query
  defp query_where_station_id(query, station_ids) when is_list(station_ids) do
    query
    |> where([p], p.station_id in ^station_ids)
  end
  defp query_where_station_id(query, station_id) do
    query
    |> where([p], p.station_id == ^station_id)
  end

  defp query_where_type(query, nil), do: query
  defp query_where_type(query, []), do: query
  defp query_where_type(query, types) when is_list(types) do
    query
    |> where([p], p.type in ^types)
  end
  defp query_where_type(query, type) do
    query
    |> where([p], p.type == ^type)
  end

  def insert(attrs \\ %{}) do
    %Price{}
    |> Price.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Price{} = price, attrs \\ %{}) do
    price
    |> Price.changeset(attrs)
    |> Repo.update()
  end

  def calculate_price_comparisons() do
    price_changesets = list()
      |> Enum.map(fn price -> price |> Repo.preload(:station) end)
      |> Enum.filter(fn price -> price.station != nil end)
      |> compare_prices()

    Repo.transaction(fn repo ->
      Enum.each(price_changesets, fn changeset -> repo.update(changeset) end)
    end)
  end

  defp compare_prices(prices), do: compare_prices(prices, prices)

  defp compare_prices([], _), do: []
  defp compare_prices([price|prices], all_prices) do
    near_prices = all_prices
      |> Enum.filter(fn p -> Geocalc.within?(20_000, [price.station.location_longitude, price.station.location_latitude], [p.station.location_longitude, p.station.location_latitude]) end)

    [
      Price.changeset(price, %{
        :e5_price_comparison => compare_price(:e5_price, price, near_prices),
        :e10_price_comparison => compare_price(:e10_price, price, near_prices),
        :diesel_price_comparison => compare_price(:diesel_price, price, near_prices)
      })
    ] ++ compare_prices(prices, all_prices)
  end

  defp compare_price(field, price, near_prices) do
    case Map.get(price, field) do
      nil ->
        nil
      price_value ->
        min_price = near_prices
          |> Enum.map(fn p -> Map.get(p, field) end)
          |> Enum.filter(fn p -> p != nil end)
          |> Enum.min()

        cond do
          min_price + 0.04 >= price_value -> "cheap"
          min_price + 0.10 >= price_value -> "medium"
          true -> "expensive"
        end
    end
  end
end
