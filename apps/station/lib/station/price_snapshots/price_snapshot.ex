defmodule Tankste.Station.PriceSnapshots.PriceSnapshot do
  @enforce_keys [:station_id, :snapshot_date]
  defstruct [
    :station_id,
    :snapshot_date,
    :petrol_price,
    :petrol_super_e5_price,
    :petrol_super_e10_price,
    :petrol_super_plus_price,
    :petrol_shell_power_price,
    :petrol_aral_ultimate_price,
    :diesel_price,
    :diesel_hv100_price,
    :diesel_truck_price,
    :diesel_shell_power_price,
    :diesel_aral_ultimate_price,
    :lpg_price,
  ]
end
