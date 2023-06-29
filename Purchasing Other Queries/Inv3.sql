use P21
select       loc.item_id,
             loc.inv_mast_uid,
             loc.qty_on_hand, 
             loc.moving_average_cost,
             loc.location_id, 
             loc.inv_max, 
             loc.inv_min,
             shrv.cogs_amount

from p21_sales_history_report_view shrv

	left join p21_view_inv_loc loc 
ON  shrv.inv_mast_uid = loc.inv_mast_uid
where loc.moving_average_cost >=0 
and	  loc.qty_on_hand > 0