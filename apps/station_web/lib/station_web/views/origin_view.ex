defmodule Tankste.StationWeb.OriginView do
  use Tankste.StationWeb, :view

  def render("index.json", %{origins: origins}) do
    render_many(origins, Tankste.StationWeb.OriginView, "origin.json")
  end

  def render("show.json", %{origin: origin}) do
    render_one(origin, Tankste.StationWeb.OriginView, "origin.json")
  end

  def render("origin.json", %{origin: origin}) do
    %{
      "id" => origin.id,
      "name" => origin.name,
      "shortName" => origin.short_name,
      "iconImageUrl" => origin.icon_image_url,
      "imageUrl" => origin.image_url,
      "websiteUrl" => origin.website_url,
      "createdAt" => origin.inserted_at,
      "updatedAt" => origin.updated_at
    }
  end
end
