select
		sup.id,
		otc.origin_system,
        otc.operation,
		sup.identification_financial_responsible,
		sup.full_name,
		sup.adress,
		sup.adress_number,
		sup.adress_complement,
		sup.district,
		sup.city,
		sup.state,
		sup.postal_code,
		sup.nationality_code,
		sup.area_code,
		sup.cellphone,
		sup.email
from supplier sup

inner join payable pay
on pay.supplier_identification = sup.identification_financial_responsible

inner join receivable rec
on rec.id = pay.receivable_id

inner join order_to_cash otc
on otc.id = rec.order_to_cash_id

where otc.country = 'Brazil' -- Integração em paralalo por operação do país
and otc.erp_subsidiary = 'BR020001' -- Neste caso a filial deve ser fixa
and otc.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and otc.operation = 'franchise_conciliator' -- Integração em paralalo por operação (plano de alunos, plano corporativo, etc...)
and rec.erp_receivable_id is not null -- Filtrar somente os receivables que ainda não foram integrados com o erp
and sup.erp_supplier_id is null
and rec.transaction_type = 'credit_card_recurring' ;-- Integração em paralalo por tipo de transação (Cartão de crédito recorrente, cartão de débito recorrente, débito em conta, boleto etc...)