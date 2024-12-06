BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'update_transaction_limit_daily',
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN UPDATE c_accounts SET transaction_limit = 50000; END;',
        start_date => SYSTIMESTAMP,
        repeat_interval => 'FREQ=DAILY; BYHOUR=0; BYMINUTE=0; BYSECOND=0;',
        enabled => true,
        comments => 'Job to update transaction limit to 50000 daily at 12AM'
    );
END;