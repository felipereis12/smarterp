select 
erp_gl_natural_account_code
,erp_gl_natural_account_name
from natural_account_from_to_version naftv

where naftv.country = 'Brazil'
and naftv.natural_account_code = '<Colocar aqui a coluna CT2_DEBITO (para lançamento a débito) ou CT2_CREDIT (para lançamento a crédito) do arquivo integrador contábil ADP>'
and naftv.created_at = ( select max(naftv.created_at) from natural_account_from_to_version naftv_v2 where  naftv_v2.natural_account_code = naftv.natural_account_code ) ;