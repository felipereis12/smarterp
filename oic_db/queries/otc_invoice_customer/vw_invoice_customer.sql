drop view if exists vw_invoice_customer; 

create view vw_invoice_customer as

select
		otc.origin_system,
        otc.country,
        otc.erp_subsidiary,
        otc.operation,
        otc.erp_invoice_customer_status_transaction,
        otc.to_generate_customer,
        rec.transaction_type,
		ivc.identification_financial_responsible,
		ivc.full_name,
		ivc.adress,
		ivc.adress_number,
		ivc.adress_complement,
		ivc.district,
		ivc.city,
		ivc.state,
		ivc.postal_code,
		ivc.nationality_code,
		ivc.area_code,
		ivc.cellphone,
		ivc.email,
		ivc.erp_customer_id
from order_to_cash otc

inner join invoice_customer ivc
on otc.id = ivc.order_to_cash_id

inner join receivable rec
on otc.id = rec.order_to_cash_id

inner join invoice_customer_comparation ivcc 
on ivc.erp_customer_id = ivcc.erp_customer_id 
and ivc.identification_financial_responsible = ivcc.identification_financial_responsible

where (
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

select
		otc.origin_system,
        otc.country,
        otc.erp_subsidiary,
        otc.operation,
        otc.erp_invoice_customer_status_transaction,
        otc.to_generate_customer,
        rec.transaction_type,        
		ivc.identification_financial_responsible,
		ivc.full_name,
		ivc.adress,
		ivc.adress_number,
		ivc.adress_complement,
		ivc.district,
		ivc.city,
		ivc.state,
		ivc.postal_code,
		ivc.nationality_code,
		ivc.area_code,
		ivc.cellphone,
		ivc.email,
		ivc.erp_customer_id
from order_to_cash otc

inner join invoice_customer ivc
on otc.id = ivc.order_to_cash_id

inner join receivable rec
on otc.id = rec.order_to_cash_id

where ivc.erp_customer_id is null;