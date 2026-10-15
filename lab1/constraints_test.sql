INSERT INTO cars (model_id, license_plate, vin, manufacture_year, fuel_level, odometer_km, status)
VALUES (1, 'А123ВС799', 'Z94CB41AAGR999999', 2023, 100, 100, 'available');


INSERT INTO car_models (brand, model_name, car_class, transmission, fuel_tank_capacity)
VALUES ('Kia', 'Rio X-Line', 'economy', 'automatic', 55);


UPDATE cars
SET fuel_level = 125
WHERE id = 1;


UPDATE users
SET rating = 5.50
WHERE id = 1;


INSERT INTO rides (user_id, car_id, tariff_id, started_at, ended_at, start_odometer, end_odometer, total_cost, status)
VALUES (1, 1, 1, '2026-10-15 15:00:00+03', '2026-10-15 14:00:00+03', 45200, 45230, 500.00, 'completed');


INSERT INTO rides (user_id, car_id, tariff_id, started_at, ended_at, start_odometer, end_odometer, total_cost, status)
VALUES (1, 1, 1, '2026-10-15 15:00:00+03', '2026-10-15 16:00:00+03', 45200, 45100, 500.00, 'completed');


DELETE FROM users WHERE id = 1;