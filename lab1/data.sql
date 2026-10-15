TRUNCATE TABLE fines, rides, cars, tariffs, car_models, users RESTART IDENTITY CASCADE;

INSERT INTO users (full_name, phone, email, driver_license, rating, is_verified) VALUES
('Иванов Алексей Сергеевич', '+79161112233', 'ivanov@mail.ru', '7701234567', 4.95, TRUE),
('Смирнова Мария Дмитриевна', '+79262223344', 'smirnova@yandex.ru', '7702345678', 5.00, TRUE),
('Кузнецов Дмитрий Игоревич', '+79033334455', 'kuznetsov@gmail.com', '5003456789', 4.20, TRUE),
('Попов Артем Викторович', '+79994445566', 'popov@inbox.ru', '7709876543', 5.00, FALSE);

INSERT INTO car_models (brand, model_name, car_class, transmission, fuel_tank_capacity) VALUES
('Kia', 'Rio X-Line', 'economy', 'automatic', 50),
('Geely', 'Coolray', 'comfort', 'robot', 45),
('Chery', 'Tiggo 4 Pro', 'comfort', 'cvt', 51),
('BMW', '320i', 'business', 'automatic', 59);

INSERT INTO cars (model_id, license_plate, vin, manufacture_year, fuel_level, odometer_km, status) VALUES
(1, 'А123ВС799', 'Z94CB41AAGR123456', 2022, 85, 45200, 'available'),
(1, 'В456ОР799', 'Z94CB41AAGR654321', 2023, 40, 28100, 'available'),
(2, 'Е789КХ797', 'Y4K8722Z8NB000111', 2024, 90, 15430, 'in_use'),
(3, 'М321ТС797', 'LVVDB11B9ND222333', 2024, 15, 19800, 'maintenance'),
(4, 'О777ОО777', 'WBA5F310X0F999888', 2021, 70, 62000, 'available');

INSERT INTO tariffs (name, price_per_min, parking_price_per_min, included_km, is_active) VALUES
('Поминутный Базовый', 14.50, 4.50, 0, TRUE),
('Фикс Город', 16.00, 5.00, 20, TRUE),
('Суточный 100 км', 8.00, 2.00, 100, TRUE),
('Архивный Промо', 10.00, 3.00, 0, FALSE);

INSERT INTO rides (user_id, car_id, tariff_id, started_at, ended_at, start_odometer, end_odometer, total_cost, status) VALUES
(1, 1, 1, '2026-10-10 09:00:00+03', '2026-10-10 09:40:00+03', 45175, 45200, 580.00, 'completed'),
(2, 5, 2, '2026-10-12 18:15:00+03', '2026-10-12 19:05:00+03', 61960, 62000, 800.00, 'completed'),
(3, 2, 1, '2026-10-14 12:00:00+03', '2026-10-14 12:50:00+03', 28050, 28100, 725.00, 'completed'),
(1, 3, 1, '2026-10-15 20:30:00+03', NULL, 15430, NULL, NULL, 'active');

INSERT INTO fines (ride_id, resolution_number, violation_type, amount, issued_at, is_paid) VALUES
(1, '18810177261010000001', 'Превышение скорости на 20-40 км/ч', 500.00, '2026-10-11 10:00:00+03', TRUE),
(3, '18810177261014000002', 'Неоплаченная городская парковка', 5000.00, '2026-10-14 16:30:00+03', FALSE),
(3, 'INTERNAL-2026-0042', 'Завершение аренды вне разрешенной зоны', 1000.00, '2026-10-14 13:00:00+03', FALSE);