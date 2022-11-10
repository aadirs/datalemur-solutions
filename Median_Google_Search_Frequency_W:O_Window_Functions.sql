-- Getting the number of observatiosn
WITH N AS
(
SELECT 
  SUM(num_users) AS n
FROM search_frequency
),

-- Getting the n/2th term
First_Term AS
(
SELECT 
	searches
FROM 
	(
	SELECT 
	*
	,CASE WHEN R >= (SELECT * FROM N)/2 THEN searches ELSE NULL END AS m_values
	,RANK() OVER(ORDER BY R) As rnk
	FROM
		(
		SELECT 
		*
		,SUM(num_users) OVER(ORDER BY searches) AS R
		FROM search_frequency
		ORDER BY searches
		) AS T1
	WHERE (CASE WHEN R >= (SELECT * FROM N)/2 THEN searches ELSE NULL END) IS NOT NULL
	) AS T2
WHERE rnk = 1
),

-- Getting the ((n+1)/2)th term
Second_Term AS
(
SELECT 
  searches
FROM 
	(
	SELECT 
	  *
	  ,CASE WHEN R >= ((SELECT * FROM N)/2)+1 THEN searches ELSE NULL END AS m_values
	  ,RANK() OVER(ORDER BY R) As rnk
	FROM
		(
		SELECT 
		  *
		  ,SUM(num_users) OVER(ORDER BY searches) AS R
		FROM search_frequency
		ORDER BY searches
		) AS T1
	WHERE (CASE WHEN R >= ((SELECT * FROM N)/2)+1 THEN searches ELSE NULL END) IS NOT NULL
	) AS T2
WHERE rnk = 1
)

-- When n is odd we return ((n+1)/2)th term, 
-- else we return the average of n/2th term and ((n+1)/2)th term
SELECT 
  ROUND(
  CASE WHEN MOD((SELECT * FROM N),2) != 0 
  THEN (SELECT * FROM Second_Term) 
  ELSE ((SELECT * FROM First_Term)+(SELECT * FROM Second_Term))/2.0 END,1) AS median



