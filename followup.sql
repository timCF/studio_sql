SELECT
  b.name,
  b.person,
  b.contacts,
  q.qty,
  s.stamp
FROM bands AS b
LEFT JOIN sessions AS s ON s.band_id = b.id
LEFT JOIN (SELECT band_id, COUNT(*) AS qty FROM sessions WHERE sessions.status = "SS_closed_ok" GROUP BY band_id) AS q ON q.band_id = b.id
WHERE s.status = "SS_closed_ok" ORDER BY s.stamp DESC;
