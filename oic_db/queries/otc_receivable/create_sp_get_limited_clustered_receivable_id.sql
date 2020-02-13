DROP PROCEDURE IF EXISTS sp_get_limited_clustered_receivable_id; 
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `sp_get_limited_clustered_receivable_id`( 	IN p_country varchar(45)													
                                                        , 	IN p_origin_system varchar(45) 
														, 	IN p_operation varchar(45) 
														,	IN p_transaction_type varchar(45)
                                                        ,	IN p_subsidiary varchar(45)
                                                        ,	IN p_id integer
                                                        , 	IN p_limit integer )
BEGIN

CREATE TABLE if not exists integration_clustered_receivable (
  keycontrol int(11) NOT NULL,
  clustered_receivable_id int(11) DEFAULT NULL,
  UNIQUE KEY clustered_receivable_id_UNIQUE (clustered_receivable_id),
  KEY idx1 (keycontrol)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into integration_clustered_receivable

select
	distinct 
    p_id
    ,rec.erp_clustered_receivable_id    
from receivable rec

inner join order_to_cash otc
on otc.id = rec.order_to_cash_id

inner join customer crc
on crc.identification_financial_responsible = otc.erp_receivable_customer_identification

left join receivable_erp_configurations recg
on recg.country = otc.country
and recg.origin_system = otc.origin_system
and recg.operation = otc.operation
and recg.transaction_type = rec.transaction_type
and recg.converted_smartfin = rec.converted_smartfin
and recg.memoline_setting = 'gross_value'

where otc.country = p_country -- Integração em paralalo por operação do país
	and otc.erp_subsidiary = p_subsidiary -- Filtro por filial (loop automático)
	and otc.origin_system = p_origin_system -- Integração em paralalo por origem (SmartFit, BioRitmo, etc...)
	and otc.operation = p_operation -- Integração em paralalo por operação (plano de alunos, plano corporativo, etc...)
	and otc.erp_receivable_status_transaction = 'clustered_receivable_created' -- Filtrar somente os registros que ainda não foram integrados com o erp e estão aguardando processamento
	and otc.to_generate_receivable = 'yes'
	and rec.erp_clustered_receivable_id is not null -- Filtrar somente os receivables que possui relacionamento com a clustered_receivable
	and rec.erp_clustered_receivable_customer_id is not null -- Filtrar somente os receivables que possui relacionamento com a customer 
	and rec.erp_receivable_id is null -- Filtrar somente os receivables que ainda não foram integrados com o erp
	and rec.transaction_type = p_transaction_type -- Integração em paralalo por tipo de transação (Cartão de crédito recorrente, cartão de débito recorrente, débito em conta, boleto etc...)
	and rec.gross_value > 0
    
limit p_limit;

END$$
DELIMITER ;
