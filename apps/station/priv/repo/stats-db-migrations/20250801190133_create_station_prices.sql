CREATE TABLE 'station_prices' (
	timestamp TIMESTAMP, 
	station_id LONG, 
	petrol_price FLOAT,
	petrol_super_e5_price FLOAT,
	petrol_super_e10_price FLOAT,
	petrol_super_plus_price FLOAT,
	petrol_shell_power_price FLOAT,
	petrol_aral_ultimate_price FLOAT,
	diesel_price FLOAT,
	diesel_hvo100_price FLOAT,
	diesel_truck_price FLOAT,
	diesel_shell_power_price FLOAT,
	diesel_aral_ultimate_price FLOAT,
	lpg_price FLOAT
) timestamp (timestamp) PARTITION BY DAY BYPASS WAL;