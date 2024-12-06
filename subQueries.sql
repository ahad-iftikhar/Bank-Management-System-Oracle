SELECT *
FROM customers
WHERE age > (
    SELECT age
    FROM customers
    WHERE customer_id = 101
);