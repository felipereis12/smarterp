select 
	 pay.unity_identification
	,pay.erp_business_unit
    ,pay.erp_legal_entity
    ,pay.erp_subsidiary
    ,pay.acronym
    ,pay.*
    ,sup.*
    ,rec.*
from payable pay

inner join receivable rec
on rec.id = pay.receivable_id

inner join order_to_cash otc
on otc.id = rec.order_to_cash_id

inner join supplier sup
on sup.erp_supplier_id = pay.erp_supplier_id

where otc.country = 'Brazil' -- Integração em paralalo por operação do país
and pay.erp_subsidiary = 'BR010001' -- Neste caso como haverá uma integração separada para os movimentos Smartfin esse filtro deverá ser fixo para tais movimentos
and otc.origin_system = 'corporatepass' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and otc.operation = 'distribution' -- Integração em paralalo por operação (plano de alunos, plano corporativo, etc...)
and pay.erp_payable_status_transaction = 'waiting_to_be_process' -- Filtrar somente os registros que ainda não foram integrados com o erp e estão aguardando processamento
and pay.erp_payable_id is null -- Filtrar somente os receivables que ainda não foram integrados com o erp
and rec.transaction_type = 'bank_transfer' -- Neste caso a integração de corporatepass repasse deve considerar somente boleto
and rec.erp_receivable_id is not null
and pay.erp_supplier_id is not null;