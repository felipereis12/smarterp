DROP PROCEDURE IF EXISTS sp_create_clustered_receivable; 
DELIMITER //
CREATE PROCEDURE sp_create_clustered_receivable ( IN p_country varchar(45) , IN  p_transaction_type varchar(45) )

BEGIN

declare v_country varchar(45) ;
declare v_unity_identification varchar(45) ;
declare v_erp_business_unit varchar(45);
declare v_erp_legal_entity varchar(45);
declare v_erp_subsidiary varchar(45);
declare v_erp_customer_id int;
declare v_fullname varchar(255);
declare v_transaction_type varchar(45);
declare v_credit_card_brand varchar(45);
declare v_contract_number varchar(45);
declare v_administration_tax_percentage float;
declare v_antecipation_tax_percentage float;
declare v_billing_date date;
declare v_credit_date date;
declare v_is_smarftin varchar(45);
declare v_gross_value float;
declare v_net_value float;
declare v_interest_value float;
declare v_administration_tax_value float;
declare v_antecipation_tax_value float;
declare v_qtd_of_receivable int;
declare done int;
declare cur1 cursor for select * from vw_clustered_receivable where country = p_country and transaction_type = p_transaction_type;
declare continue handler for not found set done=1;

    set done = 0;
    open cur1;
    
    igmLoop: loop
        fetch cur1 into  v_country
						,v_unity_identification
						,v_erp_business_unit
                        ,v_erp_legal_entity
                        ,v_erp_subsidiary
                        ,v_erp_customer_id
                        ,v_fullname
                        ,v_transaction_type
                        ,v_credit_card_brand
                        ,v_contract_number
                        ,v_administration_tax_percentage
                        ,v_antecipation_tax_percentage
                        ,v_billing_date
                        ,v_credit_date
                        ,v_is_smarftin;
                        
		if done = 1 then leave igmLoop; end if;
		
        /*
		select v_country
						,v_unity_identification
						,v_erp_business_unit
                        ,v_erp_legal_entity
                        ,v_erp_subsidiary
                        ,v_erp_customer_id
                        ,v_fullname
                        ,v_transaction_type
                        ,v_credit_card_brand
                        ,v_contract_number
                        ,v_administration_tax_percentage
                        ,v_antecipation_tax_percentage
                        ,v_billing_date
                        ,v_credit_date
                        ,v_is_smarftin;
		*/

        start transaction;
        
		select 	
			 @v_gross_value := sum(receivable.gross_value) as gross_value
			,@v_net_value := sum(receivable.net_value) as net_value
			,@v_interest_value := sum(receivable.interest_value) as interest_value
			,@v_administration_tax_value := sum(receivable.administration_tax_value) as administration_tax_value
			,@v_antecipation_tax_value := sum(receivable.antecipation_tax_value) as antecipation_tax_value
            ,@v_qtd_of_receivable = count(1) as qtd
		from receivable
        
        inner join order_to_cash
        on order_to_cash.id = receivable.order_to_cash_id
        
        where order_to_cash.country = v_country
        and order_to_cash.unity_identification = v_unity_identification
        and order_to_cash.erp_business_unit = v_erp_business_unit
        and order_to_cash.erp_legal_entity = v_erp_legal_entity
        and order_to_cash.erp_subsidiary = v_erp_subsidiary
        and receivable.erp_clustered_receivable_customer_id = v_erp_customer_id
        and receivable.transaction_type = v_transaction_type
        and receivable.contract_number = v_contract_number
        and receivable.credit_card_brand = v_credit_card_brand
        and receivable.administration_tax_percentage = v_administration_tax_percentage
        and receivable.antecipation_tax_percentage = v_antecipation_tax_percentage
        and receivable.billing_date = v_billing_date
        and receivable.credit_date = v_credit_date
        and receivable.is_smartfin = v_is_smarftin; 
        
        insert into clustered_receivable
							(country,
							unity_identification,
							erp_business_unit,
							erp_legal_entity,
							erp_subsidiary,
							erp_clustered_receivable_customer_id,
							contract_number,
							credit_card_brand,
							billing_date,
							credit_date,
							gross_value,
							net_value,
							interest_value,
							administration_tax_percentage,
							administration_tax_value,
							antecipation_tax_percentage,
							antecipation_tax_value,
                            quantity_of_receivable)
							VALUES
							(v_country,
							v_unity_identification,
							v_erp_business_unit,
							v_erp_legal_entity,
							v_erp_subsidiary,
							v_erp_customer_id,
							v_contract_number,
							v_credit_card_brand,
							v_billing_date,
							v_credit_date,
							@v_gross_value,
							@v_net_value,
							@v_interest_value,
							v_administration_tax_percentage,
							@v_administration_tax_value,
							v_antecipation_tax_percentage,
							@v_antecipation_tax_value,
                            @v_qtd_of_receivable);

        set @clustered_receivable_id = last_insert_id();
        
        update receivable
        
		inner join order_to_cash
        on order_to_cash.id = receivable.order_to_cash_id
        
        set receivable.erp_clustered_receivable_id = @clustered_receivable_id
        
        where order_to_cash.country = v_country
        and order_to_cash.unity_identification = v_unity_identification
        and order_to_cash.erp_business_unit = v_erp_business_unit
        and order_to_cash.erp_legal_entity = v_erp_legal_entity
        and order_to_cash.erp_subsidiary = v_erp_subsidiary
        and receivable.erp_clustered_receivable_customer_id = v_erp_customer_id
        and receivable.transaction_type = v_transaction_type
        and receivable.contract_number = v_contract_number
        and receivable.credit_card_brand = v_credit_card_brand
        and receivable.administration_tax_percentage = v_administration_tax_percentage
        and receivable.antecipation_tax_percentage = v_antecipation_tax_percentage
        and receivable.billing_date = v_billing_date
        and receivable.credit_date = v_credit_date
        and receivable.is_smartfin = v_is_smarftin;        
        
        commit;
	        
    end loop igmLoop;
    
    close cur1;

END;
//