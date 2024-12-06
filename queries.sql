SELECT * FROM customers;

SELECT * FROM c_accounts;

SELECT * FROM banks;

SELECT * FROM transaction_history;

INSERT INTO banks (bank_id, bank_name, address)
VALUES (1008, 'BANK', 'Lahore');

DELETE FROM customers
WHERE customer_id = 101;

DROP PROCEDURE create_new_account;

DROP TABLE transaction_history;