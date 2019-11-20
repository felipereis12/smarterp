insert into invoice_customer_comparation (
                order_to_cash_id,
                country,                
                erp_customer_id,
                full_name,
                type_person,
                identification_financial_responsible,
                nationality_code,
                state,
                city,
                adress,
                adress_number,
                adress_complement,
                district,
                postal_code,
                area_code,
                cellphone,
                email,
                state_registration,
                federal_registration,
                final_consumer,
                icms_contributor,
                erp_filename,
                erp_line_in_file )
                
select
        invoice_customer.order_to_cash_id,
        invoice_customer.country,                
        invoice_customer.erp_customer_id,
        invoice_customer.full_name,
        invoice_customer.type_person,
        invoice_customer.identification_financial_responsible,
        invoice_customer.nationality_code,
        invoice_customer.state,
        invoice_customer.city,
        invoice_customer.adress,
        invoice_customer.adress_number,
        invoice_customer.adress_complement,
        invoice_customer.district,
        invoice_customer.postal_code,
        invoice_customer.area_code,
        invoice_customer.cellphone,
        invoice_customer.email,
        invoice_customer.state_registration,
        invoice_customer.federal_registration,
        invoice_customer.final_consumer,
        invoice_customer.icms_contributor,
        invoice_customer.erp_filename,
        invoice_customer.erp_line_in_file
from invoice_customer 

inner join order_to_cash
on order_to_cash.id = invoice_customer.order_to_cash_id

where order_to_cash.country = 'Brazil' -- O filtro para encontrar o registro na invoice_customer deve ser composto pelo país + identificação cpf, cnpj ou passaporte (estrangeiros)
and invoice_customer.identification_financial_responsible = '39367233892' -- no caso do Brasil esse canterá cpf para pessoas físicas, cnpj para pessoas jurídicas e passaporte para estrangeiros

on duplicate key 

update invoice_customer_comparation.order_to_cash_id = invoice_customer.order_to_cash_id,
invoice_customer_comparation.erp_customer_id = invoice_customer.erp_customer_id,
invoice_customer_comparation.full_name = invoice_customer.full_name,
invoice_customer_comparation.type_person = invoice_customer.type_person,
invoice_customer_comparation.nationality_code = invoice_customer.nationality_code,
invoice_customer_comparation.state = invoice_customer.state,
invoice_customer_comparation.city = invoice_customer.city,
invoice_customer_comparation.adress = invoice_customer.adress,
invoice_customer_comparation.adress_number = invoice_customer.adress_number,
invoice_customer_comparation.adress_complement = invoice_customer.adress_complement,
invoice_customer_comparation.district = invoice_customer.district,
invoice_customer_comparation.postal_code = invoice_customer.postal_code,
invoice_customer_comparation.area_code = invoice_customer.area_code,
invoice_customer_comparation.cellphone = invoice_customer.cellphone,
invoice_customer_comparation.email = invoice_customer.email,
invoice_customer_comparation.state_registration = invoice_customer.state_registration,
invoice_customer_comparation.federal_registration = invoice_customer.federal_registration,
invoice_customer_comparation.final_consumer = invoice_customer.final_consumer,
invoice_customer_comparation.icms_contributor = invoice_customer.icms_contributor,
invoice_customer_comparation.erp_filename = invoice_customer.erp_filename,
invoice_customer_comparation.erp_line_in_file = invoice_customer.erp_line_in_file
