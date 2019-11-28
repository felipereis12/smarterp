select 
	cchbk.* 
    ,chbk.* 
    ,crc.erp_customer_id
    ,crc.full_name
    ,crc.identification_financial_responsible
from chargeback chbk

inner join clustered_chargeback cchbk
on cchbk.id = chbk.erp_clustered_chargeback_id

inner join receivable rec
on rec.conciliator_id = chbk.conciliator_id
and rec.erp_clustered_receivable_id is not null -- Considerar somente os receivables que já foram convertidos em clustered_receivable, ou seja, que já foram aglutinados
and rec.erp_clustered_receivable_customer_id is not null -- Considerar somente os receivables que já foram convertidos em clustered_receivable, ou seja, que já foram aglutinados
and rec.converted_smartfin <> 'yes'

inner join customer crc
on crc.erp_customer_id = rec.erp_clustered_receivable_customer_id

inner join order_to_cash otc
on otc.country = chbk.country
and otc.id = rec.order_to_cash_id

where chbk.country = 'Brazil' -- Cada país deverá ter um processamento separado
and otc.origin_system = 'smartsystem' -- Cada origem deverá ter um processamento separado
and otc.operation = 'person_plan' -- Cada operação deverá ter um processamento separado
and rec.transaction_type = 'credit_card_recurring' -- Cada tipo de transação deverá ter um processamento separado
and chbk.erp_receipt_status_transaction = 'clustered_chargeback_created'
and chbk.erp_clustered_chargeback_id is not null
and chbk.erp_receipt_id is null
and chbk.concitiation_type = 'CHBK'; -- Considerar somente os retornos de comprovante de recebimento enviado pela conciliadora 