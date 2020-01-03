set sql_mode = traditional;
call sp_create_clustered_receivable('Brazil','smartsystem','person_plan','credit_card_recurring',1500);
call sp_create_clustered_receivable('Brazil','smartsystem','person_plan','debit_account_recurring',1500);
call sp_create_clustered_receivable('Brazil','smartsystem','person_plan','boleto',1500);
call sp_create_clustered_receivable('Brazil','biosystem','person_plan','credit_card_recurring',1500);
call sp_create_clustered_receivable('Brazil','biosystem','person_plan','debit_account_recurring',1500);
call sp_create_clustered_receivable('Brazil','biosystem','person_plan','boleto',1500);
