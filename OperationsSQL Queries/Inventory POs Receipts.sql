SELECT ph.location_id, 
il.product_group_id, 
ph.supplier_id, 
sup.supplier_name, 
pl.item_id, 
pl.item_description, 
pl.unit_price,
pl.qty_received,
pl.unit_price*(rl.qty_received/pl.unit_size) as value_received,
rh.date_created

FROM p21_view_inventory_receipts_hdr rh

INNER JOIN p21_view_inventory_receipts_line rl ON rh.receipt_number = rl.receipt_number
INNER JOIN p21_view_po_hdr ph ON ph.po_no = rh.po_number
INNER JOIN p21_view_po_line pl ON pl.po_no = ph.po_no AND rl.po_line_number = pl.line_no
INNER JOIN p21_view_inv_loc il ON il.location_id = ph.location_id AND il.inv_mast_uid = pl.inv_mast_uid
INNER JOIN p21_view_supplier sup ON sup.supplier_id = ph.supplier_id

Where Year(rh.date_created) in (2021,2022)
-- WHERE CAST(rh.date_created as DATE) = DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) 
--                         WHEN 'Sunday' THEN -2 
--                         WHEN 'Monday' THEN -3 
--                         ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))
AND rh.delete_flag <> 'Y'
AND rh.receipt_type = 'P'

group by Month(rh.date_created),
ph.location_id, 
il.product_group_id, 
ph.supplier_id, 
sup.supplier_name, 
pl.item_id, 
pl.item_description, 
pl.unit_price,
pl.qty_received,
rl.qty_received,
pl.unit_size,
rh.date_created

order by rh.date_created