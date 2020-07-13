update supplier 

inner join refund ref
on ref.refund_requester_identification = sup.identification_financial_responsible 

left join refund_erp_configurations recg
on  recg.country = ref.country
and recg.origin_system = ref.origin_system
and recg.operation = ref.operation

set 
 supplier.erp_supplier_returned_from_erp_at = current_timestamp -- colocar aqui o timestamp de retorno do processamento do erp
,supplier.erp_supplier_status_transaction = if(true /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'created_at_erp','error_trying_to_create_at_erp')
,supplier.erp_supplier_log = if(false /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'Aqui deve ser gravado o erro de processamento do oracle (verificar a possibilidade de tratamento do erro para melhor entendimento)',null)
,supplier.erp_supplier_id = if(true /*colocar aqui o boolean que define se a operação foi executada com sucesso ou não*/,'Aqui deve ser gravado o id único e imutável que representa o Supplier no oracle',null)

where 
supplier.identification_financial_responsible = '<Colocar aqui o código de identificação do fornecedor (cnpj)>'
and supplier.id = '<Colocar aqui o Id da Payable do registro que foi enviado para o Oracle>'