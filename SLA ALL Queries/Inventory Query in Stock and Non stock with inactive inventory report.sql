SELECT Distinct    
invr.location_id AS Branch,
invr.Item_ID AS Item_ID, 
invr.Item_Desc AS Item_Description, 
invl.product_group_id AS Vertical,
invr.supplier_name AS SupplierName,
c.class_description AS Category, 
m.class_description AS Sub_Category, 
p21_view_inv_mast.vendor_consigned AS Consigned,
(shrv.sales_price) AS Sales,
--p21_view_inv_loc.moving_average_cost*p21_view_inv_loc.qty_on_hand AS Value_on_Hand,
(((invr.qty_on_hand-invr.special_layer_qty)*invr.cost)+invr.special_layer_value) as Value_on_Hand,
CASE WHEN (((invr.qty_on_hand-invr.special_layer_qty)*invr.cost)+invr.special_layer_value)  = 0 THEN NULL
ELSE COALESCE(SUM(shrv.sales_price),0)/((((invr.qty_on_hand-invr.special_layer_qty)*invr.cost)+invr.special_layer_value) ) END AS Inv_Turns,
invl.purchase_class AS ABC_Class,
invl.qty_on_hand AS Qty_on_Hand,
invl.qty_allocated,
invl.qty_backordered,
invl.replenishment_method AS Replen_Method,
invl.inv_min AS Min,
invl.inv_max AS Max,
invl.stockable
 
FROM       
p21_view_inventory_supplier_x_loc
INNER JOIN p21_view_inventory_supplier ON p21_view_inventory_supplier_x_loc.inventory_supplier_uid = p21_view_inventory_supplier.inventory_supplier_uid
INNER JOIN p21_view_supplier ON p21_view_inventory_supplier.supplier_id = p21_view_supplier.supplier_id  
INNER JOIN p21_view_inv_loc invl ON p21_view_inventory_supplier_x_loc.location_id = invl.location_id AND p21_view_inventory_supplier.inv_mast_uid = invl.inv_mast_uid
INNER JOIN p21_view_location ON p21_view_location.location_id = invl.location_id
INNER JOIN p21_view_inv_mast ON p21_view_inventory_supplier.inv_mast_uid = p21_view_inv_mast.inv_mast_uid
LEFT OUTER JOIN p21_view_class ON p21_view_class.class_id = p21_view_inv_mast.class_id1
LEFT OUTER JOIN   p21_view_class AS c ON c.class_id = p21_view_inv_mast.class_id1 AND c.class_number = 1
LEFT OUTER JOIN   p21_view_class AS m ON m.class_id = p21_view_inv_mast.class_id2 AND m.class_number = 2
LEFT JOIN p21_sales_history_report_view shrv ON  shrv.inv_mast_uid = invl.inv_mast_uid AND shrv.branch_id = invl.location_id  
LEFT JOIN p21_view_inventory_value_report invr on invr.location_id = invl.location_id and invr.inv_mast_uid = invl.inv_mast_uid

 
WHERE       

shrv.invoice_date BETWEEN 
DATEADD (yy, -1, DATEADD(dd, -DAY(GETDATE()-1), GETDATE()))
AND DATEADD (dd, -DAY(GETDATE()), GETDATE()) 
and
invl.delete_flag <> 'Y'
--AND p21_view_inventory_supplier_x_loc.primary_supplier = 'Y'
AND invr.Location_ID IN ('1100','1110','1111','1120','1130','1140','1150','1160','1170','1200','1210','1220','1240','1250','1260','1300','1310','1600','1700','1710','1800','1810','3500','3510','3520','3540')
AND invr.product_group_id IN ('CIN','PLB','PTP','ELE','ENG','MBV','HRR','PVF','ELD')
and p21_view_inv_mast.item_id in('F0114130','378GKTTL/X')
GROUP BY
invr.location_id,
invr.Item_ID, 
invr.Item_Desc, 
invl.product_group_id,
invr.primary_supplier_id,
invr.supplier_name,
c.class_description, 
m.class_description,
p21_view_inv_mast.vendor_consigned,
invl.moving_average_cost,
invl.purchase_class,
invl.qty_on_hand,
invl.qty_allocated,
invl.qty_backordered,
invl.replenishment_method,
invl.inv_min,
invl.inv_max,
invl.stockable,
invr.qty_on_hand,
invr.special_layer_qty,
invr.cost,
invr.special_layer_value,
shrv.sales_price
    --order by shrv.sales_price desc