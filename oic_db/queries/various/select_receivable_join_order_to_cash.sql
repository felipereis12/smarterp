select 
     order_to_cash.erp_business_unit
    ,order_to_cash.erp_legal_entity
    ,order_to_cash.erp_subsidiary
    ,order_to_cash.acronym
	,receivable.* -- Utilizar aqui somente os campos necessários para a integração
    ,order_to_cash.* -- Utilizar aqui somente os campos necessários para a integração
    ,customer.* -- Utilizar aqui somente os campos necessários para a integração
from receivable 

inner join order_to_cash
on order_to_cash.id = receivable.order_to_cash_id

inner join customer
on customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

where order_to_cash.country = 'Brazil' -- Integração por operação do país
and order_to_cash.erp_subsidiary = 'BR010001' -- Filtro por filial (loop automático)
and order_to_cash.origin_system = 'smartsystem' -- Integração por origem (SmartFit, BioRitmo, etc...)
and order_to_cash.operation = 'person_plan' -- Integração por operação (plano de alunos, plano corporativo, etc...)
and receivable.erp_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a customer 
and receivable.erp_receivable_id is null -- Filtrar somente os receivables que ainda não foram integrados com o erp
and receivable.erp_receivable_id is null -- Filtrar somente os receivables que ainda não foram integrados com o erp;