SELECT 
  ROUND(SUM(Q)/86400) AS P
FROM
(
  SELECT 
  CASE WHEN session_status = 'stop' 
    THEN EXTRACT
      (
      EPOCH FROM status_time - LAG(status_time) OVER(PARTITION BY server_id 
      ORDER BY status_time)
      ) 
    ELSE NULL END AS Q
  FROM server_utilization
) AS T1