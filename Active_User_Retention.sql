WITH J AS
(
	SELECT *
	FROM 
		user_actions
	WHERE 
		EXTRACT(MONTH FROM event_date) = 6
)

SELECT 
	EXTRACT(MONTH FROM A.event_date) AS Mnth
	,COUNT(DISTINCT A.user_id) AS monthly_active_users
FROM 
	user_actions A
JOIN 
	J ON A.user_id = J.user_id
WHERE 
	EXTRACT(MONTH FROM A.event_date) = 7
GROUP BY 1