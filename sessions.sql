SET @datef = '%Y-%m-%d';
SET @norm_std = 26400;
SET @norm_wend = 52800;
SELECT
  date_closed AS this_date,
  sessions_closed_num,
  cash_in,
  sessions_new_admins,
  sessions_new_all,
  (cash_in / sessions_closed_num) AS avg_check,
  100 * (cash_in / if(week_day IN ('WD_6','WD_7'), @norm_wend, @norm_std)) AS norm
FROM
  (
    SELECT
      COUNT(*) AS sessions_closed_num,
      SUM(amount) AS cash_in,
      DATE_FORMAT(stamp, @datef) AS date_closed,
      week_day
    FROM studio.sessions
      WHERE status = 'SS_closed_ok'
      GROUP BY DATE_FORMAT(stamp, @datef)
  ) AS sessions_closed
LEFT JOIN
  (
    SELECT
      COUNT(*) AS sessions_new_admins,
      DATE_FORMAT(created_at, @datef) AS date_created
    FROM studio.sessions
      WHERE admin_id_open != 1
      GROUP BY DATE_FORMAT(created_at, @datef)
  ) AS sessions_created
ON sessions_created.date_created = sessions_closed.date_closed
LEFT JOIN
  (
    SELECT
      COUNT(*) AS sessions_new_all,
      DATE_FORMAT(created_at, @datef) AS date_created_all
    FROM studio.sessions
      GROUP BY DATE_FORMAT(created_at, @datef)
  ) AS sessions_created_all
ON sessions_created.date_created = sessions_created_all.date_created_all;
