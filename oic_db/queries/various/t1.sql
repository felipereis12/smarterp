-- CREATE TABLE t1 (jdoc JSON);
	set sql_mode = traditional;	    

SELECT JSON_EXTRACT('[ { "front_product_id": 1123, "front_plan_id": 231, "front_addon_id": null, "quantity": 1, "list_price": 145.25, "sale_price": 95 } ]', '$[0].front_addon_id');

SELECT JSON_EXTRACT( cast('[ { "front_product_id": 120366453, "front_plan_id": 1, "front_addon_id": null, "quantity": 1, "list_price": 200, "sale_price": 100 } ]' as json), '$[0].front_product_id'  );
-- $.invoice_items.[0].front_product_id
-- $.invoice_items[0].front_plan_id
SELECT JSON_EXTRACT('{ "invoice_items" : [ { "front_product_id": 1123, "front_plan_id": 231, "front_addon_id": null, "quantity": 1, "list_price": 145.25, "sale_price": 95 } ]}', '$.invoice_items[0].front_plan_id');

SELECT JSON_LENGTH('[ { 	"front_product_id": 1123
						, 	"front_plan_id": 231
                        , 	"front_addon_id": null
                        , 	"quantity": 1
						, 	"list_price": 145.25
                        , 	"sale_price": 95 },
                        { 	"front_product_id": 1123
						, 	"front_plan_id": 231
                        , 	"front_addon_id": null
                        , 	"quantity": 1
						, 	"list_price": 145.25
                        , 	"sale_price": 95 }
                        ]');