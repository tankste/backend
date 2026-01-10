defmodule Tankste.Station.Prices.Price do
  use Ecto.Schema

  import Ecto.Changeset

  alias Tankste.Station.Origins

  # TODO: define fields & validations (required fields) independend of the MTS-K schema

  schema "station_prices" do
    belongs_to :station, Tankste.Station.Stations.Station
    belongs_to :origin, Tankste.Station.Origins.Origin
    field :type, :string
    field :price, :float
    field :label, :string
    field :priority, :integer, default: 0
    field :last_changes_at, :utc_datetime

    timestamps()
  end

  def changeset(station, attrs) do
    station
    |> cast(attrs, [:station_id, :origin_id, :type, :price, :label, :last_changes_at, :priority])
    |> validate_required([:station_id, :origin_id, :type, :price])
    # petrol: Benzin (91 Oktan)
    # petrol_super_e5: Benzin E5 (95 Oktan / E5)
    # petrol_super_e5_additive: Benzin E5 (95 Oktan / E5) mit Additiven
    # petrol_super_e10: Benzin E10 (95 Oktan / E10)
    # petrol_super_e10_additive: Benzin E10 (95 Oktan / E10) mit Additiven
    # petrol_super_plus: Benzin (98 Oktan - 100 Oktan)
    # petrol_super_plus_additive: Benzin (98 Oktan oder mehr)  mit Additiven
    # diesel: Diesel (PKW)
    # diesel_additive: Diesel (PKW) mit Additiven
    # diesel_hvo100: Diesel HVO100
    # diesel_hvo100_additive: Diesel HVO100 mit Additiven
    # diesel_truck: Diesel (LKW)
    # diesel_hvo100_truck: Diesel HVO100 (LKW)
    # lpg: Autogas
    # adblue: AdBlue
    |> validate_inclusion(:type, ~w(petrol petrol_super_e5 petrol_super_e5_additive petrol_super_e10 petrol_super_e10_additive petrol_super_plus petrol_super_plus_additive diesel diesel_additive diesel_hvo100 diesel_hvo100_additive diesel_truck diesel_hvo100_truck lpg adblue))
    |> unique_constraint([:station_id, :type])
  end

  def is_outdated?(%Tankste.Station.Prices.Price{} = price) do
    case price.last_changes_at do
      nil -> false
      last_changes_at ->  is_outdated?(last_changes_at, price |> get_outdated_days_threshold())
    end
  end
  def is_outdated?(nil), do: true

  def is_outdated?(%DateTime{} = last_changes_at, outdated_days_threshold) do
    threshold = DateTime.now!("Europe/Berlin") |> DateTime.add(-outdated_days_threshold, :day)
    case  DateTime.compare(threshold, last_changes_at) do
      :gt -> true
      _ -> false
    end
  end

  defp get_outdated_days_threshold(%Tankste.Station.Prices.Price{} = price) do
    case Ecto.assoc_loaded?(price.origin) do
      true ->
        price.origin.price_outdated_after_days || 30
      false ->
        Origins.get(price.origin_id).price_outdated_after_days || 30
    end
  end
end
