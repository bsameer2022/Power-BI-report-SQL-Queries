SELECT Distinct
p21_view_inv_loc.Location_ID,
p21_view_inv_loc.product_group_id,
p21_view_inv_loc.Item_ID, 
p21_view_inv_mast.Item_Desc AS Item_Description, 
p21_view_inv_loc.moving_average_cost,
p21_view_inv_loc.qty_on_hand,
p21_view_inv_loc.moving_average_cost*p21_view_inv_loc.qty_on_hand AS Val_OH,
p21_view_inv_loc.moving_average_cost*p21_view_inv_loc.qty_allocated AS Val_Alloc

FROM       p21_view_inventory_supplier_x_loc
INNER JOIN p21_view_inventory_supplier ON p21_view_inventory_supplier_x_loc.inventory_supplier_uid = p21_view_inventory_supplier.inventory_supplier_uid
INNER JOIN p21_view_supplier ON p21_view_inventory_supplier.supplier_id = p21_view_supplier.supplier_id  
INNER JOIN p21_view_inv_loc ON p21_view_inventory_supplier_x_loc.location_id = p21_view_inv_loc.location_id AND p21_view_inventory_supplier.inv_mast_uid = p21_view_inv_loc.inv_mast_uid
INNER JOIN p21_view_inv_mast ON p21_view_inventory_supplier.inv_mast_uid = p21_view_inv_mast.inv_mast_uid
INNER JOIN P21_view_inv_bin ON p21_view_inventory_supplier.inv_mast_uid = p21_view_inv_bin.inv_mast_uid
						 
WHERE        
p21_view_inv_loc.delete_flag <> 'Y'
AND p21_view_inventory_supplier_x_loc.primary_supplier = 'Y'
AND p21_view_inv_loc.company_id IN ('01','03')
AND p21_view_inv_loc.qty_on_hand > 0

ORDER BY p21_view_inv_loc.item_id