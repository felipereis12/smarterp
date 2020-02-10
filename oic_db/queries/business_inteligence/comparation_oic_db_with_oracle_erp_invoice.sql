select 
	 	 t1.country
		,t1.unity_identification
		,t1.erp_business_unit
		,t1.erp_subsidiary
		,t1.acronym
        ,date_format(t1.billing_date,'%Y%m') as billing_date
		,count(1) as quantity
		,round(sum(t1.gross_value),2) as gross_value
from (

select distinct 
		 otc.country
		,otc.unity_identification
		,otc.erp_business_unit
		,otc.erp_subsidiary
		,otc.acronym
		,otc.minifactu_id
        ,rec.billing_date
		,sum(iit.quantity*iit.sale_price) as gross_value
from invoice ivc

inner join invoice_items iit
on iit.id_invoice = ivc.id

inner join order_to_cash otc
on otc.id = ivc.order_to_cash_id

inner join receivable rec
on rec.order_to_cash_id = otc.id

inner join invoice_customer ivcr
on ivcr.order_to_cash_id = otc.id

inner join customer cus
on cus.identification_financial_responsible = otc.erp_receivable_customer_identification

left join order_to_cash otc_v2
on otc_v2.minifactu_id = otc.minifactu_id
and otc_v2.erp_receivable_status_transaction in ('created_at_erp')
and otc_v2.id = ( 
					select 
						max(otc_v3.id) 
					from order_to_cash otc_v3 
                    where otc_v3.minifactu_id = otc_v2.minifactu_id
                    and otc_v3.erp_receivable_status_transaction = otc_v2.erp_receivable_status_transaction
				) 

left join receivable rec_v2
on rec_v2.order_to_cash_id = otc_v2.id
 and rec_v2.erp_receivable_id is not null

left join invoice_erp_configurations iec
on iec.country = otc.country
and iec.erp_business_unit = otc.erp_business_unit
and iec.erp_legal_entity = otc.erp_legal_entity
and iec.erp_subsidiary = otc.erp_subsidiary
and iec.origin_system = otc.origin_system
and iec.operation = otc.operation
and iec.to_generate_fiscal_document = 'yes'

inner join organization_from_to_version oftv
on oftv.erp_business_unit = otc.erp_business_unit
and oftv.erp_legal_entity = otc.erp_legal_entity
and oftv.erp_subsidiary = otc.erp_subsidiary
and oftv.created_at = 	(
							select
								max(oftv_v2.created_at) as created_at
							from organization_from_to_version oftv_v2
                            where oftv_v2.erp_business_unit = oftv.erp_business_unit
                            and oftv_v2.erp_legal_entity = oftv.erp_legal_entity
                            and oftv_v2.erp_subsidiary = oftv.erp_subsidiary
						)

where otc.country in ('Brazil') -- Este campo define o país da transação - ENUM('Brazil', 'Mexico', 'Colombia', 'Chile', 'Peru', 'Paraguay', 'Argentina', 'CostaRica', 'Guatemala', 'Ecuador', 'DominicanRepublic', 'Panama', 'ElSalvador')
and otc.unity_identification in (11) -- Este campo representa um id único e imutável que representa todas as unidades operacionais ou administrativa de toda empresa (é utilizado entre todas as soluções) - utilize a query para verificar todas as possibilidades: select oftv.organization_from_to_unity_identification , oftv.* from organization_from_to_version oftv
and otc.erp_business_unit in ('BR01 - SMARTFIT') -- Este campo representa a business unit (empresa) da transação - Este campo só tem contexto dentro do Oracle ERP
and otc.erp_subsidiary in ('BR010011') -- Este campo representa a subsidiary (filial) da transação - Este campo só tem contexto dentro do Oracle ERP
and otc.to_generate_invoice = 'yes'
and otc.origin_system in ('smartsystem','biosystem','racesystem','nossystem') 
and otc.operation = 'person_plan' 
and ivc.erp_invoice_customer_id is not null -- Filtrar somente as invoices cujos os clientes já foram integrados anteriormente
and iit.to_generate_fiscal_document = 'yes' -- Tratamento para exclusão de itens de multa contratual, pois haverá uma integração separada para tal
and ( otc.erp_receivable_status_transaction = 'created_at_erp' or otc_v2.erp_receivable_status_transaction = 'created_at_erp' )-- Filtrar as transações cujos receivables que já foram integrados no erp
and ( rec.erp_receivable_id is not null or rec_v2.erp_receivable_id is not null ) -- Filtrar somente os receivables que já foram integrados
and rec.billing_date between '2019-12-01' and '2019-12-31'  -- Este campo representa a data de cobrança do pagamento do aluno cobrado pelo front
and ( rec.contract_number in ('01425787000104','90400888000142','60701190000104','00360305000104','60746948000112','01027058000191','1109194061','81399952','PV816552') or rec.contract_number is null) -- Este campo representa o código de contrato com as adquirentes, pode ser utilizado para filtra o estabelecimento - só será preenchido para as operações de cartão de crédito - somente preenchido para as transações via cartão de crédito
and ( rec.credit_card_brand in ('MASTER', 'VISA', 'AMEX', 'ELO', 'DINNERS', 'HIPERCARD') or rec.credit_card_brand is null) -- Este campo representa a banda do cartão de crédito para as operações de cartão de crédito, para as demais este campo será nulo - somente preenchido para as transações via cartão de crédito
and rec.transaction_type in ('credit_card_recurring', 'debit_card_recurring', 'debit_account_recurring', 'credit_card_tef', 'debit_card_tef', 'credit_card_pos', 'debit_card_pos', 'cash', 'boleto', 'bank_transfer', 'online_credit_card', 'online_debit_card') -- Tipo da transação no contexto de pagamentos - através deste campo poderá filtra o 'Produto' (Crédito, Débito ou Débito em Conta)
and ( cus.chargeback_acquirer_label in ('CIELO','REDE','BRADESCO','CAIXA','ITAU','SANTANDER','SMARTFIN') or cus.chargeback_acquirer_label is null) -- Campo que representa a adquirente/banco - somente preenchido para as transações via cartão de crédito
and day(current_date()) <= oftv.cutoff_limit_day -- Regra de cutoff

group by otc.country
		,otc.unity_identification
		,otc.erp_business_unit
		,otc.erp_subsidiary
		,otc.acronym
		,otc.minifactu_id
        ,rec.billing_date

) as t1

group by t1.country
		,t1.unity_identification
		,t1.erp_business_unit
		,t1.erp_subsidiary
		,t1.acronym
        ,date_format(t1.billing_date,'%Y%m')

order by 1,2,3