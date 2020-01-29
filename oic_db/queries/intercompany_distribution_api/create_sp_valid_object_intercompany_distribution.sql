drop procedure if exists sp_valid_object_intercompany_distribution; 
delimiter //
create procedure sp_valid_object_intercompany_distribution ( p_otc JSON ,out p_return boolean  ,out p_code integer ,out p_message varbinary(5000), out p_front_intercompany_distribution_id integer)

begin	

	set p_return = true;
	set p_code = 0;
	set p_message = "";
    
    if json_contains_path(p_otc,'one','$.intercompany_distribution') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution at Json request ! ");
    end if;

    if json_contains_path(p_otc,'one','$.intercompany_distribution.header') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution.header at Json request ! ");
    end if;

    if json_contains_path(p_otc,'one','$.intercompany_distribution.header.front_intercompany_distribution_id') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution.header.front_intercompany_distribution_id at Json request ! ");
	else
		set p_front_intercompany_distribution_id = cast(json_extract(p_otc,'$.intercompany_distribution.header.front_intercompany_distribution_id') as unsigned);
    end if; 
    
    if json_contains_path(p_otc,'one','$.intercompany_distribution.header.country') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution.header.country at Json request ! ");
    end if;    
    
    if json_contains_path(p_otc,'one','$.intercompany_distribution.header.unity_identification_receivable') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution.header.unity_identification_receivable at Json request ! ");
    end if;      
    
    if json_contains_path(p_otc,'one','$.intercompany_distribution.header.unity_identification_payable') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution.header.unity_identification_payable at Json request ! ");
    end if;     
    
    if json_contains_path(p_otc,'one','$.intercompany_distribution.header.origin_system') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution.header.origin_system at Json request ! ");
    end if;            
    
    if json_contains_path(p_otc,'one','$.intercompany_distribution.header.operation') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution.header.operation at Json request ! ");
    end if;                
                
    if json_contains_path(p_otc,'one','$.intercompany_distribution.header.issue_date') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution.header.issue_date at Json request ! ");
    end if;                        
    
    if json_contains_path(p_otc,'one','$.intercompany_distribution.header.due_date') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution.header.due_date at Json request ! ");
    end if;

    if json_contains_path(p_otc,'one','$.intercompany_distribution.header.gross_value') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution.header.gross_value at Json request ! ");
    end if;
    
    if json_contains_path(p_otc,'one','$.intercompany_distribution.invoice') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution.invoice at Json request ! ");
    end if;            
    
    if json_contains_path(p_otc,'one','$.intercompany_distribution.invoice.invoice_items') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node intercompany_distribution.invoice.invoice_items at Json request. ");
    end if;                
    
    if !p_return then
		set p_message = concat( p_message,"Check the documentation https://app.swaggerhub.com/apis-docs/smartfit-v2/IntercompanyDistribution/1.0.0");
    end if;	
	    
end;
//