INSERT INTO refund
(country,
origin_system,
operation,
unity_identification,
erp_business_unit,
erp_legal_entity,
erp_subsidiary,
acronym,
erp_refund_status_transaction,
erp_refund_sent_to_erp_at,
erp_refund_returned_from_erp_at,
erp_refund_log,
refund_requester_name,
refund_requester_identification,refund
issue_date,
due_date,
erp_refund_id,
front_refund_id,
refund_value,
bank_number,
bank_branch,
bank_branch_digit,
bank_account_number,
bank_account_number_digit,
bank_account_owner_name,
bank_account_owner_identification)
VALUES
('Brazil',-- country
'smartsystem', -- origin_system
'person_plan', -- operation
1, -- unity_identification
'BR01 - SMARTFIT', -- erp_business_unit
'07594978000178', -- erp_legal_entity
'BR010001', -- erp_subsidiary
'SPCMOR3', -- acronym
'waiting_to_be_process', -- erp_refund_status_transaction
null, -- erp_refund_sent_to_erp_at
null, -- erp_refund_returned_from_erp_at
null, -- erp_refund_log
'João da Silva', -- refund_requester_name
'98730168058', -- refund_requester_identification
'2019-11-19', -- issue_date
'2019-11-20', -- due_date
null, -- erp_refund_id
1546, -- front_refund_id
150.85, -- refund_value
'341', -- bank_number
'3150', -- bank_branch
'1', -- bank_branch_digit
'11542', -- bank_account_number
'0', -- bank_account_number_digit
'João da Silva', -- bank_account_owner_name
'98730168058'); -- bank_account_owner_identification

INSERT INTO refund_items
(refund_id,
front_id,
refund_item_value,
billing_date)
VALUES
(1546, -- refund_id
99877897, -- front_id
75.425, -- refund_item_value
'2019-01-10'); -- billing_date

INSERT INTO refund_items
(refund_id, -- refund_id
front_id, -- front_id
refund_item_value, -- refund_item_value
billing_date) -- billing_date
VALUES
(1546,
91237897,
75.425,
'2019-02-10');