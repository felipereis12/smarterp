update chargeback 

set chargeback.erp_receipt_returned_from_erp_at = current_timestamp -- colocar aqui o timestamp de retorno do processamento do erp
,chargeback.erp_receipt_status_transaction = if(true /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'created_at_erp','error_trying_to_create_at_erp')
,chargeback.erp_receipt_log = if(false /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'Aqui deve ser gravado o erro de processamento do oracle (verificar a possibilidade de tratamento do erro para melhor entendimento)',null)
,chargeback.erp_receipt_id = if(true /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'Aqui deve ser gravado o id único e imutável que representa o chargeback no oracle',null)

where chargeback.id = '<Colocar aqui o Id da chargeback do registro que foi enviado para o Oracle>';