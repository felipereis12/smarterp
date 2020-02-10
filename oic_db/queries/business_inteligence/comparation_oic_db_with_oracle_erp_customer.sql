-- Esta query deverá ser utilizada para o monitoramento das integrçaões de BI - oic_db <-> oracle erp customer
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
		,rec.gross_value 
from order_to_cash otc

inner join invoice_customer ivc
on otc.id = ivc.order_to_cash_id

inner join receivable rec
on otc.id = rec.order_to_cash_id

inner join customer cus
on cus.identification_financial_responsible = otc.erp_receivable_customer_identification

inner join invoice_customer_comparation ivcc 
on ivc.erp_customer_id = ivcc.erp_customer_id 
and ivc.identification_financial_responsible = ivcc.identification_financial_responsible

where otc.country in ('Brazil') -- Este campo define o país da transação - ENUM('Brazil', 'Mexico', 'Colombia', 'Chile', 'Peru', 'Paraguay', 'Argentina', 'CostaRica', 'Guatemala', 'Ecuador', 'DominicanRepublic', 'Panama', 'ElSalvador')
and otc.unity_identification in (11) -- Este campo representa um id único e imutável que representa todas as unidades operacionais ou administrativa de toda empresa (é utilizado entre todas as soluções) - utilize a query para verificar todas as possibilidades: select oftv.organization_from_to_unity_identification , oftv.* from organization_from_to_version oftv
and otc.erp_business_unit in ('BR01 - SMARTFIT') -- Este campo representa a business unit (empresa) da transação - Este campo só tem contexto dentro do Oracle ERP
and otc.erp_subsidiary in ('BR010011') -- Este campo representa a subsidiary (filial) da transação - Este campo só tem contexto dentro do Oracle ERP
and otc.to_generate_customer = 'yes'
and otc.origin_system in ('smartsystem','biosystem','racesystem','nossystem') 
and otc.operation = 'person_plan' 
and rec.billing_date between '2019-12-01' and '2019-12-31'  -- Este campo representa a data de cobrança do pagamento do aluno cobrado pelo front
and ( rec.contract_number in ('01425787000104','90400888000142','60701190000104','00360305000104','60746948000112','01027058000191','1109194061','81399952','PV816552') or rec.contract_number is null) -- Este campo representa o código de contrato com as adquirentes, pode ser utilizado para filtra o estabelecimento - só será preenchido para as operações de cartão de crédito - somente preenchido para as transações via cartão de crédito
and ( rec.credit_card_brand in ('MASTER', 'VISA', 'AMEX', 'ELO', 'DINNERS', 'HIPERCARD') or rec.credit_card_brand is null) -- Este campo representa a banda do cartão de crédito para as operações de cartão de crédito, para as demais este campo será nulo - somente preenchido para as transações via cartão de crédito
and rec.transaction_type in ('credit_card_recurring', 'debit_card_recurring', 'debit_account_recurring', 'credit_card_tef', 'debit_card_tef', 'credit_card_pos', 'debit_card_pos', 'cash', 'boleto', 'bank_transfer', 'online_credit_card', 'online_debit_card') -- Tipo da transação no contexto de pagamentos - através deste campo poderá filtra o 'Produto' (Crédito, Débito ou Débito em Conta)
and rec.administration_tax_value between 0 and 99999999 -- Campo que representa o valor de taxa da adquirente por operação
and rec.interest_value between 0 and 99999999 -- Campo que representa o juros/mora
and rec.gross_value between 0 and 99999999 -- Campo que representa o valor bruto da transação
and ( cus.chargeback_acquirer_label in ('CIELO','REDE','BRADESCO','CAIXA','ITAU','SANTANDER','SMARTFIN') or cus.chargeback_acquirer_label is null) -- Campo que representa a adquirente/banco - somente preenchido para as transações via cartão de crédito
and (
	   ivc.erp_customer_id <> ivcc.erp_customer_id
	or ivc.full_name <> ivcc.full_name
	or ivc.type_person <> ivcc.type_person
	or ivc.nationality_code <> ivcc.nationality_code
	or ivc.state <> ivcc.state
	or ivc.city <> ivcc.city
	or ivc.adress <> ivcc.adress
	or ivc.adress_number <> ivcc.adress_number
	or ivc.adress_complement <> ivcc.adress_complement 
	or ivc.district <> ivcc.district
	or ivc.postal_code <> ivcc.postal_code
	or ivc.area_code <> ivcc.area_code
	or ivc.cellphone <> ivcc.cellphone
	or ivc.email <> ivcc.email
	or ivc.state_registration <> ivcc.state_registration
	or ivc.federal_registration <> ivcc.federal_registration
	or ivc.final_consumer <> ivcc.final_consumer
	or ivc.icms_contributor <> ivcc.icms_contributor
)
                
union

select distinct 
		 otc.country
		,otc.unity_identification
		,otc.erp_business_unit
		,otc.erp_subsidiary
		,otc.acronym
		,otc.minifactu_id
        ,rec.billing_date
		,rec.gross_value 
from order_to_cash otc

inner join invoice_customer ivc
on otc.id = ivc.order_to_cash_id

inner join receivable rec
on otc.id = rec.order_to_cash_id

inner join customer cus
on cus.identification_financial_responsible = otc.erp_receivable_customer_identification

where otc.country in ('Brazil') -- Este campo define o país da transação - ENUM('Brazil', 'Mexico', 'Colombia', 'Chile', 'Peru', 'Paraguay', 'Argentina', 'CostaRica', 'Guatemala', 'Ecuador', 'DominicanRepublic', 'Panama', 'ElSalvador')
and otc.unity_identification in (11) -- Este campo representa um id único e imutável que representa todas as unidades operacionais ou administrativa de toda empresa (é utilizado entre todas as soluções) - utilize a query para verificar todas as possibilidades: select oftv.organization_from_to_unity_identification , oftv.* from organization_from_to_version oftv
and otc.erp_business_unit in ('BR01 - SMARTFIT') -- Este campo representa a business unit (empresa) da transação - Este campo só tem contexto dentro do Oracle ERP
and otc.erp_subsidiary in ('BR010011') -- Este campo representa a subsidiary (filial) da transação - Este campo só tem contexto dentro do Oracle ERP
and otc.to_generate_customer = 'yes'
and otc.origin_system in ('smartsystem','biosystem','racesystem','nossystem') 
and otc.operation = 'person_plan' 
and rec.billing_date between '2019-12-01' and '2019-12-31'  -- Este campo representa a data de cobrança do pagamento do aluno cobrado pelo front
and ( rec.contract_number in ('01425787000104','90400888000142','60701190000104','00360305000104','60746948000112','01027058000191','1109194061','81399952','PV816552') or rec.contract_number is null) -- Este campo representa o código de contrato com as adquirentes, pode ser utilizado para filtra o estabelecimento - só será preenchido para as operações de cartão de crédito - somente preenchido para as transações via cartão de crédito
and ( rec.credit_card_brand in ('MASTER', 'VISA', 'AMEX', 'ELO', 'DINNERS', 'HIPERCARD') or rec.credit_card_brand is null) -- Este campo representa a banda do cartão de crédito para as operações de cartão de crédito, para as demais este campo será nulo - somente preenchido para as transações via cartão de crédito
and rec.transaction_type in ('credit_card_recurring', 'debit_card_recurring', 'debit_account_recurring', 'credit_card_tef', 'debit_card_tef', 'credit_card_pos', 'debit_card_pos', 'cash', 'boleto', 'bank_transfer', 'online_credit_card', 'online_debit_card') -- Tipo da transação no contexto de pagamentos - através deste campo poderá filtra o 'Produto' (Crédito, Débito ou Débito em Conta)
and rec.administration_tax_value between 0 and 99999999 -- Campo que representa o valor de taxa da adquirente por operação
and rec.interest_value between 0 and 99999999 -- Campo que representa o juros/mora
and rec.gross_value between 0 and 99999999 -- Campo que representa o valor bruto da transação
and ( cus.chargeback_acquirer_label in ('CIELO','REDE','BRADESCO','CAIXA','ITAU','SANTANDER','SMARTFIN') or cus.chargeback_acquirer_label is null) -- Campo que representa a adquirente/banco - somente preenchido para as transações via cartão de crédito



) as t1

group by t1.country
		,t1.unity_identification
		,t1.erp_business_unit
		,t1.erp_subsidiary
		,t1.acronym
        ,date_format(t1.billing_date,'%Y%m')

order by 1,2,3