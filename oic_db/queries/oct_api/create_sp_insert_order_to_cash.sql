drop procedure if exists sp_insert_order_to_cash; 
delimiter //
create procedure sp_insert_order_to_cash ( 
													 in p_order_to_cash_country varchar(45) 
                                                    ,in p_order_to_cash_unity_identification varchar(45)
                                                    ,in p_order_to_cash_origin_system varchar(45)
                                                    ,in p_order_to_cash_operation varchar(45)
                                                    ,in p_order_to_cash_minifactu_id integer
                                                    ,in p_order_to_cash_conciliator_id varchar(45)
                                                    ,in p_order_to_cash_fin_id integer
                                                    ,in p_order_to_cash_front_id integer
                                                    ,in p_order_to_cash_erp_receivable_customer_identification varchar(45) 
                                                    ,in p_invoice_customer_full_name varchar(45) 
                                                    ,in p_invoice_customer_type_person varchar(45) 
                                                    ,in p_invoice_customer_identification_financial_responsible varchar(45) 
                                                    ,in p_invoice_customer_nationality_code varchar(45) 
                                                    ,in p_invoice_customer_state varchar(45) 
                                                    ,in p_invoice_customer_city varchar(45) 
                                                    ,in p_invoice_customer_adress varchar(45) 
                                                    ,in p_invoice_customer_adress_number integer
                                                    ,in p_invoice_customer_adress_complement varchar(45) 
                                                    ,in p_invoice_customer_district varchar(45) 
                                                    ,in p_invoice_customer_postal_code varchar(45) 
                                                    ,in p_invoice_customer_area_code varchar(45) 
                                                    ,in p_invoice_customer_cellphone varchar(45) 
                                                    ,in p_invoice_customer_email varchar(45) 
                                                    ,in p_invoice_customer_state_registration varchar(45) 
                                                    ,in p_invoice_customer_federal_registration varchar(45) 
                                                    ,in p_invoice_customer_final_consumer varchar(45) 
                                                    ,in p_invoice_customer_icms_contributor varchar(45) 
                                                    ,in p_receivable_is_smartfin varchar(45) 
                                                    ,in p_receivable_transaction_type varchar(45) 
                                                    ,in p_receivable_contract_number varchar(45) 
                                                    ,in p_receivable_credit_card_brand varchar(45) 
                                                    ,in p_receivable_truncated_credit_card varchar(45) 
                                                    ,in p_receivable_current_credit_card_installment integer
                                                    ,in p_receivable_total_credit_card_installment integer
                                                    ,in p_receivable_nsu varchar(45) 
                                                    ,in p_receivable_conciliator_id varchar(45) 
                                                    ,in p_receivable_authorization_code varchar(45) 
                                                    ,in p_receivable_price_list_value float
                                                    ,in p_receivable_gross_value float
                                                    ,in p_receivable_net_value float
                                                    ,in p_receivable_interest_value float
                                                    ,in p_receivable_administration_tax_percentage float
                                                    ,in p_receivable_administration_tax_value float
                                                    ,in p_receivable_antecipation_tax_percentage float
                                                    ,in p_receivable_antecipation_tax_value float
                                                    ,in p_receivable_billing_date date
                                                    ,in p_receivable_credit_date date
                                                    ,in p_receivable_conciliator_filename varchar(255) 
                                                    ,in p_receivable_acquirer_bank_filename varchar(255) 
                                                    ,in p_receivable_registration_gym_student varchar(45) 
                                                    ,in p_receivable_fullname_gym_student varchar(255) 
                                                    ,in p_receivable_identification_gym_student varchar(255) 
                                                    ,in p_invoice_transaction_type varchar(45) 
                                                    ,in p_invoice_is_overdue_recovery varchar(45) 
                                                    ,in p_invoice_items_json JSON
                                                    ,out p_return boolean
                                                    ,out p_code integer
                                                    ,out p_message varchar(255)
												)

begin	
    
    declare v_erp_business_unit varchar(45);
    declare v_erp_legal_entity varchar(45);
    declare v_erp_subsidiary varchar(45);
    declare v_acronym varchar(45);
    declare v_to_generate_customer varchar(45);
    declare v_to_generate_receivable varchar(45);
    declare v_to_generate_invoice varchar(45); 
    declare v_erp_clustered_receivable_customer_id integer;
    declare v_erp_receivable_customer_id integer;
    declare v_order_to_cash_id integer;    
    declare v_front_product_id integer;
    declare v_front_plan_id integer;
    declare v_front_addon_id integer;
    declare v_quantity integer;
    declare v_list_price float;
    declare v_sale_price float;
    declare v_invoice_id integer;    
    declare v_erp_item_ar_id varchar(45); 
    declare v_erp_gl_segment_id varchar(45); 
    declare i int default 0;	
	declare exit handler for sqlexception     
	begin
		rollback;
		get diagnostics condition 1  @v_message_text = message_text;
		select @v_message_text;
	end;
	
	set sql_mode = traditional;	    
	set p_return = true;
    
    start transaction;
    
	select
		 oftv.erp_business_unit
		,oftv.erp_legal_entity
		,oftv.erp_subsidiary
		,oftv.acronym
		,oftv.to_generate_customer
		,oftv.to_generate_receivable
		,oftv.to_generate_invoice                                        
        
        into 		 
		 @v_erp_business_unit 
		,@v_erp_legal_entity 
		,@v_erp_subsidiary 
		,@v_acronym 
		,@v_to_generate_customer 
		,@v_to_generate_receivable 
		,@v_to_generate_invoice 
        
	from organization_from_to_version oftv
	where oftv.organization_from_to_unity_identification = p_order_to_cash_unity_identification
	and oftv.created_at = (
							select 
								max(oftv_v2.created_at) as created_at
							from organization_from_to_version oftv_v2
							where oftv_v2.organization_from_to_unity_identification = oftv.organization_from_to_unity_identification
							);

    if ( @v_erp_business_unit is not null ) then
		        
		select 
			 erp_customer_id 
			,erp_customer_id  
            
            into
			 @v_erp_clustered_receivable_customer_id 
			,@v_erp_receivable_customer_id
            
		from customer cus 
		where cus.identification_financial_responsible = p_order_to_cash_erp_receivable_customer_identification;
		        
        if ( p_order_to_cash_erp_receivable_customer_identification is null or @v_erp_receivable_customer_id is not null) then
			            
			insert into order_to_cash
							(country,
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
							erp_invoice_log,
							erp_receipt_send_to_erp_at,
							erp_receipt_returned_from_erp_at,
							erp_receipt_status_transaction,
							erp_receipt_log)
							values
							(p_order_to_cash_country, -- country
							p_order_to_cash_unity_identification, -- unity_identification
							v_erp_business_unit, -- erp_business_unit
							v_erp_legal_entity, -- erp_legal_entity
							v_erp_subsidiary, -- erp_subsidiary
							v_acronym, -- acronym
							v_to_generate_customer, -- to_generate_customer
							v_to_generate_receivable, -- to_generate_receivable
							to_generate_invoice, -- to_generate_invoice
							p_order_to_cash_origin_system, -- origin_system
							p_order_to_cash_operation, -- operation
							p_order_to_cash_minifactu_id, -- minifactu_id
							p_order_to_cash_conciliator_id, -- conciliator_id
							p_order_to_cash_fin_id, -- fin_id
							p_order_to_cash_front_id, -- front_id
							null, -- erp_invoice_customer_send_to_erp_at
							null, -- erp_invoice_customer_returned_from_erp_at
							'waiting_to_be_process', -- erp_invoice_customer_status_transaction
							null, -- erp_invoice_customer_log
							null, -- erp_receivable_sent_to_erp_at
							null, -- erp_receivable_returned_from_erp_at
							p_order_to_cash_erp_receivable_customer_identification, -- erp_receivable_customer_identification
							'waiting_to_be_process', -- erp_receivable_status_transaction
							null, -- erp_receivable_log
							null, -- erp_invoice_send_to_erp_at
							null, -- erp_invoice_returned_from_erp_at
							'waiting_to_be_process', -- erp_invoice_status_transaction
							null, -- erp_invoice_log
							null, -- erp_receipt_send_to_erp_at
							null, -- erp_receipt_returned_from_erp_at
							'waiting_to_be_process', -- erp_receipt_status_transaction
							null); -- erp_receipt_log     
							
			-- saves the auto increment id from order_to_cash table
			set v_order_to_cash_id = last_insert_id();     
			
			insert into invoice_customer
							(order_to_cash_id,
							country,
							erp_customer_id,
							full_name,
							type_person,
							identification_financial_responsible,
							nationality_code,
							state,
							city,
							adress,
							adress_number,
							adress_complement,
							district,
							postal_code,
							area_code,
							cellphone,
							email,
							state_registration,
							federal_registration,
							final_consumer,
							icms_contributor,
							erp_filename,
							erp_line_in_file)
							values
							(v_order_to_cash_id, -- order_to_cash_id
							p_order_to_cash_country, -- country
							null, -- erp_customer_id
							p_invoice_customer_full_name, -- full_name
							p_invoice_customer_type_person, -- type_person
							p_invoice_customer_identification_financial_responsible, -- identification_financial_responsible
							p_invoice_customer_nationality_code, -- nationality_code
							p_invoice_customer_state, -- state
							p_invoice_customer_city, -- city
							p_invoice_customer_adress, -- adress
							p_invoice_customer_adress_number, -- adress_number
							p_invoice_customer_adress_complement, -- adress_complement
							p_invoice_customer_district, -- district
							p_invoice_customer_postal_code, -- postal_code
							p_invoice_customer_area_code, -- area_code
							p_invoice_customer_cellphone, -- cellphone
							p_invoice_customer_email, -- email
							p_invoice_customer_state_registration, -- state_registration
							p_invoice_customer_federal_registration, -- federal_registration
							p_invoice_customer_final_consumer, -- final_consumer
							p_invoice_customer_icms_contributor, -- icms_contributor
							null, -- erp_filename
							null); -- erp_line_in_file    

			insert into receivable
							(order_to_cash_id,
							erp_receivable_id,
							erp_receivable_customer_id,
							erp_clustered_receivable_id,
							erp_clustered_receivable_customer_id,
							is_smartfin,
							transaction_type,
							contract_number,
							credit_card_brand,
							truncated_credit_card,
							current_credit_card_installment,
							total_credit_card_installment,
							nsu,
							conciliator_id,
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
							values
							(v_order_to_cash_id, -- order_to_cash_id
							null, -- erp_receivable_id
							v_erp_receivable_customer_id, -- erp_receivable_customer_id
							null, -- erp_clustered_receivable_id
							v_erp_clustered_receivable_customer_id, -- erp_clustered_receivable_customer_id
							p_receivable_is_smartfin, -- is_smartfin
							p_receivable_transaction_type, -- transaction_type
							p_receivable_contract_number, -- contract_number
							p_receivable_credit_card_brand, -- credit_card_brand
							p_receivable_truncated_credit_card, -- truncated_credit_card
							p_receivable_current_credit_card_installment, -- current_credit_card_installment
							p_receivable_total_credit_card_installment, -- total_credit_card_installment
							p_receivable_nsu, -- nsu
							p_receivable_conciliator_id, -- conciliator_id
							p_receivable_authorization_code, -- authorization_code
							p_receivable_price_list_value, -- price_list_value
							p_receivable_gross_value, -- gross_value
							p_receivable_net_value, -- net_value
							p_receivable_interest_value, -- interest_value
							p_receivable_administration_tax_percentage, -- administration_tax_percentage
							p_receivable_administration_tax_value, -- administration_tax_value
							p_receivable_antecipation_tax_percentage, -- antecipation_tax_percentage
							p_receivable_antecipation_tax_value, -- antecipation_tax_value
							p_receivable_billing_date, -- billing_date
							p_receivable_credit_date, -- credit_date
							p_receivable_conciliator_filename, -- conciliator_filename
							p_receivable_acquirer_bank_filename, -- acquirer_bank_filename
							p_receivable_registration_gym_student, -- registration_gym_student
							p_receivable_fullname_gym_student, -- fullname_gym_student
							p_receivable_identification_gym_student, -- identification_gym_student
							null, -- erp_filename
							null); -- erp_line_in_file
							
			insert into invoice
						(order_to_cash_id,
						erp_invoice_customer_id,
						transaction_type,
						is_overdue_recovery,
						fiscal_id,
						fiscal_series,
						fiscal_authentication_code,
						fiscal_model,
						fiscal_authorization_datetime,
						erp_filename,
						erp_line_in_file)
						values
						(v_order_to_cash_id, -- order_to_cash_id
						null, -- erp_invoice_customer_id
						p_invoice_transaction_type, -- transaction_type
						p_invoice_is_overdue_recovery, -- is_overdue_recovery
						null, -- fiscal_id
						null, -- fiscal_series
						null, -- fiscal_authentication_code
						null, -- fiscal_model
						null, -- fiscal_authorization_datetime
						null, -- erp_filename
						null); -- erp_line_in_file                        

			-- saves the auto increment id from order_to_cash table
			set v_invoice_id = last_insert_id(); 

            if (p_invoice_items_json <> '') then 
				
                select json_length(p_invoice_items_json);
                
				invoice_items_lopp: while i <= json_length(p_invoice_items_json) do
					                    
                    if (json_contains_path(p_invoice_items_json,'one',concat('$.invoice_items[',i,'].front_product_id')) = 1
                    and json_contains_path(p_invoice_items_json,'one',concat('$.invoice_items[',i,'].front_plan_id')) = 1 
                    and json_contains_path(p_invoice_items_json,'one',concat('$.invoice_items[',i,'].front_addon_id')) = 1 
                    and json_contains_path(p_invoice_items_json,'one',concat('$.invoice_items[',i,'].quantity')) = 1 
                    and json_contains_path(p_invoice_items_json,'one',concat('$.invoice_items[',i,'].list_price')) = 1 
                    and json_contains_path(p_invoice_items_json,'one',concat('$.invoice_items[',i,'].sale_price')) = 1 
                    ) then
						                        
						select json_extract(p_invoice_items_json,concat('$.invoice_items[',i,'].front_product_id')) into @v_front_product_id;
						select json_extract(p_invoice_items_json,concat('$.invoice_items[',i,'].front_plan_id')) into @v_front_plan_id;
						select json_extract(p_invoice_items_json,concat('$.invoice_items[',i,'].front_addon_id')) into @v_front_addon_id;                    
						select json_extract(p_invoice_items_json,concat('$.invoice_items[',i,'].quantity')) into @v_quantity;
						select json_extract(p_invoice_items_json,concat('$.invoice_items[',i,'].list_price')) into @v_list_price;
						select json_extract(p_invoice_items_json,concat('$.invoice_items[',i,'].sale_price')) into @v_sale_price;
						                        
						if (p_order_to_cash_origin_system = 'smartsystem') then

							if ( @v_front_product_id is not null and @v_front_plan_id is not null  ) then
								
								select 
									erp_item_ar_id
									into @v_erp_item_ar_id
								from product_from_to_version prodftv
								where prodftv.product_from_to_origin_system = p_order_to_cash_origin_system
								and prodftv.product_from_to_operation = p_order_to_cash_operation
								and prodftv.product_from_to_front_product_id = @v_front_product_id
								and prodftv.created_at = (
																select 
																	max(prodftv_v2.created_at) as created_at
																from product_from_to_version prodftv_v2
																where prodftv_v2.product_from_to_origin_system = prodftv.product_from_to_origin_system
																and prodftv_v2.product_from_to_operation = prodftv.product_from_to_operation
																and prodftv_v2.product_from_to_front_product_id = prodftv.product_from_to_front_product_id);

								select 
									 erp_gl_segment_id
									into @v_erp_gl_segment_id
								from plan_from_to_version planftv
								where planftv.plan_from_to_origin_system = p_order_to_cash_origin_system
								and planftv.plan_from_to_operation = p_order_to_cash_operation
								and planftv.plan_from_to_front_plan_id = @v_front_plan_id
								and planftv.created_at = (	select 
																	max(planftv_v2.created_at) as created_at
															from plan_from_to_version planftv_v2
															where planftv_v2.plan_from_to_origin_system = planftv.plan_from_to_origin_system
															and planftv_v2.plan_from_to_operation = planftv.plan_from_to_operation
															and planftv_v2.plan_from_to_front_plan_id = planftv.plan_from_to_front_plan_id );
								
							elseif ( @v_front_addon_id is not null ) then

								select 
									 @v_erp_item_ar_id := erp_item_ar_id        
									,@v_erp_gl_segment_id := erp_gl_segment_id
								from addon_from_to_version addoftv
								where addoftv.addon_from_to_origin_system = p_order_to_cash_origin_system
								and addoftv.addon_from_to_operation = p_order_to_cash_operation
								and addoftv.addon_from_to_front_addon_id = @v_front_addon_id
								and addoftv.created_at = (
																select 
																	max(prodftv_v2.created_at) as created_at
																from addon_from_to_version addoftv_v2
																where addoftv_v2.addon_from_to_origin_system = addoftv.addon_from_to_origin_system
																and addoftv_v2.addon_from_to_operation = addoftv.addon_from_to_operation
																and addoftv_v2.addon_from_to_front_addon_id = addoftv.addon_from_to_front_addon_id
														);

							else
							
								rollback;
								set p_return = false;
								set p_code = 5;
								set p_message = "blabla5";
								leave invoice_items_lopp;
								
							end if;

							if  ( ( @v_erp_item_ar_id is not null ) and ( @v_erp_gl_segment_id is not null) ) then
																							
									insert into invoice_items
									(id_invoice,
									front_product_id,
									front_plan_id,
									front_addon_id,
									erp_item_ar_id,
									erp_gl_segment_product,
									quantity,
									sale_price,
									list_price,
									erp_filename,
									erp_line_in_file)
									values
									(v_invoice_id, -- id_invoice
									@v_front_product_id, -- front_product_id
									@v_front_plan_id, -- front_plan_id
									null, -- front_addon_id
									@v_erp_item_ar_id, -- erp_item_ar_id
									@v_erp_gl_segment_id, -- erp_gl_segment_product
									@v_quantity, -- quantity
									@v_list_price, -- sale_price
									@v_sale_price, -- list_price
									null, -- erp_filename
									null); -- erp_line_in_file                                            
												
							else
                            
								rollback;
								set p_return = false;
								set p_code = 3;
								set p_message = "blabla3";
								
								leave invoice_items_lopp;
															
							end if;
						
						end if;				
					
                    else
                        
						rollback;
						set p_return = false;
						set p_code = 7;
						set p_message = "blabla7";
						leave invoice_items_lopp;                    
                    
                    end if;
                                        
					set i = i + 1 ;
                    					
				end while invoice_items_lopp;
			
				if ( p_return ) then
                
					set p_return = true;
					set p_code = 0;
					set p_message = "Inserido com sucesso !";
                
                end if;
            
            else

				rollback;
				set p_return = false;
				set p_code = 6;
				set p_message = "blabla6";
            
            end if;

		else
			
            rollback;
			set p_return = false;
			set p_code = 2;
			set p_message = "blabla2";
			
        end if;
			
    else 
		
        rollback;
        set p_return = false;
        set p_code = 1;
        set p_message = "blabla1";
    
    end if;
    
end;
//