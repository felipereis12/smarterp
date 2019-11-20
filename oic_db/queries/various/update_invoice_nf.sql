update invoice

inner join order_to_cash
on order_to_cash.id = invoice.order_to_cash_id

set fiscal_id = '<Gravar aqui o número de nota fiscal retornado pela prefeitura através da Synchro>'
,fiscal_series = '<Gravar aqui a serie da nota fiscal retornado pela prefeitura através da Synchro>'
,fiscal_authentication_code = '<Gravar aqui o código de autenticação da nota fiscal retornado pela prefeitura através da Synchro>'
,fiscal_model = '<Gravar aqui o tipo da nota fiscal (nfse, nfce ou nfe) retornado pela prefeitura através da Synchro>'
,fiscal_authorization_datetime = '<Gravar aqui o timestamp da emissão da nota fiscal retornado pela prefeitura através da Synchro>'

where erp_invoice_id = '<Utilizar aqui o id da invoice do erp>'
and erp_invoice_customer_id = '<Utilizar aqui o id do cliente do erp>'
and order_to_cash.erp_business_unit = '<Utilizar aqui a business unit do erp>'
and order_to_cash.erp_legal_entity = '<Utilizar aqui a legal entity do erp>'
and order_to_cash.erp_subsidiary = '<Utilizar aqui a subsidiary do erp>'