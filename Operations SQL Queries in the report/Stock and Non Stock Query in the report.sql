/****** Script for SelectTopNRows command from SSMS  ******/

-------Developer Name: SAMEER BANDI

-------Date of Initial Development: 11/10/2022 (as mm/dd/yyyy)

-------Reason for Development: To develop a metrics of Stock and Non Stock inventory for inventory report

Select invr.company_id,

invr.default_branch_id,

invr.product_group_id,

invr.item_id,

invr.item_desc,

invr.inv_mast_uid,

invr.primary_supplier_id,

invl.stockable,

YEAR(invr.backup_date) Inv_year,

Month(invr.backup_date) Period,

sum(invr.qty_on_hand) quantity_on_hand,

((((invr.qty_on_hand - invr.special_layer_qty)*(invr.cost))+invr.special_layer_value)/invr.qty_on_hand)*invl.qty_allocated as value_allocated,

((((invr.qty_on_hand - invr.special_layer_qty)*(invr.cost))+invr.special_layer_value)/invr.qty_on_hand)*(invr.qty_on_hand-invl.qty_allocated) as value_stock,

SUM((invr.qty_on_hand-special_layer_qty)*invr.cost+special_layer_value) as Quantity_on_hand_value,

invr.backup_date

----------------------------------------------------------------

--Matt Hanlon 11/10/2022 Editing out to test speed if reverse order of where

--FROM [SA_Warehouse].[dbo].[inv_value_wh] invr

--join [SA_Warehouse].[dbo].[inv_loc] invl on invr.inv_mast_uid = invl.inv_mast_uid  and invr.location_id = invl.location_id

--UPDATE: 11/10/2022 Matt Hanlon added the link on Location ID. Also, removed "inner" from join.

----------------------------------------------------------------

FROM

[SA_Warehouse].[dbo].[inv_loc] invl

join [SA_Warehouse].[dbo].[inv_value_wh] invr on invr.inv_mast_uid = invl.inv_mast_uid and invr.location_id = invl.location_id

Where

invr.qty_on_hand > 0

and year(invr.backup_date) = (2022)

and month(invr.backup_date) = (11)

and invr.company_id in (01,03)

--and invl.stockable = 'N'

--UPDATE: 11/10/2022 Matt Hanlon Changed the order of the Where to have QOH >0 as the first to test speed of query.

--UPDATE: 11/10/2022 Matt Hanlon add the filter of Month to try to speed query up. Also, added Stockable Filter to test speed.

group by invr.company_id,

invr.default_branch_id,

invr.product_group_id,

invr.item_id,

invr.primary_supplier_id,

invr.item_desc,

invr.inv_mast_uid,

invl.stockable,

invl.inv_max,

invl.inv_min,

invl.replenishment_method,

invl.replenishment_location,

invr.backup_date,

invr.qty_on_hand,

invl.qty_allocated,

invr.special_layer_value,

invr.special_layer_qty,

invr.cost