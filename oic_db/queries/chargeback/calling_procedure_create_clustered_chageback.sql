set sql_mode = traditional;
call sp_create_clustered_chargeback('Brazil','smartsystem','person_plan','credit_card');
call sp_create_clustered_chargeback('Brazil','smartsystem','person_plan','debit_card');