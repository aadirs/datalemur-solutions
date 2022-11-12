WITH Trans AS
(
  SELECT 
    *,
    ROW_NUMBER() OVER(
      PARTITION BY merchant_id,credit_card_id 
      ORDER BY transaction_timestamp) AS row_num 
  FROM transactions
)

SELECT 
  COUNT(T1.merchant_id) AS payment_count
FROM Trans T1
JOIN Trans T2 
  ON T1.merchant_id = T2.merchant_id 
  AND T1.credit_card_id = T2.credit_card_id
  AND T1.amount = T2.amount 
  AND ROUND(EXTRACT(epoch FROM T2.transaction_timestamp - T1.transaction_timestamp)/60) <= 10
  AND T2.row_num = T1.row_num +1