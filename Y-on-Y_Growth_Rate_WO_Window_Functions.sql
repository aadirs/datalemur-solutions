WITH C AS
(
	SELECT 
		EXTRACT(YEAR FROM transaction_date) AS YR,
		product_id,
		SUM(spend) AS cur_year_spend
	FROM user_transactions
	GROUP BY 1,2

	UNION

		SELECT 2018 AS YR, 123424 AS product_id, NULL AS cur_year_spend

	UNION

		SELECT 2018 AS YR, 234412 AS product_id, NULL AS cur_year_spend

	UNION

		SELECT 2018 AS YR, 543623 AS product_id, NULL AS cur_year_spend
)


SELECT 
	C1.*,C2.cur_year_spend AS prev_year_spend,
	ROUND((C1.cur_year_spend - C2.cur_year_spend)*100/C2.cur_year_spend,2) AS yoy_rate 
FROM C AS C1
JOIN 
	C AS C2 ON C2.YR = C1.YR-1 
	AND 
	C1.product_id = C2.product_id

ORDER BY 2,1
