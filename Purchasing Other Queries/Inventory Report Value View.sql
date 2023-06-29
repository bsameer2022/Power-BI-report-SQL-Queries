Select ivr.company_id,
ivr.item_id,
ivr.item_desc,
ivr.default_branch_id,
ivr.product_group_id,
ivr.primary_supplier_id,
YEAR(CURRENT_TIMESTAMP) as Inv_year,
Month(CURRENT_TIMESTAMP) as Period,
sum(qty_on_hand) as QoH_Quantity_On_Hand,
DAY(CURRENT_TIMESTAMP) as InvDAY,
SUM((qty_on_hand-special_layer_qty)*cost+special_layer_value) as QoHV_Quantity_On_Hand_Value

from p21_view_inventory_value_report ivr

group by ivr.company_id,
ivr.default_branch_id,
ivr.product_group_id,
ivr.primary_supplier_id,
ivr.item_id,
ivr.item_desc