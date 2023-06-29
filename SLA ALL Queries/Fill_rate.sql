select   fill_rate.ship_loc_id,
month (fill_rate.order_date) as month,
year (fill_rate.order_date) as year,
count (fill_rate.line_no) as total_lines

from sa_view_order_fill_rate_data as fill_rate
left outer join sa_view_sales_order_creation_audit as audit
on audit.uid_value = fill_rate.oe_line_uid 
where fill_rate.stockable = 'y'



--and fill_rate.order_date > GETDATE() 

--group by fill_rate.ship_loc_id

--order by fill_rate.ship_loc_id ASC

