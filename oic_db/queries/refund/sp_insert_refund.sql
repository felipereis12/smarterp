drop procedure if exists sp_insert_refund; 
delimiter //

CREATE PROCEDURE `sp_insert_refund`( p_refund JSON ,out p_return boolean  ,out p_code integer ,out p_message varbinary(10000), out p_front_refund_id integer )
begin	
    declare country varchar(45);
    declare unity_identification integer default 0;
    declare origin_system varchar(45);
    declare front_refund_id varchar(45);
    declare refund_requester_name varchar(45);     
    declare issue_date integer default null;
    declare due_date integer default null;
    declare refund_value float;
    declare bank_number varchar(45);
    declare bank_branch varchar(45); 
	declare bank_branch_digit varchar(45);
    declare bank_account_number_digit varchar(45);
    declare bank_account_owner_name varchar(255);
    declare refund_requester_identification varchar(45);
    declare erp_refund_id integer;
    declare bank_account_number varchar(45);
    declare bank_account_owner_identification varchar(45);
	declare v_refund integer;
    declare p_refund_items_json JSON;
    declare i int default 0;
    
	begin
		get diagnostics condition 1  @v_message_text = message_text;
		set p_return = false;
		set p_code = -1;
		set p_message = @v_message_text;                
		rollback;
	end;

	set sql_mode = traditional;	    
	set p_return = true;
    set p_code = 0;
    set p_message = "";
    set p_front_refund_id = 0;
        
	call sp_valid_object_refund(p_refund, @p_return_v2 , @p_code_v2 , @p_message_v2, @p_front_refund_id_v2);
    
    if ( @p_return_v2 ) then 
    
		start transaction;

		select replace(replace(json_extract(p_refund,'$.refund.header.country'),'"',""),"null",null) into @reund_cash_country;
        select cast(replace(json_extract(p_refund,'$.refund.header.unity_identification'),"null",null) as unsigned) into @refund_cash_unity_identification;
		select replace(replace(json_extract(p_refund,'$.refund.header.origin_system'),'"',""),"null",null)  into @refund_cash_origin_system;
		select replace(replace(json_extract(p_refund,'$.refund.header.erp_refund_id'),'"',""),"null",null)  into @refund_erp_refund_id;
        select replace(replace(json_extract(p_refund,'$.refund.header.refund_requester_name'),'"',""),"null",null)  into @refund_refund_requester_name;
        select replace(replace(json_extract(p_refund,'$.refund.header.refund_requester_identification'),'"',""),"null",null)  into @refund_refund_requester_identification;
        select replace(replace(json_extract(p_refund,'$.refund.header.issue_date'),'"',""),"null",null)  into @refund_issue_date;
        select replace(replace(json_extract(p_refund,'$.refund.header.due_date'),'"',""),"null",null)  into @refund_due_date;
        select cast(replace(json_extract(p_refund,'$.refund.header.refund_value'),"null",null) as unsigned) into @refund_refund_value;
        select replace(replace(json_extract(p_refund,'$.refund.header.bank_number'),'"',""),"null",null)  into @refund_bank_numberh;         
        select replace(replace(json_extract(p_refund,'$.refund.header.bank_branch'),'"',""),"null",null)  into @refund_bank_branch;
        select replace(replace(json_extract(p_refund,'$.refund.header.bank_branch_digit'),'"',""),"null",null)  into @refund_bank_branch_digit;
        select replace(replace(json_extract(p_refund,'$.refund.header.bank_account_number'),'"',""),"null",null)  into @refund_bank_account_number;
        select replace(replace(json_extract(p_refund,'$.refund.header.bank_account_number_digit'),'"',""),"null",null)  into @refund_bank_account_number_digit;
        select replace(replace(json_extract(p_refund,'$.refund.header.bank_account_owner_name'),'"',""),"null",null)  into @refund_bank_account_owner_name;
        select replace(replace(json_extract(p_refund,'$.refund.header.bank_account_owner_identification'),'"',""),"null",null)  into @refund_bank_account_owner_identification;
        select cast( json_extract(p_refund,'$.refund.refund_items') as json ) into @p_refund_items_json;   
		
        if ( @p_return_v3 ) then 
			
            set @v_erp_business_unit = null;
            set @v_erp_legal_entity = null;
            set @v_erp_subsidiary = null;
            set @v_acronym = null;
            set @v_to_generate_customer = null;
            set @v_to_generate_receivable = null;
            set @v_to_generate_invoice = null;
            
			select
				 oftv.erp_business_unit
				,oftv.erp_legal_entity
				,oftv.erp_subsidiary
				,oftv.acronym
				,oftv.to_generate_customer
				,oftv.to_generate_receivable
				,oftv.to_generate_invoice                                        
				
				into 		 
				 @v_erp_business_unit 
				,@v_erp_legal_entity 
				,@v_erp_subsidiary 
				,@v_acronym 
				,@v_to_generate_customer 
				,@v_to_generate_receivable 
				,@v_to_generate_invoice 
				
			from organization_from_to_version oftv
			where oftv.organization_from_to_unity_identification = @p_order_to_cash_unity_identification
			and oftv.created_at = (
									select 
										max(oftv_v2.created_at) as created_at
									from organization_from_to_version oftv_v2
									where oftv_v2.organization_from_to_unity_identification = oftv.organization_from_to_unity_identification
									);
                    
		INSERT INTO refund
		(
			country,
			unity_identification,
			origin_system, smartsystem,
			front_refund_id, 
			refund_requester_name,
			refund_requester_identification,
			issue_date,
			due_date,
			refund_value,
			bank_number,
			bank_branch,
			bank_branch_digit,
			bank_account_number,
			bank_account_number_digit,
			bank_account_owner_name,
			bank_account_owner_identification
        )
		VALUES
		(
			@reund_cash_country, -- country
			@refund_cash_unity_identification, -- unity_identification
			@refund_cash_origin_system, -- origin_system
			@refund_erp_refund_id, -- refund_id
			@refund_refund_requester_name, -- requester_name
			@refund_refund_requester_identification, -- requester_identification
			@refund_issue_date, -- issue_date	
			@refund_due_date, -- due_date
			@refund_refund_value, -- refund_value
			@refund_bank_numberh, -- bank        
			@refund_bank_branch, -- bank_branch
			@refund_bank_branch_digit, -- bank_branch_digit
			@refund_bank_account_number, -- bank_account_number 
			@refund_bank_account_number_digit, -- bank_account_number_digit 
			@refund_bank_account_owner_name, -- bank_accont_owner_name
			@refund_bank_account_owner_identification -- bank_account_owner_identification
		);

			
		-- saves the auto increment id from order_to_cash table
		set @v_refund = last_insert_id();  
		
		-- para inserir os itens do refund
		
		if (@p_refund_items_json is not null) and  json_contains_path(@p_refund_items_json,'one','$.refund_items') = 1 then 		
            
			refund_items_lopp: while i <= json_length(json_extract(@p_refund_items_json,'$.refund_items')) - 1 do
				
				set @front_id = null;
				set @refund_item_value = null;
				set @billing_date = null;


				if (  json_contains_path(@p_invoice_items_json,'one',concat('$.refund_items[',i,'].front_id')) = 1 
				and json_contains_path(@p_invoice_items_json,'one',concat('$.refund_items[',i,'].refund_item_value')) = 1 
				and json_contains_path(@p_invoice_items_json,'one',concat('$.refund_items[',i,'].billing_date')) = 1 
				) then
					
					select cast(replace(json_extract(@p_invoice_items_json,concat('$.refund_items[',i,'].front_id')),"null",null) as unsigned) into @front_id;
					select cast(replace(json_extract(@p_invoice_items_json,concat('$.refund_items[',i,'].refund_item_value')),"null",null) as unsigned) into @refund_item_value;
					select cast(replace(json_extract(@p_invoice_items_json,concat('$.refund_items[',i,'].billing_date')),"null",null) as unsigned) into @billing_date;

					insert into invoice_items(front_id,
											refund_item_value,
											billing_date)
											values
											(@front_id, -- front_id
											@refund_item_value, -- refund_item_value
											@billing_date); -- billing_date

										commit;
										
					set i = i + 1 ;
                    
				end if;
                
            end while refund_items_lopp;
            
		end if;
				         
      end if;             
	end if; -- first if, of insert in the organization_from_to_version (oftv)
	end;
//