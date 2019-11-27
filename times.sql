CREATE TEMP TABLE hours_low
  (hour_low INTEGER PRIMARY KEY);

INSERT INTO hours_low
VALUES (0), (1), (2), (3), (4), (5);

CREATE TEMP TABLE hours_high
  (hour_high INTEGER PRIMARY KEY);

INSERT INTO hours_high
VALUES (0), (6), (12), (18), (24), (30);

CREATE TEMP TABLE minutes_low
  (minute_low INTEGER PRIMARY KEY);

INSERT INTO minutes_low
VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

CREATE TEMP TABLE minutes_high
  (minute_high INTEGER PRIMARY KEY);

INSERT INTO minutes_high
VALUES (0), (10), (20), (30), (40), (50);

DROP TABLE IF EXISTS times;
CREATE TABLE IF NOT EXISTS times (
  val INTEGER NOT NULL,
  hour INTEGER NOT NULL,
  minute INTEGER NOT NULL,
  display TEXT
);

INSERT INTO times (val, hour, minute)
SELECT
  ((hour_high + hour_low) * 60 + (minute_high + minute_low)) val,
  (hour_high + hour_low) hour,
  (minute_high + minute_low) minute
FROM hours_high, hours_low, minutes_high, minutes_low;

UPDATE times
  SET display = hour || ':' || minute
  WHERE minute > 9;

UPDATE times
  SET display = hour || ':0' || minute
  WHERE minute <= 9;

UPDATE times
  SET display = '0' || display
  WHERE hour <= 9;
