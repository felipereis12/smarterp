update invoice 

inner join order_to_cash
on order_to_cash.id = invoice.order_to_cash_id

set invoice.fiscal_id = '<Colocar aqui o número da nota fiscal da prefeitura/Sefaz>'
,invoice.fiscal_series = '<Colocar aqui a série da nota fiscal da prefeitura/Sefaz>'
,invoice.fiscal_authentication_code = '<Colocar aqui o código de autenticação da prefeitura/Sefaz>'
,invoice.fiscal_model = '<Colocar aqui o modelo de nota fiscal (nfe, nfse ou nfce) >'
,invoice.fiscal_authorization_datetime = '<Colocar aqui a data e hora de autorização da nota fiscal da prefeitura/Sefaz >'

where order_to_cash.erp_business_unit = '<Colocar aqui a Business Unit do movimento>'
and order_to_cash.erp_legal_entity = '<Colocar aqui a Legal Entity do movimento>'
and order_to_cash.erp_subsidiary = '<Colocar aqui a Subsidiary do movimento>'
and order_to_cash.minifactu_id = '<Colocar aqui a Id do Minifactu do movimento>'
and invoice.erp_invoice_id = '<Colocar aqui o Id da Invoice gerada no Oracle>';