DROP PROCEDURE IF EXISTS sp_create_smartfin_operation; 
DELIMITER //
CREATE PROCEDURE sp_create_smartfin_operation ( IN p_country varchar(45) , IN p_origin_system varchar(45) , IN p_operation varchar(45) , IN  p_transaction_type varchar(45) )

BEGIN

declare v_unity_identification varchar(45) ;
declare v_erp_business_unit varchar(45);
declare v_erp_legal_entity varchar(45);
declare v_erp_subsidiary varchar(45);
declare v_acronym varchar(45);
declare v_erp_customer_id varchar(45);
declare v_erp_clustered_receivable_customer_id varchar(45);
declare v_erp_receivable_customer_identification varchar(45);
declare v_order_to_cash_id integer;
declare v_message_text varchar(255);
declare v_conciliator_id varchar(45);
declare v_keycontrol varchar(150);
declare v_id_receivable int;
declare done int;
declare cur1 cursor for select receivable.id from receivable 
						
                        inner join order_to_cash
                        on order_to_cash.id = receivable.order_to_cash_id
                        
						where order_to_cash.country = p_country 
                        and order_to_cash.origin_system = p_origin_system 
                        and order_to_cash.operation = p_operation
                        and receivable.transaction_type = p_transaction_type 
                        and receivable.is_smartfin = 'yes'
                        
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
										) 
                        
                        order by order_to_cash.country
								,order_to_cash.origin_system
                                ,order_to_cash.operation
                                ,receivable.transaction_type
                                ,receivable.id;

declare continue handler for not found set done=1;

declare exit handler for sqlexception 
begin
    rollback;
    get diagnostics condition 1  @v_message_text = message_text;
    select @v_message_text;
end;

set @v_keycontrol 	:= concat_ws('_','sp_create_smartfin_operation',rtrim(p_country),rtrim(p_origin_system),rtrim(p_operation),rtrim(p_transaction_type));

if get_lock(@v_keycontrol,1) = 1 and  exists ( select 1 from clustered_receivable_customer crc
									  inner join organization_from_to_version oftv
									  on oftv.erp_legal_entity = crc.identification_financial_responsible 
									  where is_smartfin = 'yes')  then 
    
	select 
		 @v_unity_identification := oftv.organization_from_to_unity_identification 
		,@v_erp_business_unit := oftv.erp_business_unit 
		,@v_erp_legal_entity := oftv.erp_legal_entity
		,@v_erp_subsidiary := oftv.erp_subsidiary
		,@v_acronym := oftv.acronym
		,@v_erp_customer_id := crc.erp_customer_id
		,@v_erp_clustered_receivable_customer_id := crc.erp_customer_id
		,@v_erp_receivable_customer_identification := crc.identification_financial_responsible
	from clustered_receivable_customer crc
	
	inner join organization_from_to_version oftv
	on oftv.erp_legal_entity = crc.identification_financial_responsible 
	and oftv.created_at = ( select 
								max(oftv2.created_at) 
							from organization_from_to_version oftv2 
							where oftv2.organization_from_to_unity_identification = oftv.organization_from_to_unity_identification 
							)
	where crc.is_smartfin = 'yes';
	
    set done = 0;
    open cur1;
    
    SmartfinOperationLoop: loop
    
        fetch cur1 into v_id_receivable;
                        
		if done = 1 then leave SmartfinOperationLoop; end if;

		start transaction;

		insert into order_to_cash
			(id,
			created_at,
			smartfin_order_to_cash_id,        
			country,
			unity_identification,
			erp_business_unit,
			erp_legal_entity,
			erp_subsidiary,
			acronym,
			to_generate_customer,
			to_generate_receivable,
			to_generate_invoice,
			origin_system,
			operation,
			minifactu_id,
			conciliator_id,
			fin_id,
			front_id,
			erp_invoice_customer_send_to_erp_at,
			erp_invoice_customer_returned_from_erp_at,
			erp_invoice_customer_status_transaction,
			erp_invoice_customer_log,
			erp_receivable_sent_to_erp_at,
			erp_receivable_returned_from_erp_at,
			erp_receivable_customer_identification,
			erp_receivable_status_transaction,
			erp_receivable_log,
			erp_invoice_send_to_erp_at,
			erp_invoice_returned_from_erp_at,
			erp_invoice_status_transaction,
			erp_invoice_log)
		
			select 
				null,
				null,
				order_to_cash.id,            
				order_to_cash.country,
				@v_unity_identification,
				@v_erp_business_unit,
				@v_erp_legal_entity,
				@v_erp_subsidiary,
				@v_acronym,
				'no',
				order_to_cash.to_generate_receivable,
				'no',
				order_to_cash.origin_system,
				order_to_cash.operation,
				order_to_cash.minifactu_id*-1,
				order_to_cash.conciliator_id,
				order_to_cash.fin_id,
				order_to_cash.front_id,
				null,
				null,
				'doesnt_need_to_be_process',
				null,
				null,
				null,
				order_to_cash.erp_receivable_customer_identification,
				'waiting_to_be_process',
				null,
				null,
				null,
				'doesnt_need_to_be_process',
				null
			from order_to_cash	
			
			inner join receivable
			on receivable.order_to_cash_id = order_to_cash.id
			
			where receivable.id = v_id_receivable
			and receivable.is_smartfin = 'yes';
		
		set @v_order_to_cash_id = last_insert_id();	
		
		insert into oic_db.receivable
		(id,
		created_at,
		receivable_id_smartfin,    
		order_to_cash_id,
		erp_receivable_id,
		erp_receivable_customer_id,
		erp_clustered_receivable_id,
		erp_clustered_receivable_customer_id,
		conciliator_id,
		is_smartfin,
        type_smartfin,
		transaction_type,
		contract_number,
		credit_card_brand,
		truncated_credit_card,
		current_credit_card_installment,
		total_credit_card_installment,
		nsu,
		authorization_code,
		price_list_value,
		gross_value,
		net_value,
		interest_value,
		administration_tax_percentage,
		administration_tax_value,
		antecipation_tax_percentage,
		antecipation_tax_value,
		billing_date,
		credit_date,
		conciliator_filename,
		acquirer_bank_filename,
		registration_gym_student,
		fullname_gym_student,
		identification_gym_student,
		erp_filename,
		erp_line_in_file)
		select
			null,
			null,
			receivable.id,        
			@v_order_to_cash_id,
			null,
			receivable.erp_receivable_customer_id,
			null,
			receivable.erp_clustered_receivable_customer_id,
			receivable.conciliator_id,
			'no',
            'own',
			receivable.transaction_type,
			receivable.contract_number,
			receivable.credit_card_brand,
			receivable.truncated_credit_card,
			receivable.current_credit_card_installment,
			receivable.total_credit_card_installment,
			receivable.nsu,
			receivable.authorization_code,
			receivable.price_list_value,
			receivable.gross_value,
			receivable.net_value,
			receivable.interest_value,
			receivable.administration_tax_percentage,
			receivable.administration_tax_value,
			receivable.antecipation_tax_percentage,
			receivable.antecipation_tax_value,
			receivable.billing_date,
			receivable.credit_date,
			receivable.conciliator_filename,
			receivable.acquirer_bank_filename,
			receivable.registration_gym_student,
			receivable.fullname_gym_student,
			receivable.identification_gym_student,
			null,
			null
		from receivable
		
		where receivable.id = v_id_receivable
		and receivable.is_smartfin = 'yes'; 
			
		update receivable 
		
		inner join order_to_cash
		on order_to_cash.id = receivable.order_to_cash_id
		
		set receivable.erp_clustered_receivable_customer_id = @v_erp_clustered_receivable_customer_id
		,receivable.erp_receivable_customer_id = @v_erp_customer_id     
		,receivable.is_smartfin = 'no'
        ,receivable.converted_smartfin = 'yes'
        ,receivable.type_smartfin = 'own'
		,order_to_cash.erp_receivable_customer_identification = @v_erp_receivable_customer_identification    
		
		where receivable.id = v_id_receivable ;
            
    end loop SmartfinOperationLoop;
    
    close cur1;	
    
    do release_lock(@v_keycontrol);    
    
else 
	select concat('Procedure is already running in another thread: ',@v_keycontrol ) as log;
end if;

END;
//

DELIMITER $$