select 
erp_gl_result_center_code
,erp_gl_result_center_name
from department_from_to_version dftv

where dftv.country = 'Brazil'
and dftv.department_code = '<Colocar aqui a coluna DEPARTAMENTO do arquivo integrador contábil ADP>';