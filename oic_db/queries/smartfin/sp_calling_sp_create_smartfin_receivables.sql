DROP PROCEDURE IF EXISTS sp_calling_sp_create_smartfin_receivables; 
DELIMITER //
CREATE PROCEDURE sp_calling_sp_create_smartfin_receivables ( IN p_loop integer  )

BEGIN
	
    declare i integer default 0;
    
    set sql_mode = traditional;
    
	calling_proc_loop: while i <= p_loop do
		
		call sp_create_smartfin_receivables('Brazil','smartsystem','person_plan','credit_card_recurring');
		call sp_create_smartfin_receivables('Brazil','smartsystem','person_plan','debit_account_recurring');
		call sp_create_smartfin_receivables('Brazil','smartsystem','person_plan','boleto');
		call sp_create_smartfin_receivables('Brazil','biosystem','person_plan','credit_card_recurring');
		call sp_create_smartfin_receivables('Brazil','biosystem','person_plan','debit_account_recurring');
		call sp_create_smartfin_receivables('Brazil','biosystem','person_plan','boleto');
    
		set i = i + 1 ;

	end while calling_proc_loop;

END;
//