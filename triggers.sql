CREATE OR REPLACE TRIGGER trg_transaction_history
AFTER UPDATE ON c_accounts
FOR EACH ROW
BEGIN
    IF :OLD.balance != :NEW.balance THEN
        INSERT INTO transaction_history (transaction_id, amount, transaction_date)
        VALUES (transaction_history_seq.NEXTVAL, :NEW.balance - :OLD.balance, SYSTIMESTAMP);
    END IF;
END;