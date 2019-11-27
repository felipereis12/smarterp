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
				values(
				null, -- order_to_cash_id_smartfin
				'Brazil', -- country
				1, -- unity_identification
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
				null, -- erp_receipt_status_transaction
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