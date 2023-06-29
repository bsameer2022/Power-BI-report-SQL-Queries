select distinct il.item_id,sp.supplier_name
FROM       p21_view_inventory_supplier_x_loc sl
        INNER JOIN p21_view_inventory_supplier sup ON sl.inventory_supplier_uid = sup.inventory_supplier_uid
INNER JOIN p21_view_inv_loc il on il.inv_mast_uid =sup.inv_mast_uid and sl.location_id = il.location_id
INNER JOIN p21_view_supplier sp on sup.supplier_id = sp.supplier_id
where sl.primary_supplier = 'Y'
and sp.supplier_name = 'MODERN SALES CO-OP' 
and il.product_group_id = 'ELE'
