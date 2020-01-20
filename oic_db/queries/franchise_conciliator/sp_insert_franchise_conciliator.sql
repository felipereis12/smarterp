DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `sp_insert_franchise_conciliator`( p_franchine_conciliator JSON ,out p_return boolean, out p_code integer ,out p_message varbinary(1000), out p_front_franchise_conciliator_id integer )
begin
	declare v_otc_country varchar(45);
    declare v_otc_unity_identification integer default 0;
    declare v_otc_origin_system varchar(45);
    declare v_otc_front_franchise_conciliator_id integer; -- Neste campo será gravado o front id vindo do JSON
    declare v_otc_issue_date integer default null;
    declare v_otc_due_date integer default null;
    declare v_receivable_erp_receivable_customer_id varchar(45);
    declare v_receivable_contract_number varchar(45);
    declare v_receivable_credit_card_brand varchar(45);
    declare v_receivable_gross_value varchar(45);
    declare v_supplier_full_name varchar(45);
    declare v_supplier_type_person varchar(45);
    declare v_suplier_identification_financial_responsible varchar(45);
    declare v_suplier_nationality_code varchar(45);
    declare v_supplier_state varchar(45);
    declare v_supplier_city varchar(45);
    declare v_supplier_adress varchar(45);
    declare v_supplier_adress_complement varchar(45);
    declare v_supplier_district varchar(45);
    declare v_supplier_postal_code varchar(45);
    declare v_supplier_area_code varchar(45);
    declare v_supplier_cellphone varchar(45);
    declare v_supplier_email varchar(45);
    declare v_supplier_state_registration varchar(45);
    declare v_supplier_municipal_registration varchar(45);
    declare v_supplier_final_consumer varchar(45);
    declare v_supplier_icms_contributor varchar(45);
    -- bank_number fixo
    -- bank_branch fixo
    -- bank_branch_digit fixo 
    -- bank_account_owner_name fixo
    -- bank_account_owner_identification fixo
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
	set p_front_franchise_conciliator_id = 0;
    
    call sp_valid_object_refund(p_refund, @p_return_v2 , @p_code_v2 , @p_message_v2, @p_front_refund_id_v2);
    
    if ( @p_return_v2 ) then -- if 1
    
		start transaction;

		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.header.country'),'"',""),"null",null) into @v_otc_country;
		select cast(replace(json_extract(p_refund,'$.franchise_conciliator.header.unity_identification'),"null",null) as unsigned) into @v_otc_unity_identification;
        select replace(replace(json_extract(p_refund,'$.franchise_conciliator.header.origin_system'),'"',""),"null",null) into @v_otc_origin_system;
        select replace(replace(json_extract(p_refund,'$.franchise_conciliator.header.front_franchise_conciliator_id'),'"',""),"null",null) into @v_otc_front_franchise_conciliator_id;
        select replace(replace(json_extract(p_refund,'$.franchise_conciliator.header.origin_system'),'"',""),"null",null) into @v_otc_origin_system;
        select replace(replace(json_extract(p_refund,'$.franchise_conciliator.header.issue_date'),'"',""),"null",null) into @v_otc_issue_date;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.header.due_date'),'"',""),"null",null) into @v_otc_due_date;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.receivable.erp_receivable_customer_identification'),'"',""),"null",null) into @v_receivable_erp_receivable_customer_id;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.receivable.contract_number'),'"',""),"null",null) into @v_receivable_contract_number;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.receivable.credit_card_brand'),'"',""),"null",null) into @v_receivable_credit_card_brand;
        select cast(replace(json_extract(p_refund,'$.franchise_conciliator.receivable.gross_value'),"null",null) as unsigned) into @v_receivable_gross_value;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.full_name'),'"',""),"null",null) into @v_supplier_full_name;
        select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.type_person'),'"',""),"null",null) into @v_supplier_type_person;
        select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.identification_financial_responsible'),'"',""),"null",null) into @v_suplier_identification_financial_responsible;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.nationality_code'),'"',""),"null",null) into @v_suplier_nationality_code;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.state'),'"',""),"null",null) into @v_supplier_state;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.city'),'"',""),"null",null) into @v_supplier_city;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.adress'),'"',""),"null",null) into @v_supplier_adress;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.adress_complement'),'"',""),"null",null) into @v_supplier_adress_complement;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.postal_code'),'"',""),"null",null) into @v_supplier_postal_code;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.area_code'),'"',""),"null",null) into @v_supplier_area_code;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.district'),'"',""),"null",null) into @v_supplier_district;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.cellphone'),'"',""),"null",null) into @v_supplier_cellphone;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.email'),'"',""),"null",null) into @v_supplier_email;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.state_registration'),'"',""),"null",null) into @v_supplier_state_registration;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.municipal_registration'),'"',""),"null",null) into @v_supplier_municipal_registration;
		select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.final_consumer'),'"',""),"null",null) into @v_supplier_final_consumer;
        select replace(replace(json_extract(p_refund,'$.franchise_conciliator.supplier.icms_contributor'),'"',""),"null",null) into @v_supplier_icms_contributor;    
	end if; -- If 1
end$$
DELIMITER ;
