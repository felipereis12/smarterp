drop procedure if exists sp_valid_object_order_to_cash; 
delimiter //
create procedure sp_valid_object_order_to_cash ( p_otc JSON ,out p_return boolean  ,out p_code integer ,out p_message varbinary(5000), out p_minifactu_id integer)

begin	

	set p_return = true;
	set p_code = 0;
	set p_message = "";
    
    if json_contains_path(p_otc,'one','$.otc') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc at Json request ! ");
    end if;

    if json_contains_path(p_otc,'one','$.otc.header') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.header at Json request ! ");
    end if;

    if json_contains_path(p_otc,'one','$.otc.header.minifactu_id') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.header.minifactu_id at Json request ! ");
	else
		set p_minifactu_id = cast(json_extract(p_otc,'$.otc.header.minifactu_id') as unsigned);
    end if; 
    
    if json_contains_path(p_otc,'one','$.otc.header.country') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.header.country at Json request ! ");
    end if;    
    
    if json_contains_path(p_otc,'one','$.otc.header.unity_identification') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.header.unity_identification at Json request ! ");
    end if;        
    
    if json_contains_path(p_otc,'one','$.otc.header.origin_system') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.header.origin_system at Json request ! ");
    end if;            
    
    if json_contains_path(p_otc,'one','$.otc.header.operation') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.header.operation at Json request ! ");
    end if;                

    if json_contains_path(p_otc,'one','$.otc.header.conciliator_id') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.header.conciliator_id at Json request ! ");
    end if;                    
    
    if json_contains_path(p_otc,'one','$.otc.header.fin_id') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.header.fin_id at Json request ! ");
    end if;                        
    
    if json_contains_path(p_otc,'one','$.otc.header.front_id') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.header.front_id at Json request ! ");
    end if;

    if json_contains_path(p_otc,'one','$.otc.header.erp_receivable_customer_identification') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.header.erp_receivable_customer_identification at Json request ! ");
    end if;
    
    if json_contains_path(p_otc,'one','$.otc.invoice_customer') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.invoice_customer at Json request ! ");
    end if;    
    
    if json_contains_path(p_otc,'one','$.otc.receivable') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.receivable at Json request !");
    end if;        

    if json_contains_path(p_otc,'one','$.otc.invoice') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.invoice at Json request ! ");
    end if;            
    
    if json_contains_path(p_otc,'one','$.otc.invoice.invoice_items') = 0 then
		set p_return = false;
		set p_code = 1;
		set p_message = concat(p_message,"Missing node otc.invoice.invoice_items at Json request. ");
    end if;                
    
    if !p_return then
		set p_message = concat( p_message,"Check the documentation https://app.swaggerhub.com/apis-docs/Smartfit/OrderToCash/1.0.0");
    end if;	
	    
end;
//