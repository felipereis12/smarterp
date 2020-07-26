SELECT 
pay.erp_business_unit, 
pay.erp_legal_entity, 
pay.erp_subsidiary, 
otc.front_id, 
pecg.erp_source_name,
pecg.erp_currency_code, 
pecg.erp_payment_code, 
pecg.erp_invoice_type, 
pecg.erp_payments_terms, 
sup.identification_financial_responsible, 
sup.full_name, 
sup.erp_supplier_id, 
-- rec.erp_receivable_id, 
inv.order_to_cash_id,
pay.erp_clustered_receivable_id, 
Round(SUM(pay.gross_value), 2) 
AS gross_value, 
IF(Month(pay.issue_date) = Month(Current_date()), pay.issue_date, Current_date()) AS erp_trx_date,
IF(Month(pay.issue_date) = Month(Current_date()), pay.issue_date, Current_date()) AS erp_gl_date
FROM   payable pay 
		inner join receivable rec 
				ON rec.id = pay.receivable_id
		inner join order_to_cash otc 
				ON otc.id = rec.order_to_cash_id
		inner join invoice inv
				ON inv.order_to_cash_id = otc.id
		inner join supplier sup 
               ON sup.identification_financial_responsible = pay.supplier_identification 
       left join payable_erp_configurations pecg 
              ON pecg.country = otc.country 
                 AND pecg.origin_system = otc.origin_system 
                 AND pecg.operation = otc.operation 
                 AND pecg.transaction_type = rec.transaction_type 
                 AND pecg.converted_smartfin = rec.converted_smartfin 
WHERE     otc.country = #country 
		AND otc.origin_system = #company 
		AND otc.operation = #plan_type 
        AND rec.transaction_type = #pay_method 
        AND pay.erp_subsidiary = #filial 
		AND pay.erp_payable_status_transaction = 'waiting_to_be_process' 
		AND pay.erp_payable_id IS NULL 
--      AND rec.erp_receivable_id IS NOT NULL
		AND inv.order_to_cash_id IS NOT NULL 
		AND pay.erp_supplier_id IS NOT NULL 
GROUP  BY pay.erp_business_unit, 
          pay.erp_legal_entity, 
          pay.erp_subsidiary, 
          otc.front_id, 
          pecg.erp_source_name, 
          pecg.erp_currency_code, 
          pecg.erp_payment_code, 
          pecg.erp_invoice_type, 
          pecg.erp_payments_terms, 
          sup.identification_financial_responsible, 
          sup.full_name, 
          sup.erp_supplier_id,
          inv.order_to_cash_id,
--          rec.erp_receivable_id, 
          pay.issue_date;