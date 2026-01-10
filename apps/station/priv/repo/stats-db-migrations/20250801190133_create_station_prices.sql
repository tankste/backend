CREATE TABLE 'station_prices' (
	timestamp TIMESTAMP, 
    petrol_price FLOAT,
    petrol_super_e5_price FLOAT,
    petrol_super_e5_additive_price FLOAT,
    petrol_super_e10_price FLOAT,
    petrol_super_e10_additive_price FLOAT,
    petrol_super_plus_price FLOAT,
    petrol_super_plus_additive_price FLOAT,
    diesel_price FLOAT,
    diesel_additive_price FLOAT,
    diesel_hvo100_price FLOAT,
    diesel_hvo100_additive_price FLOAT,
    diesel_truck_price FLOAT,
    diesel_hvo100_truck_price FLOAT,
    lpg_price FLOAT,
    adblue_price FLOAT
) timestamp (timestamp) PARTITION BY DAY BYPASS WAL;