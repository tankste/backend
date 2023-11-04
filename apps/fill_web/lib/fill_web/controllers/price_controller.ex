defmodule Tankste.FillWeb.PriceController do
  use Tankste.FillWeb, :controller

  alias Tankste.Station.Stations
  alias Tankste.Station.Prices

  # def index(conn, _params) do
  #   stations = Tankste.Station.Stations.list()
  #   render(conn, "index.json", stations: stations)
  # end

  # TODO: auth + param validating
  # TODO: crawler header for origin
  # TODO: crawler token

  def update(conn, %{"_json" => prices}) when is_list(prices) do
    case upsert_prices(prices) do
      :ok ->
        case Prices.calculate_price_comparisons() do
          :ok ->
            conn
            |> put_status(:no_content)
            |> send_resp(204, "")
          {:error, changeset} ->
            conn
            |> put_status(422)
            |> put_view(ChangesetView)
            |> render("errors.json", changeset: changeset)
        end
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(ChangesetView)
        |> render("errors.json", changeset: changeset)
    end
  end
  def update(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json")
  end

  defp upsert_prices(new_prices, existing_prices \\ nil)
  defp upsert_prices([], _), do: :ok
  # TODO: refactore this
  defp upsert_prices(new_prices, nil) do
    stations = Stations.list(external_id: Enum.map(new_prices, fn p -> p["externalId"] end))
    new_prices = Enum.map(new_prices, fn p ->
      case Enum.find(stations, fn s -> s.external_id == p["externalId"] end) do
        nil ->
          nil
        station ->
          Map.put(p, "stationId", station.id)
      end
    end)
    |> Enum.filter(fn p -> p != nil end)
    existing_prices = Prices.list(station_id: Enum.map(new_prices, fn p -> p["stationId"] end))
    upsert_prices(new_prices, existing_prices)
  end
  defp upsert_prices([new_price|new_prices], existing_prices) do
    result = case Enum.find(existing_prices, fn p -> p.station_id == new_price["stationId"] end) do
      nil ->
        Prices.insert(%{
          origin: "mtk-s",
          station_id: new_price["stationId"],
          e5_price: new_price["e5Price"],
          e10_price: new_price["e10Price"],
          diesel_price: new_price["dieselPrice"],
          last_changes_at: DateTime.utc_now()
        })
      price ->
        Prices.update(price, %{
          origin: "mtk-s",
          station_id: new_price["stationId"],
          e5_price: new_price["e5Price"],
          e10_price: new_price["e10Price"],
          diesel_price: new_price["dieselPrice"],
          last_changes_at: DateTime.utc_now()
        })
    end

    case result do
      {:ok, _price} ->
        upsert_prices(new_prices, existing_prices)
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete(conn, _params) do
    # externalIds = []
    conn
  end
end
