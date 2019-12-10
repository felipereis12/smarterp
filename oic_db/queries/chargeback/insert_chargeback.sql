INSERT INTO chargeback
(country,-- Criar uma integração para cada país. No caso do Brasil será um job para a conciliadora Concil
erp_clustered_chargeback_id, -- Id do aglutinado de chargeback
erp_receipt_id, -- Id único e imutável do receipt no Oracle
erp_receipt_status_transaction, -- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
erp_receipt_sent_to_erp_at, -- TimeStamp de quando o registro foi enviado para o Oracle
erp_receipt_returned_from_erp_at, -- TimeStamp de quando o registro retornou do Oracle
erp_receivable_log,-- Este campo deverá ser preenchido no retorno do Oracle
front_status_transaction,-- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
front_sent_to_front_at, -- TimeStamp de quando o registro foi enviado para o Front
front_returned_from_front_at, -- TimeStamp de quando o registro retornou do Front
front_log, -- Este campo deverá ser preenchido no retorno do Front
chargeback_acquirer_label, -- Utilizar a coluna ADQUIRENTE do arquivo de retorno da Concil
conciliator_id, -- Utilizar a coluna COD_ERP do arquivo de retorno da Concil
concitiation_type, -- Utilizar a coluna TIPO_LANCAMENTO do arquivo de retorno da Concil - ao ler o arquivo para ser gravado nessa tabela considerar somente o tipo CHBK
conciliation_description, -- Utilizar a coluna DESCRICAO do arquivo de retorno da Concil 
transaction_type, -- Utilizar a coluna TIPO_TRANSACAO do arquivo de retorno da Concil - converter CREDITO para credit_card e DEBITO para debit_card
contract_number,-- Utilizar a coluna ESTABELECIMENTO do arquivo de retorno da Concil 
credit_card_brand, -- Utilizar a coluna BANDEIRA do arquivo de retorno da Concil - converter os valores AMEX para americanexpress, MASTER para MASTER, HIPERCARD para hipercard, ELO para elo, VISA para VISA e DINERS para diners
truncated_credit_card, -- Utilizar a coluna MASC_CARTAO do arquivo de retorno da Concil
current_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Left(NRO_PARCELA,2)
total_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Right(NRO_PARCELA,2)
nsu, -- Utilizar a coluna NSU do arquivo de retorno da Concil 
authorization_code, -- Utilizar a coluna AUTORIZACAO do arquivo de retorno da Concil 
payment_lot, -- Utilizar a coluna NR_RO do arquivo de retorno da Concil 
price_list_value, -- Desconsiderar
gross_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
net_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
interest_value,-- Desconsiderar
administration_tax_percentage,-- Utilizar a coluna TAXA/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
administration_tax_value, -- Utilizar a coluna TAXA do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_percentage,-- Utilizar a coluna VLR_DESC_ANTECIP/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_value,-- Utilizar a coluna VLR_DESC_ANTECIP do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
billing_date, -- Utilizar a coluna DT_VENDA do arquivo de retorno da Concil 
credit_date, -- Utilizar a coluna DT_PAGAMENTO do arquivo de retorno da Concil 
bank_number, -- Utilizar a coluna NRO_BANCO do arquivo de retorno da Concil 
bank_branch, -- Utilizar a coluna NRO_AGENCIA do arquivo de retorno da Concil 
bank_account, -- Utilizar a coluna NRO_CONTA do arquivo de retorno da Concil 
conciliator_filename, -- Aqui deve ser gravado o nome do arquivo lido
acquirer_bank_filename) -- Utilizar a coluna NOME_ARQUIVO do arquivo de retorno da Concil 
VALUES
('Brazil', -- country
null, -- erp_clustered_chargeback_id
null, -- erp_receipt_id
'waiting_to_be_process', -- erp_receipt_status_transaction
null, -- erp_receipt_sent_to_erp_at
null, -- erp_receipt_returned_from_erp_at
null, -- erp_receivable_log
'waiting_to_be_process', -- front_status_transaction
null, -- front_sent_to_front_at
null, -- front_returned_from_front_at
null, -- front_log
'CIELO', -- chargeback_acquirer_label
'abc123', -- conciliator_id
'CHBK', -- concitiation_type
'CANCELAMENTO EFETUADO PELO PORTADOR', -- conciliation_description
'credit_card', -- transaction_type
'1288329736', -- contract_number
'MASTER', -- credit_card_brand
'1232****8872', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'883765246', -- nsu
null, -- authorization_code
'332412', -- payment_lot
290.9, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
0, -- interest_value
3.1, -- administration_tax_percentage
34.038, -- administration_tax_value
0, -- antecipation_tax_percentage
0, -- antecipation_tax_value
'2019-11-17', -- billing_date
'2019-11-29', -- credit_date
'341', -- bank_number
'1123', -- bank_branch
'77662537', -- bank_account
null, -- conciliator_filename
null); -- acquirer_bank_filename


INSERT INTO chargeback
(country,-- Criar uma integração para cada país. No caso do Brasil será um job para a conciliadora Concil
erp_clustered_chargeback_id, -- Id do aglutinado de chargeback
erp_receipt_id, -- Id único e imutável do receipt no Oracle
erp_receipt_status_transaction, -- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
erp_receipt_sent_to_erp_at, -- TimeStamp de quando o registro foi enviado para o Oracle
erp_receipt_returned_from_erp_at, -- TimeStamp de quando o registro retornou do Oracle
erp_receivable_log,-- Este campo deverá ser preenchido no retorno do Oracle
front_status_transaction,-- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
front_sent_to_front_at, -- TimeStamp de quando o registro foi enviado para o Front
front_returned_from_front_at, -- TimeStamp de quando o registro retornou do Front
front_log, -- Este campo deverá ser preenchido no retorno do Front
chargeback_acquirer_label, -- Utilizar a coluna ADQUIRENTE do arquivo de retorno da Concil
conciliator_id, -- Utilizar a coluna COD_ERP do arquivo de retorno da Concil
concitiation_type, -- Utilizar a coluna TIPO_LANCAMENTO do arquivo de retorno da Concil - ao ler o arquivo para ser gravado nessa tabela considerar somente o tipo CHBK
conciliation_description, -- Utilizar a coluna DESCRICAO do arquivo de retorno da Concil 
transaction_type, -- Utilizar a coluna TIPO_TRANSACAO do arquivo de retorno da Concil - converter CREDITO para credit_card e DEBITO para debit_card
contract_number,-- Utilizar a coluna ESTABELECIMENTO do arquivo de retorno da Concil 
credit_card_brand, -- Utilizar a coluna BANDEIRA do arquivo de retorno da Concil - converter os valores AMEX para americanexpress, MASTER para MASTER, HIPERCARD para hipercard, ELO para elo, VISA para VISA e DINERS para diners
truncated_credit_card, -- Utilizar a coluna MASC_CARTAO do arquivo de retorno da Concil
current_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Left(NRO_PARCELA,2)
total_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Right(NRO_PARCELA,2)
nsu, -- Utilizar a coluna NSU do arquivo de retorno da Concil 
authorization_code, -- Utilizar a coluna AUTORIZACAO do arquivo de retorno da Concil 
payment_lot, -- Utilizar a coluna NR_RO do arquivo de retorno da Concil 
price_list_value, -- Desconsiderar
gross_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
net_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
interest_value,-- Desconsiderar
administration_tax_percentage,-- Utilizar a coluna TAXA/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
administration_tax_value, -- Utilizar a coluna TAXA do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_percentage,-- Utilizar a coluna VLR_DESC_ANTECIP/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_value,-- Utilizar a coluna VLR_DESC_ANTECIP do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
billing_date, -- Utilizar a coluna DT_VENDA do arquivo de retorno da Concil 
credit_date, -- Utilizar a coluna DT_PAGAMENTO do arquivo de retorno da Concil 
bank_number, -- Utilizar a coluna NRO_BANCO do arquivo de retorno da Concil 
bank_branch, -- Utilizar a coluna NRO_AGENCIA do arquivo de retorno da Concil 
bank_account, -- Utilizar a coluna NRO_CONTA do arquivo de retorno da Concil 
conciliator_filename, -- Aqui deve ser gravado o nome do arquivo lido
acquirer_bank_filename) -- Utilizar a coluna NOME_ARQUIVO do arquivo de retorno da Concil 
VALUES
('Brazil', -- country
null, -- erp_clustered_chargeback_id
null, -- erp_receipt_id
'waiting_to_be_process', -- erp_receipt_status_transaction
null, -- erp_receipt_sent_to_erp_at
null, -- erp_receipt_returned_from_erp_at
null, -- erp_receivable_log
'waiting_to_be_process', -- front_status_transaction
null, -- front_sent_to_front_at
null, -- front_returned_from_front_at
null, -- front_log
'CIELO', -- chargeback_acquirer_label
'hdjuhs123', -- conciliator_id
'CHBK', -- concitiation_type
'CANCELAMENTO EFETUADO PELO PORTADOR', -- conciliation_description
'credit_card', -- transaction_type
'1288329736', -- contract_number
'MASTER', -- credit_card_brand
'2134****2993', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'3276518275', -- nsu
null, -- authorization_code
'332412', -- payment_lot
290.9, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
0, -- interest_value
3.1, -- administration_tax_percentage
34.038, -- administration_tax_value
0, -- antecipation_tax_percentage
0, -- antecipation_tax_value
'2019-11-17', -- billing_date
'2019-11-29', -- credit_date
'341', -- bank_number
'1123', -- bank_branch
'77662537', -- bank_account
null, -- conciliator_filename
null); -- acquirer_bank_filename

INSERT INTO chargeback
(country,-- Criar uma integração para cada país. No caso do Brasil será um job para a conciliadora Concil
erp_clustered_chargeback_id, -- Id do aglutinado de chargeback
erp_receipt_id, -- Id único e imutável do receipt no Oracle
erp_receipt_status_transaction, -- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
erp_receipt_sent_to_erp_at, -- TimeStamp de quando o registro foi enviado para o Oracle
erp_receipt_returned_from_erp_at, -- TimeStamp de quando o registro retornou do Oracle
erp_receivable_log,-- Este campo deverá ser preenchido no retorno do Oracle
front_status_transaction,-- Ao ler o arquivo da Concil preencher com 'waiting_to_be_process'
front_sent_to_front_at, -- TimeStamp de quando o registro foi enviado para o Front
front_returned_from_front_at, -- TimeStamp de quando o registro retornou do Front
front_log, -- Este campo deverá ser preenchido no retorno do Front
chargeback_acquirer_label, -- Utilizar a coluna ADQUIRENTE do arquivo de retorno da Concil
conciliator_id, -- Utilizar a coluna COD_ERP do arquivo de retorno da Concil
concitiation_type, -- Utilizar a coluna TIPO_LANCAMENTO do arquivo de retorno da Concil - ao ler o arquivo para ser gravado nessa tabela considerar somente o tipo CHBK
conciliation_description, -- Utilizar a coluna DESCRICAO do arquivo de retorno da Concil 
transaction_type, -- Utilizar a coluna TIPO_TRANSACAO do arquivo de retorno da Concil - converter CREDITO para credit_card e DEBITO para debit_card
contract_number,-- Utilizar a coluna ESTABELECIMENTO do arquivo de retorno da Concil 
credit_card_brand, -- Utilizar a coluna BANDEIRA do arquivo de retorno da Concil - converter os valores AMEX para americanexpress, MASTER para MASTER, HIPERCARD para hipercard, ELO para elo, VISA para VISA e DINERS para diners
truncated_credit_card, -- Utilizar a coluna MASC_CARTAO do arquivo de retorno da Concil
current_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Left(NRO_PARCELA,2)
total_credit_card_installment, -- Utilizar a coluna NRO_PARCELA do arquivo de retorno da Concil -- Right(NRO_PARCELA,2)
nsu, -- Utilizar a coluna NSU do arquivo de retorno da Concil 
authorization_code, -- Utilizar a coluna AUTORIZACAO do arquivo de retorno da Concil 
payment_lot, -- Utilizar a coluna NR_RO do arquivo de retorno da Concil 
price_list_value, -- Desconsiderar
gross_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
net_value, -- Utilizar a coluna VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
interest_value,-- Desconsiderar
administration_tax_percentage,-- Utilizar a coluna TAXA/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
administration_tax_value, -- Utilizar a coluna TAXA do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_percentage,-- Utilizar a coluna VLR_DESC_ANTECIP/VLR_PAGO do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
antecipation_tax_value,-- Utilizar a coluna VLR_DESC_ANTECIP do arquivo de retorno da Concil (dividir por 100, pois o número do arquivo está sem pontuação decimal)
billing_date, -- Utilizar a coluna DT_VENDA do arquivo de retorno da Concil 
credit_date, -- Utilizar a coluna DT_PAGAMENTO do arquivo de retorno da Concil 
bank_number, -- Utilizar a coluna NRO_BANCO do arquivo de retorno da Concil 
bank_branch, -- Utilizar a coluna NRO_AGENCIA do arquivo de retorno da Concil 
bank_account, -- Utilizar a coluna NRO_CONTA do arquivo de retorno da Concil 
conciliator_filename, -- Aqui deve ser gravado o nome do arquivo lido
acquirer_bank_filename) -- Utilizar a coluna NOME_ARQUIVO do arquivo de retorno da Concil 
VALUES
('Brazil', -- country
null, -- erp_clustered_chargeback_id
null, -- erp_receipt_id
'waiting_to_be_process', -- erp_receipt_status_transaction
null, -- erp_receipt_sent_to_erp_at
null, -- erp_receipt_returned_from_erp_at
null, -- erp_receivable_log
'waiting_to_be_process', -- front_status_transaction
null, -- front_sent_to_front_at
null, -- front_returned_from_front_at
null, -- front_log
'CIELO', -- chargeback_acquirer_label
'hdjude123', -- conciliator_id
'CHBK', -- concitiation_type
'CANCELAMENTO EFETUADO PELO PORTADOR', -- conciliation_description
'credit_card', -- transaction_type
'1288329736', -- contract_number
'MASTER', -- credit_card_brand
'2154****2992', -- truncated_credit_card
1, -- current_credit_card_installment
1, -- total_credit_card_installment
'3278628275', -- nsu
null, -- authorization_code
'332412', -- payment_lot
329, -- price_list_value
109.8, -- gross_value
109.8, -- net_value
0, -- interest_value
3.1, -- administration_tax_percentage
34.038, -- administration_tax_value
0, -- antecipation_tax_percentage
0, -- antecipation_tax_value
'2019-11-17', -- billing_date
'2019-11-29', -- credit_date
'341', -- bank_number
'1123', -- bank_branch
'77662537', -- bank_account
null, -- conciliator_filename
null); -- acquirer_bank_filename