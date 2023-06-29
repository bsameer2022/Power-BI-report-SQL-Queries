
use P21
select  distinct 

irl.item_id,
irl.inv_mast_uid,
inl.inv_last_changed_date,
irl.qty_received,
inl.location_id,
inl.last_purchase_date,
month(inl.inv_last_changed_date) as month2022,
year(inl.inv_last_changed_date) as day2022

from p21_view_inventory_receipts_line irl

left join  p21_view_inv_loc inl 
		on inl.inv_mast_uid = irl.inv_mast_uid
left join p21_view_inventory_receipts_hdr irh
		on irh.po_number = irl.po_line_number

where year(inl.inv_last_changed_date)= 2022
--and inl.location_id = 1100
--and inl.item_id = 'A301006'