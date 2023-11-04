defmodule Tankste.FillWeb.StationController do
  use Tankste.FillWeb, :controller

  alias Tankste.Station.Stations

  # def index(conn, _params) do
  #   stations = Tankste.Station.Stations.list()
  #   render(conn, "index.json", stations: stations)
  # end

  # TODO: auth + param validating
  # TODO: crawler header for origin
  # TODO: crawler token

  def update(conn, %{"_json" => stations}) when is_list(stations) do
    case upsert_stations(stations) do
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
  end
  def update(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json")
  end

  defp upsert_stations(new_stations, existing_stations \\ nil)
  defp upsert_stations([], _), do: :ok
  defp upsert_stations(new_stations, nil) do
    existing_stations = Stations.list(external_id: Enum.map(new_stations, fn s -> s["externalId"] end))
    upsert_stations(new_stations, existing_stations)
  end
  defp upsert_stations([new_station|new_stations], existing_stations) do
    result = case Enum.find(existing_stations, fn s -> s.external_id == new_station["externalId"] end) do
      nil ->
        Stations.insert(%{
          external_id: new_station["externalId"],
          origin: "mtk-s",
          name: new_station["name"],
          brand: new_station["brand"],
          location_latitude: new_station["locationLatitude"],
          location_longitude: new_station["locationLongitude"],
          address_street: new_station["addressStreet"],
          address_house_number: new_station["addressHouseNumber"],
          address_post_code: new_station["addressPostCode"],
          address_city: new_station["addressCity"],
          address_country: new_station["addressCountry"],
          last_changes_at: DateTime.utc_now()
        })
      station ->
        Stations.update(station, %{
          external_id: new_station["externalId"],
          origin: "mtk-s",
          name: new_station["name"],
          brand: new_station["brand"],
          location_latitude: new_station["locationLatitude"],
          location_longitude: new_station["locationLongitude"],
          address_street: new_station["addressStreet"],
          address_house_number: new_station["addressHouseNumber"],
          address_post_code: new_station["addressPostCode"],
          address_city: new_station["addressCity"],
          address_country: new_station["addressCountry"],
          last_changes_at: DateTime.utc_now()
        })
    end

    case result do
      {:ok, _station} ->
        upsert_stations(new_stations, existing_stations)
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete(conn, _params) do
    # externalIds = []
    conn
  end
end
