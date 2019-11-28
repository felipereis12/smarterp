DROP PROCEDURE IF EXISTS sp_create_smartfin_receivables; 
DELIMITER //
CREATE PROCEDURE sp_create_smartfin_receivables ( IN p_id_receivable integer )

BEGIN


declare v_unity_identification varchar(45) ;
declare v_erp_business_unit varchar(45);
declare v_erp_legal_entity varchar(45);
declare v_erp_subsidiary varchar(45);
declare v_acronym varchar(45);
declare v_erp_customer_id varchar(45);
declare v_erp_clustered_receivable_customer_id varchar(45);
declare v_erp_receivable_customer_identification varchar(45);
declare v_order_to_cash_id integer;
declare v_message_text varchar(255);
declare v_conciliator_id varchar(45);

declare exit handler for sqlexception 
begin
    rollback;
    get diagnostics condition 1  @v_message_text = message_text;
    select @v_message_text;
end;

if exists ( select 1 from customer crc
			inner join organization_from_to_version oftv
            on oftv.erp_legal_entity = crc.identification_financial_responsible 
            where is_smartfin = 'yes') and
            ( select 1 from receivable r 
            where r.id = p_id_receivable 
            and r.is_smartfin = 'yes' ) then
		
    start transaction;
    
    select 
		 @v_unity_identification := oftv.organization_from_to_unity_identification 
        ,@v_erp_business_unit := oftv.erp_business_unit 
        ,@v_erp_legal_entity := oftv.erp_legal_entity
        ,@v_erp_subsidiary := oftv.erp_subsidiary
        ,@v_acronym := oftv.acronym
        ,@v_erp_customer_id := crc.erp_customer_id
        ,@v_erp_clustered_receivable_customer_id := crc.erp_customer_id
        ,@v_erp_receivable_customer_identification := crc.identification_financial_responsible
    from customer crc
    
    inner join organization_from_to_version oftv
    on oftv.erp_legal_entity = crc.identification_financial_responsible 
    and oftv.created_at = ( select 
								max(oftv2.created_at) 
							from organization_from_to_version oftv2 
							where oftv2.organization_from_to_unity_identification = oftv.organization_from_to_unity_identification 
							)
    where crc.is_smartfin = 'yes';

    select @v_conciliator_id := receivable.conciliator_id from receivable where receivable.id = p_id_receivable;
    
    update receivable 
    
    inner join order_to_cash 
    on order_to_cash.id = receivable.order_to_cash_id 
    
    set receivable.conciliator_id = null 
    ,order_to_cash.conciliator_id = null
    
    where receivable.id = p_id_receivable;
                
    insert into order_to_cash
		(id,
		created_at,
        smartfin_order_to_cash_id,        
		country,
		unity_identification,
		erp_business_unit,
		erp_legal_entity,
		erp_subsidiary,
		acronym,
		to_generate_customer,
		to_generate_receivable,
		to_generate_invoice,
		origin_system,
		operation,
		minifactu_id,
		conciliator_id,
		fin_id,
		front_id,
		erp_invoice_customer_send_to_erp_at,
		erp_invoice_customer_returned_from_erp_at,
		erp_invoice_customer_status_transaction,
		erp_invoice_customer_log,
		erp_receivable_sent_to_erp_at,
		erp_receivable_returned_from_erp_at,
		erp_receivable_customer_identification,
		erp_receivable_status_transaction,
		erp_receivable_log,
		erp_invoice_send_to_erp_at,
		erp_invoice_returned_from_erp_at,
		erp_invoice_status_transaction,
		erp_invoice_log)
 
		select 
			null,
			null,
            order_to_cash.id,            
			order_to_cash.country,
			@v_unity_identification,
			@v_erp_business_unit,
			@v_erp_legal_entity,
			@v_erp_subsidiary,
			@v_acronym,
			'no',
			order_to_cash.to_generate_receivable,
			'no',
			order_to_cash.origin_system,
			order_to_cash.operation,
			order_to_cash.minifactu_id*-1,
			@v_conciliator_id,
			order_to_cash.fin_id,
			order_to_cash.front_id,
			null,
			null,
			'doesnt_need_to_be_process',
			null,
			null,
			null,
			order_to_cash.erp_receivable_customer_identification,
			'waiting_to_be_process',
			null,
			null,
			null,
			'doesnt_need_to_be_process',
			null
		from order_to_cash	
		
		inner join receivable
		on receivable.order_to_cash_id = order_to_cash.id
		
		where receivable.id = p_id_receivable
		and receivable.is_smartfin = 'yes';
    
    set @v_order_to_cash_id = last_insert_id();	
    
	insert into oic_db.receivable
	(id,
	created_at,
    receivable_id_smartfin,    
	order_to_cash_id,
	erp_receivable_id,
	erp_receivable_customer_id,
	erp_clustered_receivable_id,
	erp_clustered_receivable_customer_id,
	conciliator_id,
	is_smartfin,
	transaction_type,
	contract_number,
	credit_card_brand,
	truncated_credit_card,
	current_credit_card_installment,
	total_credit_card_installment,
	nsu,
	authorization_code,
	price_list_value,
	gross_value,
	net_value,
	interest_value,
	administration_tax_percentage,
	administration_tax_value,
	antecipation_tax_percentage,
	antecipation_tax_value,
	billing_date,
	credit_date,
	conciliator_filename,
	acquirer_bank_filename,
	registration_gym_student,
	fullname_gym_student,
	identification_gym_student,
	erp_filename,
	erp_line_in_file)
	select
		null,
		null,
        receivable.id,        
		@v_order_to_cash_id,
		null,
		receivable.erp_receivable_customer_id,
		null,
		receivable.erp_clustered_receivable_customer_id,
		@v_conciliator_id,
		'no',
		receivable.transaction_type,
		receivable.contract_number,
		receivable.credit_card_brand,
		receivable.truncated_credit_card,
		receivable.current_credit_card_installment,
		receivable.total_credit_card_installment,
		receivable.nsu,
		receivable.authorization_code,
		receivable.price_list_value,
		receivable.gross_value,
		receivable.net_value,
		receivable.interest_value,
		receivable.administration_tax_percentage,
		receivable.administration_tax_value,
		receivable.antecipation_tax_percentage,
		receivable.antecipation_tax_value,
		receivable.billing_date,
		receivable.credit_date,
		receivable.conciliator_filename,
		receivable.acquirer_bank_filename,
		receivable.registration_gym_student,
		receivable.fullname_gym_student,
		receivable.identification_gym_student,
		null,
		null
	from receivable
    
    where receivable.id = p_id_receivable
    and receivable.is_smartfin = 'yes'; 
		
    update receivable 
    
    inner join order_to_cash
    on order_to_cash.id = receivable.order_to_cash_id
    
    set receivable.erp_clustered_receivable_customer_id = @v_erp_clustered_receivable_customer_id
	,receivable.erp_receivable_customer_id = @v_erp_customer_id     
    ,receivable.is_smartfin = 'no'
    ,order_to_cash.conciliator_id = concat('smartfin_',@v_conciliator_id)
    ,order_to_cash.erp_receivable_customer_identification = @v_erp_receivable_customer_identification    
    
    where receivable.id = p_id_receivable ;

    update receivable 
       
    set receivable.conciliator_id = concat('smartfin_',@v_conciliator_id)
    
    where receivable.id = p_id_receivable ;
        
end if;

END;
//

DELIMITER $$