DROP PROCEDURE IF EXISTS sp_create_clustered_receivable; 
DELIMITER //
CREATE PROCEDURE sp_create_clustered_receivable ( IN p_country varchar(45) , IN p_origin_system varchar(45) , IN p_operation varchar(45) , IN  p_transaction_type varchar(45) )

BEGIN

declare v_country varchar(45) ;
declare v_origin_system varchar(45) ;
declare v_unity_identification varchar(45) ;
declare v_erp_business_unit varchar(45);
declare v_erp_legal_entity varchar(45);
declare v_erp_subsidiary varchar(45);
declare v_operation varchar(45);
declare v_erp_customer_id int;
declare v_fullname varchar(255);
declare v_transaction_type varchar(45);
declare v_credit_card_brand varchar(45);
declare v_contract_number varchar(45);
declare v_administration_tax_percentage float;
declare v_antecipation_tax_percentage float;
declare v_billing_date date;
declare v_credit_date date;
declare v_is_smarftin varchar(45);
declare v_price_list_value float;
declare v_gross_value float;
declare v_net_value float;
declare v_interest_value float;
declare v_administration_tax_value float;
declare v_antecipation_tax_value float;
declare v_qtd_of_receivable int;
declare done int;
declare v_message_text varchar(255);
declare v_keycontrol varchar(150);
declare v_created_at timestamp;
declare cur1 cursor for select * from vw_clustered_receivable 
						where country = p_country 
                        and origin_system = p_origin_system 
                        and operation = p_operation
                        and transaction_type = p_transaction_type 
                        order by country
								,origin_system
                                ,operation
                                ,transaction_type
                                ,billing_date;
declare continue handler for not found set done=1;
declare exit handler for sqlexception 
begin
    rollback;
    get diagnostics condition 1  @v_message_text = message_text;
    select @v_message_text;
end;

set @v_keycontrol 	:= concat_ws('_','sp_create_clustered_receivable',rtrim(p_country),rtrim(p_origin_system),rtrim(p_operation),rtrim(p_transaction_type));
set @v_created_at	:= current_timestamp;

if get_lock(@v_keycontrol,1) = 1 then 
		
	if ( select not exists(
							select 
								1 
							from information_schema.tables 
							where table_schema = database()
							and table_name = 'control_clustered_receivable'
							)
		) then		
        
        create table control_clustered_receivable (keycontrol varchar(150), created_at timestamp, id integer);        
    
    end if;

    set done = 0;
	
    open cur1;
    
    ClusteredReceivableLoop: loop
        fetch cur1 into  v_country
						,v_origin_system
						,v_unity_identification
						,v_erp_business_unit
                        ,v_erp_legal_entity
                        ,v_erp_subsidiary
                        ,v_operation
                        ,v_erp_customer_id
                        ,v_fullname
                        ,v_transaction_type
                        ,v_credit_card_brand
                        ,v_contract_number
                        ,v_administration_tax_percentage
                        ,v_antecipation_tax_percentage
                        ,v_billing_date
                        ,v_credit_date
                        ,v_is_smarftin;
                        
		if done = 1 then leave ClusteredReceivableLoop; end if;
	      
        start transaction;
		
        insert into control_clustered_receivable
								select 
									 @v_keycontrol as keycontrol
                                    ,@v_created_at as created_at
									,order_to_cash.id as id
								from order_to_cash
                                
								inner join receivable
								on receivable.order_to_cash_id = order_to_cash.id
                                                                
								where receivable.erp_clustered_receivable_customer_id = v_erp_customer_id
								and receivable.transaction_type = v_transaction_type
								and receivable.contract_number = v_contract_number
								and ( ( receivable.credit_card_brand is not null and receivable.credit_card_brand = v_credit_card_brand) or (receivable.credit_card_brand is null) )
								and round(receivable.administration_tax_percentage,2) = round(v_administration_tax_percentage,2)
								and round(receivable.antecipation_tax_percentage,2) = round(v_antecipation_tax_percentage,2)
								and receivable.billing_date = v_billing_date
								and receivable.credit_date = v_credit_date
								and receivable.is_smartfin = v_is_smarftin        
								and order_to_cash.origin_system = v_origin_system
								and order_to_cash.operation = v_operation
								and order_to_cash.unity_identification = v_unity_identification
								and order_to_cash.erp_business_unit = v_erp_business_unit
								and order_to_cash.erp_legal_entity = v_erp_legal_entity
								and order_to_cash.erp_subsidiary = v_erp_subsidiary
								and order_to_cash.country = v_country
								and order_to_cash.erp_receivable_status_transaction = 'waiting_to_be_process'    
                                and order_to_cash.to_generate_receivable = 'yes'
                                and exists ( select 1 
											from order_to_cash otc_v2  
                                            
                                            inner join invoice_customer invc
                                            on invc.order_to_cash_id = otc_v2.id 
                                            
                                            where otc_v2.country = order_to_cash.country
                                            and otc_v2.origin_system = order_to_cash.origin_system
                                            and otc_v2.operation = order_to_cash.operation
                                            and otc_v2.minifactu_id = order_to_cash.minifactu_id
                                            and invc.erp_customer_id is not null )
								and not exists ( 
													select 
														1 
													from order_to_cash order_to_cash_v3
													
													inner join receivable receivable_v2
													on receivable_v2.order_to_cash_id = order_to_cash_v3.id
													
													where order_to_cash_v3.unity_identification = order_to_cash.unity_identification
                                                    and order_to_cash_v3.minifactu_id =  order_to_cash.minifactu_id 
													and ( 
																( order_to_cash_v3.erp_receivable_status_transaction = 'clustered_receivable_being_created' ) 
															or	( order_to_cash_v3.erp_receivable_status_transaction = 'clustered_receivable_created' ) 
															or	( receivable_v2.erp_clustered_receivable_id is not null ) 
															or	( receivable_v2.erp_receivable_id is not null ) 
														)
												)  limit 100 ;
                                                
		if exists ( select id from control_clustered_receivable where keycontrol = @v_keycontrol and created_at = @v_created_at)  then 
        
			update order_to_cash 
			
			inner join receivable
			on receivable.order_to_cash_id = order_to_cash.id
			
			set order_to_cash.erp_receivable_status_transaction = 'clustered_receivable_being_created'
			
			where order_to_cash.id in ( select id from control_clustered_receivable where keycontrol = @v_keycontrol and created_at = @v_created_at);
		
			select 	
				 round(sum(receivable.gross_value),2) as gross_value
				,round(sum(receivable.price_list_value),2) as price_list_value
				,round(sum(receivable.net_value),2) as net_value
				,round(sum(receivable.interest_value),2) as interest_value
				,round(sum(receivable.administration_tax_value),2) as administration_tax_value
				,round(sum(receivable.antecipation_tax_value),2) as antecipation_tax_value
				,count(1) as qtd
				
				into @v_gross_value
					,@v_price_list_value
					,@v_net_value
					,@v_interest_value
					,@v_administration_tax_value
					,@v_antecipation_tax_value
					,@v_qtd_of_receivable
				
			from receivable 
			
			inner join order_to_cash
			on order_to_cash.id = receivable.order_to_cash_id
			
			where order_to_cash.id in ( select id from control_clustered_receivable where keycontrol = @v_keycontrol and created_at = @v_created_at)
			and order_to_cash.erp_receivable_status_transaction = 'clustered_receivable_being_created' ;			
			
			insert into clustered_receivable
								(country,
								unity_identification,
								erp_business_unit,
								erp_legal_entity,
								erp_subsidiary,
								erp_clustered_receivable_customer_id,
								contract_number,
								credit_card_brand,
								billing_date,
								credit_date,
								price_list_value,
								gross_value,
								net_value,
								interest_value,
								administration_tax_percentage,
								administration_tax_value,
								antecipation_tax_percentage,
								antecipation_tax_value,
								quantity_of_receivable)
								VALUES
								(v_country,
								v_unity_identification,
								v_erp_business_unit,
								v_erp_legal_entity,
								v_erp_subsidiary,
								v_erp_customer_id,
								v_contract_number,
								v_credit_card_brand,
								v_billing_date,
								v_credit_date,
								@v_price_list_value,
								@v_gross_value,
								@v_net_value,
								@v_interest_value,
								v_administration_tax_percentage,
								@v_administration_tax_value,
								v_antecipation_tax_percentage,
								@v_antecipation_tax_value,
								@v_qtd_of_receivable);

			set @clustered_receivable_id = last_insert_id();
			
			update receivable
			
			inner join order_to_cash
			on order_to_cash.id = receivable.order_to_cash_id
			
			set receivable.erp_clustered_receivable_id = @clustered_receivable_id
			, order_to_cash.erp_receivable_status_transaction = 'clustered_receivable_created'

			where order_to_cash.id in ( select id from control_clustered_receivable where keycontrol = @v_keycontrol and created_at = @v_created_at)
			and order_to_cash.erp_receivable_status_transaction = 'clustered_receivable_being_created' ;        
        
        end if;
        
        delete from control_clustered_receivable where keycontrol = @v_keycontrol and created_at = @v_created_at;
        
    end loop ClusteredReceivableLoop;
    
    close cur1;	
    
    do release_lock(@v_keycontrol);

else 
	select concat('Procedure is already running in another thread: ',@v_keycontrol ) as log;
end if;

END;
//