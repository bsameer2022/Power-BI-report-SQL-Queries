-------Developer Name: SAMEER BANDI
-------Date of Initial Development: 10/25/2022 (as mm/dd/yyyy)
-------Reason for Development: To develop a inventory value and metrics live report
Select company_id,default_branch_id, product_group_id,item_id,item_desc, primary_supplier_id, YEAR(CURRENT_TIMESTAMP) Inv_year,
Month(CURRENT_TIMESTAMP) Period,
sum(qty_on_hand) quantity_on_hand,  SUM((qty_on_hand-special_layer_qty)*cost+special_layer_value) Quantity_on_hand_value
from p21_view_inventory_value_report
group by company_id,default_branch_id, product_group_id,item_id, primary_supplier_id,item_desc