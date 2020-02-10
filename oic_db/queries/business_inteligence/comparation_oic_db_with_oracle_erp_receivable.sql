select 
	 	 t1.country
		,t1.unity_identification
		,t1.erp_business_unit
		,t1.erp_subsidiary
		,t1.acronym
        ,date_format(t1.billing_date,'%Y%m') as billing_date
		,count(1) as quantity
		,round(sum(t1.gross_value),2) as gross_value 
		,round(sum(t1.administration_tax_value),2) as administration_tax_value 
		,round(sum(t1.interest_value),2) as interest_value 
from (

select distinct 
		 t0.country
		,t0.unity_identification
		,t0.erp_business_unit
		,t0.erp_subsidiary
		,t0.acronym
		,t0.minifactu_id
        ,t0.billing_date
		,sum(t0.gross_value) as gross_value
		,sum(t0.administration_tax_value) as administration_tax_value
		,sum(t0.interest_value) as interest_value

from (
/*
gross_value => valor serviço/mercadororia + juros/mora
net_value => valor serviço/mercadororia + juros/mora - taxa operadora
interest_value => juros/mora
*/
/*Valores bruto da venda*/
select distinct 
		 otc.country
		,otc.unity_identification
		,otc.erp_business_unit
		,otc.erp_subsidiary
		,otc.acronym
		,otc.minifactu_id
        ,rec.billing_date
		,rec.gross_value 
		,0 as administration_tax_value 
		,0 as interest_value
from receivable rec

inner join order_to_cash otc
on otc.id = rec.order_to_cash_id

inner join customer cus
on cus.identification_financial_responsible = otc.erp_receivable_customer_identification

left join receivable_erp_configurations recg
on recg.country = otc.country
and recg.origin_system = otc.origin_system
and recg.operation = otc.operation
and recg.transaction_type = rec.transaction_type
and recg.converted_smartfin = rec.converted_smartfin
and recg.erp_business_unit = otc.erp_business_unit
and recg.memoline_setting = 'gross_value'

where otc.country in ('Brazil') -- Este campo define o país da transação - ENUM('Brazil', 'Mexico', 'Colombia', 'Chile', 'Peru', 'Paraguay', 'Argentina', 'CostaRica', 'Guatemala', 'Ecuador', 'DominicanRepublic', 'Panama', 'ElSalvador')
and otc.unity_identification in (11) -- Este campo representa um id único e imutável que representa todas as unidades operacionais ou administrativa de toda empresa (é utilizado entre todas as soluções) - utilize a query para verificar todas as possibilidades: select oftv.organization_from_to_unity_identification , oftv.* from organization_from_to_version oftv
and otc.erp_business_unit in ('BR01 - SMARTFIT') -- Este campo representa a business unit (empresa) da transação - Este campo só tem contexto dentro do Oracle ERP
and otc.erp_subsidiary in ('BR010011') -- Este campo representa a subsidiary (filial) da transação - Este campo só tem contexto dentro do Oracle ERP
and otc.to_generate_receivable = 'yes'
and otc.origin_system in ('smartsystem','biosystem','racesystem','nossystem') 
and otc.operation = 'person_plan' 
and rec.erp_clustered_receivable_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable
and rec.erp_clustered_receivable_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a customer 
and rec.billing_date between '2019-12-01' and '2019-12-31'  -- Este campo representa a data de cobrança do pagamento do aluno cobrado pelo front
and ( rec.contract_number in ('01425787000104','90400888000142','60701190000104','00360305000104','60746948000112','01027058000191','1109194061','81399952','PV816552') or rec.contract_number is null) -- Este campo representa o código de contrato com as adquirentes, pode ser utilizado para filtra o estabelecimento - só será preenchido para as operações de cartão de crédito - somente preenchido para as transações via cartão de crédito
and ( rec.credit_card_brand in ('MASTER', 'VISA', 'AMEX', 'ELO', 'DINNERS', 'HIPERCARD') or rec.credit_card_brand is null) -- Este campo representa a banda do cartão de crédito para as operações de cartão de crédito, para as demais este campo será nulo - somente preenchido para as transações via cartão de crédito
and rec.transaction_type in ('credit_card_recurring', 'debit_card_recurring', 'debit_account_recurring', 'credit_card_tef', 'debit_card_tef', 'credit_card_pos', 'debit_card_pos', 'cash', 'boleto', 'bank_transfer', 'online_credit_card', 'online_debit_card') -- Tipo da transação no contexto de pagamentos - através deste campo poderá filtra o 'Produto' (Crédito, Débito ou Débito em Conta)
and rec.gross_value > 0
and ( cus.chargeback_acquirer_label in ('CIELO','REDE','BRADESCO','CAIXA','ITAU','SANTANDER','SMARTFIN') or cus.chargeback_acquirer_label is null) -- Campo que representa a adquirente/banco - somente preenchido para as transações via cartão de crédito

union

/*Valores da taxa de administração da operadora*/
select distinct 
		 otc.country
		,otc.unity_identification
		,otc.erp_business_unit
		,otc.erp_subsidiary
		,otc.acronym
		,otc.minifactu_id
        ,rec.billing_date
		,0 as gross_value 
		,rec.administration_tax_value 
		,0 as interest_value 
from receivable rec

inner join order_to_cash otc
on otc.id = rec.order_to_cash_id

inner join customer cus
on cus.identification_financial_responsible = otc.erp_receivable_customer_identification

left join receivable_erp_configurations recg
on recg.country = otc.country
and recg.origin_system = otc.origin_system
and recg.operation = otc.operation
and recg.transaction_type = rec.transaction_type
and recg.converted_smartfin = rec.converted_smartfin
and recg.erp_business_unit = otc.erp_business_unit
and recg.memoline_setting = 'administration_tax'

where otc.country in ('Brazil') -- Este campo define o país da transação - ENUM('Brazil', 'Mexico', 'Colombia', 'Chile', 'Peru', 'Paraguay', 'Argentina', 'CostaRica', 'Guatemala', 'Ecuador', 'DominicanRepublic', 'Panama', 'ElSalvador')
and otc.unity_identification in (11) -- Este campo representa um id único e imutável que representa todas as unidades operacionais ou administrativa de toda empresa (é utilizado entre todas as soluções) - utilize a query para verificar todas as possibilidades: select oftv.organization_from_to_unity_identification , oftv.* from organization_from_to_version oftv
and otc.erp_business_unit in ('BR01 - SMARTFIT') -- Este campo representa a business unit (empresa) da transação - Este campo só tem contexto dentro do Oracle ERP
and otc.erp_subsidiary in ('BR010011') -- Este campo representa a subsidiary (filial) da transação - Este campo só tem contexto dentro do Oracle ERP
and otc.to_generate_receivable = 'yes'
and otc.origin_system in ('smartsystem','biosystem','racesystem','nossystem') 
and otc.operation = 'person_plan' 
and rec.erp_clustered_receivable_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable
and rec.erp_clustered_receivable_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a customer 
and rec.billing_date between '2019-12-01' and '2019-12-31'  -- Este campo representa a data de cobrança do pagamento do aluno cobrado pelo front
and ( rec.contract_number in ('01425787000104','90400888000142','60701190000104','00360305000104','60746948000112','01027058000191','1109194061','81399952','PV816552') or rec.contract_number is null) -- Este campo representa o código de contrato com as adquirentes, pode ser utilizado para filtra o estabelecimento - só será preenchido para as operações de cartão de crédito - somente preenchido para as transações via cartão de crédito
and ( rec.credit_card_brand in ('MASTER', 'VISA', 'AMEX', 'ELO', 'DINNERS', 'HIPERCARD') or rec.credit_card_brand is null) -- Este campo representa a banda do cartão de crédito para as operações de cartão de crédito, para as demais este campo será nulo - somente preenchido para as transações via cartão de crédito
and rec.transaction_type in ('credit_card_recurring', 'debit_card_recurring', 'debit_account_recurring', 'credit_card_tef', 'debit_card_tef', 'credit_card_pos', 'debit_card_pos', 'cash', 'boleto', 'bank_transfer', 'online_credit_card', 'online_debit_card') -- Tipo da transação no contexto de pagamentos - através deste campo poderá filtra o 'Produto' (Crédito, Débito ou Débito em Conta)
and rec.administration_tax_value > 0
and ( cus.chargeback_acquirer_label in ('CIELO','REDE','BRADESCO','CAIXA','ITAU','SANTANDER','SMARTFIN') or cus.chargeback_acquirer_label is null) -- Campo que representa a adquirente/banco - somente preenchido para as transações via cartão de crédito

union

/*Valores de juros/mora*/
select distinct 
		 otc.country
		,otc.unity_identification
		,otc.erp_business_unit
		,otc.erp_subsidiary
		,otc.acronym
		,otc.minifactu_id
        ,rec.billing_date
		,0 as gross_value 
		,0 as administration_tax_value 
		,rec.interest_value 
from receivable rec

inner join order_to_cash otc
on otc.id = rec.order_to_cash_id

inner join customer cus
on cus.identification_financial_responsible = otc.erp_receivable_customer_identification

left join receivable_erp_configurations recg
on recg.country = otc.country
and recg.origin_system = otc.origin_system
and recg.operation = otc.operation
and recg.transaction_type = rec.transaction_type
and recg.converted_smartfin = rec.converted_smartfin
and recg.erp_business_unit = otc.erp_business_unit
and recg.memoline_setting = 'interest'

where otc.country in ('Brazil') -- Este campo define o país da transação - ENUM('Brazil', 'Mexico', 'Colombia', 'Chile', 'Peru', 'Paraguay', 'Argentina', 'CostaRica', 'Guatemala', 'Ecuador', 'DominicanRepublic', 'Panama', 'ElSalvador')
and otc.unity_identification in (11) -- Este campo representa um id único e imutável que representa todas as unidades operacionais ou administrativa de toda empresa (é utilizado entre todas as soluções) - utilize a query para verificar todas as possibilidades: select oftv.organization_from_to_unity_identification , oftv.* from organization_from_to_version oftv
and otc.erp_business_unit in ('BR01 - SMARTFIT') -- Este campo representa a business unit (empresa) da transação - Este campo só tem contexto dentro do Oracle ERP
and otc.erp_subsidiary in ('BR010011') -- Este campo representa a subsidiary (filial) da transação - Este campo só tem contexto dentro do Oracle ERP
and otc.to_generate_receivable = 'yes'
and otc.origin_system in ('smartsystem','biosystem','racesystem','nossystem') 
and otc.operation = 'person_plan' 
and rec.erp_clustered_receivable_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable
and rec.erp_clustered_receivable_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a customer 
and rec.billing_date between '2019-12-01' and '2019-12-31'  -- Este campo representa a data de cobrança do pagamento do aluno cobrado pelo front
and ( rec.contract_number in ('01425787000104','90400888000142','60701190000104','00360305000104','60746948000112','01027058000191','1109194061','81399952','PV816552') or rec.contract_number is null) -- Este campo representa o código de contrato com as adquirentes, pode ser utilizado para filtra o estabelecimento - só será preenchido para as operações de cartão de crédito - somente preenchido para as transações via cartão de crédito
and ( rec.credit_card_brand in ('MASTER', 'VISA', 'AMEX', 'ELO', 'DINNERS', 'HIPERCARD') or rec.credit_card_brand is null) -- Este campo representa a banda do cartão de crédito para as operações de cartão de crédito, para as demais este campo será nulo - somente preenchido para as transações via cartão de crédito
and rec.transaction_type in ('credit_card_recurring', 'debit_card_recurring', 'debit_account_recurring', 'credit_card_tef', 'debit_card_tef', 'credit_card_pos', 'debit_card_pos', 'cash', 'boleto', 'bank_transfer', 'online_credit_card', 'online_debit_card') -- Tipo da transação no contexto de pagamentos - através deste campo poderá filtra o 'Produto' (Crédito, Débito ou Débito em Conta)
and rec.interest_value > 0
and ( cus.chargeback_acquirer_label in ('CIELO','REDE','BRADESCO','CAIXA','ITAU','SANTANDER','SMARTFIN') or cus.chargeback_acquirer_label is null) -- Campo que representa a adquirente/banco - somente preenchido para as transações via cartão de crédito

) as t0

group by t0.country
		,t0.unity_identification
		,t0.erp_business_unit
		,t0.erp_subsidiary
		,t0.acronym
		,t0.minifactu_id
        ,t0.billing_date

) as t1

order by 1,2,3