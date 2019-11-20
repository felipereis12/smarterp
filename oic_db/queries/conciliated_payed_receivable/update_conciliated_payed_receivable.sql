update conciliated_payed_receivable 

inner join receivable
on receivable.conciliator_id = conciliated_payed_receivable.conciliator_id
and receivable.erp_clustered_receivable_id is not null -- Considerar somente os receivables que já foram convertidos em clustered_receivable, ou seja, que já foram aglutinados
and receivable.erp_clustered_receivable_customer_id is not null -- Considerar somente os receivables que já foram convertidos em clustered_receivable, ou seja, que já foram aglutinados

inner join order_to_cash
on order_to_cash.id = receivable.order_to_cash_id

set conciliated_payed_receivable.erp_receipt_returned_from_erp_at = current_timestamp -- colocar aqui o timestamp de retorno do processamento do erp
,conciliated_payed_receivable.erp_receipt_status_transaction = if(true /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'created_at_erp','error_trying_to_create_at_erp')
,conciliated_payed_receivable.erp_receipt_log = if(false /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'Aqui deve ser gravado o erro de processamento do oracle (verificar a possibilidade de tratamento do erro para melhor entendimento)',null)
,conciliated_payed_receivable.erp_receipt_id = if(true /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'Aqui deve ser gravado o id único e imutável que representa o receipt no oracle',null)
,order_to_cash.erp_receipt_returned_from_erp_at = current_timestamp -- colocar aqui o timestamp de retorno do processamento do erp
,order_to_cash.erp_receipt_status_transaction = if(true /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'created_at_erp','error_trying_to_create_at_erp')
,order_to_cash.erp_receipt_log = if(false /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'Aqui deve ser gravado o erro de processamento do oracle (verificar a possibilidade de tratamento do erro para melhor entendimento)',null)
,receivable.erp_receipt_id = if(true /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'Aqui deve ser gravado o id único e imutável que representa o receipt no oracle',null)

where order_to_cash.erp_business_unit = '<Colocar aqui o código da Business Unit do movimento>'
and order_to_cash.erp_legal_entity = '<Colocar aqui o código da Legal Entity do movimento>'
and order_to_cash.erp_subsidiary = '<Colocar aqui o código da Subsidiary do movimento>'
and receivable.erp_receivable_id = '<Colocar aqui o Id clustered_receivable do registro que foi enviado para o Oracle>'
and receivable.id = '<Colocar aqui o Id da Receivable do registro que foi enviado para o Oracle>';