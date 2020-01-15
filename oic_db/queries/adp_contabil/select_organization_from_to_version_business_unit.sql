select 
	erp_business_unit 
    ,erp_legal_entity
    ,erp_subsidiary
    ,erp_subsidiary_gl_brand_code
    ,erp_subsidiary_gl_brand_name
    ,unity_opening_date
from organization_from_to_version oftv 

where oftv.protheus_business_unit_code = '<Colocar aqui a coluna EMP do arquivo integrador contáBil ADP>' 
and oftv.protheus_subsidiary_code = '<Colocar aqui a coluna CT2_FILIAL do arquivo integrador contáBil ADP>' 
and oftv.created_at = ( select max(oftv_v2.created_at) from organization_from_to_version oftv_v2 where  oftv_v2.organization_from_to_unity_identification = oftv.organization_from_to_unity_identification ) ;