select 
     order_to_cash.erp_business_unit
    ,order_to_cash.erp_legal_entity
    ,order_to_cash.erp_subsidiary
    ,order_to_cash.acronym
    ,receivable.* -- Utilizar aqui somente os campos necessários para a integração
	,invoice.* -- Utilizar aqui somente os campos necessários para a integração
	,invoice_items.* -- Utilizar aqui somente os campos necessários para a integração    
    ,order_to_cash.* -- Utilizar aqui somente os campos necessários para a integração
from invoice 

inner join invoice_items
on invoice_items.id_invoice = invoice.id

inner join order_to_cash
on order_to_cash.id = invoice.order_to_cash_id

inner join receivable
on order_to_cash.id = receivable.order_to_cash_id

where order_to_cash.country = 'Brazil' -- Integração em paralelo por operação do país
and order_to_cash.erp_subsidiary = 'BR010001' -- Filtro por filial (loop automático)
and order_to_cash.origin_system = 'smartsystem' -- Integração em paralelo por origem (SmartFit, BioRitmo, etc...)
and order_to_cash.operation = 'royalties' -- Integração em paralelo por operação (plano de alunos, plano corporativo, etc...)
and order_to_cash.to_generate_invoice = 'yes'
and order_to_cash.erp_invoice_status_transaction = 'waiting_to_be_process' -- Filtrar somente os registros que ainda não foram integrados com o erp e estão aguardando processamento
and invoice.erp_invoice_customer_id is not null -- Filtrar somente as invoices cujos os clientes já foram integrados anteriormente
and invoice.erp_invoice_id is null -- Filtrar somente as invoices que ainda não foram integrados com o erp