select 
     order_to_cash.erp_business_unit
    ,order_to_cash.erp_legal_entity
    ,order_to_cash.erp_subsidiary
    ,order_to_cash.acronym
	,receivable.* -- Utilizar aqui somente os campos necessários para a integração
    ,order_to_cash.* -- Utilizar aqui somente os campos necessários para a integração
    ,clustered_receivable_customer.* -- Utilizar aqui somente os campos necessários para a integração
from receivable 

inner join order_to_cash
on order_to_cash.id = receivable.order_to_cash_id

inner join clustered_receivable_customer
on clustered_receivable_customer.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification

where order_to_cash.country = 'Brazil' -- Integração em paralalo por operação do país
and order_to_cash.erp_subsidiary = 'BR020001' -- Neste caso como haverá uma integração separada para os movimentos Smartfin esse filtro deverá ser fixo para tais movimentos
and order_to_cash.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and order_to_cash.operation = 'person_plan' -- Integração em paralalo por operação (plano de alunos, plano corporativo, etc...)
and order_to_cash.erp_receivable_status_transaction = 'clustered_receivable_created' -- Filtrar somente os registros que ainda não foram integrados com o erp e estão aguardando processamento
and order_to_cash.to_generate_receivable = 'yes'
and receivable.erp_clustered_receivable_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable
and receivable.erp_clustered_receivable_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable_customer 
and receivable.erp_receivable_id is null -- Filtrar somente os receivables que ainda não foram integrados com o erp
and receivable.transaction_type = 'credit_card_recurring' -- Integração em paralalo por tipo de transação (Cartão de crédito recorrente, cartão de débito recorrente, débito em conta, boleto etc...)