CREATE OR REPLACE PROCEDURE create_new_account (
    p_customerID IN NUMBER,
    p_firstName IN VARCHAR2,
    p_lastName IN VARCHAR2,
    p_age IN NUMBER,
    p_email IN VARCHAR2,
    p_bankID IN NUMBER,
    p_accType IN VARCHAR2,
    p_balance IN NUMBER
) AS
    chk_bank VARCHAR2(50);
    chk_customer VARCHAR(50);
    bank_not_found EXCEPTION;
BEGIN

    IF p_age < 18 THEN
        RAISE_APPLICATION_ERROR(-20001, 'AGE RESTRICTION: Customer age is less than 18');
    END IF;

    BEGIN
        SELECT bank_name
        INTO chk_bank
        FROM banks
        WHERE bank_id = p_bankID;
            
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                RAISE bank_not_found;
                
    END;
    
    BEGIN
        SELECT first_name
        INTO chk_customer
        FROM customers
        WHERE customer_id = p_customerID;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                INSERT INTO customers (customer_id, first_name, last_name, age, email)
                VALUES (p_customerID, p_firstName, p_lastName, p_age, p_email);
                
    END;
    
    INSERT INTO c_accounts (customer_id, acc_type, balance, is_active, transaction_limit, bank_id)
    VALUES (p_customerID, p_accType, p_balance, 1, 50000, p_bankID);
    COMMIT;
    
    EXCEPTION
        WHEN bank_not_found THEN
            DBMS_OUTPUT.PUT_LINE('BANK not found!!!');
        
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An unexpected error occured!!!');
            
END;



CREATE OR REPLACE PROCEDURE make_transaction (
    p_senderID IN NUMBER,
    p_receiverID IN NUMBER,
    p_amount IN NUMBER,
    p_senderBankID IN NUMBER,
    p_receiverBankID IN NUMBER
) AS
    senderName VARCHAR2(50);
    sender_exception EXCEPTION;
    receiverName VARCHAR2(50);
    receiver_exception EXCEPTION;
    sender_bank_name VARCHAR2(50);
    sender_bank_exception EXCEPTION;
    receiver_bank_name VARCHAR2(50);
    receiver_bank_exception EXCEPTION;
    sender_balance NUMBER;
    receiver_balance NUMBER;
    low_balance EXCEPTION;
    sender_limit NUMBER;
    sender_transaction_limit_exception EXCEPTION;
BEGIN
    BEGIN
        SELECT c.first_name, a.balance, a.transaction_limit
        INTO senderName, sender_balance, sender_limit
        FROM customers c
        JOIN c_accounts a ON c.customer_id = a.customer_id
        WHERE c.customer_id = p_senderID;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE sender_exception;
    END;
    
    BEGIN
        SELECT c.first_name, a.balance
        INTO receiverName, receiver_balance
        FROM customers c
        JOIN c_accounts a ON c.customer_id = a.customer_id
        WHERE c.customer_id = p_receiverID;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE receiver_exception;
                
    END;
    
    BEGIN
        SELECT bank_name
        INTO sender_bank_name
        FROM banks
        WHERE bank_id = p_senderBankID;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE sender_bank_exception;
                
    END;
    
    BEGIN
        SELECT bank_name
        INTO receiver_bank_name
        FROM banks
        WHERE bank_id = p_receiverBankID;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE receiver_bank_exception;
                
    END;
    
    IF sender_balance < p_amount THEN
        RAISE low_balance;
    END IF;
    
    IF sender_limit < p_amount THEN
            RAISE sender_transaction_limit_exception;
    END IF;
    
    BEGIN
        UPDATE c_accounts
        SET balance = sender_balance - p_amount,
            transaction_limit = sender_limit - p_amount
        WHERE customer_id = p_senderID;
        
        UPDATE c_accounts
        SET balance = receiver_balance + p_amount
        WHERE customer_id = p_receiverID;
        COMMIT;
        
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'Transaction failed! Try again later.');
        
    END;
    
    EXCEPTION
        WHEN sender_exception THEN
            DBMS_OUTPUT.PUT_LINE('Sender do not exist.');
            
        WHEN receiver_exception THEN
            DBMS_OUTPUT.PUT_LINE('Receiver do not exist.');
            
        WHEN sender_bank_exception THEN
            DBMS_OUTPUT.PUT_LINE('Sender Bank do not exist.');
            
        WHEN receiver_bank_exception THEN
            DBMS_OUTPUT.PUT_LINE('Receiver Bank do not exist.');
            
        WHEN low_balance THEN
            DBMS_OUTPUT.PUT_LINE('You do not have sufficient balance in your account.');
            
        WHEN sender_transaction_limit_exception THEN
            DBMS_OUTPUT.PUT_LINE('Your daily transaction limit is completed.');
            
        WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('An unexpected error occured. Try again later.');
    
END;