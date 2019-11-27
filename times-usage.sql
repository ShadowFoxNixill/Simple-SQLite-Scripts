CREATE TEMP TABLE vars (
  freq INTEGER NOT NULL,
  start TEXT NOT NULL);

INSERT INTO vars (start, freq) VALUES (
  '10:00', 60);

SELECT display FROM times
WHERE (val %
  (SELECT freq FROM vars))
= (SELECT val FROM times
      WHERE display = (SELECT start FROM vars)) % (SELECT freq FROM vars);
