CREATE INDEX div_btr_rid ON [GDAC].[dbo].[divvy-bad_trip_records] ([ride_id])
CREATE INDEX div_td_ssid_stlt_stln ON [GDAC].[dbo].[divvy-tripdata] ([start_station_id]) INCLUDE ([start_lat], [start_lng])
CREATE INDEX div_td_ssid_ea_esid_slt_sln_elt_eln_mc_rl_dow ON [GDAC].[dbo].[divvy-tripdata] ([start_station_id]) INCLUDE ([ended_at]
, [end_station_id], [start_lat], [start_lng], [end_lat], [end_lng],
[member_casual], [ride_length], [day_of_week])
