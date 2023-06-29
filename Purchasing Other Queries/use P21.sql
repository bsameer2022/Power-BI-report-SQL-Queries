use P21
SELECT Distinct     
p21_view_inv_loc.location_id AS Branch,
p21_view_inv_mast.Item_ID AS Item_ID, 
p21_view_inv_mast.Item_Desc AS Item_Description, 
p21_view_inv_loc.product_group_id AS Vertical,
p21_view_supplier.supplier_name AS SupplierName,
c.class_description AS Category, 
m.class_description AS Sub_Category, 
p21_view_inv_mast.vendor_consigned AS Consigned,
COALESCE(SUM(shrv.sales_price),0) AS Sales,
p21_view_inv_loc.moving_average_cost*p21_view_inv_loc.qty_on_hand AS Value_on_Hand,
CASE WHEN p21_view_inv_loc.moving_average_cost*p21_view_inv_loc.qty_on_hand = 0 THEN NULL
ELSE COALESCE(SUM(shrv.sales_price),0)/(p21_view_inv_loc.moving_average_cost*p21_view_inv_loc.qty_on_hand) END AS Inv_Turns,
p21_view_inv_loc.purchase_class AS ABC_Class,
p21_view_inv_loc.qty_on_hand AS Qty_on_Hand,
p21_view_inv_loc.qty_allocated,
p21_view_inv_loc.qty_backordered,
p21_view_inv_loc.replenishment_method AS Replen_Method,
p21_view_inv_loc.inv_min AS Min,
p21_view_inv_loc.inv_max AS Max,
p21_view_inv_loc.stockable
 
FROM       p21_view_inventory_supplier_x_loc
INNER JOIN p21_view_inventory_supplier ON p21_view_inventory_supplier_x_loc.inventory_supplier_uid = p21_view_inventory_supplier.inventory_supplier_uid
INNER JOIN p21_view_supplier ON p21_view_inventory_supplier.supplier_id = p21_view_supplier.supplier_id  
INNER JOIN p21_view_inv_loc ON p21_view_inventory_supplier_x_loc.location_id = p21_view_inv_loc.location_id AND p21_view_inventory_supplier.inv_mast_uid = p21_view_inv_loc.inv_mast_uid
INNER JOIN p21_view_location ON p21_view_location.location_id = p21_view_inv_loc.location_id
INNER JOIN p21_view_inv_mast ON p21_view_inventory_supplier.inv_mast_uid = p21_view_inv_mast.inv_mast_uid
LEFT OUTER JOIN p21_view_class ON p21_view_class.class_id = p21_view_inv_mast.class_id1
LEFT OUTER JOIN   p21_view_class AS c ON c.class_id = p21_view_inv_mast.class_id1 AND c.class_number = 1
LEFT OUTER JOIN   p21_view_class AS m ON m.class_id = p21_view_inv_mast.class_id2 AND m.class_number = 2
LEFT JOIN p21_sales_history_report_view shrv ON  shrv.inv_mast_uid = p21_view_inv_mast.inv_mast_uid AND shrv.branch_id = p21_view_inv_loc.location_id AND 

shrv.invoice_date BETWEEN 
DATEADD (yy, -1, DATEADD(dd, -DAY(GETDATE()-1), GETDATE()))
AND DATEADD (dd, -DAY(GETDATE()), GETDATE())
 
WHERE        
p21_view_inv_loc.delete_flag <> 'Y'
AND p21_view_inventory_supplier_x_loc.primary_supplier = 'Y'
AND p21_view_inv_loc.Location_ID IN ('1100','1110','1111','1120','1130','1140','1150','1160','1170','1200','1210','1220','1240','1250','1260','1300','1310','1600','1700','1710','1800','1810','3500','3510','3520','3540')
AND p21_view_inv_loc.product_group_id IN ('CIN','PLB','PTP','ELE','ENG','MBV','HRR','PVF','ELD')
 
GROUP BY
p21_view_inv_loc.location_id,
p21_view_inv_mast.Item_ID, 
p21_view_inv_mast.Item_Desc, 
p21_view_inv_loc.product_group_id,
p21_view_supplier.supplier_id,
p21_view_supplier.supplier_name,
c.class_description, 
m.class_description,
p21_view_inv_mast.vendor_consigned,
p21_view_inv_loc.moving_average_cost,
p21_view_inv_loc.purchase_class,
p21_view_inv_loc.qty_on_hand,
p21_view_inv_loc.qty_allocated,
p21_view_inv_loc.qty_backordered,
p21_view_inv_loc.replenishment_method,
p21_view_inv_loc.inv_min,
p21_view_inv_loc.inv_max,
p21_view_inv_loc.stockable
    
