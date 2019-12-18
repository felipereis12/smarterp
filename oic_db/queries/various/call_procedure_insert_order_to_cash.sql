set @p_return  = true;
set @p_code = 0;
set @p_message = "";

call sp_insert_order_to_cash(	'Brazil' -- {in p_order_to_cash_country varchar(45)}>
							,	1 -- <{in p_order_to_cash_unity_identification varchar(45)}
							, 	'smartsystem' -- <{in p_order_to_cash_origin_system varchar(45)}>
							, 	'person_plan' -- <{in p_order_to_cash_operation varchar(45)}>
							, 	123 -- <{in p_order_to_cash_minifactu_id integer}>
							, 	'889729' -- <{in p_order_to_cash_conciliator_id varchar(45)}>
							, 	942 -- <{in p_order_to_cash_fin_id integer}>
							, 	837 -- <{in p_order_to_cash_front_id integer}>
							,	'01027058000191' -- <{in p_order_to_cash_erp_receivable_customer_identification varchar(45)}>
							, 	'Felipe' -- <{in p_invoice_customer_full_name varchar(45)}>
							, 	'natural_person' -- <{in p_invoice_customer_type_person varchar(45)}>
							, 	'39367233892' -- <{in p_invoice_customer_identification_financial_responsible varchar(45)}>
							, 	'BR' -- <{in p_invoice_customer_nationality_code varchar(45)}>
							, 	'SP' -- <{in p_invoice_customer_state varchar(45)}>
							, 	'São Paulo' -- <{in p_invoice_customer_city varchar(45)}>
							, 	'Rua Manifesto' -- <{in p_invoice_customer_adress varchar(45)}>
							, 	2191 -- <{in p_invoice_customer_adress_number integer}>
							, 	null -- <{in p_invoice_customer_adress_complement varchar(45)}>
							, 	'Ipiranga' -- <{in p_invoice_customer_district varchar(45)}>
							, 	'04209002' -- <{in p_invoice_customer_postal_code varchar(45)}>
							, 	'11' -- <{in p_invoice_customer_area_code varchar(45)}>
							, 	'970718989' -- <{in p_invoice_customer_cellphone varchar(45)}>
							, 	'felipe.nambara@bioritmo.com.br' -- <{in p_invoice_customer_email varchar(45)}>
							,	null -- <{in p_invoice_customer_state_registration varchar(45)}>
							, 	null -- <{in p_invoice_customer_federal_registration varchar(45)}>
							, 	'yes' -- <{in p_invoice_customer_final_consumer varchar(45)}>
							, 	'no' -- <{in p_invoice_customer_icms_contributor varchar(45)}>
							, 	'no' -- <{in p_receivable_is_smartfin varchar(45)}>
							, 	'credit_card_recurring' -- <{in p_receivable_transaction_type varchar(45)}>
							, 	'98773652676' -- <{in p_receivable_contract_number varchar(45)}>
							, 	'MASTER' -- <{in p_receivable_credit_card_brand varchar(45)}>
							, 	'1234***9873' -- <{in p_receivable_truncated_credit_card varchar(45)}>
							, 	1 -- <{in p_receivable_current_credit_card_installment integer}>
							, 	1 -- <{in p_receivable_total_credit_card_installment integer}>
							,	'88736275' -- <{in p_receivable_nsu varchar(45)}>
							, 	'123214124' -- <{in p_receivable_conciliator_id varchar(45)}>
							, 	'123231233' -- <{in p_receivable_authorization_code varchar(45)}>
							, 	200 -- <{in p_receivable_price_list_value float}>
							, 	100 -- <{in p_receivable_gross_value float}>
							, 	100 -- <{in p_receivable_net_value float}>
							, 	0 -- <{in p_receivable_interest_value float}>
							, 	0.5 -- <{in p_receivable_administration_tax_percentage float}>
							,	0.5 -- <{in p_receivable_administration_tax_value float}>
							, 	0 -- <{in p_receivable_antecipation_tax_percentage float}>
							, 	0 -- <{in p_receivable_antecipation_tax_value float}>
							, 	'2019-12-14' -- <{in p_receivable_billing_date date}>
							, 	'2019-12-14' -- <{in p_receivable_credit_date date}>
							,	'teste0.txt' -- <{in p_receivable_conciliator_filename varchar(255)}>
							,	'teste1.txt' -- <{in p_receivable_acquirer_bank_filename varchar(255)}>
							,	'998273' -- <{in p_receivable_registration_gym_student varchar(45)}>
							,	'Felipe Volcov Nambara' -- <{in p_receivable_fullname_gym_student varchar(255)}>
							,	'39367233892' -- <{in p_receivable_identification_gym_student varchar(255)}>
							,	'invoice_to_financial_responsible' -- <{in p_invoice_transaction_type varchar(45)}>
							,	'no' -- <{in p_invoice_is_overdue_recovery varchar(45)}>
							,	cast(' { "invoice_items" : [ { "front_product_id": 120366453, "front_plan_id": 1, "front_addon_id": null, "quantity": 1, "list_price": 200, "sale_price": 100 } , { "front_product_id": 120366453, "front_plan_id": 1, "front_addon_id": null, "quantity": 1, "list_price": 200, "sale_price": 100 } ] }' as json) -- <{in p_invoice_items_json varchar(255)}>
							,	@p_return -- <{out p_return boolean}>
							,	@p_code -- <{out p_code integer}>
							,	@p_message); -- <{out p_message varchar(255)}>)
                            
                            
select @p_return,@p_code,@p_message;