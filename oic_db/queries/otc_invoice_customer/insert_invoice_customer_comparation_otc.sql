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
        ivc.order_to_cash_id,
        ivc.country,                
        ivc.erp_customer_id,
        ivc.full_name,
        ivc.type_person,
        ivc.identification_financial_responsible,
        ivc.nationality_code,
        ivc.state,
        ivc.city,
        ivc.adress,
        ivc.adress_number,
        ivc.adress_complement,
        ivc.district,
        ivc.postal_code,
        ivc.area_code,
        ivc.cellphone,
        ivc.email,
        ivc.state_registration,
        ivc.federal_registration,
        ivc.final_consumer,
        ivc.icms_contributor,
        ivc.erp_filename,
        ivc.erp_line_in_file
from invoice_customer ivc

inner join order_to_cash otc
on otc.id = ivc.order_to_cash_id

where otc.country = 'Brazil' -- O filtro para encontrar o registro na invoice_customer deve ser composto pelo país + identificação cpf, cnpj ou passaporte (estrangeiros)
and ivc.identification_financial_responsible = '39367233892' -- no caso do Brasil esse canterá cpf para pessoas físicas, cnpj para pessoas jurídicas e passaporte para estrangeiros

on duplicate key 

update invoice_customer_comparation.order_to_cash_id = ivc.order_to_cash_id,
invoice_customer_comparation.erp_customer_id = ivc.erp_customer_id,
invoice_customer_comparation.full_name = ivc.full_name,
invoice_customer_comparation.type_person = ivc.type_person,
invoice_customer_comparation.nationality_code = ivc.nationality_code,
invoice_customer_comparation.state = ivc.state,
invoice_customer_comparation.city = ivc.city,
invoice_customer_comparation.adress = ivc.adress,
invoice_customer_comparation.adress_number = ivc.adress_number,
invoice_customer_comparation.adress_complement = ivc.adress_complement,
invoice_customer_comparation.district = ivc.district,
invoice_customer_comparation.postal_code = ivc.postal_code,
invoice_customer_comparation.area_code = ivc.area_code,
invoice_customer_comparation.cellphone = ivc.cellphone,
invoice_customer_comparation.email = ivc.email,
invoice_customer_comparation.state_registration = ivc.state_registration,
invoice_customer_comparation.federal_registration = ivc.federal_registration,
invoice_customer_comparation.final_consumer = ivc.final_consumer,
invoice_customer_comparation.icms_contributor = ivc.icms_contributor,
invoice_customer_comparation.erp_filename = ivc.erp_filename,
invoice_customer_comparation.erp_line_in_file = ivc.erp_line_in_file
