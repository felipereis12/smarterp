select  
	 refund.*  -- Utilizar aqui somente os campos necessários para a integração
    ,invoice_customer.erp_customer_id
    ,invoice_customer.*  -- Utilizar aqui somente os campos necessários para a integração
    ,receivable.*  -- Utilizar aqui somente os campos necessários para a integração
from refund 

inner join invoice_customer
on invoice_customer.identification_financial_responsible = refund.refund_requester_identification

inner join order_to_cash
on order_to_cash.id = invoice_customer.order_to_cash_id
and order_to_cash.country = refund.country

inner join receivable
on receivable.order_to_cash_id = order_to_cash.id

where order_to_cash.country = 'Brazil' -- Integração em paralalo por operação do país
and order_to_cash.erp_subsidiary = 'BR010001' -- Filtro por filial (loop automático)
and order_to_cash.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and order_to_cash.operation = 'person_plan' -- Neste caso filtrar somente person_plan, pois a operação de refund só ocorre para os planos de alunos
and refund.erp_refund_status_transaction = 'waiting_to_be_process'
-- and invoice_customer.erp_customer_id is not null -- Filtrar somente os refuns que tiverem relacionamento com a invoice_customer, as quais já tiverem sido integradas com o erp
and receivable.erp_clustered_receivable_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable
and receivable.erp_clustered_receivable_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable_customer 
-- and receivable.erp_receivable_id is not null -- Filtrar somente os receivables que já foram integrados com o erp