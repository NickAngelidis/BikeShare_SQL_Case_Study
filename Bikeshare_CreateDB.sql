-- Create Database
CREATE DATABASE BikeShare;
USE BikeShare;

-- Stations
CREATE TABLE Stations (
station_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL, 
city VARCHAR(50),
latitude DECIMAL (9,6),
longtitude DECIMAL (9,6),
capacity INT DEFAULT 20,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Bikes
CREATE TABLE bikes (
  bike_id INT AUTO_INCREMENT PRIMARY KEY,
  model VARCHAR(50),
  purchase_date DATE,
  status ENUM('available','in_use','maintenance','retired') DEFAULT 'available',
  last_maintenance DATE
);

-- Riders
CREATE TABLE rider (
  rider_id INT AUTO_INCREMENT PRIMARY KEY,
  signup_date DATE,
  member_type ENUM('casual','subscriber') DEFAULT 'casual',
  birth_year SMALLINT,
  gender ENUM('M','F','O') DEFAULT 'O'
);

-- Trips
CREATE TABLE trip (
  trip_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  bike_id INT NOT NULL,
  rider_id INT,
  start_station_id INT NOT NULL,
  end_station_id INT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  duration_seconds INT AS (TIMESTAMPDIFF(SECOND, start_time, end_time)) STORED,
  cost_cents INT, -- optional
  FOREIGN KEY (bike_id) REFERENCES bikes(bike_id),
  FOREIGN KEY (rider_id) REFERENCES rider(rider_id),
  FOREIGN KEY (start_station_id) REFERENCES stations(station_id),
  FOREIGN KEY (end_station_id) REFERENCES stations(station_id)
);

-- Weather
CREATE TABLE weather_hourly (
  wh_id INT AUTO_INCREMENT PRIMARY KEY,
  station_id INT, -- nearest station for local weather
  obs_time DATETIME,
  temp_c DECIMAL(4,1),
  precipitation_mm DECIMAL(5,2),
  wind_kph DECIMAL(5,2),
  conditions VARCHAR(100),
  FOREIGN KEY (station_id) REFERENCES stations(station_id)
);

-- Maintenance Events
CREATE TABLE maintenance (
  m_id INT AUTO_INCREMENT PRIMARY KEY,
  bike_id INT,
  station_id INT,
  start_time DATETIME,
  end_time DATETIME,
  issue VARCHAR(200),
  resolved BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (bike_id) REFERENCES bikes(bike_id),
  FOREIGN KEY (station_id) REFERENCES stations(station_id)
);

-- Insert Data for Stations
INSERT INTO stations (name, city, latitude, longtitude, capacity) VALUES
('Central Park West', 'Athens', 37.9838, 23.7275, 30),
('Metropolitan Library', 'Athens', 37.9755, 23.7361, 15),
('Riverfront', 'Athens', 37.9680, 23.7210, 20),
('Tech Campus', 'Athens', 37.9900, 23.7300, 25);

-- Bikes Sample
INSERT INTO bikes (model, purchase_date, status, last_maintenance) VALUES
('UrbanX 2020', '2021-03-15', 'available', '2025-09-01'),
('UrbanX 2020', '2021-03-15', 'available', '2025-09-04'),
('CityCruiser 2019', '2019-06-01', 'maintenance', '2025-10-01'),
('E-Bike Pro', '2022-08-12', 'available', '2025-08-20');

-- Riders Sample
INSERT INTO rider (signup_date, member_type, birth_year, gender) VALUES
('2023-01-05','subscriber',1992,'F'),
('2024-06-20','casual',1988,'M'),
('2022-11-11','subscriber',2001,'O');

-- Trips Sample
INSERT INTO trip (bike_id, rider_id, start_station_id, end_station_id, start_time, end_time, cost_cents) VALUES
(1, 1, 1, 2, '2025-10-10 08:15:00', '2025-10-10 08:30:00', 150),
(2, 2, 2, 3, '2025-10-10 09:00:00', '2025-10-10 09:20:00', 200),
(4, NULL, 3, 1, '2025-10-11 18:10:00', '2025-10-11 18:40:00', 300);

-- Weather Sample
INSERT INTO weather_hourly (station_id, obs_time, temp_c, precipitation_mm, wind_kph, conditions) VALUES
(1, '2025-10-10 08:00:00', 18.5, 0.0, 8.2, 'Clear'),
(2, '2025-10-10 09:00:00', 19.1, 0.0, 6.1, 'Partly Cloudy'),
(3, '2025-10-11 18:00:00', 21.0, 0.5, 12.0, 'Light Rain');

-- Maintenance Sample
INSERT INTO maintenance (bike_id, station_id, start_time, end_time, issue, resolved) VALUES
(3, 2, '2025-10-01 10:00:00', '2025-10-02 15:00:00', 'Brake replacement', TRUE);

