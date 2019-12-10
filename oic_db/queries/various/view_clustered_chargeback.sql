drop view if exists vw_clustered_chargeback; 
create view vw_clustered_chargeback as 

select 

	order_to_cash.country
    ,order_to_cash.origin_system
    ,order_to_cash.unity_identification
    ,order_to_cash.erp_business_unit
    ,order_to_cash.erp_legal_entity
    ,order_to_cash.erp_subsidiary
    ,order_to_cash.operation
    ,customer.erp_customer_id
    ,customer.full_name
    ,chargeback.transaction_type
	,chargeback.credit_card_brand
	,chargeback.contract_number
	,chargeback.administration_tax_percentage
	,chargeback.antecipation_tax_percentage
	,chargeback.billing_date
	,chargeback.credit_date

from chargeback

inner join customer
on customer.chargeback_acquirer_label = chargeback.chargeback_acquirer_label

inner join receivable 
on receivable.conciliator_id = chargeback.conciliator_id

inner join order_to_cash
on order_to_cash.id = receivable.order_to_cash_id 

where chargeback.erp_receipt_status_transaction = 'waiting_to_be_process'
and chargeback.erp_clustered_chargeback_id is null
and chargeback.erp_receipt_id is null ;