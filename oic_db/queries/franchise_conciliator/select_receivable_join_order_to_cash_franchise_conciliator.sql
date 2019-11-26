select 
	 t1.erp_business_unit
	,t1.id
    ,t1.idx_qry
	,t1.erp_source_name
	,t1.erp_type_transaction
    ,t1.erp_payments_terms
    ,t1.erp_currency_code
    ,t1.erp_currency_conversion_type
    ,t1.erp_interface_line_context
    ,t1.erp_memo_line
    ,t1.erp_clustered_receivable_id
    ,t1.identification_financial_responsible
    ,t1.full_name
    ,t1.net_value
    ,t1.conciliator_id
    ,t1.credit_card_brand
    ,t1.contract_number
    ,t1.transaction_type
    ,t1.truncated_credit_card
    ,t1.current_credit_card_installment
    ,t1.total_credit_card_installment
    ,t1.nsu
    ,t1.authorization_code
    ,t1.administration_tax_percentage
    ,t1.billing_date
    ,t1.credit_date
    ,t1.converted_smartfin
from (

/*Valores bruto da venda*/
select
	 otc.erp_business_unit
	,otc.id
    ,1 as idx_qry
	,recg.erp_source_name
	,recg.erp_type_transaction
    ,recg.erp_payments_terms
    ,recg.erp_currency_code
    ,recg.erp_currency_conversion_type
    ,recg.erp_interface_line_context
    ,recg.erp_memo_line
    ,rec.erp_clustered_receivable_id
    ,crc.identification_financial_responsible
    ,crc.full_name
    ,rec.net_value
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
and recg.memoline_setting = 'gross_value'

where otc.country = 'Brazil' -- Integração em paralalo por operação do país
and otc.erp_subsidiary = 'BR020001' -- Filtro por filial (loop automático)
and otc.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and otc.operation = 'franchise_conciliator' -- Integração em paralalo por operação (plano de alunos, plano corporativo, etc...)
and otc.to_generate_receivable = 'yes'
and rec.erp_clustered_receivable_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable_customer 
and rec.erp_receivable_id is null -- Filtrar somente os receivables que ainda não foram integrados com o erp
and rec.transaction_type = 'credit_card_recurring' -- Integração em paralalo por tipo de transação (Cartão de crédito recorrente, cartão de débito recorrente, débito em conta, boleto etc...)

union

/*Valores da taxa de administração da operadora*/
select 
	 otc.erp_business_unit
	,otc.id
    ,2 as idx_qry
	,recg.erp_source_name
	,recg.erp_type_transaction
    ,recg.erp_payments_terms
    ,recg.erp_currency_code
    ,recg.erp_currency_conversion_type
    ,recg.erp_interface_line_context
    ,recg.erp_memo_line
    ,rec.erp_clustered_receivable_id
    ,crc.identification_financial_responsible
    ,crc.full_name
    ,rec.administration_tax_value*-1
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
and recg.memoline_setting = 'administration_tax'

where otc.country = 'Brazil' -- Integração em paralalo por operação do país
and otc.erp_subsidiary = 'BR020001' -- Filtro por filial (loop automático)
and otc.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and otc.operation = 'franchise_conciliator' -- Integração em paralalo por operação (plano de alunos, plano corporativo, etc...)
and otc.to_generate_receivable = 'yes'
and rec.erp_clustered_receivable_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable_customer 
and rec.erp_receivable_id is null -- Filtrar somente os receivables que ainda não foram integrados com o erp
and rec.transaction_type = 'credit_card_recurring' -- Integração em paralalo por tipo de transação (Cartão de crédito recorrente, cartão de débito recorrente, débito em conta, boleto etc...)
and rec.administration_tax_value > 0

union

/*Valores de juros/mora*/
select 
	 otc.erp_business_unit
	,otc.id
    ,3 as idx_qry
	,recg.erp_source_name
	,recg.erp_type_transaction
    ,recg.erp_payments_terms
    ,recg.erp_currency_code
    ,recg.erp_currency_conversion_type
    ,recg.erp_interface_line_context
    ,recg.erp_memo_line
    ,rec.erp_clustered_receivable_id
    ,crc.identification_financial_responsible
    ,crc.full_name
    ,rec.interest_value
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
and recg.memoline_setting = 'interest'

where otc.country = 'Brazil' -- Integração em paralalo por operação do país
and otc.erp_subsidiary = 'BR020001' -- Filtro por filial (loop automático)
and otc.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and otc.operation = 'franchise_conciliator' -- Integração em paralalo por operação (plano de alunos, plano corporativo, etc...)
and otc.to_generate_receivable = 'yes'
and rec.erp_clustered_receivable_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable_customer 
and rec.erp_receivable_id is null -- Filtrar somente os receivables que ainda não foram integrados com o erp
and rec.transaction_type = 'credit_card_recurring' -- Integração em paralalo por tipo de transação (Cartão de crédito recorrente, cartão de débito recorrente, débito em conta, boleto etc...)
and rec.interest_value > 0

) as t1

order by t1.erp_business_unit
		,t1.id
        ,t1.idx_qry