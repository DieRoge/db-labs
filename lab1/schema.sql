DROP TABLE IF EXISTS fines CASCADE;
DROP TABLE IF EXISTS rides CASCADE;
DROP TABLE IF EXISTS cars CASCADE;
DROP TABLE IF EXISTS tariffs CASCADE;
DROP TABLE IF EXISTS car_models CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    driver_license VARCHAR(20) NOT NULL,
    rating NUMERIC(3, 2) NOT NULL DEFAULT 5.00,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_users_phone UNIQUE (phone),
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT uq_users_license UNIQUE (driver_license),

    CONSTRAINT chk_users_rating CHECK (rating >= 0.00 AND rating <= 5.00),
    CONSTRAINT chk_users_phone_format CHECK (phone ~ '^\+7[0-9]{10}$')
);

CREATE TABLE car_models (
    id SERIAL PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    car_class VARCHAR(20) NOT NULL,
    transmission VARCHAR(20) NOT NULL,
    fuel_tank_capacity INTEGER NOT NULL,

    CONSTRAINT uq_car_models_brand_model_trans UNIQUE (brand, model_name, transmission),

    CONSTRAINT chk_car_models_class CHECK (car_class IN ('economy', 'comfort', 'business', 'electro')),
    CONSTRAINT chk_car_models_trans CHECK (transmission IN ('automatic', 'manual', 'robot', 'cvt')),
    CONSTRAINT chk_car_models_tank CHECK (fuel_tank_capacity > 0 AND fuel_tank_capacity <= 150)
);

CREATE TABLE cars (
    id SERIAL PRIMARY KEY,
    model_id INTEGER NOT NULL,
    license_plate VARCHAR(15) NOT NULL,
    vin CHAR(17) NOT NULL,
    manufacture_year INTEGER NOT NULL,
    fuel_level INTEGER NOT NULL DEFAULT 100,
    odometer_km INTEGER NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'available',

    CONSTRAINT fk_cars_model FOREIGN KEY (model_id) 
        REFERENCES car_models (id) ON DELETE RESTRICT,

    CONSTRAINT uq_cars_license_plate UNIQUE (license_plate),
    CONSTRAINT uq_cars_vin UNIQUE (vin),

    CONSTRAINT chk_cars_vin_length CHECK (char_length(vin) = 17),
    CONSTRAINT chk_cars_year CHECK (manufacture_year >= 2015 AND manufacture_year <= 2026),
    CONSTRAINT chk_cars_fuel CHECK (fuel_level BETWEEN 0 AND 100),
    CONSTRAINT chk_cars_odometer CHECK (odometer_km >= 0),
    CONSTRAINT chk_cars_status CHECK (status IN ('available', 'in_use', 'maintenance', 'decommissioned'))
);

CREATE TABLE tariffs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price_per_min NUMERIC(8, 2) NOT NULL,
    parking_price_per_min NUMERIC(8, 2) NOT NULL,
    included_km INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT uq_tariffs_name UNIQUE (name),

    CONSTRAINT chk_tariffs_prices CHECK (
        price_per_min > 0 
        AND parking_price_per_min >= 0 
        AND parking_price_per_min <= price_per_min
    ),
    CONSTRAINT chk_tariffs_km CHECK (included_km >= 0)
);

CREATE TABLE rides (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    car_id INTEGER NOT NULL,
    tariff_id INTEGER NOT NULL,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ,
    start_odometer INTEGER NOT NULL,
    end_odometer INTEGER,
    total_cost NUMERIC(10, 2),
    status VARCHAR(20) NOT NULL DEFAULT 'active',

    CONSTRAINT fk_rides_user FOREIGN KEY (user_id) 
        REFERENCES users (id) ON DELETE RESTRICT,
    CONSTRAINT fk_rides_car FOREIGN KEY (car_id) 
        REFERENCES cars (id) ON DELETE RESTRICT,
    CONSTRAINT fk_rides_tariff FOREIGN KEY (tariff_id) 
        REFERENCES tariffs (id) ON DELETE RESTRICT,

    CONSTRAINT chk_rides_dates CHECK (ended_at IS NULL OR ended_at >= started_at),
    CONSTRAINT chk_rides_odometer CHECK (end_odometer IS NULL OR end_odometer >= start_odometer),
    CONSTRAINT chk_rides_status_consistency CHECK (
        (status = 'active' AND ended_at IS NULL AND end_odometer IS NULL AND total_cost IS NULL)
        OR
        (status IN ('completed', 'canceled') AND ended_at IS NOT NULL AND end_odometer IS NOT NULL AND total_cost IS NOT NULL)
    ),

    CONSTRAINT chk_rides_start_odometer CHECK (start_odometer >= 0),
    CONSTRAINT chk_rides_total_cost CHECK (total_cost IS NULL OR total_cost >= 0)
);

CREATE TABLE fines (
    id SERIAL PRIMARY KEY,
    ride_id INTEGER NOT NULL,
    resolution_number VARCHAR(30) NOT NULL,
    violation_type VARCHAR(100) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    issued_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_paid BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT fk_fines_ride FOREIGN KEY (ride_id) 
        REFERENCES rides (id) ON DELETE CASCADE,

    CONSTRAINT uq_fines_resolution UNIQUE (resolution_number),
    CONSTRAINT chk_fines_amount CHECK (amount > 0)
);