CREATE VIEW active_customers AS
SELECT c.first_name, c.last_name, c.email
FROM customers c
JOIN c_accounts a ON c.customer_id = a.customer_id
WHERE a.is_active = 1;