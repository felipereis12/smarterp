select 
	 pay.erp_business_unit
    ,pay.erp_legal_entity
    ,oftv.erp_legal_entity_name
    ,pay.erp_subsidiary
    ,pec.erp_source_name
    ,pec.erp_currency_code
    ,pec.erp_payment_code
    ,pec.erp_invoice_type
    ,pec.erp_payments_terms
    ,sup.identification_financial_responsible    
    ,sup.full_name
    ,sup.erp_supplier_id
    ,rec.erp_receivable_id
    ,rec.erp_clustered_receivable_id
    ,pay.gross_value
    ,if(month(pay.issue_date)=month(current_date()),pay.issue_date,current_date()) as erp_trx_date
    ,if(month(pay.issue_date)=month(current_date()),pay.issue_date,current_date()) as erp_gl_date     
from payable pay

inner join receivable rec
on rec.id = pay.receivable_id

inner join order_to_cash otc
on otc.id = rec.order_to_cash_id

inner join supplier sup
on sup.erp_supplier_id = pay.erp_supplier_id

left join payable_erp_configurations pec
on pec.country = otc.country
and pec.origin_system = otc.origin_system
and pec.operation = otc.operation
and pec.transaction_type = rec.transaction_type
and pec.converted_smartfin = rec.converted_smartfin

inner join organization_from_to_version oftv
on oftv.erp_business_unit = otc.erp_business_unit
and oftv.erp_legal_entity = otc.erp_legal_entity
and oftv.erp_subsidiary = otc.erp_subsidiary
and oftv.created_at = 	(
							select
								max(oftv_v2.created_at) as created_at
							from organization_from_to_version oftv_v2
                            where oftv_v2.erp_business_unit = oftv.erp_business_unit
                            and oftv_v2.erp_legal_entity = oftv.erp_legal_entity
                            and oftv_v2.erp_subsidiary = oftv.erp_subsidiary
						)

where otc.country = 'Brazil' -- Integração em paralalo por operação do país
and otc.erp_subsidiary = 'BR020001' -- Neste caso como haverá uma integração separada para os movimentos Smartfin esse filtro deverá ser fixo para tais movimentos
and otc.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and otc.operation = 'person_plan' -- Integração em paralalo por operação (plano de alunos, plano corporativo, etc...)
and pay.erp_payable_status_transaction = 'waiting_to_be_process' -- Filtrar somente os registros que ainda não foram integrados com o erp e estão aguardando processamento
and pay.erp_payable_id is null -- Filtrar somente os receivables que ainda não foram integrados com o erp
and rec.transaction_type = 'credit_card_recurring';
