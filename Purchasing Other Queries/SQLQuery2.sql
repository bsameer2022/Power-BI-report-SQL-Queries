SELECT DISTINCT 
shrv.branch_id,
shrv.product_group_id,
shrv.customer_name,
shrv.invoice_no
, im.item_id
, im.item_desc
, shrv.supplier_name
, shrv.sales_price
, CAST(COALESCE(il.qty_shipped / coalesce(il.sales_unit_size,iu.unit_size,1),0) AS Decimal(19, 9)) qty_shipped
, shrv.commission_cost*CAST(COALESCE(il.qty_shipped / coalesce(il.sales_unit_size,iu.unit_size,1),0) AS Decimal(19, 9)) as Costs
, shrv.sales_price - (shrv.commission_cost*CAST(COALESCE(il.qty_shipped / coalesce(il.sales_unit_size,iu.unit_size,1),0) AS Decimal(19, 9))) AS profit_comm
, shrv.invoice_date
FROM p21_sales_history_report_view shrv
INNER JOIN p21_view_inv_mast im ON shrv.inv_mast_uid = im.inv_mast_uid
INNER JOIN p21_view_invoice_line il ON shrv.invoice_line_uid = il.invoice_line_uid
LEFT JOIN p21_view_item_uom iu ON iu.inv_mast_uid = il.inv_mast_uid

WHERE 
CONVERT(DATE, shrv.invoice_date) = DATEADD(day, CASE DATENAME(WEEKDAY, GETDATE()) 
                        WHEN 'Sunday' THEN -2 
                        WHEN 'Monday' THEN -3 
                        ELSE -1 END, DATEDIFF(DAY, 365, GETDATE()))
--AND shrv.sales_location_id  IN ('1100','1110','1111','1120','1130','1160','1170','1200','1210','1220','1260','1300','1310','1600','1700','1710','1800','1810','3500','3510','3520','3540')

GROUP BY 
shrv.branch_id,
shrv.customer_name,
shrv.invoice_no
, im.item_id
, im.item_desc
, shrv.supplier_name
, shrv.product_group_id
, shrv.unit_of_measure
, shrv.commission_cost 
, shrv.sales_price
, il.sales_unit_size
, iu.unit_size
, il.qty_shipped
, shrv.invoice_date