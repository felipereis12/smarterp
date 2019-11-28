update payable 

set payable.erp_payable_returned_from_erp_at = current_timestamp -- colocar aqui o timestamp de retorno do processamento do erp
,payable.erp_payable_status_transaction = if(true /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'created_at_erp','error_trying_to_create_at_erp')
,payable.erp_payable_log = if(false /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'Aqui deve ser gravado o erro de processamento do oracle (verificar a possibilidade de tratamento do erro para melhor entendimento)',null)
,payable.erp_payable_id = if(true /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'Aqui deve ser gravado o id único e imutável que representa o receivable no oracle',null)

where payable.erp_business_unit = '<Colocar aqui o código da Business Unit do movimento>'
and payable.erp_legal_entity = '<Colocar aqui o código da Legal Entity do movimento>'
and payable.erp_subsidiary = '<Colocar aqui o código da Subsidiary do movimento>'
and payable.id = '<Colocar aqui o Id da Receivable do registro que foi enviado para o Oracle>';