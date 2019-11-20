update receivable 

inner join order_to_cash
on order_to_cash.id = receivable.order_to_cash_id

inner join clustered_receivable
on clustered_receivable.id = receivable.erp_clustered_receivable_id

set order_to_cash.erp_receivable_returned_from_erp_at = current_timestamp -- colocar aqui o timestamp de retorno do processamento do erp
,order_to_cash.erp_receivable_status_transaction = if(true /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'created_at_erp','error_trying_to_create_at_erp')
,order_to_cash.erp_receivable_log = if(false /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'Aqui deve ser gravado o erro de processamento do oracle (verificar a possibilidade de tratamento do erro para melhor entendimento)',null)
,receivable.erp_receivable_id = if(true /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'Aqui deve ser gravado o id único e imutável que representa o receivable no oracle',null)

where order_to_cash.erp_business_unit = '<Colocar aqui o código da Business Unit do movimento>'
and order_to_cash.erp_legal_entity = '<Colocar aqui o código da Legal Entity do movimento>'
and order_to_cash.erp_subsidiary = '<Colocar aqui o código da Subsidiary do movimento>'
and receivable.erp_receivable_id = '<Colocar aqui o Id clustered_receivable do registro que foi enviado para o Oracle>'
and receivable.id = '<Colocar aqui o Id da Receivable do registro que foi enviado para o Oracle>';