defmodule Tankste.Station.PriceSnapshots.PriceSnapshot do
  @enforce_keys [:station_id, :snapshot_date]
  defstruct [
    :station_id,
    :snapshot_date,
    :petrol_price,
    :petrol_super_e5_price,
    :petrol_super_e5_additive_price,
    :petrol_super_e10_price,
    :petrol_super_e10_additive_price,
    :petrol_super_plus_price,
    :petrol_super_plus_additive_price,
    :diesel_price,
    :diesel_additive_price,
    :diesel_hvo100_price,
    :diesel_hvo100_additive_price,
    :diesel_truck_price,
    :diesel_hvo100_truck_price,
    :lpg_price,
    :adblue_price
  ]
end
