Select company_id,default_branch_id,product_group_id,primary_supplier_id,
YEAR(CURRENT_TIMESTAMP) Inv_year,
Month(CURRENT_TIMESTAMP) Period,
(qty_on_hand) ,
DAY(CURRENT_TIMESTAMP) InvDAY,
SUM(((qty_on_hand-special_layer_qty)*cost)+special_layer_value) Quantity_on_hand_value,
item_id
from p21_view_inventory_value_report ivr


group by company_id,
ivr.qty_on_hand,
default_branch_id,
product_group_id,
primary_supplier_id,
item_id


select loc.location_id
     , loc.qty_on_hand
     , loc.inv_mast_uid

from p21.dbo.p21_view_inv_loc loc

where loc.item_id='31990020'



select *

from P21.dbo.p21_view_inv_loc_stock_status ilss

where ilss.inv_mast_uid = '13108'