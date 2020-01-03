set @json_request = cast( '  {
    "otc": {
      "header": {
        "country": "Brazil",
        "unity_identification" : 1,
        "origin_system" : "biosystem",
        "operation": "person_plan",
        "minifactu_id": 1246845,
        "fin_id" : 12345,
        "erp_receivable_customer_identification" : "01425787000104",
        "front_id": 2131231
      },
      "invoice_customer": {
        "full_name": "João da Silva",
        "type_person": "natural_person",
        "identification_financial_responsible": 98730168058,
        "nationality_code": "BR",
        "state": "SP",
        "city": "São Paulo",
        "adress": "Av. Paulista",
        "adress_number": 1294,
        "adress_complement": "Segundo andar",
        "district": "Bela Vista",
        "postal_code": 364608,
        "area_code": 11,
        "cellphone": 912345678,
        "email": "felipe.nambara@bioritmo.com.br",
                "final_consumer": "yes",
        "icms_contributor": "no"
      },
      "receivable": {
        "is_smartfin": "no",
        "transaction_type": "credit_card_recurring",
        "contract_number": 1040380465,
        "credit_card_brand": "MASTER",
        "truncated_credit_card": "1234****6548",
        "current_credit_card_installment": 1,
        "total_credit_card_installment": 12,
        "nsu": 1234575,
        "authorization_code": 8887548,
        "price_list_value": 290.5,
        "gross_value": 191.58,
        "net_value": 190,
        "interest_value": 1.58,
        "administration_tax_percentage": 3.45,
        "administration_tax_value": 6.61,
        "billing_date": "2019-12-09",
        "credit_date": "2020-01-09",
        "conciliator_filename": "concil_filename_201912091632.txt",
        "acquirer_bank_filename": "cielo_filename_201912091632.txt",
        "registration_gym_student": 12345678,
        "fullname_gym_student": "Maria da Silva",
        "identification_gym_student": "Maria da Silva"
      },
      "invoice": {
        "transaction_type": "invoice_to_financial_responsible",
        "is_overdue_recovery": "no",
        "invoice_items": {
          "invoice_items": [
            {
              "front_product_id": 120366453,
              "front_plan_id": 1,
              "front_addon_id": null,
              "quantity": 1,
              "list_price": 145.25,
              "sale_price": 95
            },
            {
              "front_product_id": null,
              "front_plan_id": null,
              "front_addon_id": 1,
              "quantity": 1,
              "list_price": 145.25,
              "sale_price": 95
            }            
          ]
        }
      }
    }
  }' as json );

call sp_insert_order_to_cash_v2( @json_request ,@p_return ,	@p_code ,@p_message, @p_minifactu_id); 
                            
select @p_return,@p_code,cast(@p_message as char),@p_minifactu_id;

-- Missing node otc.header.erp_receivable_customer_identification at Json request ! Check the documentation https://app.swaggerhub.com/apis-docs/Smartfit/OrderToCash/1.0.0