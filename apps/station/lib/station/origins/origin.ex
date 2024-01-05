defmodule Tankste.Station.Origins.Origin do
  use Ecto.Schema

  import Ecto.Changeset

  schema "origins" do
    field :name, :string
    field :short_name, :string
    field :icon_image_url, :string
    field :image_url, :string
    field :website_url, :string

    timestamps()
  end

  def changeset(station, attrs) do
    station
    |> cast(attrs, [:name, :short_name, :icon_image_url, :image_url, :website_url])
    |> validate_required([:name, :short_name, :icon_image_url, :image_url])
  end
end
