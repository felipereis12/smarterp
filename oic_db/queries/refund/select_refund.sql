select   
	
     inc.erp_customer_id
    ,otc.erp_business_unit
    ,otc.front_id
    ,otc.fin_id
    ,otc.minifactu_id
    ,recg.erp_set_of_books_id
    ,recg.erp_currency_code
    ,recg.erp_interface_line_context
    ,recg.erp_memo_line
    ,refund.refund_value
    ,rec.transaction_type
    ,rec.erp_payment_terms
    ,rec.conciliator_id
    ,ivcr.identification_financial_responsible
    ,ivcr.full_name
    ,rec.erp_clustered_receivable_id
    ,if(month(refund.issue_date)=month(current_date()),refund.issue_date,current_date()) as erp_trx_date
    ,if(month(refund.issue_date)=month(current_date()),refund.issue_date,current_date()) as erp_gl_date
from refund 

inner join invoice_customer inc
on inc.identification_financial_responsible = refund.refund_requester_identification

inner join order_to_cash otc
on otc.id = inc.order_to_cash_id
and otc.country = refund.country

inner join receivable rec
on rec.order_to_cash_id = otc.id

inner join receivable_erp_configurations recg
on  refund.country = otc.country
and refund.erp_business_unit = otc.erp_business_unit
and recg.origin_system = otc.origin_system
and recg.operation = otc.operation

inner join invoice inv
on otc.id = inv.erp_invoice_id

inner join invoice_customer ivcr
on otc.id = ivcr.order_to_cash_id

where otc.country = 'Brazil' -- Integração em paralalo por operação do país
and otc.erp_subsidiary = 'BR010001' -- Filtro por filial (loop automático)
and otc.origin_system = 'smartsystem' -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
and otc.operation = 'person_plan' -- Neste caso filtrar somente person_plan, pois a operação de refund só ocorre para os planos de alunos
and refund.erp_refund_status_transaction = 'waiting_to_be_process'
-- and invoice_customer.erp_customer_id is not null -- Filtrar somente os refuns que tiverem relacionamento com a invoice_customer, as quais já tiverem sido integradas com o erp
and rec.erp_clustered_receivable_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable
and rec.erp_clustered_receivable_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a customer 
-- and receivable.erp_receivable_id is not null -- Filtrar somente os receivables que já foram integrados com o erp



 
