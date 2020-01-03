drop view if exists vw_clustered_receivable; 
create VIEW vw_clustered_receivable AS
    SELECT DISTINCT
        order_to_cash.country AS country,
        order_to_cash.origin_system AS origin_system,
        order_to_cash.unity_identification AS unity_identification,
        order_to_cash.erp_business_unit AS erp_business_unit,
        order_to_cash.erp_legal_entity AS erp_legal_entity,
        order_to_cash.erp_subsidiary AS erp_subsidiary,
        order_to_cash.operation AS operation,
        customer.erp_customer_id AS erp_customer_id,
        customer.full_name AS full_name,
        receivable.transaction_type AS transaction_type,
        receivable.credit_card_brand AS credit_card_brand,
        receivable.contract_number AS contract_number,
        round(receivable.administration_tax_percentage,2) AS administration_tax_percentage,
        round(receivable.antecipation_tax_percentage,2) AS antecipation_tax_percentage,
        receivable.billing_date AS billing_date,
        receivable.credit_date AS credit_date,
        receivable.is_smartfin AS is_smartfin
    FROM
        ((receivable
        JOIN order_to_cash ON (((order_to_cash.id = receivable.order_to_cash_id)
				/*
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
					)*/)))
        JOIN customer ON ((customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification)))
    WHERE
        ((order_to_cash.erp_receivable_status_transaction = 'waiting_to_be_process' and order_to_cash.to_generate_receivable = 'yes')
            AND ISNULL(receivable.erp_clustered_receivable_id)
            AND ISNULL(receivable.erp_receivable_id)
            AND (receivable.is_smartfin <> 'yes'))   ;

    -- limit 50 ;