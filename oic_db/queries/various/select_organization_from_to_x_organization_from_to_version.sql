select 
	 organization_from_to_version.erp_business_unit
    ,organization_from_to_version.erp_legal_entity
    ,organization_from_to_version.erp_subsidiary
from organization_from_to

inner join organization_from_to_version
on organization_from_to_version.organization_from_to_unity_identification = organization_from_to.unity_identification
and organization_from_to_version.created_at = ( 
												select 
													max(organization_from_to_version_v2.created_at) as created_at
												from organization_from_to_version organization_from_to_version_v2 
                                                where organization_from_to_version.organization_from_to_unity_identification = organization_from_to_version_v2.organization_from_to_unity_identification
												)
order by 1,2,3;