select 


invr.item_id,
shrv.sales_price,
(((invr.qty_on_hand-invr.special_layer_qty)*invr.cost)+invr.special_layer_value) as QoH_Value


from p21_view_inventory_value_report invr
left join p21_view_inv_loc iloc on
--invr.location_id = iloc.location_id and 
invr.inv_mast_uid = iloc.inv_mast_uid
LEFT JOIN p21_sales_history_report_view shrv ON  shrv.inv_mast_uid = invr.inv_mast_uid AND shrv.branch_id = invr.location_id

where invr.item_id =  '378GKTTL 2XL'