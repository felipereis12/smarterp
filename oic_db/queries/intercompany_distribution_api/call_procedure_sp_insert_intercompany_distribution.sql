set @json_request = cast(  '{
   "intercompany_distribution":{
      "header":{
         "country": "Brazil",
         "origin_system": "corporatepass",
         "operation": "distribution",
         "unity_identification_receivable": 307,
         "unity_identification_payable": 15,
         "front_intercompany_distribution_id": 4234,
         "issue_date":"2019-12-30",
         "due_date":"2020-01-30",
         "gross_value": 12000
      },
      "invoice" : 
			{ 
				"invoice_items" : 
                [
					{
						"front_product_id" : 1,
						"quantity" : 1,
						"sale_price" : 6000
                    },
					{
						"front_product_id" : 1,
						"quantity" : 1,
						"sale_price" : 6000
                    }                    
                ]
			}
   }
}' as json );

call sp_insert_inter_distrib( @json_request ,@p_return ,   @p_code ,@p_message, @p_inter_distrib_id); 
                            
select @p_return as retorno ,@p_code,cast(@p_message as char),@p_inter_distrib_id;