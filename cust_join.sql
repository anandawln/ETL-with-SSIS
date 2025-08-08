SELECT * FROM financial_transactions t INNER JOIN customer_details c
ON t.customer_id = c.customer_id

SELECT * FROM dbo.financial_transactions t INNER JOIN dbo.customer_details c
ON t.customer_id = c.customer_id

SELECT t.*, c.customer_name, c.email customer_email, c.phone customer_phone
FROM dbo.financial_transactions t
INNER JOIN dbo.customer_details c ON t.customer_id=c.customer_id