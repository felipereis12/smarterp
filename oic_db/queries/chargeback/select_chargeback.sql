select 
	chargeback.* 
    ,clustered_receivable_customer.erp_customer_id
    ,clustered_receivable_customer.full_name
    ,clustered_receivable_customer.identification_financial_responsible
from chargeback

inner join receivable
on receivable.conciliator_id = chargeback.conciliator_id
and receivable.erp_clustered_receivable_id is not null -- Considerar somente os receivables que já foram convertidos em clustered_receivable, ou seja, que já foram aglutinados
and receivable.erp_clustered_receivable_customer_id is not null -- Considerar somente os receivables que já foram convertidos em clustered_receivable, ou seja, que já foram aglutinados

inner join clustered_receivable_customer
on clustered_receivable_customer.erp_customer_id = receivable.erp_clustered_receivable_customer_id

inner join order_to_cash
on order_to_cash.country = chargeback.country
and order_to_cash.id = receivable.order_to_cash_id

where chargeback.country = 'Brazil' -- Cada país deverá ter um processamento separado
and order_to_cash.origin_system = 'smartsystem' -- Cada origem deverá ter um processamento separado
and order_to_cash.operation = 'person_plan' -- Cada operação deverá ter um processamento separado
and receivable.transaction_type = 'credit_card_recurring' -- Cada tipo de transação deverá ter um processamento separado
and chargeback.erp_receipt_status_transaction = 'clustered_chargeback_created'
and chargeback.erp_clustered_chargeback_id is not null
and chargeback.erp_receipt_id is null
and chargeback.concitiation_type = 'CHBK'; -- Considerar somente os retornos de comprovante de recebimento enviado pela conciliadora 