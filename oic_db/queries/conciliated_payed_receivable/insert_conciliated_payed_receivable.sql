INSERT INTO `oic_db`.`conciliated_payed_receivable`
(`country`, -- Criar uma integração para cada país. No caso do Brasil será um job para a conciliadora Concil
`erp_receipt_id`, -- Id único e imutável do receipt no Oracle
`erp_receipt_status_transaction`, -- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
`erp_receipt_sent_to_erp_at`, -- TimeStamp de quando o registro foi enviado para o Oracle
`erp_receipt_returned_from_erp_at`, -- TimeStamp de quando o registro retornou do Oracle
`erp_receipt_log`, -- Este campo deverá ser preenchido no retorno do Oracle
`erp_receivable_customer_id`, -- Desconsiderar
`conciliator_id`, -- Utilizar a coluna COD_ERP do arquivo de retorno da Concil
`concitiation_type`, -- Utilizar a coluna TIPO_LANCAMENTO do arquivo de retorno da Concil - ao ler o arquivo para ser gravado nessa tabela considerar somente o tipo PCV
`conciliation_description`, -- Utilizar a coluna DESCRICAO do arquivo de retorno da Concil 
`transaction_type`, -- Utilizar a coluna TIPO_TRANSACAO do arquivo de retorno da Concil - converter CREDITO para credit_card e DEBITO para debit_card
`contract_number`, -- Utilizar a coluna ESTABELECIMENTO do arquivo de retorno da Concil 
`credit_card_brand`, -- Utilizar a coluna BANDEIRA do arquivo de retorno da Concil - converter os valores AMEX para americanexpress, MASTERCARD para mastercard, HIPERCARD para hipercard, ELO para elo, VISA para visa e DINERS para diners
`truncated_credit_card`, -- Utilizar a coluna MASC_CARTAO do arquivo de retorno da Concil
`current_credit_card_installment`, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Left(NRO_PARCELA,2)
`total_credit_card_installment`, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Right(NRO_PARCELA,2)
`nsu`, -- Utilizar a coluna NSU do arquivo de retorno da Concil 
`authorization_code`, -- Utilizar a coluna AUTORIZACAO do arquivo de retorno da Concil 
`payment_lot`, -- Utilizar a coluna NR_RO do arquivo de retorno da Concil 
`price_list_value`, -- Desconsiderar
`gross_value`, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`net_value`, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`interest_value`, -- Desconsiderar
`administration_tax_percentage`, -- Utilizar a coluna TAXA/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`administration_tax_value`, -- Utilizar a coluna TAXA do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`antecipation_tax_percentage`, -- Utilizar a coluna VLR_DESC_ANTECIP/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`antecipation_tax_value`,-- Utilizar a coluna VLR_DESC_ANTECIP do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
`billing_date`, -- Utilizar a coluna DT_VENDA do arquivo de retorno da Concil 
`credit_date`, -- Utilizar a coluna DT_PAGAMENTO do arquivo de retorno da Concil 
`bank_number`, -- Utilizar a coluna NRO_BANCO do arquivo de retorno da Concil 
`bank_branch`, -- Utilizar a coluna NRO_AGENCIA do arquivo de retorno da Concil 
`bank_account`, -- Utilizar a coluna NRO_CONTA do arquivo de retorno da Concil 
`conciliator_filename`, -- Aqui deve ser gravado o nome do arquivo lido
`acquirer_bank_filename`) -- Utilizar a coluna NOME_ARQUIVO do arquivo de retorno da Concil 
VALUES
('Brazil', -- country
null, -- erp_receipt_id
'waiting_to_be_process', -- erp_receipt_status_transaction
null, -- erp_receipt_sent_to_erp_at
null, -- erp_receipt_returned_from_erp_at
null, -- erp_receivable_log
null, -- erp_receivable_customer_id
'abc123', -- conciliator_id
'PCV', -- concitiation_type
'COMPROVANTE', -- conciliation_description
'credit_card', -- transaction_type
'1288329736', -- contract_number
'mastercard', -- credit_card_brand
'1232****8872', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'883765246', -- nsu
null, -- authorization_code
'332412', -- payment_lot
290.90, -- price_list_value
109.80, -- gross_value
109.80, -- net_value
0, -- interest_value
3.1, -- administration_tax_percentage
34.038, -- administration_tax_value
0, -- antecipation_tax_percentage
0, -- antecipation_tax_value
'2019-10-17', -- billing_date
'2019-11-17', -- credit_date
'341', -- bank_number
'1123', -- bank_branch
'77662537', -- bank_account
null, -- conciliator_filename
null); -- acquirer_bank_filename

INSERT INTO `oic_db`.`conciliated_payed_receivable`
(`country`,
`erp_receipt_id`,
`erp_receipt_status_transaction`,
`erp_receipt_sent_to_erp_at`,
`erp_receipt_returned_from_erp_at`,
`erp_receipt_log`,
`erp_receivable_customer_id`,
`conciliator_id`,
`concitiation_type`,
`conciliation_description`,
`transaction_type`,
`contract_number`,
`credit_card_brand`,
`truncated_credit_card`,
`current_credit_card_installment`,
`total_credit_card_installment`,
`nsu`,
`authorization_code`,
`payment_lot`,
`price_list_value`,
`gross_value`,
`net_value`,
`interest_value`,
`administration_tax_percentage`,
`administration_tax_value`,
`antecipation_tax_percentage`, 
`antecipation_tax_value`,
`billing_date`,
`credit_date`,
`bank_number`,
`bank_branch`,
`bank_account`,
`conciliator_filename`,
`acquirer_bank_filename`)
VALUES
('Brazil', -- country
null, -- erp_receipt_id
'waiting_to_be_process', -- erp_receipt_status_transaction
null, -- erp_receipt_sent_to_erp_at
null, -- erp_receipt_returned_from_erp_at
null, -- erp_receivable_log
null, -- erp_receivable_customer_id
'hdjuhs123', -- conciliator_id
'PCV', -- concitiation_type
'COMPROVANTE', -- conciliation_description
'credit_card', -- transaction_type
'1288329736', -- contract_number
'mastercard', -- credit_card_brand
'2134****2993', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'3276518275', -- nsu
null, -- authorization_code
'332412', -- payment_lot
290.80, -- price_list_value
109.80, -- gross_value
109.80, -- net_value
0, -- interest_value
3.1, -- administration_tax_percentage
34.038, -- administration_tax_value
0, -- antecipation_tax_percentage
0, -- antecipation_tax_value
'2019-10-18', -- billing_date
'2019-11-18', -- credit_date
'341', -- bank_number
'1123', -- bank_branch
'77662537', -- bank_account
null, -- conciliator_filename
null); -- acquirer_bank_filename


INSERT INTO `oic_db`.`conciliated_payed_receivable`
(`country`,
`erp_receipt_id`,
`erp_receipt_status_transaction`,
`erp_receipt_sent_to_erp_at`,
`erp_receipt_returned_from_erp_at`,
`erp_receipt_log`,
`erp_receivable_customer_id`,
`conciliator_id`,
`concitiation_type`,
`conciliation_description`,
`transaction_type`,
`contract_number`,
`credit_card_brand`,
`truncated_credit_card`,
`current_credit_card_installment`,
`total_credit_card_installment`,
`nsu`,
`authorization_code`,
`payment_lot`,
`price_list_value`,
`gross_value`,
`net_value`,
`interest_value`,
`administration_tax_percentage`,
`administration_tax_value`,
`antecipation_tax_percentage`, 
`antecipation_tax_value`,
`billing_date`,
`credit_date`,
`bank_number`,
`bank_branch`,
`bank_account`,
`conciliator_filename`,
`acquirer_bank_filename`)
VALUES
('Brazil', -- country
null, -- erp_receipt_id
'waiting_to_be_process', -- erp_receipt_status_transaction
null, -- erp_receipt_sent_to_erp_at
null, -- erp_receipt_returned_from_erp_at
null, -- erp_receivable_log
null, -- erp_receivable_customer_id
'hdjude123', -- conciliator_id
'PCV', -- concitiation_type
'COMPROVANTE', -- conciliation_description
'credit_card', -- transaction_type
'1288329736', -- contract_number
'mastercard', -- credit_card_brand
'2154****2992', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'3278628275', -- nsu
null, -- authorization_code
'332412', -- payment_lot
329.00, -- price_list_value
109.80, -- gross_value
109.80, -- net_value
0, -- interest_value
3.1, -- administration_tax_percentage
34.038, -- administration_tax_value
0, -- antecipation_tax_percentage
0, -- antecipation_tax_value
'2019-10-18', -- billing_date
'2019-11-18', -- credit_date
'341', -- bank_number
'1123', -- bank_branch
'77662537', -- bank_account
null, -- conciliator_filename
null); -- acquirer_bank_filename
