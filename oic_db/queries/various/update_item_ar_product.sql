update invoice_items iit

inner join invoice inv
on inv.id = iit.id_invoice

inner join order_to_cash otc
on otc.id = inv.order_to_cash_id

/*
inner join product_from_to_version pftv
on pftv.product_from_to_origin_system = otc.origin_system
and pftv.product_from_to_operation = otc.operation
and pftv.product_from_to_front_product_id = iit.front_product_id

set iit.erp_item_ar_id = pftv.erp_item_ar_overdue_recovery_id, iit.erp_item_ar_name = pftv.erp_item_ar_overdue_recovery_name

inner join addon_from_to_version aftv
on aftv.addon_from_to_origin_system = otc.origin_system
and aftv.addon_from_to_operation = otc.operation
and aftv.addon_from_to_front_addon_id = iit.front_addon_id

set iit.erp_item_ar_id = aftv.erp_item_ar_overdue_recovery_id, iit.erp_item_ar_name = aftv.erp_item_ar_overdue_recovery_name


inner join product_from_to_version pftv
on pftv.product_from_to_origin_system = otc.origin_system
and pftv.product_from_to_operation = otc.operation
and pftv.product_from_to_front_product_id = iit.front_product_id

set iit.erp_item_ar_id = pftv.erp_item_ar_overdue_recovery_id, iit.erp_item_ar_name = pftv.erp_item_ar_overdue_recovery_name


inner join plan_from_to_version pftv
on pftv.plan_from_to_origin_system = otc.origin_system
and pftv.plan_from_to_operation = otc.operation
and pftv.plan_from_to_front_plan_id = iit.front_plan_id

set iit.erp_item_ar_id = pftv.erp_item_ar_overdue_recovery_id, iit.erp_item_ar_name = pftv.erp_item_ar_overdue_recovery_name
*/

inner join product_from_to_version pftv
on pftv.product_from_to_origin_system = otc.origin_system
and pftv.product_from_to_operation = otc.operation
and pftv.product_from_to_front_product_id = iit.front_product_id
and pftv.id = ( select 
						max(pftv_v2.id) 
				from  product_from_to_version pftv_v2 
				where pftv_v2.product_from_to_origin_system = pftv.product_from_to_origin_system
                and pftv_v2.product_from_to_operation = pftv.product_from_to_operation
                and pftv_v2.product_from_to_front_product_id = pftv.product_from_to_front_product_id )

set iit.erp_item_ar_id = pftv.erp_item_ar_id, iit.erp_item_ar_name = pftv.erp_item_ar_name

/*
inner join plan_from_to_version pftv
on pftv.plan_from_to_origin_system = otc.origin_system
and pftv.plan_from_to_operation = otc.operation
and pftv.plan_from_to_front_plan_id = iit.front_plan_id
and pftv.id = ( select 
						max(pftv_v2.id) 
				from  plan_from_to_version pftv_v2 
				where pftv_v2.plan_from_to_origin_system = pftv.plan_from_to_origin_system
                and pftv_v2.plan_from_to_operation = pftv.plan_from_to_operation
                and pftv_v2.plan_from_to_front_plan_id = pftv.plan_from_to_front_plan_id )

set iit.erp_item_ar_id = pftv.erp_item_ar_id, iit.erp_item_ar_name = pftv.erp_item_ar_name

*/

where otc.origin_system = 'biosystem'
and otc.operation = 'corporate_plan';