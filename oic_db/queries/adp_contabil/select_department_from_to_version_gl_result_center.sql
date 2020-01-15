select 
erp_gl_result_center_code
,erp_gl_result_center_name
from department_from_to_version dftv

where dftv.country = 'Brazil'
and dftv.department_code = '<Colocar aqui a coluna DEPARTAMENTO do arquivo integrador contábil ADP>'
and dftv.created_at = ( select max(dftv_v2.created_at) from department_from_to_version dftv_v2 where  dftv_v2.department_code = dftv.department_code ) ;