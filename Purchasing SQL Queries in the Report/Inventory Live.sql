-------Developer Name: SAMEER BANDI
-------Date of Initial Development: 12/15/2022 (as mm/dd/yyyy)
-------Reason for Development: To develop a inventory value and metrics report
SELECT    distinct
il.company_id,
il.location_id,
il.item_id,
inv.item_desc,
il.product_group_id,
il.inv_mast_uid,
il.primary_supplier_id,
il.qty_on_hand,
il.qty_allocated,
il.stockable


FROM [dbo].[p21_view_inv_loc] il
left join p21_view_inv_mast inv on il.inv_mast_uid = inv.inv_mast_uid and il.item_id = inv.item_id 

  where  
      il.company_id in ('01','03')
	 and il.qty_on_hand > 0


group by il.company_id,
il.location_id, 
il.product_group_id,
il.inv_mast_uid,
il.item_id,
inv.item_desc,
il.primary_supplier_id,
il.qty_on_hand,
il.moving_average_cost,
il.stockable,
il.qty_allocated

