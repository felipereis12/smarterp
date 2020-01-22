drop procedure if exists sp_check_if_franchise_conciliator; 
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `sp_check_if_franchise_conciliator`( p_franchine_conciliator JSON ,out p_return boolean ,out p_code integer ,out p_message varbinary(5000), out p_front_franchise_conciliator_id integer)
begin	
	declare v_id integer;
    declare v_country varchar(45);
    declare v_unity_identification integer;
    declare v_origin_system varchar(45);
    declare v_erp_refund_status_transaction varchar(45);
    declare v_created_at timestamp;
    declare v_front_franchise_conciliator_id integer;
    
    set v_front_franchise_conciliator_id = cast(json_extract(p_refund,'$.franchise_conciliator.header.front_franchise_conciliator_id') as unsigned);    
    
    select 
		 otc.front_id -- este campo esquivale a front_franchise_conciliator_id
        ,otc.country
        ,otc.unity_identification
        ,otc.origin_system
        ,otc.created_at as created_at
        into
		 v_id -- front_id
        ,v_country -- country
        ,v_unity_identification -- unity_identification
        ,v_origin_system -- origin_system
        ,v_created_at -- created_at
    from order_to_cash otc
	
    where otc.front_id = v_front_franchise_conciliator_id -- recebe a função
    and otc.id = (  select max(otc2.id) from order_to_cash otc2 where otc2.front_id = otc.front_id);
    
    if (v_id is null) then

		set p_return = true;
		set p_code = 0;
		set p_message = "";
		set p_franchine_conciliator = v_front_franchise_conciliator_id;
	
    else
        
		set p_return = false;
		set p_code = 2;
		set p_message = concat('The refund transaction was already added to oic_db and is waiting to be process ! => { "id" : ',v_id 
								,', "created_at:" ',ifnull(v_created_at,"null")
								,'} ');
		set p_franchine_conciliator = v_front_franchise_conciliator_id;  	
                
    end if;
    
end$$
DELIMITER ;
