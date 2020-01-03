DROP PROCEDURE IF EXISTS sp_calling_sp_create_clustered_receivable; 
DELIMITER //
CREATE PROCEDURE sp_calling_sp_create_clustered_receivable ( IN p_country varchar(45) , IN p_origin_system varchar(45) , IN p_operation varchar(45) , IN  p_transaction_type varchar(45), IN p_limit integer, IN p_loop integer  )

BEGIN
	
    declare i integer default 0;
    
    set sql_mode = traditional;
    
	calling_proc_loop: while i <= p_loop -1 do
		
        select concat("Loop ",i," - callilng sp_create_clustered_receivable(",p_origin_system,",",p_operation,",",p_operation,",",p_transaction_type,",",p_limit,");");
		call sp_create_clustered_receivable(p_origin_system,p_operation,p_operation,p_transaction_type,p_limit);
    
		set i = i + 1 ;

	end while calling_proc_loop;

END;
//