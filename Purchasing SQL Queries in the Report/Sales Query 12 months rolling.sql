--Developer Name: SAMEER BANDI
--Date of Initial Development: 18/05/2023 (as mm/dd/yyyy)
--Reason for Development: To develop Sales of the inventory rolling 12 months

select Turns.*,
shrv.sales_location_id,
shrv.product_group_id,
shrv.supplier_name,
shrv.item_id,
shrv.stockable,
shrv.item_desc,
((shrv.unit_price/shrv.unit_size) * shrv.qty_shipped) AS Sales,
shrv.invoice_date

from p21_sales_history_report_view shrv
RIGHT OUTER JOIN (/****** Script for SelectTopNRows command from SSMS  ******/

-------Developer Name: SAMEER BANDI

-------Date of Change in the query: 05/23/2023 (as mm/dd/yyyy)

-------Reason for Development: To show Stock and Non stock inventory items and Turns with inventory value report

SELECT Distinct    
invr.location_id AS 'Location ID',
invr.default_branch_id as 'Branch id',
invr.Item_ID AS Item_ID, 
invr.Item_Desc AS Item_Description, 
invl.product_group_id AS Vertical,
invr.supplier_name AS SupplierName,
c.class_description AS Category, 
m.class_description AS Sub_Category, 
p21_view_inv_mast.vendor_consigned AS Consigned,
((invr.qty_on_hand-invr.special_layer_qty)*invr.cost)+invr.special_layer_value as Value_on_Hand,
invl.purchase_class AS ABC_Class,
invl.qty_on_hand AS Qty_on_Hand,
invl.qty_allocated,
invl.qty_backordered,
invl.replenishment_method AS Replen_Method,
invl.inv_min AS Min,
invl.inv_max AS Max,
invl.stockable,
GETDATE() as CurrentBusinessDate 
 
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
--LEFT JOIN p21_sales_history_report_view shrv ON  shrv.inv_mast_uid = invl.inv_mast_uid AND shrv.branch_id = invl.location_id  
LEFT JOIN p21_view_inventory_value_report invr on invr.location_id = invl.location_id and invr.inv_mast_uid = invl.inv_mast_uid
WHERE       
invr.company_id in (01,03)
and invl.delete_flag <> 'Y'
--and invr.item_id = '12106566' 
--and invr.default_branch_id = '1600' 
-- and invl.location_id = '1250'
AND invr.default_branch_id IN 
('1100','1110','1111','1120','1130','1140','1150','1160','1170','1200','1210','1220','1230','1240','1250','1260','1300','1310','1600','1601','1700','1701','1710','1711','1800','1801','1810','1811','3500','3510','3520','3540','4500','5250','8000')
AND invr.product_group_id IN ('CIN','PLB','PTP','ELE','ENG','MBV','HRR','PVF','ELD','MET','REN','MVU','MBV')
--and p21_view_inv_mast.item_id = ' TS36030'
GROUP BY
invr.location_id,
invr.default_branch_id,
invr.Item_ID, 
invr.Item_Desc, 
invl.product_group_id,
invr.primary_supplier_id,
invr.supplier_name,
c.class_description, 
m.class_description,
p21_view_inv_mast.vendor_consigned,
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
invr.special_layer_value) as Turns
on Turns.Item_ID = shrv.item_id and Turns.[Location ID] = shrv.sales_location_id
    --order by shrv.sales_price desc)
where  shrv.invoice_date >= GETDATE()-365
and shrv.sales_location_id in (1100,1110,1111,1120,1130,1140,1150,1160,1170,1200,1210,1220,1230,1240,1250,1260,1300,1310,1600,1601,1700,1701,1710,1711,1800,1801,1810,1811,3500,3510,3520,3540)
--and shrv.item_id = '12106566' and shrv.sales_location_id = '1600'
--and shrv.order_type = 1706