--Developer Name: SAMEER BANDI
--Date of Initial Development: 26/05/2023 (as mm/dd/yyyy)
--Reason for Development: To develop ABStock for the vertical scorecard

SELECT 
invl.location_id
, invl.item_id
, invl.primary_supplier_id
, s.supplier_name
, s.supplier_id
, invl.product_group_id
, invl.inv_mast_uid
, case when invl.qty_on_hand > 0 then 1 else  0 end AS stocked
, im.item_desc

FROM p21_view_inventory_value_report invl
INNER JOIN p21_view_inv_mast im on im.item_id = invl.item_id
INNER JOIN p21_view_supplier s ON s.supplier_id = invl.primary_supplier_id
LEFT JOIN p21_view_inv_loc il on invl.item_id = il.item_id
WHERE il.stockable = 'Y'
AND invl.purchase_class IN ('A', 'B')
AND il.delete_flag <> 'Y'
AND invl.location_id IN ('1100','1110','1111','1120','1130','1160','1170','1200','1210','1220','1260','1300','1310','1600','1700','1710','1800','1810','3500','3510','3520','3540')
AND invl.product_group_id IN ('CIN','PLB','PTP','ELE','HRR','PVF')