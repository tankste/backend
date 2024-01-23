defmodule Tankste.StationWeb.StationView do
  use Tankste.StationWeb, :view

  def render("index.json", %{stations: stations}) do
    render_many(stations, Tankste.StationWeb.StationView, "station.json")
  end

  def render("show.json", %{station: station}) do
    render_one(station, Tankste.StationWeb.StationView, "station.json")
  end

  def render("station.json", %{station: station}) do
    %{
      "id" => station.id,
      "externalId" => station.external_id,
      "originId" => station.origin_id,
      "name" => station.name,
      "brand" => station.brand,
      "address" => %{
        "street" => station.address_street,
        "houseNumber" => station.address_house_number,
        "postCode" => station.address_post_code,
        "city" => station.address_city,
        "country" => station.address_country
      },
      "location" => %{
        "latitude" => station.location_latitude,
        "longitude" => station.location_longitude
      },
      "isOpen" => station.is_open,
      "lastChangesAt" => station.last_changes_at,
      "createdAt" => station.inserted_at,
      "updatedAt" => station.updated_at
    }
  end
end
