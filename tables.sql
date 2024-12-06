CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    age NUMBER,
    email VARCHAR2(50) UNIQUE
);

CREATE TABLE banks (
    bank_id NUMBER PRIMARY KEY,
    bank_name VARCHAR2(50) UNIQUE,
    address VARCHAR2(50)
);


CREATE TABLE c_accounts (
    customer_id NUMBER REFERENCES customers(customer_id) ON DELETE CASCADE,
    acc_type VARCHAR2(20),
    balance NUMBER,
    is_active NUMBER,
    transaction_limit NUMBER,
    bank_id NUMBER REFERENCES banks(bank_id) ON DELETE CASCADE
);

CREATE TABLE transaction_history (
    transaction_id NUMBER PRIMARY KEY,
    amount NUMBER,
    transaction_date DATE
);