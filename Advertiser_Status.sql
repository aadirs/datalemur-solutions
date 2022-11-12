SELECT 
  A.user_id
  ,CASE WHEN P.user_id IS NULL 
    THEN 'CHURN' 
    ELSE 
      (
      CASE WHEN A.status = 'NEW' THEN 'EXISTING'
           WHEN A.status = 'EXISTING' THEN A.status
           WHEN A.status = 'CHURN' THEN 'RESURRECT'
           WHEN A.status = 'RESURRECT' THEN 'EXISTING' 
      END
      )
    END AS New_Status 
FROM advertiser A
LEFT JOIN daily_pay P 
ON A.user_id = P.user_id

UNION

SELECT 
  P.user_id
  ,'NEW' AS New_Status
FROM advertiser A1
RIGHT JOIN daily_pay P 
ON A1.user_id = P.user_id
WHERE A1.user_id IS NULL

ORDER BY user_id



