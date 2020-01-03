set sql_mode = traditional;
call sp_create_smartfin_receivables('Brazil','smartsystem','person_plan','credit_card_recurring');
call sp_create_smartfin_receivables('Brazil','smartsystem','person_plan','debit_account_recurring');
call sp_create_smartfin_receivables('Brazil','smartsystem','person_plan','boleto');
call sp_create_smartfin_receivables('Brazil','biosystem','person_plan','credit_card_recurring');
call sp_create_smartfin_receivables('Brazil','biosystem','person_plan','debit_account_recurring');
call sp_create_smartfin_receivables('Brazil','biosystem','person_plan','boleto');
