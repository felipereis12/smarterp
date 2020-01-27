set sql_mode = traditional;
call sp_create_clustered_chargeback('Brazil','smartsystem','person_plan','credit_card');
call sp_create_clustered_chargeback('Brazil','smartsystem','person_plan','debit_card');
call sp_create_clustered_chargeback('Brazil','biosystem','person_plan','credit_card');
call sp_create_clustered_chargeback('Brazil','biosystem','person_plan','debit_card');
call sp_create_clustered_chargeback('Brazil','racesystem','person_plan','credit_card');
call sp_create_clustered_chargeback('Brazil','racesystem','person_plan','debit_card');
call sp_create_clustered_chargeback('Brazil','nossystem','person_plan','credit_card');
call sp_create_clustered_chargeback('Brazil','nossystem','person_plan','debit_card');