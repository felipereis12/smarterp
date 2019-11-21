DROP PROCEDURE IF EXISTS sp_create_smartfin_payables; 
DELIMITER //
CREATE PROCEDURE sp_create_smartfin_payables ( IN p_country varchar(45) , IN p_origin_system varchar(45) , IN p_operation varchar(45) , IN  p_transaction_type varchar(45) )

BEGIN

declare v_unity_identification varchar(45) ;
declare v_erp_business_unit varchar(45);
declare v_erp_legal_entity varchar(45);
declare v_erp_subsidiary varchar(45);
declare v_acronym varchar(45);
declare v_erp_supplier_id varchar(45);
declare v_erp_payable_supplier_identification varchar(45);
declare v_order_to_cash_id integer;
declare v_message_text varchar(255);
declare v_conciliator_id varchar(45);
declare v_keycontrol varchar(150);
declare v_id_receivable int;
declare v_id_receivable_smartfin int;
declare done int;
declare cur1 cursor for 

					select
						rec.id
                        ,receivable_id_smartfin
					from receivable rec
					
					inner join order_to_cash
					on order_to_cash.id = rec.order_to_cash_id
					
					inner join clustered_receivable_customer crc
					on crc.identification_financial_responsible = order_to_cash.erp_receivable_customer_identification
					and crc.is_smartfin = 'yes' -- Neste caso como haverá uma integração separada para os movimentos Smartfin esse filtro deverá ser fixo para tais movimentos
                    
					inner join organization_from_to_version oftv
					on oftv.erp_legal_entity = crc.identification_financial_responsible 					
					
					where order_to_cash.country = p_country
					and order_to_cash.origin_system = p_origin_system
					and order_to_cash.operation = p_operation
					and order_to_cash.erp_receivable_status_transaction = 'created_at_erp' -- Filtrar somente os registros que já foram integrados o AR no Oracle
					and order_to_cash.erp_receipt_status_transaction = 'created_at_erp' -- Filtrar somente os registros que já foram baixados (Receipt)
					and rec.erp_clustered_receivable_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable
					and rec.erp_clustered_receivable_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable_customer 
					and rec.erp_receivable_id is not null -- Filtrar somente os receivables que já foram integrados com o erp
					and rec.erp_receivable_receipt_id is not null -- Filtrar somente os receivables que já foram integrados com o erp
					and rec.transaction_type = p_transaction_type ;-- Integração em paralalo por tipo de transação (cartão de crédito recorrente, cartão de débito recorrente, débito em conta, boleto etc...)


declare continue handler for not found set done=1;

declare exit handler for sqlexception 
begin
    rollback;
    get diagnostics condition 1  @v_message_text = message_text;
    select @v_message_text;
end;

set @v_keycontrol 	:= concat_ws('_','sp_create_smartfin_payables',rtrim(p_country),rtrim(p_origin_system),rtrim(p_operation),rtrim(p_transaction_type));

if get_lock(@v_keycontrol,1) = 1 and  exists ( select 1 from clustered_receivable_customer crc
									  inner join organization_from_to_version oftv
									  on oftv.erp_legal_entity = crc.identification_financial_responsible 
									  where is_smartfin = 'yes')  then 

    set done = 0;	
    open cur1;
    
    SmartfinPayablesLoop: loop
    
        fetch cur1 into v_id_receivable, v_id_receivable_smartfin;
                        
		if done = 1 then leave SmartfinPayablesLoop; end if;

		start transaction;
		
        if exists (
					select 
						 @v_unity_identification := oftv.organization_from_to_unity_identification 
						,@v_erp_business_unit := oftv.erp_business_unit 
						,@v_erp_legal_entity := oftv.erp_legal_entity
						,@v_erp_subsidiary := oftv.erp_subsidiary
						,@v_acronym := oftv.acronym
						,@v_erp_supplier_id := sup.erp_supplier_id
						,@v_erp_payable_supplier_identification := sup.identification_financial_responsible
					from receivable rec
					
					inner join order_to_cash otc
					on otc.id = rec.order_to_cash_id
					
					inner join clustered_receivable_customer crc
					on crc.identification_financial_responsible = otc.erp_receivable_customer_identification
					
					inner join organization_from_to_version oftv
					on oftv.erp_legal_entity = crc.identification_financial_responsible 
					and oftv.created_at = ( select 
												max(oftv2.created_at) 
											from organization_from_to_version oftv2 
											where oftv2.organization_from_to_unity_identification = oftv.organization_from_to_unity_identification 
											)

					inner join supplier sup
                    on sup.identification_financial_responsible = crc.identification_financial_responsible
                    and sup.erp_supplier_id is not null
                    
					where rec.id = v_id_receivable_smartfin ) and
                    
                    not exists 
                    (
						select
							1
						from oic_db.payable pay
                        where pay.erp_business_unit = @v_erp_business_unit
                        and pay.erp_legal_entity = @v_erp_legal_entity
                        and pay.erp_subsidiary = @v_erp_subsidiary
                        and pay.receivable_id = v_id_receivable
                    )
                    
                    then 
			
			insert into oic_db.payable
				(erp_business_unit,
				erp_legal_entity,
				erp_subsidiary,
				acronym,
				erp_payable_id,
				receivable_id,
				erp_supplier_id,
				issue_date,
				due_date,
				erp_payable_send_to_erp_at,
				erp_payable_returned_from_erp_at,
				erp_payable_status_transaction,
				erp_payable_log,
				erp_filename,
				erp_line_in_file)
				VALUES
				(@v_erp_business_unit, -- erp_business_unit
				@v_erp_legal_entity, -- erp_legal_entity
				@v_erp_subsidiary, -- erp_subsidiary
				@v_acronym, -- acronym
				null, -- erp_payable_id
				v_id_receivable, -- receivable_id
				@v_erp_supplier_id, -- erp_supplier_id
				current_date(), -- issue_date
				current_date(), -- due_date
				null, -- erp_payable_send_to_erp_at
				null, -- erp_payable_returned_from_erp_at
				'waiting_to_be_process', -- erp_payable_status_transaction
				null, -- erp_payable_log
				null, -- erp_filename
				null); -- erp_line_in_file
			
            
            update receivable 
            
            inner join order_to_cash
            on order_to_cash.id = receivable.order_to_cash_id
            
            set order_to_cash.erp_receivable_status_transaction = 'payable_created_at_oic_db'
            
            where receivable.id = v_id_receivable;
            
        end if;
        
    end loop SmartfinPayablesLoop;
    
    close cur1;	
    
    do release_lock(@v_keycontrol);    
    
else 
	select concat('Procedure is already running in another thread: ',@v_keycontrol ) as log;
end if;

END;
//

DELIMITER $$