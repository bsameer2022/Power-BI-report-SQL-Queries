SELECT ph.company_no,
       ph.expected_date,
       ph.location_id,
       il.product_group_id,
       (pl.qty_ordered - pl.qty_received)*pl.unit_price as open_value

FROM p21_view_po_hdr ph 

INNER JOIN p21_view_po_line pl 
        ON ph.po_no = pl.po_no
INNER JOIN p21_view_inv_loc il 
        ON il.inv_mast_uid = pl.inv_mast_uid 
       AND il.location_id = ph.location_id

WHERE ph.expected_date > GETDATE() 
AND ph.complete = 'N'
AND ph.cancel_flag <> 'Y'
AND pl.cancel_flag <> 'Y'
AND pl.delete_flag <> 'Y'
AND pl.qty_ordered > pl.qty_received
AND ph.company_no IN ('01', '03')

order by ph.expected_date