defmodule Tankste.Station.Stations.Station do
  use Ecto.Schema

  import Ecto.Changeset

  # TODO: define fields & validations (required fields) independend of the MTS-K schema

  schema "stations" do
    has_many :prices, Tankste.Station.Prices.Price
    has_many :station_infos, Tankste.Station.StationInfos.StationInfo
    field :status, :string, default: "available"

    timestamps()
  end

  def changeset(station, attrs) do
    station
    |> cast(attrs, [:status])
    |> validate_required([:status])
    # available: the station is available and publich visibility
    # disabled: this station should not be visible, for technical reasons
    # closed: station business has closed, don't show this station anymore
    |> validate_inclusion(:status, ~w(available disabled closed))
  end
end
