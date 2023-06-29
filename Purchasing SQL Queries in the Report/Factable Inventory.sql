select distinct il.inv_mast_uid,
il.item_id, 
m.item_desc,  
il.location_id,
il.product_group_id

 

from p21_view_inv_loc il
inner join p21_view_inv_mast m 
on m.inv_mast_uid = il.inv_mast_uid 
and m.item_id = il.item_id

where il.company_id in ('01','03')


order by il.item_id