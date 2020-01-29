drop procedure if exists sp_check_if_exists_intercompany_distribution; 
delimiter //
create procedure sp_check_if_exists_intercompany_distribution ( p_inter_distrib JSON ,out p_return boolean  ,out p_code integer ,out p_message varbinary(5000), out p_front_intercompany_distribution_id integer)

begin	
	declare v_id integer;
    declare v_country varchar(45);
    declare v_unity_identification integer;
    declare v_origin_system varchar(45);
    declare v_operation varchar(45);
    declare v_erp_invoice_customer_status_transaction varchar(45);
    declare v_erp_receivable_status_transaction varchar(45);
    declare v_erp_invoice_status_transaction varchar(45);
    declare v_created_at timestamp;
    declare v_front_intercompany_distribution_id integer;
    
    
    set v_origin_system = replace(replace(json_extract(p_inter_distrib,'$.intercompany_distribution.header.origin_system'),'"',""),"null",null);   
    set v_operation = replace(replace(json_extract(p_inter_distrib,'$.intercompany_distribution.header.operation'),'"',""),"null",null);    
    set v_front_intercompany_distribution_id = cast(json_extract(p_inter_distrib,'$.intercompany_distribution.header.front_intercompany_distribution_id') as unsigned);            
    
    
    select 
		 otc.id
        ,otc.country
        ,otc.unity_identification
        ,otc.origin_system
        ,otc.operation
        ,otc.erp_invoice_customer_status_transaction
        ,otc.erp_receivable_status_transaction
        ,otc.erp_invoice_status_transaction
        ,otc.created_at as created_at
        into
		 v_id
        ,v_country
        ,v_unity_identification
        ,v_origin_system
        ,v_operation
        ,v_erp_invoice_customer_status_transaction
        ,v_erp_receivable_status_transaction
        ,v_erp_invoice_status_transaction
        ,v_created_at        
    from order_to_cash otc
	
    where otc.front_id = v_front_intercompany_distribution_id
    and otc.origin_system = v_origin_system
    and otc.operation = v_operation
    and otc.id = (  select max(otc_v2.id) from order_to_cash otc_v2 where otc_v2.front_id = otc.front_id);
    
    if (v_id is null 
		or v_erp_invoice_customer_status_transaction = 'error_trying_to_create_at_erp' 
		or v_erp_receivable_status_transaction = 'error_at_trying_to_process' 
        or v_erp_receivable_status_transaction = 'error_trying_to_create_at_erp' 
        or v_erp_invoice_status_transaction = 'error_trying_to_create_at_erp') then

		set p_return = true;
		set p_code = 0;
		set p_message = "";
		set p_front_intercompany_distribution_id = v_front_intercompany_distribution_id;    
			
    else
        
		set p_return = false;
		set p_code = 2;
		set p_message = concat('The Intercopmany Distribution transaction was already added to oic_db and is waiting to be process ! => { "id" : ',v_id 
								,', "created_at:" ',v_created_at
								,', "erp_invoice_customer_status_transaction: " ',v_erp_invoice_customer_status_transaction
								,', "erp_receivable_status_transaction: " ',v_erp_receivable_status_transaction
								,', "erp_invoice_status_transaction: " ',v_erp_invoice_status_transaction 
								,'} ');		
		set p_front_intercompany_distribution_id = v_front_intercompany_distribution_id;    	
                
    end if;
    
end;
//