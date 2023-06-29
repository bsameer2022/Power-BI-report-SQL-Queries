-------Inventory POs Received Today and Yesterday------------
-------Developer Name: SAMEER BANDI
-------Date of Initial Development: 10/25/2022 (as mm/dd/yyyy)
-------Reason for Development: To develop a inventory POs received live report
SELECT 
phr.po_no,
phr.vendor_id,
phr.ship2_name,
phr.receipt_date,
phr.location_id,
phr.sales_order_number,
phr.source_type,
phr.supplier_id,
phr.purchase_group_id,
phr.po_type,
phr.created_by,
phr.order_date,
phr.delete_flag,
phr.cancel_flag,
il.product_group_id, 
phr.supplier_id, 
sup.supplier_name,  
pol.unit_price,
pol.qty_received,
pol.unit_price*(rl.qty_received/pol.unit_size) as value_received,
rh.date_created,
pol.po_no,
pol.qty_ordered,
pol.qty_received,
pol.received_date,
pol.unit_price,
pol.delete_flag,
pol.date_created,
pol.cancel_flag,
pol.item_description,
pol.unit_of_measure,
pol.unit_quantity,
pol.line_no,
pol.inv_mast_uid,
pol.source_type,
pol.po_line_uid

FROM p21_view_inventory_receipts_hdr rh

INNER JOIN p21_view_inventory_receipts_line rl ON rh.receipt_number = rl.receipt_number
INNER JOIN p21_view_po_hdr phr ON phr.po_no = rh.po_number
INNER JOIN p21_view_po_line pol ON pol.po_no = phr.po_no AND rl.po_line_number = pol.line_no ----check the po header uid and po line header uid
INNER JOIN p21_view_inv_loc il ON il.location_id = phr.location_id AND il.inv_mast_uid = pol.inv_mast_uid
INNER JOIN p21_view_supplier sup ON sup.supplier_id = phr.supplier_id

Where 
--(rh.date_created) > CAST( GETDATE() AS Date ) 

-- or CAST(rh.date_created as DATE) = DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE())       
--                   WHEN 'Sunday' THEN -2 
--                   WHEN 'Monday' THEN -3   
--                   ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))
--AND
rh.delete_flag <> 'Y'
AND rh.receipt_type = 'P'

group by Month(rh.date_created),
phr.location_id, 
il.product_group_id, 
phr.supplier_id, 
phr.po_no,
phr.vendor_id,
phr.ship2_name,
phr.receipt_date,
phr.location_id,
phr.sales_order_number,
phr.source_type,
phr.supplier_id,
phr.purchase_group_id,
phr.po_type,
phr.created_by,
phr.order_date,
phr.delete_flag,
phr.cancel_flag,
sup.supplier_name, 
pol.item_id, 
pol.item_description, 
pol.unit_price,
pol.qty_received,
rl.qty_received,
pol.unit_size,
rh.date_created,
pol.po_no,
pol.qty_ordered,
pol.qty_received,
pol.received_date,
pol.unit_price,
pol.delete_flag,
pol.date_created,
pol.cancel_flag,
pol.item_description,
pol.unit_of_measure,
pol.unit_quantity,
pol.line_no,
pol.inv_mast_uid,
pol.source_type,
pol.po_line_uid

