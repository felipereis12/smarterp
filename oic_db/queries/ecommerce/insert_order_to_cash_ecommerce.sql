
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
				1, -- unity_identification -- aqui o valor a ser inserido deve ser fixo a principio - será necessário verificar qual o id correspondente a filial/empresa que as vendas de uniformes deverão ser integradas
				null, -- erp_business_unit
				null, -- erp_legal_entity
				null, -- erp_subsidiary
				null, -- acronym
				'no', -- to_generate_customer -- não é necessário gerar o cliente no Oracle, pois a origem de criação será lá
				'no', -- to_generate_receivable -- o receivable neste caso não deve ser gerado separadamente, pois o order management deverá criar ao criar o pedido no Oracle
				'yes', -- to_generate_invoice -- essa integração deverá gerar um order no OM do Oracle
				'magento', -- origin_system
				'uniform_sale_personal', -- operation -- esse dado deve variar de acordo com o tipo da venda do uniforme (uniform_sale_personal = venda para personal trainer, uniform_sale_franchise = venda para fraquias ou uniform_sale_own = venda para unidade própria)
				null, -- minifactu_id
				null, -- conciliator_id
				null, -- fin_id
				11548, -- front_id -- esse dado deve vir do e-commerce - trata-se do id do pedido no e-commerce
				null, -- erp_invoice_customer_send_to_erp_at
				null, -- erp_invoice_customer_returned_from_erp_at
				'doesnt_need_to_be_process', -- erp_invoice_customer_status_transaction
				null, -- erp_invoice_customer_log
				null, -- erp_receivable_sent_to_erp_at
				null, -- erp_receivable_returned_from_erp_at
				null, -- erp_receivable_customer_identification
				'doesnt_need_to_be_process', -- erp_receivable_status_transaction
				null, -- erp_receivable_log
				null, -- erp_invoice_send_to_erp_at
				null, -- erp_invoice_returned_from_erp_at
				'waiting_to_be_process', -- erp_invoice_status_transaction
				null, -- erp_invoice_log
				null, -- erp_receipt_send_to_erp_at
				null, -- erp_receipt_returned_from_erp_at
				'doesnt_need_to_be_process', -- erp_receipt_status_transaction
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


insert into oic_db.invoice_customer
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
				VALUES
				(@order_to_cash_id, -- order_to_cash_id
				'Brazil', -- country
				null, -- erp_customer_id
				'Maria Da Silva Ribeiro', -- full_name -- esse dado deve vir do e-commerce
				'natural_person', -- type_person -- esse dado deve vir do e-commerce
				'40198371047', -- identification_financial_responsible -- esse dado deve vir do e-commerce
				'BR', -- nationality_code -- esse dado deve vir do e-commerce
				'SP', -- state -- esse dado deve vir do e-commerce
				'São Paulo', -- city -- esse dado deve vir do e-commerce
				'Av. Paulista', -- adress -- esse dado deve vir do e-commerce
				'1294', -- adress_number -- esse dado deve vir do e-commerce
				'Segundo andar', -- adress_complement -- esse dado deve vir do e-commerce
				'Bela Vista', -- district -- esse dado deve vir do e-commerce
				'00000-00', -- postal_code -- esse dado deve vir do e-commerce
				'011', -- area_code -- esse dado deve vir do e-commerce
				'944511548', -- cellphone -- esse dado deve vir do e-commerce
				'felipe.nambara@bioritmo.com.br', -- email -- esse dado deve vir do e-commerce
				null, -- state_registration 
				null, -- federal_registration 
				'yes', -- final_consumer 
				'no', -- icms_contributor 
				null, -- erp_filename
				null); -- erp_line_in_file

insert into oic_db.receivable
				(order_to_cash_id,
				erp_receivable_id,
				erp_receipt_id,
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
				null, -- erp_receipt_id
				null, -- erp_receivable_customer_id
				null, -- erp_clustered_receivable_id
				null, -- erp_clustered_receivable_customer_id
				'no', -- is_smartfin
				'no', -- converted_smartfin
				null, -- type_smartfin
				null, -- receivable_id_smartfin
				'xpto1', -- ecommerce_payment_terms
				null, -- erp_payment_terms 
				null, -- conciliator_id
				'online_credit_card', -- transaction_type -- esse valor deve variar de acordo com a transação no e-commerce (cartão de crédito = online_credit_card, cartão de débito = online_debit_card)
				'123458', -- contract_number -- esse valor deve vir do e-commerce - trata-se do número de contrato com as operadoras de cartão de crédito
				'mastercard', -- credit_card_brand -- bandeira do cartão de crédito (mastercard, visa, americanexpress, elo, diners ou hipercard)
				'4458', -- truncated_credit_card --  no caso do e-commerce somentes os quatro ultimos dígitos do cartão é fornecido
				1, -- current_credit_card_installment -- trata-se da parcela atual. Neste caso sempre considerar 1, pois o Oracle ERP que gerará as parcelas de acordo com a condição de pagamento
				3, -- total_credit_card_installment -- trata-se do total de parcelas.
				'11545', -- nsu -- esse valor deve vir do e-commerce
				'55484', -- authorization_code -- esse valor deve vir do e-commerce
				100.15, -- price_list_value -- esse valor deve vir do e-commerce
				100.15, -- gross_value -- esse valor deve vir do e-commerce
				100.15, -- net_value -- esse valor deve vir do e-commerce
				0, -- interest_value
				0, -- administration_tax_percentage
				0, -- administration_tax_value
				0, -- antecipation_tax_percentage
				0, -- antecipation_tax_value
				'2019-11-22', -- billing_date -- esse valor deve vir do e-commerce - trata-se da data de cobrança
				'2019-12-22', -- credit_date - billing_date + 30
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

inner join payment_terms_from_to_version
on payment_terms_from_to_version.ecommerce_payment_terms = receivable.ecommerce_payment_terms
and payment_terms_from_to_version.created_at = (
												select
													max(payment_terms_from_to_version_v2.created_at) as created_at
												from payment_terms_from_to_version payment_terms_from_to_version_v2
                                                where payment_terms_from_to_version_v2.ecommerce_payment_terms = payment_terms_from_to_version.ecommerce_payment_terms
												)
                                                
set receivable.erp_payment_terms = payment_terms_from_to_version.erp_payment_terms

where receivable.id = @receivable_id;

insert into oic_db.invoice
				(order_to_cash_id,
				erp_invoice_id,
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
				(@order_to_cash_id, -- order_to_cash_id
				null, -- erp_invoice_id
				null, -- erp_invoice_customer_id
				'invoice_to_financial_responsible', -- transaction_type
				'no', -- is_overdue_recovery
				null, -- fiscal_id
				null, -- fiscal_series
				null, -- fiscal_authentication_code
				null, -- fiscal_model
				null, -- fiscal_authorization_datetime
				null, -- erp_filename
				null); -- erp_line_in_file

-- saves the auto increment id from order_to_cash table
set @invoice_id = last_insert_id();

insert into oic_db.invoice_items
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
				(@invoice_id, -- id_invoice
				120366453, -- front_product_id
				null, -- front_plan_id
				null, -- front_addon_id
				null, -- erp_item_ar_id
				null, -- erp_gl_segment_product
				1, -- quantity
				100.15, -- sale_price
				100.15, -- list_price
				null, -- erp_filename
				null); -- erp_line_in_file

-- saves the auto increment id from order_to_cash table
set @invoice_id_item = last_insert_id();

update invoice_items 

inner join invoice
on invoice.id = invoice_items.id_invoice

inner join order_to_cash
on order_to_cash.id = invoice.order_to_cash_id

inner join product_from_to 
on product_from_to.front_product_id = invoice_items.front_product_id
and product_from_to.origin_system = order_to_cash.origin_system

inner join product_from_to_version
on product_from_to_version.product_from_to_front_product_id = product_from_to.front_product_id
and product_from_to_version.product_from_to_origin_system = product_from_to.origin_system
and product_from_to_version.created_at = ( 
												select 
													max(product_from_to_version_v2.created_at) as max_created_at
												from product_from_to_version product_from_to_version_v2
                                                where product_from_to_version_v2.product_from_to_origin_system = product_from_to_version.product_from_to_origin_system
                                                and product_from_to_version_v2.product_from_to_front_product_id = product_from_to_version.product_from_to_front_product_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = product_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

