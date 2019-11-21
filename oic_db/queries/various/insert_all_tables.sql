start transaction;
set sql_mode = traditional;

-- { example: Brazil, smartfit, person_plan, credit_card } =========================================================================================================================================
-- create the order_to_cash header moviment
insert into `oic_db`.`order_to_cash`
(`country`,
`unity_identification`,
`erp_business_unit`,
`erp_legal_entity`,
`erp_subsidiary`,
`to_generate_customer`,
`to_generate_receivable`,
`to_generate_invoice`,
`origin_system`,
`operation`,
`minifactu_id`,
`conciliator_id`,
`fin_id`,
`front_id`,
`erp_invoice_customer_send_to_erp_at`,
`erp_invoice_customer_returned_from_erp_at`,
`erp_invoice_customer_status_transaction`,
`erp_invoice_customer_log`,
`erp_receivable_sent_to_erp_at`,
`erp_receivable_returned_from_erp_at`,
`erp_receivable_customer_identification`,
`erp_receivable_status_transaction`,
`erp_receivable_log`,
`erp_invoice_send_to_erp_at`,
`erp_invoice_returned_from_erp_at`,
`erp_invoice_status_transaction`,
`erp_invoice_log`,
`erp_receipt_send_to_erp_at`,
`erp_receipt_returned_from_erp_at`,
`erp_receipt_status_transaction`,
`erp_receipt_log`)
values
('Brazil', -- country
'1', -- unity_identification
null, -- erp_business_unit
null, -- erp_legal_entity
null, -- erp_subsidiary
null, -- to_generate_customer
null, -- to_generate_receivable
null, -- to_generate_invoice
'smartsystem', -- origin_system
'person_plan', -- operation
1, -- minifactu_id
'abc123', -- conciliator_id
2, -- fin_id
99877897, -- front_id
null, -- erp_invoice_customer_send_to_erp_at
null, -- erp_invoice_customer_returned_from_erp_at
'waiting_to_be_process', -- erp_invoice_customer_status_transaction
null, -- erp_invoice_customer_log
null, -- erp_receivable_sent_to_erp_at
null, -- erp_receivable_returned_from_erp_at
'01027058000191', -- erp_receivable_customer_identification
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
order_to_cash.acronym = organization_from_to_version.acronym,
order_to_cash.to_generate_customer = organization_from_to_version.to_generate_customer,
order_to_cash.to_generate_receivable = organization_from_to_version.to_generate_receivable,
order_to_cash.to_generate_invoice = organization_from_to_version.to_generate_invoice

where order_to_cash.id = @order_to_cash_id;

-- create the invoice_customer 
insert into `oic_db`.`invoice_customer`
(`order_to_cash_id`,
`erp_customer_id`,
`full_name`,
`type_person`,
`identification_financial_responsible`,
`nationality_code`,
`state`,
`city`,
`adress`,
`adress_number`,
`adress_complement`,
`district`,
`postal_code`,
`area_code`,
`cellphone`,
`email`,
`state_registration`,
`federal_registration`,
`final_consumer`,
`icms_contributor`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_customer_id
'Felipe Volcov Nambara', -- full_name
'natural_person', -- type_person
'39367233892', -- identification_financial_responsible
'BR', -- nationality_code
'SP', -- state
'São Paulo', -- city
'Rua Manifesto', -- adress
2191, -- adress_number
null, -- adress_complement
'Ipiranga', -- district
'04209002', -- postal_code
'11', -- area_code
'970718989', -- cellphone
'felipe.nambara@bioritmo.com.br', -- email
null, -- state_registration
null, -- federal_registration
'yes', -- final_consumer
'no', -- icms_contributor
null, -- erp_filename
null); -- erp_line_in_file

-- create the receivable
insert into `oic_db`.`receivable`
(`order_to_cash_id`,
`erp_receivable_id`,
`erp_receivable_customer_id`,
`erp_clustered_receivable_id`,
`erp_clustered_receivable_customer_id`,
`is_smartfin`,
`transaction_type`,
`contract_number`,
`credit_card_brand`,
`truncated_credit_card`,
`current_credit_card_installment`,
`total_credit_card_installment`,
`nsu`,
`conciliator_id`,
`authorization_code`,
`price_list_value`,
`gross_value`,
`net_value`,
`interest_value`,
`administration_tax_percentage`,
`administration_tax_value`,
`antecipation_tax_percentage`,
`antecipation_tax_value`,
`billing_date`,
`credit_date`,
`conciliator_filename`,
`acquirer_bank_filename`,
`registration_gym_student`,
`fullname_gym_student`,
`identification_gym_student`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_receivable_id
null, -- erp_receivable_customer_id
null, -- erp_clustered_receivable_id
null, -- erp_clustered_receivable_customer_id
'yes', -- is_smartfin
'credit_card_recurring', -- transaction_type
'1288329736', -- contract_number
'mastercard', -- credit_card_brand
'1232****8872', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'883765246', -- nsu
'abc123', -- conciliator_id
null, -- authorization_code
290.9, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
0.0, -- interest_value
3.1, -- administration_tax_percentage
3.4038, -- administration_tax_value
0.0, -- antecipation_tax_percentage
0.0, -- antecipation_tax_value
20191017, -- billing_date
20191117, -- credit_date
null, -- conciliator_filename
null, -- acquirer_bank_filename
'12321322', -- registration_gym_student
'Felipe Volcov Nambara', -- fullname_gym_student
'39367233892', -- identification_gym_student
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from receivable table
set @receivable_id = last_insert_id();

-- updates the erp_products fields from invoice_items table. Note that the last version from product_from_to_version must be always considered
update receivable 

inner join order_to_cash 
on order_to_cash.id = receivable.order_to_cash_id

inner join clustered_receivable_customer
on clustered_receivable_customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_clustered_receivable_customer_id = clustered_receivable_customer.erp_customer_id,
receivable.erp_receivable_customer_id = clustered_receivable_customer.erp_customer_id

where receivable.id = @receivable_id;

-- create the invoice
insert into `oic_db`.`invoice`
(`order_to_cash_id`,
`erp_invoice_customer_id`,
`transaction_type`,
`is_overdue_recovery`,
`fiscal_id`,
`fiscal_series`,
`fiscal_authentication_code`,
`fiscal_model`,
`fiscal_authorization_datetime`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
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

-- saves the auto increment id from invoice table
set @invoice_id = last_insert_id();

-- create the invoice_items
insert into `oic_db`.`invoice_items`
(`id_invoice`,
`front_product_id`,
`front_plan_id`,
`front_addon_id`,
`erp_item_ar_id`,
`erp_gl_segment_product`,
`quantity`,
`sale_price`,
`list_price`,
`erp_filename`,
`erp_line_in_file`)
values
(@invoice_id, -- id_invoice
120366453, -- front_product_id
1, -- front_plan_id
null, -- front_addon_id
null, -- erp_item_ar_id
null, -- erp_gl_segment_product
1, -- quantity
49.90, -- sale_price
89.90, -- list_price
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from invoice_items table
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

inner join plan_from_to 
on plan_from_to.front_plan_id = invoice_items.front_plan_id
and plan_from_to.origin_system = order_to_cash.origin_system

inner join plan_from_to_version
on plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- create the invoice_items
insert into `oic_db`.`invoice_items`
(`id_invoice`,
`front_product_id`,
`front_plan_id`,
`front_addon_id`,
`erp_item_ar_id`,
`erp_gl_segment_product`,
`quantity`,
`sale_price`,
`list_price`,
`erp_filename`,
`erp_line_in_file`)
values
(@invoice_id, -- id_invoice
120366453, -- front_product_id
1, -- front_plan_id
null, -- front_addon_id
null, -- erp_item_ar_id
null, -- erp_gl_segment_product
1, -- quantity
59.90, -- sale_price
89.90, -- list_price
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from invoice_items table
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

inner join plan_from_to 
on plan_from_to.front_plan_id = invoice_items.front_plan_id
and plan_from_to.origin_system = order_to_cash.origin_system

inner join plan_from_to_version
on plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- { example: Brazil, smartfit, person_plan, debit_account } =========================================================================================================================================
-- create the order_to_cash header moviment
insert into `oic_db`.`order_to_cash`
(`country`,
`unity_identification`,
`erp_business_unit`,
`erp_legal_entity`,
`erp_subsidiary`,
`to_generate_customer`,
`to_generate_receivable`,
`to_generate_invoice`,
`origin_system`,
`operation`,
`minifactu_id`,
`conciliator_id`,
`fin_id`,
`front_id`,
`erp_invoice_customer_send_to_erp_at`,
`erp_invoice_customer_returned_from_erp_at`,
`erp_invoice_customer_status_transaction`,
`erp_invoice_customer_log`,
`erp_receivable_sent_to_erp_at`,
`erp_receivable_returned_from_erp_at`,
`erp_receivable_customer_identification`,
`erp_receivable_status_transaction`,
`erp_receivable_log`,
`erp_invoice_send_to_erp_at`,
`erp_invoice_returned_from_erp_at`,
`erp_invoice_status_transaction`,
`erp_invoice_log`,
`erp_receipt_send_to_erp_at`,
`erp_receipt_returned_from_erp_at`,
`erp_receipt_status_transaction`,
`erp_receipt_log`)
values
('Brazil', -- country
'1', -- unity_identification
null, -- erp_business_unit
null, -- erp_legal_entity
null, -- erp_subsidiary
null, -- to_generate_customer
null, -- to_generate_receivable
null, -- to_generate_invoice
'smartsystem', -- origin_system
'person_plan', -- operation
2, -- minifactu_id
'xyz123', -- conciliator_id
3, -- fin_id
99872631, -- front_id
null, -- erp_invoice_customer_send_to_erp_at
null, -- erp_invoice_customer_returned_from_erp_at
'waiting_to_be_process', -- erp_invoice_customer_status_transaction
null, -- erp_invoice_customer_log
null, -- erp_receivable_sent_to_erp_at
null, -- erp_receivable_returned_from_erp_at
'60701190000104', -- erp_receivable_customer_identification
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
order_to_cash.acronym = organization_from_to_version.acronym,
order_to_cash.to_generate_customer = organization_from_to_version.to_generate_customer,
order_to_cash.to_generate_receivable = organization_from_to_version.to_generate_receivable,
order_to_cash.to_generate_invoice = organization_from_to_version.to_generate_invoice

where order_to_cash.id = @order_to_cash_id;

-- create the invoice_customer 
insert into `oic_db`.`invoice_customer`
(`order_to_cash_id`,
`erp_customer_id`,
`full_name`,
`type_person`,
`identification_financial_responsible`,
`nationality_code`,
`state`,
`city`,
`adress`,
`adress_number`,
`adress_complement`,
`district`,
`postal_code`,
`area_code`,
`cellphone`,
`email`,
`state_registration`,
`federal_registration`,
`final_consumer`,
`icms_contributor`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_customer_id
'João da Silva', -- full_name
'natural_person', -- type_person
'80873516060', -- identification_financial_responsible
'BR', -- nationality_code
'SP', -- state
'São Paulo', -- city
'Av Ipiranga', -- adress
1000, -- adress_number
null, -- adress_complement
'Centro', -- district
'04209002', -- postal_code
'11', -- area_code
'970718989', -- cellphone
'felipe.nambara@bioritmo.com.br', -- email
null, -- state_registration
null, -- federal_registration
'yes', -- final_consumer
'no', -- icms_contributor
null, -- erp_filename
null); -- erp_line_in_file

-- create the receivable
insert into `oic_db`.`receivable`
(`order_to_cash_id`,
`erp_receivable_id`,
`erp_receivable_customer_id`,
`erp_clustered_receivable_id`,
`erp_clustered_receivable_customer_id`,
`is_smartfin`,
`transaction_type`,
`contract_number`,
`credit_card_brand`,
`truncated_credit_card`,
`current_credit_card_installment`,
`total_credit_card_installment`,
`nsu`,
`conciliator_id`,
`authorization_code`,
`price_list_value`,
`gross_value`,
`net_value`,
`interest_value`,
`administration_tax_percentage`,
`administration_tax_value`,
`antecipation_tax_percentage`,
`antecipation_tax_value`,
`billing_date`,
`credit_date`,
`conciliator_filename`,
`acquirer_bank_filename`,
`registration_gym_student`,
`fullname_gym_student`,
`identification_gym_student`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_receivable_id
null, -- erp_receivable_customer_id
null, -- erp_clustered_receivable_id
null, -- erp_clustered_receivable_customer_id
'no', -- is_smartfin
'debit_account_recurring', -- transaction_type
'1288329725', -- contract_number
null, -- credit_card_brand
null, -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
null, -- nsu
'xyz123', -- conciliator_id
'3277618275', -- authorization_code
290.9, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
0.0, -- interest_value
0.0, -- administration_tax_percentage
0.0, -- administration_tax_value
0.0, -- antecipation_tax_percentage
0.0, -- antecipation_tax_value
20191018, -- billing_date
20191118, -- credit_date
null, -- conciliator_filename
null, -- acquirer_bank_filename
'12321355', -- registration_gym_student
'João da Silva', -- fullname_gym_student
'80873516060', -- identification_gym_student
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from receivable table
set @receivable_id = last_insert_id();

-- updates the erp_products fields from invoice_items table. Note that the last version from product_from_to_version must be always considered
update receivable 

inner join order_to_cash 
on order_to_cash.id = receivable.order_to_cash_id

inner join clustered_receivable_customer
on clustered_receivable_customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_clustered_receivable_customer_id = clustered_receivable_customer.erp_customer_id,
receivable.erp_receivable_customer_id = clustered_receivable_customer.erp_customer_id

where receivable.id = @receivable_id;

-- create the invoice
insert into `oic_db`.`invoice`
(`order_to_cash_id`,
`erp_invoice_customer_id`,
`transaction_type`,
`is_overdue_recovery`,
`fiscal_id`,
`fiscal_series`,
`fiscal_authentication_code`,
`fiscal_model`,
`fiscal_authorization_datetime`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
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

-- saves the auto increment id from invoice table
set @invoice_id = last_insert_id();

-- create the invoice_items
insert into `oic_db`.`invoice_items`
(`id_invoice`,
`front_product_id`,
`front_plan_id`,
`front_addon_id`,
`erp_item_ar_id`,
`erp_gl_segment_product`,
`quantity`,
`sale_price`,
`list_price`,
`erp_filename`,
`erp_line_in_file`)
values
(@invoice_id, -- id_invoice
120366453, -- front_product_id
1, -- front_plan_id
null, -- front_addon_id
null, -- erp_item_ar_id
null, -- erp_gl_segment_product
1, -- quantity
49.90, -- sale_price
89.90, -- list_price
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from invoice_items table
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

inner join plan_from_to 
on plan_from_to.front_plan_id = invoice_items.front_plan_id
and plan_from_to.origin_system = order_to_cash.origin_system

inner join plan_from_to_version
on plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- create the invoice_items
insert into `oic_db`.`invoice_items`
(`id_invoice`,
`front_product_id`,
`front_plan_id`,
`front_addon_id`,
`erp_item_ar_id`,
`erp_gl_segment_product`,
`quantity`,
`sale_price`,
`list_price`,
`erp_filename`,
`erp_line_in_file`)
values
(@invoice_id, -- id_invoice
120366453, -- front_product_id
1, -- front_plan_id
null, -- front_addon_id
null, -- erp_item_ar_id
null, -- erp_gl_segment_product
1, -- quantity
59.90, -- sale_price
89.90, -- list_price
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from invoice_items table
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

inner join plan_from_to 
on plan_from_to.front_plan_id = invoice_items.front_plan_id
and plan_from_to.origin_system = order_to_cash.origin_system

inner join plan_from_to_version
on plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- { example: Brazil, smartfit, person_plan, credit_card } =========================================================================================================================================
-- create the order_to_cash header moviment
insert into `oic_db`.`order_to_cash`
(`country`,
`unity_identification`,
`erp_business_unit`,
`erp_legal_entity`,
`erp_subsidiary`,
`to_generate_customer`,
`to_generate_receivable`,
`to_generate_invoice`,
`origin_system`,
`operation`,
`minifactu_id`,
`conciliator_id`,
`fin_id`,
`front_id`,
`erp_invoice_customer_send_to_erp_at`,
`erp_invoice_customer_returned_from_erp_at`,
`erp_invoice_customer_status_transaction`,
`erp_invoice_customer_log`,
`erp_receivable_sent_to_erp_at`,
`erp_receivable_returned_from_erp_at`,
`erp_receivable_customer_identification`,
`erp_receivable_status_transaction`,
`erp_receivable_log`,
`erp_invoice_send_to_erp_at`,
`erp_invoice_returned_from_erp_at`,
`erp_invoice_status_transaction`,
`erp_invoice_log`,
`erp_receipt_send_to_erp_at`,
`erp_receipt_returned_from_erp_at`,
`erp_receipt_status_transaction`,
`erp_receipt_log`)
values
('Brazil', -- country
'1', -- unity_identification
null, -- erp_business_unit
null, -- erp_legal_entity
null, -- erp_subsidiary
null, -- to_generate_customer
null, -- to_generate_receivable
null, -- to_generate_invoice
'smartsystem', -- origin_system
'person_plan', -- operation
3, -- minifactu_id
'hdjuhs123', -- conciliator_id
4, -- fin_id
99872644, -- front_id
null, -- erp_invoice_customer_send_to_erp_at
null, -- erp_invoice_customer_returned_from_erp_at
'waiting_to_be_process', -- erp_invoice_customer_status_transaction
null, -- erp_invoice_customer_log
null, -- erp_receivable_sent_to_erp_at
null, -- erp_receivable_returned_from_erp_at
'01027058000191', -- erp_receivable_customer_identification
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
order_to_cash.acronym = organization_from_to_version.acronym,
order_to_cash.to_generate_customer = organization_from_to_version.to_generate_customer,
order_to_cash.to_generate_receivable = organization_from_to_version.to_generate_receivable,
order_to_cash.to_generate_invoice = organization_from_to_version.to_generate_invoice

where order_to_cash.id = @order_to_cash_id;

-- create the invoice_customer 
insert into `oic_db`.`invoice_customer`
(`order_to_cash_id`,
`erp_customer_id`,
`full_name`,
`type_person`,
`identification_financial_responsible`,
`nationality_code`,
`state`,
`city`,
`adress`,
`adress_number`,
`adress_complement`,
`district`,
`postal_code`,
`area_code`,
`cellphone`,
`email`,
`state_registration`,
`federal_registration`,
`final_consumer`,
`icms_contributor`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_customer_id
'Maria da Silva', -- full_name
'natural_person', -- type_person
'42159466034', -- identification_financial_responsible
'BR', -- nationality_code
'SP', -- state
'São Paulo', -- city
'Xpto', -- adress
9876, -- adress_number
null, -- adress_complement
'Itaim Bibi', -- district
'04209002', -- postal_code
'11', -- area_code
'970718989', -- cellphone
'felipe.nambara@bioritmo.com.br', -- email
null, -- state_registration
null, -- federal_registration
'yes', -- final_consumer
'no', -- icms_contributor
null, -- erp_filename
null); -- erp_line_in_file

-- create the receivable
insert into `oic_db`.`receivable`
(`order_to_cash_id`,
`erp_receivable_id`,
`erp_receivable_customer_id`,
`erp_clustered_receivable_id`,
`erp_clustered_receivable_customer_id`,
`is_smartfin`,
`transaction_type`,
`contract_number`,
`credit_card_brand`,
`truncated_credit_card`,
`current_credit_card_installment`,
`total_credit_card_installment`,
`nsu`,
`conciliator_id`,
`authorization_code`,
`price_list_value`,
`gross_value`,
`net_value`,
`interest_value`,
`administration_tax_percentage`,
`administration_tax_value`,
`antecipation_tax_percentage`,
`antecipation_tax_value`,
`billing_date`,
`credit_date`,
`conciliator_filename`,
`acquirer_bank_filename`,
`registration_gym_student`,
`fullname_gym_student`,
`identification_gym_student`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_receivable_id
null, -- erp_receivable_customer_id
null, -- erp_clustered_receivable_id
null, -- erp_clustered_receivable_customer_id
'no', -- is_smartfin
'credit_card_recurring', -- transaction_type
'1288329736', -- contract_number
'mastercard', -- credit_card_brand
'2134****2993', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'3276518275', -- nsu
'hdjuhs123', -- conciliator_id
null, -- authorization_code
290.8, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
0.0, -- interest_value
3.1, -- administration_tax_percentage
3.4038, -- administration_tax_value
0.0, -- antecipation_tax_percentage
0.0, -- antecipation_tax_value
20191018, -- billing_date
20191118, -- credit_date
null, -- conciliator_filename
null, -- acquirer_bank_filename
'12321355', -- registration_gym_student
'João da Silva', -- fullname_gym_student
'80873516060', -- identification_gym_student
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from receivable table
set @receivable_id = last_insert_id();

-- updates the erp_products fields from invoice_items table. Note that the last version from product_from_to_version must be always considered
update receivable 

inner join order_to_cash 
on order_to_cash.id = receivable.order_to_cash_id

inner join clustered_receivable_customer
on clustered_receivable_customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_clustered_receivable_customer_id = clustered_receivable_customer.erp_customer_id,
receivable.erp_receivable_customer_id = clustered_receivable_customer.erp_customer_id

where receivable.id = @receivable_id;

-- create the invoice
insert into `oic_db`.`invoice`
(`order_to_cash_id`,
`erp_invoice_customer_id`,
`transaction_type`,
`is_overdue_recovery`,
`fiscal_id`,
`fiscal_series`,
`fiscal_authentication_code`,
`fiscal_model`,
`fiscal_authorization_datetime`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
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

-- saves the auto increment id from invoice table
set @invoice_id = last_insert_id();

-- create the invoice_items
insert into `oic_db`.`invoice_items`
(`id_invoice`,
`front_product_id`,
`front_plan_id`,
`front_addon_id`,
`erp_item_ar_id`,
`erp_gl_segment_product`,
`quantity`,
`sale_price`,
`list_price`,
`erp_filename`,
`erp_line_in_file`)
values
(@invoice_id, -- id_invoice
120366453, -- front_product_id
1, -- front_plan_id
null, -- front_addon_id
null, -- erp_item_ar_id
null, -- erp_gl_segment_product
1, -- quantity
49.90, -- sale_price
89.90, -- list_price
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from invoice_items table
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

inner join plan_from_to 
on plan_from_to.front_plan_id = invoice_items.front_plan_id
and plan_from_to.origin_system = order_to_cash.origin_system

inner join plan_from_to_version
on plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- create the invoice_items
insert into `oic_db`.`invoice_items`
(`id_invoice`,
`front_product_id`,
`front_plan_id`,
`front_addon_id`,
`erp_item_ar_id`,
`erp_gl_segment_product`,
`quantity`,
`sale_price`,
`list_price`,
`erp_filename`,
`erp_line_in_file`)
values
(@invoice_id, -- id_invoice
120366453, -- front_product_id
1, -- front_plan_id
null, -- front_addon_id
null, -- erp_item_ar_id
null, -- erp_gl_segment_product
1, -- quantity
59.90, -- sale_price
89.90, -- list_price
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from invoice_items table
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

inner join plan_from_to 
on plan_from_to.front_plan_id = invoice_items.front_plan_id
and plan_from_to.origin_system = order_to_cash.origin_system

inner join plan_from_to_version
on plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- { example: Brazil, smartfit, person_plan, debit_account } =========================================================================================================================================
-- create the order_to_cash header moviment
insert into `oic_db`.`order_to_cash`
(`country`,
`unity_identification`,
`erp_business_unit`,
`erp_legal_entity`,
`erp_subsidiary`,
`to_generate_customer`,
`to_generate_receivable`,
`to_generate_invoice`,
`origin_system`,
`operation`,
`minifactu_id`,
`conciliator_id`,
`fin_id`,
`front_id`,
`erp_invoice_customer_send_to_erp_at`,
`erp_invoice_customer_returned_from_erp_at`,
`erp_invoice_customer_status_transaction`,
`erp_invoice_customer_log`,
`erp_receivable_sent_to_erp_at`,
`erp_receivable_returned_from_erp_at`,
`erp_receivable_customer_identification`,
`erp_receivable_status_transaction`,
`erp_receivable_log`,
`erp_invoice_send_to_erp_at`,
`erp_invoice_returned_from_erp_at`,
`erp_invoice_status_transaction`,
`erp_invoice_log`,
`erp_receipt_send_to_erp_at`,
`erp_receipt_returned_from_erp_at`,
`erp_receipt_status_transaction`,
`erp_receipt_log`)
values
('Brazil', -- country
'1', -- unity_identification
null, -- erp_business_unit
null, -- erp_legal_entity
null, -- erp_subsidiary
null, -- to_generate_customer
null, -- to_generate_receivable
null, -- to_generate_invoice
'smartsystem', -- origin_system
'person_plan', -- operation
4, -- minifactu_id
'yytre123', -- conciliator_id
5, -- fin_id
93472631, -- front_id
null, -- erp_invoice_customer_send_to_erp_at
null, -- erp_invoice_customer_returned_from_erp_at
'waiting_to_be_process', -- erp_invoice_customer_status_transaction
null, -- erp_invoice_customer_log
null, -- erp_receivable_sent_to_erp_at
null, -- erp_receivable_returned_from_erp_at
'60701190000104', -- erp_receivable_customer_identification
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
order_to_cash.acronym = organization_from_to_version.acronym,
order_to_cash.to_generate_customer = organization_from_to_version.to_generate_customer,
order_to_cash.to_generate_receivable = organization_from_to_version.to_generate_receivable,
order_to_cash.to_generate_invoice = organization_from_to_version.to_generate_invoice

where order_to_cash.id = @order_to_cash_id;

-- create the invoice_customer 
insert into `oic_db`.`invoice_customer`
(`order_to_cash_id`,
`erp_customer_id`,
`full_name`,
`type_person`,
`identification_financial_responsible`,
`nationality_code`,
`state`,
`city`,
`adress`,
`adress_number`,
`adress_complement`,
`district`,
`postal_code`,
`area_code`,
`cellphone`,
`email`,
`state_registration`,
`federal_registration`,
`final_consumer`,
`icms_contributor`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_customer_id
'Carol da Silva', -- full_name
'natural_person', -- type_person
'59061781043', -- identification_financial_responsible
'BR', -- nationality_code
'SP', -- state
'São Paulo', -- city
'Av Ipiranga', -- adress
1000, -- adress_number
null, -- adress_complement
'Centro', -- district
'04209002', -- postal_code
'11', -- area_code
'970718989', -- cellphone
'felipe.nambara@bioritmo.com.br', -- email
null, -- state_registration
null, -- federal_registration
'yes', -- final_consumer
'no', -- icms_contributor
null, -- erp_filename
null); -- erp_line_in_file

-- create the receivable
insert into `oic_db`.`receivable`
(`order_to_cash_id`,
`erp_receivable_id`,
`erp_receivable_customer_id`,
`erp_clustered_receivable_id`,
`erp_clustered_receivable_customer_id`,
`is_smartfin`,
`transaction_type`,
`contract_number`,
`credit_card_brand`,
`truncated_credit_card`,
`current_credit_card_installment`,
`total_credit_card_installment`,
`nsu`,
`conciliator_id`,
`authorization_code`,
`price_list_value`,
`gross_value`,
`net_value`,
`interest_value`,
`administration_tax_percentage`,
`administration_tax_value`,
`antecipation_tax_percentage`,
`antecipation_tax_value`,
`billing_date`,
`credit_date`,
`conciliator_filename`,
`acquirer_bank_filename`,
`registration_gym_student`,
`fullname_gym_student`,
`identification_gym_student`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_receivable_id
null, -- erp_receivable_customer_id
null, -- erp_clustered_receivable_id
null, -- erp_clustered_receivable_customer_id
'no', -- is_smartfin
'debit_account_recurring', -- transaction_type
'1288329725', -- contract_number
null, -- credit_card_brand
null, -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
null, -- nsu
'yytre123', -- conciliator_id
'3277618273', -- authorization_code
299.9, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
0.0, -- interest_value
0.0, -- administration_tax_percentage
0.0, -- administration_tax_value
0.0, -- antecipation_tax_percentage
0.0, -- antecipation_tax_value
20191018, -- billing_date
20191118, -- credit_date
null, -- conciliator_filename
null, -- acquirer_bank_filename
'12321355', -- registration_gym_student
'João da Silva', -- fullname_gym_student
'80873516060', -- identification_gym_student
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from receivable table
set @receivable_id = last_insert_id();

-- updates the erp_products fields from invoice_items table. Note that the last version from product_from_to_version must be always considered
update receivable 

inner join order_to_cash 
on order_to_cash.id = receivable.order_to_cash_id

inner join clustered_receivable_customer
on clustered_receivable_customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_clustered_receivable_customer_id = clustered_receivable_customer.erp_customer_id,
receivable.erp_receivable_customer_id = clustered_receivable_customer.erp_customer_id

where receivable.id = @receivable_id;

-- create the invoice
insert into `oic_db`.`invoice`
(`order_to_cash_id`,
`erp_invoice_customer_id`,
`transaction_type`,
`is_overdue_recovery`,
`fiscal_id`,
`fiscal_series`,
`fiscal_authentication_code`,
`fiscal_model`,
`fiscal_authorization_datetime`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
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

-- saves the auto increment id from invoice table
set @invoice_id = last_insert_id();

-- create the invoice_items
insert into `oic_db`.`invoice_items`
(`id_invoice`,
`front_product_id`,
`front_plan_id`,
`front_addon_id`,
`erp_item_ar_id`,
`erp_gl_segment_product`,
`quantity`,
`sale_price`,
`list_price`,
`erp_filename`,
`erp_line_in_file`)
values
(@invoice_id, -- id_invoice
120366453, -- front_product_id
1, -- front_plan_id
null, -- front_addon_id
null, -- erp_item_ar_id
null, -- erp_gl_segment_product
1, -- quantity
49.90, -- sale_price
89.90, -- list_price
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from invoice_items table
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

inner join plan_from_to 
on plan_from_to.front_plan_id = invoice_items.front_plan_id
and plan_from_to.origin_system = order_to_cash.origin_system

inner join plan_from_to_version
on plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- create the invoice_items
insert into `oic_db`.`invoice_items`
(`id_invoice`,
`front_product_id`,
`front_plan_id`,
`front_addon_id`,
`erp_item_ar_id`,
`erp_gl_segment_product`,
`quantity`,
`sale_price`,
`list_price`,
`erp_filename`,
`erp_line_in_file`)
values
(@invoice_id, -- id_invoice
120366453, -- front_product_id
1, -- front_plan_id
null, -- front_addon_id
null, -- erp_item_ar_id
null, -- erp_gl_segment_product
1, -- quantity
59.90, -- sale_price
89.90, -- list_price
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from invoice_items table
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

inner join plan_from_to 
on plan_from_to.front_plan_id = invoice_items.front_plan_id
and plan_from_to.origin_system = order_to_cash.origin_system

inner join plan_from_to_version
on plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- { example: Brazil, smartfit, person_plan, debit_account } =========================================================================================================================================
-- create the order_to_cash header moviment
insert into `oic_db`.`order_to_cash`
(`country`,
`unity_identification`,
`erp_business_unit`,
`erp_legal_entity`,
`erp_subsidiary`,
`to_generate_customer`,
`to_generate_receivable`,
`to_generate_invoice`,
`origin_system`,
`operation`,
`minifactu_id`,
`conciliator_id`,
`fin_id`,
`front_id`,
`erp_invoice_customer_send_to_erp_at`,
`erp_invoice_customer_returned_from_erp_at`,
`erp_invoice_customer_status_transaction`,
`erp_invoice_customer_log`,
`erp_receivable_sent_to_erp_at`,
`erp_receivable_returned_from_erp_at`,
`erp_receivable_customer_identification`,
`erp_receivable_status_transaction`,
`erp_receivable_log`,
`erp_invoice_send_to_erp_at`,
`erp_invoice_returned_from_erp_at`,
`erp_invoice_status_transaction`,
`erp_invoice_log`,
`erp_receipt_send_to_erp_at`,
`erp_receipt_returned_from_erp_at`,
`erp_receipt_status_transaction`,
`erp_receipt_log`)
values
('Brazil', -- country
'1', -- unity_identification
null, -- erp_business_unit
null, -- erp_legal_entity
null, -- erp_subsidiary
null, -- to_generate_customer
null, -- to_generate_receivable
null, -- to_generate_invoice
'smartsystem', -- origin_system
'person_plan', -- operation
5, -- minifactu_id
'yytre383', -- conciliator_id
6, -- fin_id
93474331, -- front_id
null, -- erp_invoice_customer_send_to_erp_at
null, -- erp_invoice_customer_returned_from_erp_at
'waiting_to_be_process', -- erp_invoice_customer_status_transaction
null, -- erp_invoice_customer_log
null, -- erp_receivable_sent_to_erp_at
null, -- erp_receivable_returned_from_erp_at
'60701190000104', -- erp_receivable_customer_identification
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
order_to_cash.acronym = organization_from_to_version.acronym,
order_to_cash.to_generate_customer = organization_from_to_version.to_generate_customer,
order_to_cash.to_generate_receivable = organization_from_to_version.to_generate_receivable,
order_to_cash.to_generate_invoice = organization_from_to_version.to_generate_invoice

where order_to_cash.id = @order_to_cash_id;

-- create the invoice_customer 
insert into `oic_db`.`invoice_customer`
(`order_to_cash_id`,
`erp_customer_id`,
`full_name`,
`type_person`,
`identification_financial_responsible`,
`nationality_code`,
`state`,
`city`,
`adress`,
`adress_number`,
`adress_complement`,
`district`,
`postal_code`,
`area_code`,
`cellphone`,
`email`,
`state_registration`,
`federal_registration`,
`final_consumer`,
`icms_contributor`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_customer_id
'José da Silva', -- full_name
'natural_person', -- type_person
'41474280021', -- identification_financial_responsible
'BR', -- nationality_code
'SP', -- state
'São Paulo', -- city
'Av Ipiranga', -- adress
1000, -- adress_number
null, -- adress_complement
'Centro', -- district
'04209002', -- postal_code
'11', -- area_code
'970718989', -- cellphone
'felipe.nambara@bioritmo.com.br', -- email
null, -- state_registration
null, -- federal_registration
'yes', -- final_consumer
'no', -- icms_contributor
null, -- erp_filename
null); -- erp_line_in_file

-- create the receivable
insert into `oic_db`.`receivable`
(`order_to_cash_id`,
`erp_receivable_id`,
`erp_receivable_customer_id`,
`erp_clustered_receivable_id`,
`erp_clustered_receivable_customer_id`,
`is_smartfin`,
`transaction_type`,
`contract_number`,
`credit_card_brand`,
`truncated_credit_card`,
`current_credit_card_installment`,
`total_credit_card_installment`,
`nsu`,
`conciliator_id`,
`authorization_code`,
`price_list_value`,
`gross_value`,
`net_value`,
`interest_value`,
`administration_tax_percentage`,
`administration_tax_value`,
`antecipation_tax_percentage`,
`antecipation_tax_value`,
`billing_date`,
`credit_date`,
`conciliator_filename`,
`acquirer_bank_filename`,
`registration_gym_student`,
`fullname_gym_student`,
`identification_gym_student`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_receivable_id
null, -- erp_receivable_customer_id
null, -- erp_clustered_receivable_id
null, -- erp_clustered_receivable_customer_id
'no', -- is_smartfin
'debit_account_recurring', -- transaction_type
'1288329725', -- contract_number
null, -- credit_card_brand
null, -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
null, -- nsu
'yytre383', -- conciliator_id
'3277623173', -- authorization_code
299.9, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
0.0, -- interest_value
0.0, -- administration_tax_percentage
0.0, -- administration_tax_value
0.0, -- antecipation_tax_percentage
0.0, -- antecipation_tax_value
20191018, -- billing_date
20191118, -- credit_date
null, -- conciliator_filename
null, -- acquirer_bank_filename
'12321355', -- registration_gym_student
'João da Silva', -- fullname_gym_student
'80873516060', -- identification_gym_student
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from receivable table
set @receivable_id = last_insert_id();

-- updates the erp_products fields from invoice_items table. Note that the last version from product_from_to_version must be always considered
update receivable 

inner join order_to_cash 
on order_to_cash.id = receivable.order_to_cash_id

inner join clustered_receivable_customer
on clustered_receivable_customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_clustered_receivable_customer_id = clustered_receivable_customer.erp_customer_id,
receivable.erp_receivable_customer_id = clustered_receivable_customer.erp_customer_id

where receivable.id = @receivable_id;

-- create the invoice
insert into `oic_db`.`invoice`
(`order_to_cash_id`,
`erp_invoice_customer_id`,
`transaction_type`,
`is_overdue_recovery`,
`fiscal_id`,
`fiscal_series`,
`fiscal_authentication_code`,
`fiscal_model`,
`fiscal_authorization_datetime`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
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

-- saves the auto increment id from invoice table
set @invoice_id = last_insert_id();

-- create the invoice_items
insert into `oic_db`.`invoice_items`
(`id_invoice`,
`front_product_id`,
`front_plan_id`,
`front_addon_id`,
`erp_item_ar_id`,
`erp_gl_segment_product`,
`quantity`,
`sale_price`,
`list_price`,
`erp_filename`,
`erp_line_in_file`)
values
(@invoice_id, -- id_invoice
120366453, -- front_product_id
1, -- front_plan_id
null, -- front_addon_id
null, -- erp_item_ar_id
null, -- erp_gl_segment_product
1, -- quantity
49.90, -- sale_price
89.90, -- list_price
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from invoice_items table
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

inner join plan_from_to 
on plan_from_to.front_plan_id = invoice_items.front_plan_id
and plan_from_to.origin_system = order_to_cash.origin_system

inner join plan_from_to_version
on plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- create the invoice_items
insert into `oic_db`.`invoice_items`
(`id_invoice`,
`front_product_id`,
`front_plan_id`,
`front_addon_id`,
`erp_item_ar_id`,
`erp_gl_segment_product`,
`quantity`,
`sale_price`,
`list_price`,
`erp_filename`,
`erp_line_in_file`)
values
(@invoice_id, -- id_invoice
120366453, -- front_product_id
1, -- front_plan_id
null, -- front_addon_id
null, -- erp_item_ar_id
null, -- erp_gl_segment_product
1, -- quantity
59.90, -- sale_price
89.90, -- list_price
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from invoice_items table
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

inner join plan_from_to 
on plan_from_to.front_plan_id = invoice_items.front_plan_id
and plan_from_to.origin_system = order_to_cash.origin_system

inner join plan_from_to_version
on plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- { example: Brazil, smartfit, person_plan, credit_card } =========================================================================================================================================
-- create the order_to_cash header moviment
insert into `oic_db`.`order_to_cash`
(`country`,
`unity_identification`,
`erp_business_unit`,
`erp_legal_entity`,
`erp_subsidiary`,
`to_generate_customer`,
`to_generate_receivable`,
`to_generate_invoice`,
`origin_system`,
`operation`,
`minifactu_id`,
`conciliator_id`,
`fin_id`,
`front_id`,
`erp_invoice_customer_send_to_erp_at`,
`erp_invoice_customer_returned_from_erp_at`,
`erp_invoice_customer_status_transaction`,
`erp_invoice_customer_log`,
`erp_receivable_sent_to_erp_at`,
`erp_receivable_returned_from_erp_at`,
`erp_receivable_customer_identification`,
`erp_receivable_status_transaction`,
`erp_receivable_log`,
`erp_invoice_send_to_erp_at`,
`erp_invoice_returned_from_erp_at`,
`erp_invoice_status_transaction`,
`erp_invoice_log`,
`erp_receipt_send_to_erp_at`,
`erp_receipt_returned_from_erp_at`,
`erp_receipt_status_transaction`,
`erp_receipt_log`)
values
('Brazil', -- country
'1', -- unity_identification
null, -- erp_business_unit
null, -- erp_legal_entity
null, -- erp_subsidiary
null, -- to_generate_customer
null, -- to_generate_receivable
null, -- to_generate_invoice
'smartsystem', -- origin_system
'person_plan', -- operation
7, -- minifactu_id
'hdjude123', -- conciliator_id
10, -- fin_id
91334244, -- front_id
null, -- erp_invoice_customer_send_to_erp_at
null, -- erp_invoice_customer_returned_from_erp_at
'waiting_to_be_process', -- erp_invoice_customer_status_transaction
null, -- erp_invoice_customer_log
null, -- erp_receivable_sent_to_erp_at
null, -- erp_receivable_returned_from_erp_at
'01027058000191', -- erp_receivable_customer_identification
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
order_to_cash.acronym = organization_from_to_version.acronym,
order_to_cash.to_generate_customer = organization_from_to_version.to_generate_customer,
order_to_cash.to_generate_receivable = organization_from_to_version.to_generate_receivable,
order_to_cash.to_generate_invoice = organization_from_to_version.to_generate_invoice

where order_to_cash.id = @order_to_cash_id;

-- create the invoice_customer 
insert into `oic_db`.`invoice_customer`
(`order_to_cash_id`,
`erp_customer_id`,
`full_name`,
`type_person`,
`identification_financial_responsible`,
`nationality_code`,
`state`,
`city`,
`adress`,
`adress_number`,
`adress_complement`,
`district`,
`postal_code`,
`area_code`,
`cellphone`,
`email`,
`state_registration`,
`federal_registration`,
`final_consumer`,
`icms_contributor`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_customer_id
'Jesus da Silva', -- full_name
'natural_person', -- type_person
'14648540093', -- identification_financial_responsible
'BR', -- nationality_code
'SP', -- state
'São Paulo', -- city
'Xpto', -- adress
9876, -- adress_number
null, -- adress_complement
'Itaim Bibi', -- district
'04209002', -- postal_code
'11', -- area_code
'970718989', -- cellphone
'felipe.nambara@bioritmo.com.br', -- email
null, -- state_registration
null, -- federal_registration
'yes', -- final_consumer
'no', -- icms_contributor
null, -- erp_filename
null); -- erp_line_in_file

-- create the receivable
insert into `oic_db`.`receivable`
(`order_to_cash_id`,
`erp_receivable_id`,
`erp_receivable_customer_id`,
`erp_clustered_receivable_id`,
`erp_clustered_receivable_customer_id`,
`is_smartfin`,
`transaction_type`,
`contract_number`,
`credit_card_brand`,
`truncated_credit_card`,
`current_credit_card_installment`,
`total_credit_card_installment`,
`nsu`,
`conciliator_id`,
`authorization_code`,
`price_list_value`,
`gross_value`,
`net_value`,
`interest_value`,
`administration_tax_percentage`,
`administration_tax_value`,
`antecipation_tax_percentage`,
`antecipation_tax_value`,
`billing_date`,
`credit_date`,
`conciliator_filename`,
`acquirer_bank_filename`,
`registration_gym_student`,
`fullname_gym_student`,
`identification_gym_student`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_receivable_id
null, -- erp_receivable_customer_id
null, -- erp_clustered_receivable_id
null, -- erp_clustered_receivable_customer_id
'no', -- is_smartfin
'credit_card_recurring', -- transaction_type
'1288329736', -- contract_number
'mastercard', -- credit_card_brand
'2154****2992', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'3278628275', -- nsu
'hdjude123', -- conciliator_id
null, -- authorization_code
329.0, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
0.0, -- interest_value
3.1, -- administration_tax_percentage
3.4038, -- administration_tax_value
0.0, -- antecipation_tax_percentage
0.0, -- antecipation_tax_value
20191018, -- billing_date
20191118, -- credit_date
null, -- conciliator_filename
null, -- acquirer_bank_filename
'12321355', -- registration_gym_student
'João da Silva', -- fullname_gym_student
'80873516060', -- identification_gym_student
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from receivable table
set @receivable_id = last_insert_id();

-- updates the erp_products fields from invoice_items table. Note that the last version from product_from_to_version must be always considered
update receivable 

inner join order_to_cash 
on order_to_cash.id = receivable.order_to_cash_id

inner join clustered_receivable_customer
on clustered_receivable_customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_clustered_receivable_customer_id = clustered_receivable_customer.erp_customer_id,
receivable.erp_receivable_customer_id = clustered_receivable_customer.erp_customer_id

where receivable.id = @receivable_id;

-- create the invoice
insert into `oic_db`.`invoice`
(`order_to_cash_id`,
`erp_invoice_customer_id`,
`transaction_type`,
`is_overdue_recovery`,
`fiscal_id`,
`fiscal_series`,
`fiscal_authentication_code`,
`fiscal_model`,
`fiscal_authorization_datetime`,
`erp_filename`,
`erp_line_in_file`)
values
(@order_to_cash_id, -- order_to_cash_id
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

-- saves the auto increment id from invoice table
set @invoice_id = last_insert_id();

-- create the invoice_items
insert into `oic_db`.`invoice_items`
(`id_invoice`,
`front_product_id`,
`front_plan_id`,
`front_addon_id`,
`erp_item_ar_id`,
`erp_gl_segment_product`,
`quantity`,
`sale_price`,
`list_price`,
`erp_filename`,
`erp_line_in_file`)
values
(@invoice_id, -- id_invoice
120366453, -- front_product_id
1, -- front_plan_id
null, -- front_addon_id
null, -- erp_item_ar_id
null, -- erp_gl_segment_product
1, -- quantity
49.90, -- sale_price
89.90, -- list_price
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from invoice_items table
set @invoice_id_item = last_insert_id();

-- updates the erp_products fields from invoice_items table. Note that the last version from product_from_to_version must be always considered

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

inner join plan_from_to 
on plan_from_to.front_plan_id = invoice_items.front_plan_id
and plan_from_to.origin_system = order_to_cash.origin_system

inner join plan_from_to_version
on plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- create the invoice_items
insert into `oic_db`.`invoice_items`
(`id_invoice`,
`front_product_id`,
`front_plan_id`,
`front_addon_id`,
`erp_item_ar_id`,
`erp_gl_segment_product`,
`quantity`,
`sale_price`,
`list_price`,
`erp_filename`,
`erp_line_in_file`)
values
(@invoice_id, -- id_invoice
120366453, -- front_product_id
1, -- front_plan_id
null, -- front_addon_id
null, -- erp_item_ar_id
null, -- erp_gl_segment_product
1, -- quantity
59.90, -- sale_price
89.90, -- list_price
null, -- erp_filename
null); -- erp_line_in_file

-- saves the auto increment id from invoice_items table
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

inner join plan_from_to 
on plan_from_to.front_plan_id = invoice_items.front_plan_id
and plan_from_to.origin_system = order_to_cash.origin_system

inner join plan_from_to_version
on plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;


INSERT INTO `oic_db`.`refund`
(`country`,
`unity_identification`,
`erp_business_unit`,
`erp_legal_entity`,
`erp_subsidiary`,
`acronym`,
`erp_refund_status_transaction`,
`erp_refund_sent_to_erp_at`,
`erp_refund_returned_from_erp_at`,
`erp_refund_log`,
`refund_requester_name`,
`refund_requester_identification`,
`issue_date`,
`due_date`,
`erp_refund_id`,
`front_refund_id`,
`refund_value`,
`bank_number`,
`bank_branch`,
`bank_branch_digit`,
`bank_account_number`,
`bank_account_number_digit`,
`bank_account_owner_name`,
`bank_account_owner_identification`)
VALUES
('Brazil',-- country
1, -- unity_identification
'BR01 - SMARTFIT', -- erp_business_unit
'07594978000178', -- erp_legal_entity
'BR010001', -- erp_subsidiary
'SPCMOR3', -- acronym
'waiting_to_be_process', -- erp_refund_status_transaction
null, -- erp_refund_sent_to_erp_at
null, -- erp_refund_returned_from_erp_at
null, -- erp_refund_log
'Felipe Volcov Nambara', -- refund_requester_name
'39367233892', -- refund_requester_identification
'2019-11-19', -- issue_date
'2019-11-20', -- due_date
null, -- erp_refund_id
1546, -- front_refund_id
150.85, -- refund_value
'341', -- bank_number
'3150', -- bank_branch
'1', -- bank_branch_digit
'11542', -- bank_account_number
'0', -- bank_account_number_digit
'Felipe Volcov Nambara', -- bank_account_owner_name
'39367233892'); -- bank_account_owner_identification

INSERT INTO `oic_db`.`refund_items`
(`refund_id`,
`front_id`,
`refund_item_value`,
`billing_date`)
VALUES
(1546, -- refund_id
99877897, -- front_id
75.425, -- refund_item_value
'2019-01-10'); -- billing_date

INSERT INTO `oic_db`.`refund_items`
(`refund_id`, -- refund_id
`front_id`, -- front_id
`refund_item_value`, -- refund_item_value
`billing_date`) -- billing_date
VALUES
(1546,
91237897,
75.425,
'2019-02-10');


INSERT INTO `oic_db`.`chargeback`
(`country`,-- Criar uma integração para cada país. No caso do Brasil será um job para a conciliadora Concil
`erp_clustered_chargeback_id`, -- Id do aglutinado de chargeback
`erp_receipt_id`, -- Id único e imutável do receipt no Oracle
`erp_receipt_status_transaction`, -- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
`erp_receipt_sent_to_erp_at`, -- TimeStamp de quando o registro foi enviado para o Oracle
`erp_receipt_returned_from_erp_at`, -- TimeStamp de quando o registro retornou do Oracle
`erp_receivable_log`,-- Este campo deverá ser preenchido no retorno do Oracle
`front_status_transaction`,-- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
`front_sent_to_front_at`, -- TimeStamp de quando o registro foi enviado para o Front
`front_returned_from_front_at`, -- TimeStamp de quando o registro retornou do Front
`front_log`, -- Este campo deverá ser preenchido no retorno do Front
`chargeback_acquirer_label`, -- Utilizar a coluna ADQUIRENTE do arquivo de retorno da Concil
`conciliator_id`, -- Utilizar a coluna COD_ERP do arquivo de retorno da Concil
`concitiation_type`, -- Utilizar a coluna TIPO_LANCAMENTO do arquivo de retorno da Concil - ao ler o arquivo para ser gravado nessa tabela considerar somente o tipo CHBK
`conciliation_description`, -- Utilizar a coluna DESCRICAO do arquivo de retorno da Concil 
`transaction_type`, -- Utilizar a coluna TIPO_TRANSACAO do arquivo de retorno da Concil - converter CREDITO para credit_card e DEBITO para debit_card
`contract_number`,-- Utilizar a coluna ESTABELECIMENTO do arquivo de retorno da Concil 
`credit_card_brand`, -- Utilizar a coluna BANDEIRA do arquivo de retorno da Concil - converter os valores AMEX para americanexpress, MASTERCARD para mastercard, HIPERCARD para hipercard, ELO para elo, VISA para visa e DINERS para diners
`truncated_credit_card`, -- Utilizar a coluna MASC_CARTAO do arquivo de retorno da Concil
`current_credit_card_installment`, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Left(NRO_PARCELA,2)
`total_credit_card_installment`, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Right(NRO_PARCELA,2)
`nsu`, -- Utilizar a coluna NSU do arquivo de retorno da Concil 
`authorization_code`, -- Utilizar a coluna AUTORIZACAO do arquivo de retorno da Concil 
`payment_lot`, -- Utilizar a coluna NR_RO do arquivo de retorno da Concil 
`price_list_value`, -- Desconsiderar
`gross_value`, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`net_value`, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`interest_value`,-- Desconsiderar
`administration_tax_percentage`,-- Utilizar a coluna TAXA/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`administration_tax_value`, -- Utilizar a coluna TAXA do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`antecipation_tax_percentage`,-- Utilizar a coluna VLR_DESC_ANTECIP/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`antecipation_tax_value`,-- Utilizar a coluna VLR_DESC_ANTECIP do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`billing_date`, -- Utilizar a coluna DT_VENDA do arquivo de retorno da Concil 
`credit_date`, -- Utilizar a coluna DT_PAGAMENTO do arquivo de retorno da Concil 
`bank_number`, -- Utilizar a coluna NRO_BANCO do arquivo de retorno da Concil 
`bank_branch`, -- Utilizar a coluna NRO_AGENCIA do arquivo de retorno da Concil 
`bank_account`, -- Utilizar a coluna NRO_CONTA do arquivo de retorno da Concil 
`conciliator_filename`, -- Aqui deve ser gravado o nome do arquivo lido
`acquirer_bank_filename`) -- Utilizar a coluna NOME_ARQUIVO do arquivo de retorno da Concil 
VALUES
('Brazil', -- country
null, -- erp_clustered_chargeback_id
null, -- erp_receipt_id
'waiting_to_be_process', -- erp_receipt_status_transaction
null, -- erp_receipt_sent_to_erp_at
null, -- erp_receipt_returned_from_erp_at
null, -- erp_receivable_log
'waiting_to_be_process', -- front_status_transaction
null, -- front_sent_to_front_at
null, -- front_returned_from_front_at
null, -- front_log
'CIELO', -- chargeback_acquirer_label
'abc123', -- conciliator_id
'CHBK', -- concitiation_type
'CANCELAMENTO EFETUADO PELO PORTADOR', -- conciliation_description
'credit_card', -- transaction_type
'1288329736', -- contract_number
'mastercard', -- credit_card_brand
'1232****8872', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'883765246', -- nsu
null, -- authorization_code
'332412', -- payment_lot
290.9, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
0, -- interest_value
3.1, -- administration_tax_percentage
34.038, -- administration_tax_value
0, -- antecipation_tax_percentage
0, -- antecipation_tax_value
'2019-11-17', -- billing_date
'2019-11-29', -- credit_date
'341', -- bank_number
'1123', -- bank_branch
'77662537', -- bank_account
null, -- conciliator_filename
null); -- acquirer_bank_filename


INSERT INTO `oic_db`.`chargeback`
(`country`,-- Criar uma integração para cada país. No caso do Brasil será um job para a conciliadora Concil
`erp_clustered_chargeback_id`, -- Id do aglutinado de chargeback
`erp_receipt_id`, -- Id único e imutável do receipt no Oracle
`erp_receipt_status_transaction`, -- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
`erp_receipt_sent_to_erp_at`, -- TimeStamp de quando o registro foi enviado para o Oracle
`erp_receipt_returned_from_erp_at`, -- TimeStamp de quando o registro retornou do Oracle
`erp_receivable_log`,-- Este campo deverá ser preenchido no retorno do Oracle
`front_status_transaction`,-- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
`front_sent_to_front_at`, -- TimeStamp de quando o registro foi enviado para o Front
`front_returned_from_front_at`, -- TimeStamp de quando o registro retornou do Front
`front_log`, -- Este campo deverá ser preenchido no retorno do Front
`chargeback_acquirer_label`, -- Utilizar a coluna ADQUIRENTE do arquivo de retorno da Concil
`conciliator_id`, -- Utilizar a coluna COD_ERP do arquivo de retorno da Concil
`concitiation_type`, -- Utilizar a coluna TIPO_LANCAMENTO do arquivo de retorno da Concil - ao ler o arquivo para ser gravado nessa tabela considerar somente o tipo CHBK
`conciliation_description`, -- Utilizar a coluna DESCRICAO do arquivo de retorno da Concil 
`transaction_type`, -- Utilizar a coluna TIPO_TRANSACAO do arquivo de retorno da Concil - converter CREDITO para credit_card e DEBITO para debit_card
`contract_number`,-- Utilizar a coluna ESTABELECIMENTO do arquivo de retorno da Concil 
`credit_card_brand`, -- Utilizar a coluna BANDEIRA do arquivo de retorno da Concil - converter os valores AMEX para americanexpress, MASTERCARD para mastercard, HIPERCARD para hipercard, ELO para elo, VISA para visa e DINERS para diners
`truncated_credit_card`, -- Utilizar a coluna MASC_CARTAO do arquivo de retorno da Concil
`current_credit_card_installment`, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Left(NRO_PARCELA,2)
`total_credit_card_installment`, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Right(NRO_PARCELA,2)
`nsu`, -- Utilizar a coluna NSU do arquivo de retorno da Concil 
`authorization_code`, -- Utilizar a coluna AUTORIZACAO do arquivo de retorno da Concil 
`payment_lot`, -- Utilizar a coluna NR_RO do arquivo de retorno da Concil 
`price_list_value`, -- Desconsiderar
`gross_value`, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`net_value`, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`interest_value`,-- Desconsiderar
`administration_tax_percentage`,-- Utilizar a coluna TAXA/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`administration_tax_value`, -- Utilizar a coluna TAXA do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`antecipation_tax_percentage`,-- Utilizar a coluna VLR_DESC_ANTECIP/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`antecipation_tax_value`,-- Utilizar a coluna VLR_DESC_ANTECIP do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`billing_date`, -- Utilizar a coluna DT_VENDA do arquivo de retorno da Concil 
`credit_date`, -- Utilizar a coluna DT_PAGAMENTO do arquivo de retorno da Concil 
`bank_number`, -- Utilizar a coluna NRO_BANCO do arquivo de retorno da Concil 
`bank_branch`, -- Utilizar a coluna NRO_AGENCIA do arquivo de retorno da Concil 
`bank_account`, -- Utilizar a coluna NRO_CONTA do arquivo de retorno da Concil 
`conciliator_filename`, -- Aqui deve ser gravado o nome do arquivo lido
`acquirer_bank_filename`) -- Utilizar a coluna NOME_ARQUIVO do arquivo de retorno da Concil 
VALUES
('Brazil', -- country
null, -- erp_clustered_chargeback_id
null, -- erp_receipt_id
'waiting_to_be_process', -- erp_receipt_status_transaction
null, -- erp_receipt_sent_to_erp_at
null, -- erp_receipt_returned_from_erp_at
null, -- erp_receivable_log
'waiting_to_be_process', -- front_status_transaction
null, -- front_sent_to_front_at
null, -- front_returned_from_front_at
null, -- front_log
'CIELO', -- chargeback_acquirer_label
'hdjuhs123', -- conciliator_id
'CHBK', -- concitiation_type
'CANCELAMENTO EFETUADO PELO PORTADOR', -- conciliation_description
'credit_card', -- transaction_type
'1288329736', -- contract_number
'mastercard', -- credit_card_brand
'2134****2993', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'3276518275', -- nsu
null, -- authorization_code
'332412', -- payment_lot
290.9, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
0, -- interest_value
3.1, -- administration_tax_percentage
34.038, -- administration_tax_value
0, -- antecipation_tax_percentage
0, -- antecipation_tax_value
'2019-11-17', -- billing_date
'2019-11-29', -- credit_date
'341', -- bank_number
'1123', -- bank_branch
'77662537', -- bank_account
null, -- conciliator_filename
null); -- acquirer_bank_filename

INSERT INTO `oic_db`.`chargeback`
(`country`,-- Criar uma integração para cada país. No caso do Brasil será um job para a conciliadora Concil
`erp_clustered_chargeback_id`, -- Id do aglutinado de chargeback
`erp_receipt_id`, -- Id único e imutável do receipt no Oracle
`erp_receipt_status_transaction`, -- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
`erp_receipt_sent_to_erp_at`, -- TimeStamp de quando o registro foi enviado para o Oracle
`erp_receipt_returned_from_erp_at`, -- TimeStamp de quando o registro retornou do Oracle
`erp_receivable_log`,-- Este campo deverá ser preenchido no retorno do Oracle
`front_status_transaction`,-- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
`front_sent_to_front_at`, -- TimeStamp de quando o registro foi enviado para o Front
`front_returned_from_front_at`, -- TimeStamp de quando o registro retornou do Front
`front_log`, -- Este campo deverá ser preenchido no retorno do Front
`chargeback_acquirer_label`, -- Utilizar a coluna ADQUIRENTE do arquivo de retorno da Concil
`conciliator_id`, -- Utilizar a coluna COD_ERP do arquivo de retorno da Concil
`concitiation_type`, -- Utilizar a coluna TIPO_LANCAMENTO do arquivo de retorno da Concil - ao ler o arquivo para ser gravado nessa tabela considerar somente o tipo CHBK
`conciliation_description`, -- Utilizar a coluna DESCRICAO do arquivo de retorno da Concil 
`transaction_type`, -- Utilizar a coluna TIPO_TRANSACAO do arquivo de retorno da Concil - converter CREDITO para credit_card e DEBITO para debit_card
`contract_number`,-- Utilizar a coluna ESTABELECIMENTO do arquivo de retorno da Concil 
`credit_card_brand`, -- Utilizar a coluna BANDEIRA do arquivo de retorno da Concil - converter os valores AMEX para americanexpress, MASTERCARD para mastercard, HIPERCARD para hipercard, ELO para elo, VISA para visa e DINERS para diners
`truncated_credit_card`, -- Utilizar a coluna MASC_CARTAO do arquivo de retorno da Concil
`current_credit_card_installment`, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Left(NRO_PARCELA,2)
`total_credit_card_installment`, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Right(NRO_PARCELA,2)
`nsu`, -- Utilizar a coluna NSU do arquivo de retorno da Concil 
`authorization_code`, -- Utilizar a coluna AUTORIZACAO do arquivo de retorno da Concil 
`payment_lot`, -- Utilizar a coluna NR_RO do arquivo de retorno da Concil 
`price_list_value`, -- Desconsiderar
`gross_value`, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`net_value`, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`interest_value`,-- Desconsiderar
`administration_tax_percentage`,-- Utilizar a coluna TAXA/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`administration_tax_value`, -- Utilizar a coluna TAXA do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`antecipation_tax_percentage`,-- Utilizar a coluna VLR_DESC_ANTECIP/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`antecipation_tax_value`,-- Utilizar a coluna VLR_DESC_ANTECIP do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`billing_date`, -- Utilizar a coluna DT_VENDA do arquivo de retorno da Concil 
`credit_date`, -- Utilizar a coluna DT_PAGAMENTO do arquivo de retorno da Concil 
`bank_number`, -- Utilizar a coluna NRO_BANCO do arquivo de retorno da Concil 
`bank_branch`, -- Utilizar a coluna NRO_AGENCIA do arquivo de retorno da Concil 
`bank_account`, -- Utilizar a coluna NRO_CONTA do arquivo de retorno da Concil 
`conciliator_filename`, -- Aqui deve ser gravado o nome do arquivo lido
`acquirer_bank_filename`) -- Utilizar a coluna NOME_ARQUIVO do arquivo de retorno da Concil 
VALUES
('Brazil', -- country
null, -- erp_clustered_chargeback_id
null, -- erp_receipt_id
'waiting_to_be_process', -- erp_receipt_status_transaction
null, -- erp_receipt_sent_to_erp_at
null, -- erp_receipt_returned_from_erp_at
null, -- erp_receivable_log
'waiting_to_be_process', -- front_status_transaction
null, -- front_sent_to_front_at
null, -- front_returned_from_front_at
null, -- front_log
'CIELO', -- chargeback_acquirer_label
'hdjude123', -- conciliator_id
'CHBK', -- concitiation_type
'CANCELAMENTO EFETUADO PELO PORTADOR', -- conciliation_description
'credit_card', -- transaction_type
'1288329736', -- contract_number
'mastercard', -- credit_card_brand
'2154****2992', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'3278628275', -- nsu
null, -- authorization_code
'332412', -- payment_lot
329, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
0, -- interest_value
3.1, -- administration_tax_percentage
34.038, -- administration_tax_value
0, -- antecipation_tax_percentage
0, -- antecipation_tax_value
'2019-11-17', -- billing_date
'2019-11-29', -- credit_date
'341', -- bank_number
'1123', -- bank_branch
'77662537', -- bank_account
null, -- conciliator_filename
null); -- acquirer_bank_filename

INSERT INTO `oic_db`.`conciliated_payed_receivable`
(`country`, -- Criar uma integração para cada país. No caso do Brasil será um job para a conciliadora Concil
`erp_receipt_id`, -- Id único e imutável do receipt no Oracle
`erp_receipt_status_transaction`, -- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
`erp_receipt_sent_to_erp_at`, -- TimeStamp de quando o registro foi enviado para o Oracle
`erp_receipt_returned_from_erp_at`, -- TimeStamp de quando o registro retornou do Oracle
`erp_receipt_log`, -- Este campo deverá ser preenchido no retorno do Oracle
`erp_receivable_customer_id`, -- Desconsiderar
`conciliator_id`, -- Utilizar a coluna COD_ERP do arquivo de retorno da Concil
`concitiation_type`, -- Utilizar a coluna TIPO_LANCAMENTO do arquivo de retorno da Concil - ao ler o arquivo para ser gravado nessa tabela considerar somente o tipo PCV
`conciliation_description`, -- Utilizar a coluna DESCRICAO do arquivo de retorno da Concil 
`transaction_type`, -- Utilizar a coluna TIPO_TRANSACAO do arquivo de retorno da Concil - converter CREDITO para credit_card e DEBITO para debit_card
`contract_number`, -- Utilizar a coluna ESTABELECIMENTO do arquivo de retorno da Concil 
`credit_card_brand`, -- Utilizar a coluna BANDEIRA do arquivo de retorno da Concil - converter os valores AMEX para americanexpress, MASTERCARD para mastercard, HIPERCARD para hipercard, ELO para elo, VISA para visa e DINERS para diners
`truncated_credit_card`, -- Utilizar a coluna MASC_CARTAO do arquivo de retorno da Concil
`current_credit_card_installment`, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Left(NRO_PARCELA,2)
`total_credit_card_installment`, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Right(NRO_PARCELA,2)
`nsu`, -- Utilizar a coluna NSU do arquivo de retorno da Concil 
`authorization_code`, -- Utilizar a coluna AUTORIZACAO do arquivo de retorno da Concil 
`payment_lot`, -- Utilizar a coluna NR_RO do arquivo de retorno da Concil 
`price_list_value`, -- Desconsiderar
`gross_value`, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`net_value`, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`interest_value`, -- Desconsiderar
`administration_tax_percentage`, -- Utilizar a coluna TAXA/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`administration_tax_value`, -- Utilizar a coluna TAXA do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`antecipation_tax_percentage`, -- Utilizar a coluna VLR_DESC_ANTECIP/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`antecipation_tax_value`,-- Utilizar a coluna VLR_DESC_ANTECIP do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`billing_date`, -- Utilizar a coluna DT_VENDA do arquivo de retorno da Concil 
`credit_date`, -- Utilizar a coluna DT_PAGAMENTO do arquivo de retorno da Concil 
`bank_number`, -- Utilizar a coluna NRO_BANCO do arquivo de retorno da Concil 
`bank_branch`, -- Utilizar a coluna NRO_AGENCIA do arquivo de retorno da Concil 
`bank_account`, -- Utilizar a coluna NRO_CONTA do arquivo de retorno da Concil 
`conciliator_filename`, -- Aqui deve ser gravado o nome do arquivo lido
`acquirer_bank_filename`) -- Utilizar a coluna NOME_ARQUIVO do arquivo de retorno da Concil 
VALUES
('Brazil', -- country
null, -- erp_receipt_id
'waiting_to_be_process', -- erp_receipt_status_transaction
null, -- erp_receipt_sent_to_erp_at
null, -- erp_receipt_returned_from_erp_at
null, -- erp_receivable_log
null, -- erp_receivable_customer_id
'abc123', -- conciliator_id
'PCV', -- concitiation_type
'COMPROVANTE', -- conciliation_description
'credit_card', -- transaction_type
'1288329736', -- contract_number
'mastercard', -- credit_card_brand
'1232****8872', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'883765246', -- nsu
null, -- authorization_code
'332412', -- payment_lot
290.90, -- price_list_value
109.80, -- gross_value
109.80, -- net_value
0, -- interest_value
3.1, -- administration_tax_percentage
34.038, -- administration_tax_value
0, -- antecipation_tax_percentage
0, -- antecipation_tax_value
'2019-10-17', -- billing_date
'2019-11-17', -- credit_date
'341', -- bank_number
'1123', -- bank_branch
'77662537', -- bank_account
null, -- conciliator_filename
null); -- acquirer_bank_filename

INSERT INTO `oic_db`.`conciliated_payed_receivable`
(`country`,
`erp_receipt_id`,
`erp_receipt_status_transaction`,
`erp_receipt_sent_to_erp_at`,
`erp_receipt_returned_from_erp_at`,
`erp_receipt_log`,
`erp_receivable_customer_id`,
`conciliator_id`,
`concitiation_type`,
`conciliation_description`,
`transaction_type`,
`contract_number`,
`credit_card_brand`,
`truncated_credit_card`,
`current_credit_card_installment`,
`total_credit_card_installment`,
`nsu`,
`authorization_code`,
`payment_lot`,
`price_list_value`,
`gross_value`,
`net_value`,
`interest_value`,
`administration_tax_percentage`,
`administration_tax_value`,
`antecipation_tax_percentage`, 
`antecipation_tax_value`,
`billing_date`,
`credit_date`,
`bank_number`,
`bank_branch`,
`bank_account`,
`conciliator_filename`,
`acquirer_bank_filename`)
VALUES
('Brazil', -- country
null, -- erp_receipt_id
'waiting_to_be_process', -- erp_receipt_status_transaction
null, -- erp_receipt_sent_to_erp_at
null, -- erp_receipt_returned_from_erp_at
null, -- erp_receivable_log
null, -- erp_receivable_customer_id
'hdjuhs123', -- conciliator_id
'PCV', -- concitiation_type
'COMPROVANTE', -- conciliation_description
'credit_card', -- transaction_type
'1288329736', -- contract_number
'mastercard', -- credit_card_brand
'2134****2993', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'3276518275', -- nsu
null, -- authorization_code
'332412', -- payment_lot
290.80, -- price_list_value
109.80, -- gross_value
109.80, -- net_value
0, -- interest_value
3.1, -- administration_tax_percentage
34.038, -- administration_tax_value
0, -- antecipation_tax_percentage
0, -- antecipation_tax_value
'2019-10-18', -- billing_date
'2019-11-18', -- credit_date
'341', -- bank_number
'1123', -- bank_branch
'77662537', -- bank_account
null, -- conciliator_filename
null); -- acquirer_bank_filename


INSERT INTO `oic_db`.`conciliated_payed_receivable`
(`country`,
`erp_receipt_id`,
`erp_receipt_status_transaction`,
`erp_receipt_sent_to_erp_at`,
`erp_receipt_returned_from_erp_at`,
`erp_receipt_log`,
`erp_receivable_customer_id`,
`conciliator_id`,
`concitiation_type`,
`conciliation_description`,
`transaction_type`,
`contract_number`,
`credit_card_brand`,
`truncated_credit_card`,
`current_credit_card_installment`,
`total_credit_card_installment`,
`nsu`,
`authorization_code`,
`payment_lot`,
`price_list_value`,
`gross_value`,
`net_value`,
`interest_value`,
`administration_tax_percentage`,
`administration_tax_value`,
`antecipation_tax_percentage`, 
`antecipation_tax_value`,
`billing_date`,
`credit_date`,
`bank_number`,
`bank_branch`,
`bank_account`,
`conciliator_filename`,
`acquirer_bank_filename`)
VALUES
('Brazil', -- country
null, -- erp_receipt_id
'waiting_to_be_process', -- erp_receipt_status_transaction
null, -- erp_receipt_sent_to_erp_at
null, -- erp_receipt_returned_from_erp_at
null, -- erp_receivable_log
null, -- erp_receivable_customer_id
'hdjude123', -- conciliator_id
'PCV', -- concitiation_type
'COMPROVANTE', -- conciliation_description
'credit_card', -- transaction_type
'1288329736', -- contract_number
'mastercard', -- credit_card_brand
'2154****2992', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'3278628275', -- nsu
null, -- authorization_code
'332412', -- payment_lot
329.00, -- price_list_value
109.80, -- gross_value
109.80, -- net_value
0, -- interest_value
3.1, -- administration_tax_percentage
34.038, -- administration_tax_value
0, -- antecipation_tax_percentage
0, -- antecipation_tax_value
'2019-10-18', -- billing_date
'2019-11-18', -- credit_date
'341', -- bank_number
'1123', -- bank_branch
'77662537', -- bank_account
null, -- conciliator_filename
null); -- acquirer_bank_filename
