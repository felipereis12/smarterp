select 
erp_gl_natural_account_code
,erp_gl_natural_account_name
from natural_account_from_to_version naftv

where naftv.country = 'Brazil'
and naftv.natural_account_code = '<Colocar aqui a coluna CT2_DEBITO (para lançamento a débito) ou CT2_CREDIT (para lançamento a crédito) do arquivo integrador contábil ADP>';