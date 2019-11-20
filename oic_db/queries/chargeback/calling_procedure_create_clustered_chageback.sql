set sql_mode = traditional;
call sp_create_clustered_chargeback('Brazil','smartsystem','person_plan','credit_card_recurring');
call sp_create_clustered_chargeback('Brazil','smartsystem','person_plan','debit_account_recurring');