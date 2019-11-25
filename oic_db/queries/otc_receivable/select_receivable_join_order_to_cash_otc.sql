select 
	 otc.erp_business_unit
	,otc.id
	,recg.erp_source_name
	,recg.erp_type_transaction
    ,recg.erp_payments_terms
    ,recg.erp_currency_code
    ,recg.erp_currency_conversion_type
    ,rec.erp_clustered_receivable_id
    ,crc.identification_financial_responsible
    ,crc.full_name
    ,rec.net_value
    ,rec.price_list_value
    ,rec.conciliator_id
    ,rec.credit_card_brand
    ,rec.contract_number
    ,rec.transaction_type
    ,rec.truncated_credit_card
    ,rec.current_credit_card_installment
    ,rec.total_credit_card_installment
    ,rec.nsu
    ,rec.authorization_code
    ,rec.administration_tax_percentage
    ,rec.administration_tax_value
    ,rec.billing_date
    ,rec.credit_date
    ,rec.converted_smartfin
from receivable rec

inner join order_to_cash otc
on otc.id = rec.order_to_cash_id

inner join clustered_receivable_customer crc
on crc.identification_financial_responsible = otc.erp_receivable_customer_identification

left join receivable_erp_configurations recg
on recg.country = otc.country
and recg.origin_system = otc.origin_system
and recg.operation = otc.operation
and recg.transaction_type = rec.transaction_type
and recg.converted_smartfin = rec.converted_smartfin

where otc.country = 'Brazil' -- Integração em paralalo por operação do país
and otc.erp_subsidiary = 'BR010001' -- Filtro por filial (loop automático)
and otc.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and otc.operation = 'person_plan' -- Integração em paralalo por operação (plano de alunos, plano corporativo, etc...)
and otc.erp_receivable_status_transaction = 'clustered_receivable_created' -- Filtrar somente os registros que ainda não foram integrados com o erp e estão aguardando processamento
and otc.to_generate_receivable = 'yes'
and rec.erp_clustered_receivable_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable
and rec.erp_clustered_receivable_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable_customer 
and rec.erp_receivable_id is null -- Filtrar somente os receivables que ainda não foram integrados com o erp
and rec.transaction_type = 'credit_card_recurring' -- Integração em paralalo por tipo de transação (Cartão de crédito recorrente, cartão de débito recorrente, débito em conta, boleto etc...)