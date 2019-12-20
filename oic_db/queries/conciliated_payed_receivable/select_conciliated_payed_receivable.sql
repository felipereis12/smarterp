select 
	otc.id
	,otc.erp_business_unit
    ,otc.erp_subsidiary
    ,crc.identification_financial_responsible
    ,cpr.bank_number
    ,cpr.bank_branch
    ,cpr.bank_account
	,cpr.created_at
    ,concat ('RD_',cpr.bank_number,'_',cpr.bank_branch,'_',cpr.bank_account) as Receipt_Method
    ,rec.conciliator_id
    ,rec.credit_card_brand
    ,rec.contract_number
    ,rec.transaction_type
    ,rec.credit_date
    ,rec.credit_card_brand
    ,if (rec.transaction_type in ('credit_card_recurring','credit_card_tef','credit_card_pos','online_credit_card'), 'CARTOES DE CREDITO', 
          if (rec.transaction_type = 'debit_account_recurring', 'DEPOSITO EM CONTA CORRENTE', 
 		     if (rec.transaction_type in ('debit_card_tef','debit_card_pos','online_debit_card'), 'CARTOES DE DEBITO', 
			     if (rec.transaction_type = 'debit_card_recurring','DEBITO SEM SENHA', 
                    if (rec.transaction_type = 'bank_transfer', 'TRANSFERENCIA BANCARIA', 
                       if (rec.transaction_type = 'cash', 'DINHEIRO', 
                          if (rec.transaction_type = 'boleto', 'BOLETO', null)
                       )
                    )
                 )
             )
		)
         
	) as transaction_type
    ,cus.full_name
from conciliated_payed_receivable cpr

inner join receivable rec
on rec.conciliator_id = cpr.conciliator_id
and rec.erp_clustered_receivable_id is not null -- Considerar somente os receivables que já foram convertidos em clustered_receivable, ou seja, que já foram aglutinados
and rec.erp_clustered_receivable_customer_id is not null -- Considerar somente os receivables que já foram convertidos em clustered_receivable, ou seja, que já foram aglutinados
and rec.converted_smartfin <> 'yes'

inner join customer cus
on cus.erp_customer_id = rec.erp_receivable_customer_id

inner join customer crc
on crc.erp_customer_id = rec.erp_clustered_receivable_customer_id

inner join order_to_cash otc
on otc.country = cpr.country
and otc.id = rec.order_to_cash_id

where cpr.country = 'Brazil' -- Cada país deverá ter um processamento separado
and otc.origin_system = 'smartsystem' -- Cada origem deverá ter um processamento separado
and otc.operation = 'person_plan' -- Cada operação deverá ter um processamento separado
and rec.transaction_type = 'credit_card_recurring' -- Cada tipo de transação deverá ter um processamento separado
and rec.erp_receivable_id is not null
and cpr.erp_receipt_status_transaction = 'waiting_to_be_process'
and cpr.erp_receipt_id is null
and cpr.concitiation_type = 'PCV'; -- Considerar somente os retornos de comprovante de recebimento enviado pela conciliadora
