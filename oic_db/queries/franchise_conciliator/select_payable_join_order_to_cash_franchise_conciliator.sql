select 
	 pay.unity_identification
	,pay.erp_business_unit
    ,pay.erp_legal_entity
    ,pay.erp_subsidiary
    ,pay.acronym
    ,pay.*
from payable pay

inner join receivable rec
on rec.id = pay.receivable_id

inner join order_to_cash otc
on otc.id = rec.order_to_cash_id

where otc.country = 'Brazil' -- Integração em paralalo por operação do país
and otc.erp_subsidiary = 'BR020001' -- Neste caso fixar esse valor para a integração de conciliador de franquias
and otc.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and otc.operation = 'franchise_conciliator' -- Neste caso fixar esse valor para a integração de conciliador de franquias
and rec.transaction_type = 'credit_card_recurring' -- Integração em paralalo por tipo de transação (Cartão de crédito recorrente, cartão de débito recorrente, débito em conta, boleto etc...)
and rec.erp_receivable_id is not null
and rec.erp_receipt_id is not null
and pay.erp_supplier_id is not null
and pay.erp_payable_status_transaction = 'waiting_to_be_process' -- Filtrar somente os registros que ainda não foram integrados com o erp e estão aguardando processamento
and pay.erp_payable_id is null; -- Filtrar somente os receivables que ainda não foram integrados com o erp
