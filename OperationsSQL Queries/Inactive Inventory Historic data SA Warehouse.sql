-------Developer Name: SAMEER BANDI
-------Date of Initial Development: 11/02/2022 (as mm/dd/yyyy)
-------Reason for Development: To develop a inactive inventory report

SELECT DISTINCT
location_id
,product_group_id
,item_id
,item_desc
,supplier_name
,qty_on_hand
,moving_average_cost
,qty_on_hand * moving_average_cost as value_on_hand
,value_on_hand
,last_order_date
,last_po_recived_date
,last_transfer_in
,last_transfer_out
,last_usage
,age_in_days
,qty_allocated
,qty_for_production
,backup_date

from dbo.inactive_inv ii

where year(backup_date) = 2022 


group by
location_id
,product_group_id
,item_id
,item_desc
,supplier_name
,qty_on_hand
,moving_average_cost
,value_on_hand
,last_order_date
,last_po_recived_date
,last_transfer_in
,last_transfer_out
,last_usage
,age_in_days
,qty_allocated
,qty_for_production
,backup_date
order by backup_date
