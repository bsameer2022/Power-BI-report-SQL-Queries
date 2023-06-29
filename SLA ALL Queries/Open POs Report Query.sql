SELECT 
pohdr.po_no
, poln.line_no

, pohdr.date_created
, pohdr.branch_id
, sup.supplier_id
, sup.supplier_name
, invloc.product_group_id
, SUBSTRING(pohdr.created_by,5,20) as taker
, pohdr.external_po_no
, CASE WHEN pohdr.po_class1 = 01 THEN 'Acknowledged - Inside Sales'
    WHEN pohdr.po_class1 = 02 THEN 'Acknowledged - Completed'
    WHEN pohdr.po_class1 = 03 THEN 'No acknowledgement Required'
    WHEN pohdr.po_class1 = 05 THEN 'Acknowledgement with Issues'
    ELSE NULL END as po_ack

, poln.item_id
, poln.item_description
, invsup.supplier_part_no
, poln.qty_ordered 
, poln.qty_received
, poln.qty_ordered - poln.qty_received as qty_remaining
, (poln.unit_price / poln.pricing_unit_size)*(poln.qty_ordered - poln.qty_received) AS Extended_qty_remaining
, invloc.qty_on_hand
, invloc.qty_backordered
, poln.unit_price
, poln.unit_of_measure
, (poln.unit_price / poln.pricing_unit_size)*poln.qty_ordered AS line_extended_price
, poln.required_date
, poln.expedite_notes
, poln.expected_ship_date

FROM P21.dbo.p21_view_po_hdr pohdr

INNER JOIN P21.dbo.p21_view_po_line poln 
ON poln.po_no = pohdr.po_no

LEFT JOIN P21.dbo.p21_view_inv_loc invloc 
ON poln.inv_mast_uid = invloc.inv_mast_uid AND pohdr.branch_id = invloc.location_id

LEFT JOIN P21.dbo.p21_view_supplier sup 
ON pohdr.supplier_id = sup.supplier_id

LEFT JOIN p21_view_inventory_supplier invsup 
ON invsup.inv_mast_uid = poln.inv_mast_uid AND invsup.supplier_id = pohdr.supplier_id

WHERE pohdr.delete_flag <> 'Y'
AND poln.delete_flag <> 'Y'
AND pohdr.complete <> 'Y'
AND poln.complete <> 'Y'
AND pohdr.date_created > DATEADD(year, -2, GETDATE())
--AND poln.item_id = 'LAN240HYV3'
ORDER BY pohdr.po_no, poln.line_no ASC