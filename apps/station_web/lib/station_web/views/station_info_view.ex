defmodule Tankste.StationWeb.StationInfoView do
  use Tankste.StationWeb, :view

  def render("index.json", %{station_infos: station_infos}) do
    render_many(station_infos, Tankste.StationWeb.StationInfoView, "station_info.json")
  end

  def render("show.json", %{station_info: station_info}) do
    render_one(station_info, Tankste.StationWeb.StationInfoView, "station_info.json")
  end

  def render("station_info.json", %{station_info: station_info}) do
    %{
      "id" => station_info.station_id,
      "externalId" => station_info.external_id,
      "originId" => station_info.origin_id,
      "name" => station_info.name,
      "brand" => station_info.brand,
      "address" => %{
        "street" => station_info.address_street,
        "houseNumber" => station_info.address_house_number,
        "postCode" => station_info.address_post_code,
        "city" => station_info.address_city,
        "country" => station_info.address_country
      },
      "location" => %{
        "latitude" => station_info.location_latitude,
        "longitude" => station_info.location_longitude
      },
      "isOpen" => station_info.is_open,
      "currency" => station_info.currency,
      "lastChangesAt" => station_info.last_changes_at,
      "createdAt" => station_info.inserted_at,
      "updatedAt" => station_info.updated_at
    }
  end
end
