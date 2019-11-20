select 
     order_to_cash.erp_business_unit
    ,order_to_cash.erp_legal_entity
    ,order_to_cash.erp_subsidiary
    ,order_to_cash.acronym
	,receivable.*
    ,order_to_cash.*
from receivable 

inner join order_to_cash
on order_to_cash.id = receivable.order_to_cash_id

where order_to_cash.erp_business_unit = '<param1>'
and order_to_cash.erp_legal_entity = '<param2>'
and order_to_cash.erp_subsidiary = '<param3>';