insert into oic_db.order_to_cash
				(order_to_cash_id_smartfin,
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
				erp_invoice_log,
				erp_receipt_send_to_erp_at,
				erp_receipt_returned_from_erp_at,
				erp_receipt_status_transaction,
				erp_receipt_log)
				values
				(null, -- order_to_cash_id_smartfin
				'Brazil', -- country
				307, -- unity_identification
				null, -- erp_business_unit
				null, -- erp_legal_entity
				null, -- erp_subsidiary
				null, -- acronym
				'no', -- to_generate_customer
				'yes', -- to_generate_receivable
				'no', -- to_generate_invoice
				'smartsystem', -- origin_system
				'franchise_conciliator', -- operation
				null, -- minifactu_id
				null, -- conciliator_id
				null, -- fin_id
				115485, -- front_id
				null, -- erp_invoice_customer_send_to_erp_at
				null, -- erp_invoice_customer_returned_from_erp_at
				'doesnt_need_to_be_process', -- erp_invoice_customer_status_transaction
				null, -- erp_invoice_customer_log
				null, -- erp_receivable_sent_to_erp_at
				null, -- erp_receivable_returned_from_erp_at
				'01027058000191', -- erp_receivable_customer_identification
				'waiting_to_be_process', -- erp_receivable_status_transaction
				null, -- erp_receivable_log
				null, -- erp_invoice_send_to_erp_at
				null, -- erp_invoice_returned_from_erp_at
				'doesnt_need_to_be_process', -- erp_invoice_status_transaction
				null, -- erp_invoice_log
				null, -- erp_receipt_send_to_erp_at
				null, -- erp_receipt_returned_from_erp_at
				'waiting_to_be_process', -- erp_receipt_status_transaction
				null); -- erp_receipt_log

-- saves the auto increment id from order_to_cash table
set @order_to_cash_id = last_insert_id();

-- updates the organizations fields from order_to_cash table. Note that the last version from organization_from_to_version must be always considered
update order_to_cash 

inner join organization_from_to 
on order_to_cash.unity_identification = organization_from_to.unity_identification

inner join organization_from_to_version
on organization_from_to_version.organization_from_to_unity_identification = organization_from_to.unity_identification
and organization_from_to_version.created_at = ( 
												select 
													max(organization_from_to_version_v2.created_at) as max_created_at
												from organization_from_to_version organization_from_to_version_v2
                                                where organization_from_to_version_v2.organization_from_to_unity_identification = organization_from_to_version.organization_from_to_unity_identification
												)

set order_to_cash.erp_business_unit = organization_from_to_version.erp_business_unit,
order_to_cash.erp_legal_entity = organization_from_to_version.erp_legal_entity,
order_to_cash.erp_subsidiary = organization_from_to_version.erp_subsidiary,
order_to_cash.acronym = organization_from_to_version.acronym

where order_to_cash.id = @order_to_cash_id;

insert into oic_db.receivable
			(order_to_cash_id,
			erp_receivable_id,
			erp_receivable_receipt_id,
			erp_receivable_customer_id,
			erp_clustered_receivable_id,
			erp_clustered_receivable_customer_id,
			is_smartfin,
			converted_smartfin,
			type_smartfin,
			receivable_id_smartfin,
			ecommerce_payment_terms,
			erp_payment_terms,
			conciliator_id,
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
			values
			(@order_to_cash_id, -- order_to_cash_id
			null, -- erp_receivable_id
			null, -- erp_receivable_receipt_id
			null, -- erp_receivable_customer_id
			null, -- erp_clustered_receivable_id
			null, -- erp_clustered_receivable_customer_id
			'yes', -- is_smartfin
			'no', -- converted_smartfin
			'franchise', -- type_smartfin
			null, -- receivable_id_smartfin
			null, -- ecommerce_payment_terms
			null, -- erp_payment_terms
			null, -- conciliator_id
			'credit_card_recurring', -- transaction_type
			null, -- contract_number
			'mastercard', -- credit_card_brand
			null, -- truncated_credit_card
			1, -- current_credit_card_installment
			1, -- total_credit_card_installment
			null, -- nsu
			null, -- authorization_code
			15545.55, -- price_list_value
			15545.55, -- gross_value
			15545.55, -- net_value
			0, -- interest_value
			0, -- administration_tax_percentage
			0, -- administration_tax_value
			0, -- antecipation_tax_percentage
			0, -- antecipation_tax_value
			'2019-11-26', -- billing_date
			'2019-11-28', -- credit_date
			null, -- conciliator_filename
			null, -- acquirer_bank_filename
			null, -- registration_gym_student
			null, -- fullname_gym_student
			null, -- identification_gym_student
			null, -- erp_filename
			null); -- erp_line_in_file

-- saves the auto increment id from order_to_cash table
set @receivable_id = last_insert_id();

update receivable

inner join order_to_cash
on order_to_cash.id = receivable.order_to_cash_id

inner join clustered_receivable_customer
on clustered_receivable_customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_receivable_customer_id = clustered_receivable_customer.erp_customer_id
	,receivable.erp_clustered_receivable_customer_id = clustered_receivable_customer.erp_customer_id

where receivable.id = @receivable_id;

insert into oic_db.supplier
			(erp_supplier_id,
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
			erp_supplier_send_to_erp_at,
			erp_supplier_returned_from_erp_at,
			erp_supplier_status_transaction,
			erp_supplier_log,
			erp_filename,
			erp_line_in_file)
			VALUES
			(null, -- erp_supplier_id
			'SMART FIT SAO CARLOS', -- full_name
			'legal_person', -- type_person
			'23383105000172', -- identification_financial_responsible
			'BR', -- nationality_code
			'SP', -- state
			'São Paulo', -- city
			'AV FRANCISCO PEREIRA LOPES TERREO 2 ', -- adress_number
			's/n', -- adress_number
			'', -- adress_complement
			'PQ ARNOLD SCHIMIDT', -- district
			'13564002', -- postal_code
			'11', -- area_code
			'', -- cellphone
			'felilpe.nambara@bioritmo.com.br', -- email
			null, -- state_registration
			null, -- federal_registration
			'no', -- final_consumer
			'no', -- icms_contributor
			null, -- erp_supplier_send_to_erp_at
			null, -- erp_supplier_returned_from_erp_at
			null, -- erp_supplier_status_transaction
			null, -- erp_supplier_log
			null, -- erp_filename
			null); -- erp_line_in_file

insert into oic_db.payable
			(unity_identification,
			erp_business_unit,
			erp_legal_entity,
			erp_subsidiary,
			acronym,
			erp_payable_id,
			receivable_id,
			erp_receivable_id,
			erp_clustered_receivable_id,
			erp_payable_receipt_id,
			erp_supplier_id,
            supplier_identification,
			issue_date,
			due_date,
			erp_payable_send_to_erp_at,
			erp_payable_returned_from_erp_at,
			erp_payable_status_transaction,
			erp_payable_log,
			erp_receipt_send_to_erp_at,
			erp_receipt_returned_from_erp_at,
			erp_receipt_status_transaction,
			erp_receipt_log,
			erp_filename,
			erp_line_in_file)
			VALUES(
			307, -- unity_identification
			null, -- erp_business_unit
			null, -- erp_legal_entity
			null, -- erp_subsidiary
			null, -- acronym
			null, -- erp_payable_id
			null, -- receivable_id
			@receivable_id, -- erp_receivable_id
			null, -- erp_clustered_receivable_id
			null, -- erp_payable_receipt_id
			null, -- erp_supplier_id
            '23383105000172', -- supplier_identification
			'2019-11-26', --  issue_date
			'2019-11-28', -- due_date
			null, -- erp_payable_send_to_erp_at
			null, -- erp_payable_returned_from_erp_at
			'waiting_to_be_process', -- erp_payable_status_transaction
			null, -- erp_payable_log
			null, -- erp_receipt_send_to_erp_at
			null, -- erp_receipt_returned_from_erp_at
			'waiting_to_be_process', -- erp_receipt_status_transaction
			null, -- erp_receipt_log
			null, -- erp_filename
			null); -- erp_line_in_file
            
-- saves the auto increment id from order_to_cash table
set @payable_id = last_insert_id();

-- updates the organizations fields from order_to_cash table. Note that the last version from organization_from_to_version must be always considered
update payable 

inner join organization_from_to 
on payable.unity_identification = organization_from_to.unity_identification

inner join organization_from_to_version
on organization_from_to_version.organization_from_to_unity_identification = organization_from_to.unity_identification
and organization_from_to_version.created_at = ( 
												select 
													max(organization_from_to_version_v2.created_at) as max_created_at
												from organization_from_to_version organization_from_to_version_v2
                                                where organization_from_to_version_v2.organization_from_to_unity_identification = organization_from_to_version.organization_from_to_unity_identification
												)

set payable.erp_business_unit = organization_from_to_version.erp_business_unit,
payable.erp_legal_entity = organization_from_to_version.erp_legal_entity,
payable.erp_subsidiary = organization_from_to_version.erp_subsidiary,
payable.acronym = organization_from_to_version.acronym

where payable.id = @payable_id;            
