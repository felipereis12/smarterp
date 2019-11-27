select 
	t1.id
    ,t1.idx_qry
	,t1.erp_business_unit
	,t1.erp_source_name
	,t1.erp_type_transaction
    ,t1.erp_payments_terms
    ,t1.erp_currency_code
    ,t1.erp_currency_conversion_type
    ,t1.erp_clustered_receivable_id
    ,t1.identification_financial_responsible
    ,t1.bank_number
    ,t1.bank_branch
    ,t1.bank_account
    ,t1.quantity_of_days_to_due_date
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
    ,t1.administration_tax_value
    ,t1.billing_date
    ,t1.credit_date
    
from (

select 
	otc.id
    ,1 as idx_qry
	,otc.erp_business_unit
	,recg.erp_source_name
	,recg.erp_type_transaction
    ,recg.erp_payments_terms
    ,recg.erp_currency_code
    ,recg.erp_currency_conversion_type
    ,rec.erp_clustered_receivable_id
    ,crc.identification_financial_responsible
    ,rftv.bank_number
    ,rftv.bank_branch
    ,rftv.bank_account
    ,rftv.quantity_of_days_to_due_date
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
    ,rec.administration_tax_value
    ,rec.billing_date
    ,rec.credit_date
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
and recg.memoline_setting = 'gross_value'

left join receipt_from_to_version rftv
on rftv.origin_system = otc.origin_system
and rftv.order_to_cash_operation = otc.operation
and rftv.erp_business_unit = otc.erp_business_unit
and rftv.receivable_transaction_type = rec.transaction_type
and rftv.erp_receivable_customer_identification = crc.identification_financial_responsible
and rftv.created_at = 	(
							select
								max(rftv_v2.created_at) as created_at
							from receipt_from_to_version rftv_v2
							where rftv_v2.origin_system = rftv.origin_system
							and rftv_v2.order_to_cash_operation = rftv.order_to_cash_operation
                            and rftv_v2.erp_business_unit = rftv.erp_business_unit
							and rftv_v2.receivable_transaction_type = rftv.receivable_transaction_type
							and rftv_v2.erp_receivable_customer_identification = rftv.erp_receivable_customer_identification
						)

where otc.country = 'Brazil' -- Integração em paralalo por operação do país
and otc.erp_subsidiary = 'BR020001' -- Neste caso a filial deve ser fixa
and otc.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and otc.operation = 'franchise_conciliator' -- Integração em paralalo por operação (plano de alunos, plano corporativo, etc...)
and rec.type_smartfin = 'franchise'
and rec.net_value > 0
and rec.erp_receivable_id is not null -- Filtrar somente os receivables que já foram integrados no erp e devem ser baixados

union

select	
	otc.id
    ,2 as idx_qry
	,otc.erp_business_unit
	,recg.erp_source_name
	,recg.erp_type_transaction
    ,recg.erp_payments_terms
    ,recg.erp_currency_code
    ,recg.erp_currency_conversion_type
    ,rec.erp_clustered_receivable_id
    ,crc.identification_financial_responsible
    ,rftv.bank_number
    ,rftv.bank_branch
    ,rftv.bank_account
    ,rftv.quantity_of_days_to_due_date
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
    ,rec.administration_tax_value
    ,rec.billing_date
    ,rec.credit_date
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
and recg.memoline_setting = 'administration_tax'

left join receipt_from_to_version rftv
on rftv.erp_business_unit = otc.erp_business_unit
and rftv.receivable_transaction_type = rec.transaction_type
and rftv.erp_receivable_customer_identification = crc.identification_financial_responsible
and rftv.created_at = 	(
							select
								max(rftv_v2.created_at) as created_at
							from receipt_from_to_version rftv_v2
							where rftv_v2.erp_business_unit = rftv.erp_business_unit
							and rftv_v2.receivable_transaction_type = rftv.receivable_transaction_type
							and rftv_v2.erp_receivable_customer_identification = rftv.erp_receivable_customer_identification
						)

where otc.country = 'Brazil' -- Integração em paralalo por operação do país
and otc.erp_subsidiary = 'BR020001' -- Neste caso a filial deve ser fixa
and otc.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and otc.operation = 'franchise_conciliator' -- Integração em paralalo por operação (plano de alunos, plano corporativo, etc...)
and rec.type_smartfin = 'franchise'
and rec.administration_tax_value > 0
and rec.erp_receivable_id is not null -- Filtrar somente os receivables que já foram integrados no erp e devem ser baixados

union

select 	
	 otc.id
    ,3 as idx_qry
	,otc.erp_business_unit
	,recg.erp_source_name
	,recg.erp_type_transaction
    ,recg.erp_payments_terms
    ,recg.erp_currency_code
    ,recg.erp_currency_conversion_type
    ,rec.erp_clustered_receivable_id
    ,crc.identification_financial_responsible
    ,rftv.bank_number
    ,rftv.bank_branch
    ,rftv.bank_account
    ,rftv.quantity_of_days_to_due_date
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
    ,rec.administration_tax_value
    ,rec.billing_date
    ,rec.credit_date
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
and recg.memoline_setting = 'interest'

left join receipt_from_to_version rftv
on rftv.erp_business_unit = otc.erp_business_unit
and rftv.receivable_transaction_type = rec.transaction_type
and rftv.erp_receivable_customer_identification = crc.identification_financial_responsible
and rftv.created_at = 	(
							select
								max(rftv_v2.created_at) as created_at
							from receipt_from_to_version rftv_v2
							where rftv_v2.erp_business_unit = rftv.erp_business_unit
							and rftv_v2.receivable_transaction_type = rftv.receivable_transaction_type
							and rftv_v2.erp_receivable_customer_identification = rftv.erp_receivable_customer_identification
						)

where otc.country = 'Brazil' -- Integração em paralalo por operação do país
and otc.erp_subsidiary = 'BR020001' -- Neste caso a filial deve ser fixa
and otc.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and otc.operation = 'franchise_conciliator' -- Integração em paralalo por operação (plano de alunos, plano corporativo, etc...)
and rec.type_smartfin = 'franchise'
and rec.interest_value > 0
and rec.erp_receivable_id is not null -- Filtrar somente os receivables que já foram integrados no erp e devem ser baixados

) as t1 