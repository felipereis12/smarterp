select 
	 oftv.erp_business_unit
    ,oftv.erp_legal_entity
    ,oftv.erp_subsidiary
from organization_from_to oft

inner join organization_from_to_version oftv
on oftv.organization_from_to_unity_identification = oft.unity_identification
and oftv.created_at = ( 
												select 
													max(oft_v2.created_at) as created_at
												from organization_from_to_version oft_v2 
                                                where oft_v2.organization_from_to_unity_identification = oftv.organization_from_to_unity_identification
												)
                                                
where ( oftv.to_generate_customer = 'yes' 
		or	oftv.to_generate_receivable = 'yes' 
        or	oftv.to_generate_invoice = 'yes' )

order by 1,2,3;