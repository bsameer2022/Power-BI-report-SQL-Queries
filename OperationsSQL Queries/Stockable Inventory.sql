/****** Script for SelectTopNRows command from SSMS  ******/
-------Developer Name: SAMEER BANDI
-------Date of Initial Development: 11/08/2022 (as mm/dd/yyyy)
-------Reason for Development: To develop a metrics of Stock  inventory for inventory report
Select invr.company_id,
invr.default_branch_id, 
invr.product_group_id,
invr.item_id,item_desc,
invr.primary_supplier_id,
YEAR(invr.backup_date) Inv_year,
Month(invr.backup_date) Period,
sum(invr.qty_on_hand) quantity_on_hand,
((((invr.qty_on_hand - invr.special_layer_qty)*(invr.cost))+invr.special_layer_value)/invr.qty_on_hand)*invl.qty_allocated as value_allocated,
((((invr.qty_on_hand - invr.special_layer_qty)*(invr.cost))+invr.special_layer_value)/invr.qty_on_hand)*(invr.qty_on_hand-invl.qty_allocated) as value_stock,
SUM((invr.qty_on_hand-special_layer_qty)*invr.cost+special_layer_value) as Quantity_on_hand_value,
invr.backup_date,
invl.stockable

FROM [SA_Warehouse].[dbo].[inv_value_wh] invr
inner join [SA_Warehouse].[dbo].[inv_loc] invl 
on invr.inv_mast_uid = invl.inv_mast_uid  

Where year(invr.backup_date) = (2022)
and invr.company_id in (01,03)
and invl.qty_on_hand > 0
and invl.stockable <> 'N'

group by invr.company_id,
invr.default_branch_id,
invr.product_group_id,
invr.item_id, 
invr.primary_supplier_id,
invr.item_desc,
invr.backup_date,
invr.qty_on_hand,
invl.qty_allocated,
invr.special_layer_value,
invr.special_layer_qty,
invr.cost,
invl.stockable
