CREATE TEMP TABLE vars AS SELECT
  '07:37' AS left_time,
  40 AS left_freq,
  '19:15' AS right_time,
  30 AS right_freq;

CREATE TEMP TABLE left_times AS
SELECT val AS l_val, display AS l_disp, NULL AS lr_val FROM times
WHERE (val % (SELECT left_freq FROM vars)) = (SELECT val FROM times
      WHERE display = (SELECT left_time FROM vars)) % (SELECT left_freq FROM vars);

CREATE TEMP TABLE right_times AS
SELECT NULL AS rl_val, val AS r_val, display AS r_disp FROM times
WHERE (val % (SELECT right_freq FROM vars)) = (SELECT val FROM times
      WHERE display = (SELECT right_time FROM vars)) % (SELECT right_freq FROM vars);

UPDATE left_times
SET lr_val =
  (SELECT r_val
  FROM right_times
  WHERE r_val >= l_val
  ORDER BY r_val ASC
  LIMIT 1);

SELECT l_disp FROM left_times;

UPDATE right_times
SET rl_val =
  (SELECT l_val
  FROM left_times
  WHERE l_val <= r_val
  ORDER BY l_val DESC
  LIMIT 1);

CREATE TEMP TABLE merged_times AS
  SELECT
    l_val,
    lr_val AS r_val,
    (SELECT display FROM times WHERE val = l_val) AS l_disp,
    (SELECT display FROM times WHERE val = lr_val) AS r_disp,
    lr_val - l_val AS diff
  FROM left_times
  UNION
  SELECT
    rl_val AS l_val,
    r_val,
    (SELECT display FROM times WHERE val = rl_val) AS l_disp,
    (SELECT display FROM times WHERE val = r_val) AS r_disp,
    r_val - rl_val AS diff
  FROM right_times;

SELECT l_disp, r_disp, diff
FROM merged_times
WHERE diff = 0
OR diff BETWEEN (SELECT left_freq FROM vars) AND (SELECT right_freq FROM vars)
ORDER BY l_val ASC, r_val ASC;

SELECT r_disp FROM right_times;

/*
SELECT 173 / 60.0
*/