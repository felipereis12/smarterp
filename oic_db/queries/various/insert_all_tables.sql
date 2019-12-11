start transaction;
set sql_mode = traditional;

-- { example: Brazil, smartfit, person_plan, credit_card } =========================================================================================================================================
-- create the order_to_cash header moviment
insert into order_to_cash
(country,
unity_identification,
erp_business_unit,
erp_legal_entity,
erp_subsidiary,
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
(@order_to_cash_id, -- order_to_cash_id
'Brazil', -- country
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
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_receivable_id
null, -- erp_receivable_customer_id
null, -- erp_clustered_receivable_id
null, -- erp_clustered_receivable_customer_id
'yes', -- is_smartfin
'credit_card_recurring', -- transaction_type
'1288329736', -- contract_number
'MASTER', -- credit_card_brand
'1232****8872', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'883765246', -- nsu
'abc123', -- conciliator_id
null, -- authorization_code
290.9, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
1.5, -- interest_value
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

inner join customer
on customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_clustered_receivable_customer_id = customer.erp_customer_id,
receivable.erp_receivable_customer_id = customer.erp_customer_id

where receivable.id = @receivable_id;

-- create the invoice
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
on plan_from_to.country = order_to_cash.country
and plan_from_to.origin_system = order_to_cash.origin_system
and plan_from_to.operation = order_to_cash.operation
and plan_from_to.front_plan_id = invoice_items.front_plan_id

inner join plan_from_to_version
on plan_from_to_version.country = plan_from_to.country
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.plan_from_to_operation = plan_from_to.operation
and plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.country = plan_from_to_version.country
                                                and plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_operation = plan_from_to_version.plan_from_to_operation
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- create the invoice_items
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
on plan_from_to.country = order_to_cash.country
and plan_from_to.origin_system = order_to_cash.origin_system
and plan_from_to.operation = order_to_cash.operation
and plan_from_to.front_plan_id = invoice_items.front_plan_id

inner join plan_from_to_version
on plan_from_to_version.country = plan_from_to.country
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.plan_from_to_operation = plan_from_to.operation
and plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.country = plan_from_to_version.country
                                                and plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_operation = plan_from_to_version.plan_from_to_operation
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- { example: Brazil, smartfit, person_plan, debit_account } =========================================================================================================================================
-- create the order_to_cash header moviment
insert into order_to_cash
(country,
unity_identification,
erp_business_unit,
erp_legal_entity,
erp_subsidiary,
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
(@order_to_cash_id, -- order_to_cash_id
'Brazil', -- country
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

inner join customer
on customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_clustered_receivable_customer_id = customer.erp_customer_id,
receivable.erp_receivable_customer_id = customer.erp_customer_id

where receivable.id = @receivable_id;

-- create the invoice
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
on plan_from_to.country = order_to_cash.country
and plan_from_to.origin_system = order_to_cash.origin_system
and plan_from_to.operation = order_to_cash.operation
and plan_from_to.front_plan_id = invoice_items.front_plan_id

inner join plan_from_to_version
on plan_from_to_version.country = plan_from_to.country
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.plan_from_to_operation = plan_from_to.operation
and plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.country = plan_from_to_version.country
                                                and plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_operation = plan_from_to_version.plan_from_to_operation
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- create the invoice_items
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
on plan_from_to.country = order_to_cash.country
and plan_from_to.origin_system = order_to_cash.origin_system
and plan_from_to.operation = order_to_cash.operation
and plan_from_to.front_plan_id = invoice_items.front_plan_id

inner join plan_from_to_version
on plan_from_to_version.country = plan_from_to.country
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.plan_from_to_operation = plan_from_to.operation
and plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.country = plan_from_to_version.country
                                                and plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_operation = plan_from_to_version.plan_from_to_operation
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- { example: Brazil, smartfit, person_plan, credit_card } =========================================================================================================================================
-- create the order_to_cash header moviment
insert into order_to_cash
(country,
unity_identification,
erp_business_unit,
erp_legal_entity,
erp_subsidiary,
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
(@order_to_cash_id, -- order_to_cash_id
'Brazil', -- country
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
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_receivable_id
null, -- erp_receivable_customer_id
null, -- erp_clustered_receivable_id
null, -- erp_clustered_receivable_customer_id
'no', -- is_smartfin
'credit_card_recurring', -- transaction_type
'1288329736', -- contract_number
'MASTER', -- credit_card_brand
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

inner join customer
on customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_clustered_receivable_customer_id = customer.erp_customer_id,
receivable.erp_receivable_customer_id = customer.erp_customer_id

where receivable.id = @receivable_id;

-- create the invoice
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
on plan_from_to.country = order_to_cash.country
and plan_from_to.origin_system = order_to_cash.origin_system
and plan_from_to.operation = order_to_cash.operation
and plan_from_to.front_plan_id = invoice_items.front_plan_id

inner join plan_from_to_version
on plan_from_to_version.country = plan_from_to.country
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.plan_from_to_operation = plan_from_to.operation
and plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.country = plan_from_to_version.country
                                                and plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_operation = plan_from_to_version.plan_from_to_operation
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- create the invoice_items
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
on plan_from_to.country = order_to_cash.country
and plan_from_to.origin_system = order_to_cash.origin_system
and plan_from_to.operation = order_to_cash.operation
and plan_from_to.front_plan_id = invoice_items.front_plan_id

inner join plan_from_to_version
on plan_from_to_version.country = plan_from_to.country
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.plan_from_to_operation = plan_from_to.operation
and plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.country = plan_from_to_version.country
                                                and plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_operation = plan_from_to_version.plan_from_to_operation
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- { example: Brazil, smartfit, person_plan, debit_account } =========================================================================================================================================
-- create the order_to_cash header moviment
insert into order_to_cash
(country,
unity_identification,
erp_business_unit,
erp_legal_entity,
erp_subsidiary,
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
(@order_to_cash_id, -- order_to_cash_id
'Brazil', -- country
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

inner join customer
on customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_clustered_receivable_customer_id = customer.erp_customer_id,
receivable.erp_receivable_customer_id = customer.erp_customer_id

where receivable.id = @receivable_id;

-- create the invoice
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
on plan_from_to.country = order_to_cash.country
and plan_from_to.origin_system = order_to_cash.origin_system
and plan_from_to.operation = order_to_cash.operation
and plan_from_to.front_plan_id = invoice_items.front_plan_id

inner join plan_from_to_version
on plan_from_to_version.country = plan_from_to.country
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.plan_from_to_operation = plan_from_to.operation
and plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.country = plan_from_to_version.country
                                                and plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_operation = plan_from_to_version.plan_from_to_operation
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- create the invoice_items
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
on plan_from_to.country = order_to_cash.country
and plan_from_to.origin_system = order_to_cash.origin_system
and plan_from_to.operation = order_to_cash.operation
and plan_from_to.front_plan_id = invoice_items.front_plan_id

inner join plan_from_to_version
on plan_from_to_version.country = plan_from_to.country
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.plan_from_to_operation = plan_from_to.operation
and plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.country = plan_from_to_version.country
                                                and plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_operation = plan_from_to_version.plan_from_to_operation
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- { example: Brazil, smartfit, person_plan, debit_account } =========================================================================================================================================
-- create the order_to_cash header moviment
insert into order_to_cash
(country,
unity_identification,
erp_business_unit,
erp_legal_entity,
erp_subsidiary,
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
(@order_to_cash_id, -- order_to_cash_id
'Brazil', -- country
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

inner join customer
on customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_clustered_receivable_customer_id = customer.erp_customer_id,
receivable.erp_receivable_customer_id = customer.erp_customer_id

where receivable.id = @receivable_id;

-- create the invoice
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
on plan_from_to.country = order_to_cash.country
and plan_from_to.origin_system = order_to_cash.origin_system
and plan_from_to.operation = order_to_cash.operation
and plan_from_to.front_plan_id = invoice_items.front_plan_id

inner join plan_from_to_version
on plan_from_to_version.country = plan_from_to.country
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.plan_from_to_operation = plan_from_to.operation
and plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.country = plan_from_to_version.country
                                                and plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_operation = plan_from_to_version.plan_from_to_operation
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- create the invoice_items
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
on plan_from_to.country = order_to_cash.country
and plan_from_to.origin_system = order_to_cash.origin_system
and plan_from_to.operation = order_to_cash.operation
and plan_from_to.front_plan_id = invoice_items.front_plan_id

inner join plan_from_to_version
on plan_from_to_version.country = plan_from_to.country
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.plan_from_to_operation = plan_from_to.operation
and plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.country = plan_from_to_version.country
                                                and plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_operation = plan_from_to_version.plan_from_to_operation
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- { example: Brazil, smartfit, person_plan, credit_card } =========================================================================================================================================
-- create the order_to_cash header moviment
insert into order_to_cash
(country,
unity_identification,
erp_business_unit,
erp_legal_entity,
erp_subsidiary,
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
(@order_to_cash_id, -- order_to_cash_id
'Brazil', -- country
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
(@order_to_cash_id, -- order_to_cash_id
null, -- erp_receivable_id
null, -- erp_receivable_customer_id
null, -- erp_clustered_receivable_id
null, -- erp_clustered_receivable_customer_id
'no', -- is_smartfin
'credit_card_recurring', -- transaction_type
'1288329736', -- contract_number
'MASTER', -- credit_card_brand
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

inner join customer
on customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_clustered_receivable_customer_id = customer.erp_customer_id,
receivable.erp_receivable_customer_id = customer.erp_customer_id

where receivable.id = @receivable_id;

-- create the invoice
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
on plan_from_to.country = order_to_cash.country
and plan_from_to.origin_system = order_to_cash.origin_system
and plan_from_to.operation = order_to_cash.operation
and plan_from_to.front_plan_id = invoice_items.front_plan_id

inner join plan_from_to_version
on plan_from_to_version.country = plan_from_to.country
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.plan_from_to_operation = plan_from_to.operation
and plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.country = plan_from_to_version.country
                                                and plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_operation = plan_from_to_version.plan_from_to_operation
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

-- create the invoice_items
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
on plan_from_to.country = order_to_cash.country
and plan_from_to.origin_system = order_to_cash.origin_system
and plan_from_to.operation = order_to_cash.operation
and plan_from_to.front_plan_id = invoice_items.front_plan_id

inner join plan_from_to_version
on plan_from_to_version.country = plan_from_to.country
and plan_from_to_version.plan_from_to_origin_system = plan_from_to.origin_system
and plan_from_to_version.plan_from_to_operation = plan_from_to.operation
and plan_from_to_version.plan_from_to_front_plan_id = plan_from_to.front_plan_id
and plan_from_to_version.created_at = ( 
												select 
													max(plan_from_to_version_v2.created_at) as max_created_at
												from plan_from_to_version plan_from_to_version_v2
                                                where plan_from_to_version_v2.country = plan_from_to_version.country
                                                and plan_from_to_version_v2.plan_from_to_origin_system = plan_from_to_version.plan_from_to_origin_system
                                                and plan_from_to_version_v2.plan_from_to_operation = plan_from_to_version.plan_from_to_operation
                                                and plan_from_to_version_v2.plan_from_to_front_plan_id = plan_from_to_version.plan_from_to_front_plan_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = plan_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;


INSERT INTO refund
(country,
unity_identification,
erp_business_unit,
erp_legal_entity,
erp_subsidiary,
acronym,
erp_refund_status_transaction,
erp_refund_sent_to_erp_at,
erp_refund_returned_from_erp_at,
erp_refund_log,
refund_requester_name,
refund_requester_identification,
issue_date,
due_date,
erp_refund_id,
front_refund_id,
refund_value,
bank_number,
bank_branch,
bank_branch_digit,
bank_account_number,
bank_account_number_digit,
bank_account_owner_name,
bank_account_owner_identification)
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

INSERT INTO refund_items
(refund_id,
front_id,
refund_item_value,
billing_date)
VALUES
(1546, -- refund_id
99877897, -- front_id
75.425, -- refund_item_value
'2019-01-10'); -- billing_date

INSERT INTO refund_items
(refund_id, -- refund_id
front_id, -- front_id
refund_item_value, -- refund_item_value
billing_date) -- billing_date
VALUES
(1546,
91237897,
75.425,
'2019-02-10');


INSERT INTO chargeback
(country,-- Criar uma integração para cada país. No caso do Brasil será um job para a conciliadora Concil
erp_clustered_chargeback_id, -- Id do aglutinado de chargeback
erp_receipt_id, -- Id único e imutável do receipt no Oracle
erp_receipt_status_transaction, -- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
erp_receipt_sent_to_erp_at, -- TimeStamp de quando o registro foi enviado para o Oracle
erp_receipt_returned_from_erp_at, -- TimeStamp de quando o registro retornou do Oracle
erp_receivable_log,-- Este campo deverá ser preenchido no retorno do Oracle
front_status_transaction,-- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
front_sent_to_front_at, -- TimeStamp de quando o registro foi enviado para o Front
front_returned_from_front_at, -- TimeStamp de quando o registro retornou do Front
front_log, -- Este campo deverá ser preenchido no retorno do Front
chargeback_acquirer_label, -- Utilizar a coluna ADQUIRENTE do arquivo de retorno da Concil
conciliator_id, -- Utilizar a coluna COD_ERP do arquivo de retorno da Concil
concitiation_type, -- Utilizar a coluna TIPO_LANCAMENTO do arquivo de retorno da Concil - ao ler o arquivo para ser gravado nessa tabela considerar somente o tipo CHBK
conciliation_description, -- Utilizar a coluna DESCRICAO do arquivo de retorno da Concil 
transaction_type, -- Utilizar a coluna TIPO_TRANSACAO do arquivo de retorno da Concil - converter CREDITO para credit_card e DEBITO para debit_card
contract_number,-- Utilizar a coluna ESTABELECIMENTO do arquivo de retorno da Concil 
credit_card_brand, -- Utilizar a coluna BANDEIRA do arquivo de retorno da Concil - converter os valores AMEX para americanexpress, MASTER para MASTER, HIPERCARD para hipercard, ELO para elo, VISA para VISA e DINERS para diners
truncated_credit_card, -- Utilizar a coluna MASC_CARTAO do arquivo de retorno da Concil
current_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Left(NRO_PARCELA,2)
total_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Right(NRO_PARCELA,2)
nsu, -- Utilizar a coluna NSU do arquivo de retorno da Concil 
authorization_code, -- Utilizar a coluna AUTORIZACAO do arquivo de retorno da Concil 
payment_lot, -- Utilizar a coluna NR_RO do arquivo de retorno da Concil 
price_list_value, -- Desconsiderar
gross_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
net_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
interest_value,-- Desconsiderar
administration_tax_percentage,-- Utilizar a coluna TAXA/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
administration_tax_value, -- Utilizar a coluna TAXA do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_percentage,-- Utilizar a coluna VLR_DESC_ANTECIP/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_value,-- Utilizar a coluna VLR_DESC_ANTECIP do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
billing_date, -- Utilizar a coluna DT_VENDA do arquivo de retorno da Concil 
credit_date, -- Utilizar a coluna DT_PAGAMENTO do arquivo de retorno da Concil 
bank_number, -- Utilizar a coluna NRO_BANCO do arquivo de retorno da Concil 
bank_branch, -- Utilizar a coluna NRO_AGENCIA do arquivo de retorno da Concil 
bank_account, -- Utilizar a coluna NRO_CONTA do arquivo de retorno da Concil 
conciliator_filename, -- Aqui deve ser gravado o nome do arquivo lido
acquirer_bank_filename) -- Utilizar a coluna NOME_ARQUIVO do arquivo de retorno da Concil 
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
'MASTER', -- credit_card_brand
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


INSERT INTO chargeback
(country,-- Criar uma integração para cada país. No caso do Brasil será um job para a conciliadora Concil
erp_clustered_chargeback_id, -- Id do aglutinado de chargeback
erp_receipt_id, -- Id único e imutável do receipt no Oracle
erp_receipt_status_transaction, -- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
erp_receipt_sent_to_erp_at, -- TimeStamp de quando o registro foi enviado para o Oracle
erp_receipt_returned_from_erp_at, -- TimeStamp de quando o registro retornou do Oracle
erp_receivable_log,-- Este campo deverá ser preenchido no retorno do Oracle
front_status_transaction,-- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
front_sent_to_front_at, -- TimeStamp de quando o registro foi enviado para o Front
front_returned_from_front_at, -- TimeStamp de quando o registro retornou do Front
front_log, -- Este campo deverá ser preenchido no retorno do Front
chargeback_acquirer_label, -- Utilizar a coluna ADQUIRENTE do arquivo de retorno da Concil
conciliator_id, -- Utilizar a coluna COD_ERP do arquivo de retorno da Concil
concitiation_type, -- Utilizar a coluna TIPO_LANCAMENTO do arquivo de retorno da Concil - ao ler o arquivo para ser gravado nessa tabela considerar somente o tipo CHBK
conciliation_description, -- Utilizar a coluna DESCRICAO do arquivo de retorno da Concil 
transaction_type, -- Utilizar a coluna TIPO_TRANSACAO do arquivo de retorno da Concil - converter CREDITO para credit_card e DEBITO para debit_card
contract_number,-- Utilizar a coluna ESTABELECIMENTO do arquivo de retorno da Concil 
credit_card_brand, -- Utilizar a coluna BANDEIRA do arquivo de retorno da Concil - converter os valores AMEX para americanexpress, MASTER para MASTER, HIPERCARD para hipercard, ELO para elo, VISA para VISA e DINERS para diners
truncated_credit_card, -- Utilizar a coluna MASC_CARTAO do arquivo de retorno da Concil
current_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Left(NRO_PARCELA,2)
total_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Right(NRO_PARCELA,2)
nsu, -- Utilizar a coluna NSU do arquivo de retorno da Concil 
authorization_code, -- Utilizar a coluna AUTORIZACAO do arquivo de retorno da Concil 
payment_lot, -- Utilizar a coluna NR_RO do arquivo de retorno da Concil 
price_list_value, -- Desconsiderar
gross_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
net_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
interest_value,-- Desconsiderar
administration_tax_percentage,-- Utilizar a coluna TAXA/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
administration_tax_value, -- Utilizar a coluna TAXA do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_percentage,-- Utilizar a coluna VLR_DESC_ANTECIP/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_value,-- Utilizar a coluna VLR_DESC_ANTECIP do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
billing_date, -- Utilizar a coluna DT_VENDA do arquivo de retorno da Concil 
credit_date, -- Utilizar a coluna DT_PAGAMENTO do arquivo de retorno da Concil 
bank_number, -- Utilizar a coluna NRO_BANCO do arquivo de retorno da Concil 
bank_branch, -- Utilizar a coluna NRO_AGENCIA do arquivo de retorno da Concil 
bank_account, -- Utilizar a coluna NRO_CONTA do arquivo de retorno da Concil 
conciliator_filename, -- Aqui deve ser gravado o nome do arquivo lido
acquirer_bank_filename) -- Utilizar a coluna NOME_ARQUIVO do arquivo de retorno da Concil 
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
'MASTER', -- credit_card_brand
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

INSERT INTO chargeback
(country,-- Criar uma integração para cada país. No caso do Brasil será um job para a conciliadora Concil
erp_clustered_chargeback_id, -- Id do aglutinado de chargeback
erp_receipt_id, -- Id único e imutável do receipt no Oracle
erp_receipt_status_transaction, -- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
erp_receipt_sent_to_erp_at, -- TimeStamp de quando o registro foi enviado para o Oracle
erp_receipt_returned_from_erp_at, -- TimeStamp de quando o registro retornou do Oracle
erp_receivable_log,-- Este campo deverá ser preenchido no retorno do Oracle
front_status_transaction,-- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
front_sent_to_front_at, -- TimeStamp de quando o registro foi enviado para o Front
front_returned_from_front_at, -- TimeStamp de quando o registro retornou do Front
front_log, -- Este campo deverá ser preenchido no retorno do Front
chargeback_acquirer_label, -- Utilizar a coluna ADQUIRENTE do arquivo de retorno da Concil
conciliator_id, -- Utilizar a coluna COD_ERP do arquivo de retorno da Concil
concitiation_type, -- Utilizar a coluna TIPO_LANCAMENTO do arquivo de retorno da Concil - ao ler o arquivo para ser gravado nessa tabela considerar somente o tipo CHBK
conciliation_description, -- Utilizar a coluna DESCRICAO do arquivo de retorno da Concil 
transaction_type, -- Utilizar a coluna TIPO_TRANSACAO do arquivo de retorno da Concil - converter CREDITO para credit_card e DEBITO para debit_card
contract_number,-- Utilizar a coluna ESTABELECIMENTO do arquivo de retorno da Concil 
credit_card_brand, -- Utilizar a coluna BANDEIRA do arquivo de retorno da Concil - converter os valores AMEX para americanexpress, MASTER para MASTER, HIPERCARD para hipercard, ELO para elo, VISA para VISA e DINERS para diners
truncated_credit_card, -- Utilizar a coluna MASC_CARTAO do arquivo de retorno da Concil
current_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Left(NRO_PARCELA,2)
total_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Right(NRO_PARCELA,2)
nsu, -- Utilizar a coluna NSU do arquivo de retorno da Concil 
authorization_code, -- Utilizar a coluna AUTORIZACAO do arquivo de retorno da Concil 
payment_lot, -- Utilizar a coluna NR_RO do arquivo de retorno da Concil 
price_list_value, -- Desconsiderar
gross_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
net_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
interest_value,-- Desconsiderar
administration_tax_percentage,-- Utilizar a coluna TAXA/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
administration_tax_value, -- Utilizar a coluna TAXA do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_percentage,-- Utilizar a coluna VLR_DESC_ANTECIP/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_value,-- Utilizar a coluna VLR_DESC_ANTECIP do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
billing_date, -- Utilizar a coluna DT_VENDA do arquivo de retorno da Concil 
credit_date, -- Utilizar a coluna DT_PAGAMENTO do arquivo de retorno da Concil 
bank_number, -- Utilizar a coluna NRO_BANCO do arquivo de retorno da Concil 
bank_branch, -- Utilizar a coluna NRO_AGENCIA do arquivo de retorno da Concil 
bank_account, -- Utilizar a coluna NRO_CONTA do arquivo de retorno da Concil 
conciliator_filename, -- Aqui deve ser gravado o nome do arquivo lido
acquirer_bank_filename) -- Utilizar a coluna NOME_ARQUIVO do arquivo de retorno da Concil 
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
'MASTER', -- credit_card_brand
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

INSERT INTO conciliated_payed_receivable
(country, -- Criar uma integração para cada país. No caso do Brasil será um job para a conciliadora Concil
erp_receipt_id, -- Id único e imutável do receipt no Oracle
erp_receipt_status_transaction, -- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
erp_receipt_sent_to_erp_at, -- TimeStamp de quando o registro foi enviado para o Oracle
erp_receipt_returned_from_erp_at, -- TimeStamp de quando o registro retornou do Oracle
erp_receipt_log, -- Este campo deverá ser preenchido no retorno do Oracle
erp_receivable_customer_id, -- Desconsiderar
conciliator_id, -- Utilizar a coluna COD_ERP do arquivo de retorno da Concil
concitiation_type, -- Utilizar a coluna TIPO_LANCAMENTO do arquivo de retorno da Concil - ao ler o arquivo para ser gravado nessa tabela considerar somente o tipo PCV
conciliation_description, -- Utilizar a coluna DESCRICAO do arquivo de retorno da Concil 
transaction_type, -- Utilizar a coluna TIPO_TRANSACAO do arquivo de retorno da Concil - converter CREDITO para credit_card e DEBITO para debit_card
contract_number, -- Utilizar a coluna ESTABELECIMENTO do arquivo de retorno da Concil 
credit_card_brand, -- Utilizar a coluna BANDEIRA do arquivo de retorno da Concil - converter os valores AMEX para americanexpress, MASTER para MASTER, HIPERCARD para hipercard, ELO para elo, VISA para VISA e DINERS para diners
truncated_credit_card, -- Utilizar a coluna MASC_CARTAO do arquivo de retorno da Concil
current_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Left(NRO_PARCELA,2)
total_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Right(NRO_PARCELA,2)
nsu, -- Utilizar a coluna NSU do arquivo de retorno da Concil 
authorization_code, -- Utilizar a coluna AUTORIZACAO do arquivo de retorno da Concil 
payment_lot, -- Utilizar a coluna NR_RO do arquivo de retorno da Concil 
price_list_value, -- Desconsiderar
gross_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
net_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
interest_value, -- Desconsiderar
administration_tax_percentage, -- Utilizar a coluna TAXA/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
administration_tax_value, -- Utilizar a coluna TAXA do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_percentage, -- Utilizar a coluna VLR_DESC_ANTECIP/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_value,-- Utilizar a coluna VLR_DESC_ANTECIP do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
billing_date, -- Utilizar a coluna DT_VENDA do arquivo de retorno da Concil 
credit_date, -- Utilizar a coluna DT_PAGAMENTO do arquivo de retorno da Concil 
bank_number, -- Utilizar a coluna NRO_BANCO do arquivo de retorno da Concil 
bank_branch, -- Utilizar a coluna NRO_AGENCIA do arquivo de retorno da Concil 
bank_account, -- Utilizar a coluna NRO_CONTA do arquivo de retorno da Concil 
conciliator_filename, -- Aqui deve ser gravado o nome do arquivo lido
acquirer_bank_filename) -- Utilizar a coluna NOME_ARQUIVO do arquivo de retorno da Concil 
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
'MASTER', -- credit_card_brand
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

INSERT INTO conciliated_payed_receivable
(country,
erp_receipt_id,
erp_receipt_status_transaction,
erp_receipt_sent_to_erp_at,
erp_receipt_returned_from_erp_at,
erp_receipt_log,
erp_receivable_customer_id,
conciliator_id,
concitiation_type,
conciliation_description,
transaction_type,
contract_number,
credit_card_brand,
truncated_credit_card,
current_credit_card_installment,
total_credit_card_installment,
nsu,
authorization_code,
payment_lot,
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
bank_number,
bank_branch,
bank_account,
conciliator_filename,
acquirer_bank_filename)
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
'MASTER', -- credit_card_brand
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


INSERT INTO conciliated_payed_receivable
(country,
erp_receipt_id,
erp_receipt_status_transaction,
erp_receipt_sent_to_erp_at,
erp_receipt_returned_from_erp_at,
erp_receipt_log,
erp_receivable_customer_id,
conciliator_id,
concitiation_type,
conciliation_description,
transaction_type,
contract_number,
credit_card_brand,
truncated_credit_card,
current_credit_card_installment,
total_credit_card_installment,
nsu,
authorization_code,
payment_lot,
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
bank_number,
bank_branch,
bank_account,
conciliator_filename,
acquirer_bank_filename)
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
'MASTER', -- credit_card_brand
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


insert into order_to_cash
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
				1, -- unity_identification
				null, -- erp_business_unit
				null, -- erp_legal_entity
				null, -- erp_subsidiary
				null, -- acronym
				'no', -- to_generate_customer -- não é necessário gerar o cliente no Oracle, pois a origem de criação será lá
				'no', -- to_generate_receivable -- o receivable neste caso não deve ser gerado separadamente, pois o order management deverá criar ao criar o pedido no Oracle
				'yes', -- to_generate_invoice -- essa integração deverá gerar um order no OM do Oracle
				'magento', -- origin_system
				'uniform_sale_own', -- operation
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

insert into receivable
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
				'MASTER', -- credit_card_brand -- bandeira do cartão de crédito (MASTER, VISA, americanexpress, elo, diners ou hipercard)
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

insert into invoice
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
on product_from_to.country = order_to_cash.country
and product_from_to.origin_system = order_to_cash.origin_system
and product_from_to.operation = order_to_cash.operation
and product_from_to.front_product_id = invoice_items.front_product_id

inner join product_from_to_version
on product_from_to_version.country = product_from_to.country
and product_from_to_version.product_from_to_origin_system = product_from_to.origin_system
and product_from_to_version.product_from_to_operation = product_from_to.operation
and product_from_to_version.product_from_to_front_product_id = product_from_to.front_product_id
and product_from_to_version.created_at = ( 
												select 
													max(product_from_to_version_v2.created_at) as max_created_at
												from product_from_to_version product_from_to_version_v2
                                                where product_from_to_version_v2.country =  product_from_to_version.country
                                                and product_from_to_version_v2.product_from_to_origin_system = product_from_to_version.product_from_to_origin_system
                                                and product_from_to_version_v2.product_from_to_operation = product_from_to_version.product_from_to_operation
                                                and product_from_to_version_v2.product_from_to_front_product_id = product_from_to_version.product_from_to_front_product_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = product_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;

INSERT INTO supplier VALUES (1,'2019-11-21 18:52:01',44584,'SPCMOR3     ','legal_person','07594978000178','BR','SP','São Paulo',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'felipe.nambara@bioritmo.com.br',NULL,NULL,'yes','yes',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO supplier VALUES (13,'2019-11-21 18:52:01',55455,'SPCSTO1     ','legal_person','07594978001654','BR','SP','São Paulo',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'felipe.nambara@bioritmo.com.br',NULL,NULL,'yes','yes',NULL,NULL,NULL,NULL,NULL,NULL);

insert into order_to_cash
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

insert into receivable
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
			'yes', -- is_smartfin
			'no', -- converted_smartfin
			'franchise', -- type_smartfin
			null, -- receivable_id_smartfin
			null, -- ecommerce_payment_terms
			null, -- erp_payment_terms
			null, -- conciliator_id
			'credit_card_recurring', -- transaction_type
			null, -- contract_number
			'MASTER', -- credit_card_brand
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

inner join customer
on customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

set receivable.erp_receivable_customer_id = customer.erp_customer_id
	,receivable.erp_clustered_receivable_customer_id = customer.erp_customer_id

where receivable.id = @receivable_id;

insert into supplier
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

insert into payable
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
			@receivable_id, -- receivable_id
			null, -- erp_receivable_id
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

insert into order_to_cash
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
				values(
				null, -- order_to_cash_id_smartfin
				'Brazil', -- country
				15, -- unity_identification
				null, -- erp_business_unit
				null, -- erp_legal_entity
				null, -- erp_subsidiary
				null, -- acronym
				'no', -- to_generate_customer
				'no', -- to_generate_receivable
				'yes', -- to_generate_invoice
				'corporatepass', -- origin_system
				'distribution', -- operation
				null, -- minifactu_id
				null, -- conciliator_id
				null, -- fin_id
				115458, -- front_id
				null, -- erp_invoice_customer_send_to_erp_at
				null, -- erp_invoice_customer_returned_from_erp_at
				'doesnt_need_to_be_process', -- erp_invoice_customer_status_transaction
				null, -- erp_invoice_customer_log
				null, -- erp_receivable_sent_to_erp_at
				null, -- erp_receivable_returned_from_erp_at
				'07594978014128', -- erp_receivable_customer_identification
				'doesnt_need_to_be_process', -- erp_receivable_status_transaction
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
order_to_cash.acronym = organization_from_to_version.acronym

where order_to_cash.id = @order_to_cash_id;

insert into receivable
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
				null, -- is_smartfin
				'no', -- converted_smartfin
				null, -- type_smartfin
				null, -- receivable_id_smartfin
				null, -- ecommerce_payment_terms
				null, -- erp_payment_terms
				null, -- conciliator_id
				'bank_transfer', -- transaction_type
				null, -- contract_number
				null, -- credit_card_brand
				null, -- truncated_credit_card
				null, -- current_credit_card_installment
				null, -- total_credit_card_installment
				null, -- nsu
				null, -- authorization_code
				100.15, -- price_list_value
				100.15, -- gross_value
				100.15, -- net_value
				0, -- interest_value
				0, -- administration_tax_percentage
				0, -- administration_tax_value
				0, -- antecipation_tax_percentage
				0, -- antecipation_tax_value
				'2019-11-28', -- billing_date
				'2019-11-28',-- credit_date
				null, -- conciliator_filename
				null, -- acquirer_bank_filename
				null, -- registration_gym_student
				null, -- fullname_gym_student
				null, -- identification_gym_student
				null, -- erp_filename
				null); -- erp_line_in_file

-- saves the auto increment id from receivable table
set @receivable_id = last_insert_id();

insert into invoice
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
				'invoice_intercompany', -- transaction_type
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
				(@invoice_id, -- id_invoice
				5554845, -- front_product_id
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
on product_from_to.country = order_to_cash.country
and product_from_to.origin_system = order_to_cash.origin_system
and product_from_to.operation = order_to_cash.operation
and product_from_to.front_product_id = invoice_items.front_product_id

inner join product_from_to_version
on product_from_to_version.country = product_from_to.country
and product_from_to_version.product_from_to_origin_system = product_from_to.origin_system
and product_from_to_version.product_from_to_operation = product_from_to.operation
and product_from_to_version.product_from_to_front_product_id = product_from_to.front_product_id
and product_from_to_version.created_at = ( 
												select 
													max(product_from_to_version_v2.created_at) as max_created_at
												from product_from_to_version product_from_to_version_v2
                                                where product_from_to_version_v2.country =  product_from_to_version.country
                                                and product_from_to_version_v2.product_from_to_origin_system = product_from_to_version.product_from_to_origin_system
                                                and product_from_to_version_v2.product_from_to_operation = product_from_to_version.product_from_to_operation
                                                and product_from_to_version_v2.product_from_to_front_product_id = product_from_to_version.product_from_to_front_product_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = product_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;


insert into payable
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
			values
			(1, -- unity_identification
			null, -- erp_business_unit
			null, -- erp_legal_entity
			null, -- erp_subsidiary
			null, -- acronym
			null, -- erp_payable_id
			@receivable_id, -- receivable_id
			null, -- erp_receivable_id
			null, -- erp_clustered_receivable_id
			null, -- erp_payable_receipt_id
			null, -- erp_supplier_id
			'07594978001654', -- supplier_identification
			'2019-11-28', -- issue_date
			'2019-11-30', -- due_date
			null, -- erp_payable_send_to_erp_at
			null, -- erp_payable_returned_from_erp_at
			'waiting_to_be_process', -- erp_payable_status_transaction
			null, -- erp_payable_log
			null, -- erp_receipt_send_to_erp_at
			null, -- erp_receipt_returned_from_erp_at
			'doesnt_need_to_be_process', -- erp_receipt_status_transaction
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

inner join supplier
on supplier.identification_financial_responsible = payable.supplier_identification

set payable.erp_business_unit = organization_from_to_version.erp_business_unit,
payable.erp_legal_entity = organization_from_to_version.erp_legal_entity,
payable.erp_subsidiary = organization_from_to_version.erp_subsidiary,
payable.acronym = organization_from_to_version.acronym,
payable.erp_supplier_id = supplier.erp_supplier_id

where payable.id = @payable_id;

insert into order_to_cash
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
				values(
				null, -- order_to_cash_id_smartfin
				'Brazil', -- country
				1, -- unity_identification
				null, -- erp_business_unit
				null, -- erp_legal_entity
				null, -- erp_subsidiary
				null, -- acronym
				'yes', -- to_generate_customer
				'no', -- to_generate_receivable
				'yes', -- to_generate_invoice
				'corporatepass', -- origin_system
				'revenue', -- operation
				null, -- minifactu_id
				null, -- conciliator_id
				null, -- fin_id
				4448815, -- front_id
				null, -- erp_invoice_customer_send_to_erp_at
				null, -- erp_invoice_customer_returned_from_erp_at
				'waiting_to_be_process', -- erp_invoice_customer_status_transaction
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

-- create the invoice_customer 
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
(@order_to_cash_id, -- order_to_cash_id
'Brazil', -- country
null, -- erp_customer_id
'Carrefour', -- full_name
'legal_person', -- type_person
'25012971000182', -- identification_financial_responsible
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

insert into receivable
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
				null, -- is_smartfin
				'no', -- converted_smartfin
				null, -- type_smartfin
				null, -- receivable_id_smartfin
				null, -- ecommerce_payment_terms
				null, -- erp_payment_terms
				null, -- conciliator_id
				'boleto', -- transaction_type
				null, -- contract_number
				null, -- credit_card_brand
				null, -- truncated_credit_card
				null, -- current_credit_card_installment
				null, -- total_credit_card_installment
				null, -- nsu
				null, -- authorization_code
				10000, -- price_list_value
				10000, -- gross_value
				10000, -- net_value
				0, -- interest_value
				0, -- administration_tax_percentage
				0, -- administration_tax_value
				0, -- antecipation_tax_percentage
				0, -- antecipation_tax_value
				'2019-11-28', -- billing_date
				'2019-11-28',-- credit_date
				null, -- conciliator_filename
				null, -- acquirer_bank_filename
				null, -- registration_gym_student
				null, -- fullname_gym_student
				null, -- identification_gym_student
				null, -- erp_filename
				null); -- erp_line_in_file

-- saves the auto increment id from receivable table
set @receivable_id = last_insert_id();

insert into invoice
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
				'invoice_to_other_company', -- transaction_type
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
				(@invoice_id, -- id_invoice
				4588715, -- front_product_id
				null, -- front_plan_id
				null, -- front_addon_id
				null, -- erp_item_ar_id
				null, -- erp_gl_segment_product
				1, -- quantity
				10000, -- sale_price
				10000, -- list_price
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
on product_from_to.country = order_to_cash.country
and product_from_to.origin_system = order_to_cash.origin_system
and product_from_to.operation = order_to_cash.operation
and product_from_to.front_product_id = invoice_items.front_product_id

inner join product_from_to_version
on product_from_to_version.country = product_from_to.country
and product_from_to_version.product_from_to_origin_system = product_from_to.origin_system
and product_from_to_version.product_from_to_operation = product_from_to.operation
and product_from_to_version.product_from_to_front_product_id = product_from_to.front_product_id
and product_from_to_version.created_at = ( 
												select 
													max(product_from_to_version_v2.created_at) as max_created_at
												from product_from_to_version product_from_to_version_v2
                                                where product_from_to_version_v2.country =  product_from_to_version.country
                                                and product_from_to_version_v2.product_from_to_origin_system = product_from_to_version.product_from_to_origin_system
                                                and product_from_to_version_v2.product_from_to_operation = product_from_to_version.product_from_to_operation
                                                and product_from_to_version_v2.product_from_to_front_product_id = product_from_to_version.product_from_to_front_product_id
												)

set invoice_items.erp_item_ar_id = product_from_to_version.erp_item_ar_id,
invoice_items.erp_gl_segment_product = product_from_to_version.erp_gl_segment_id

where invoice_items.id = @invoice_id_item ;
