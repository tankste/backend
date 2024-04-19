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
      "createdAt" => station.inserted_at,
      "updatedAt" => station.updated_at
    }
  end
end
