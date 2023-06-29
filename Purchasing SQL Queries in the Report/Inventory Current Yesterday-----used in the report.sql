/****** Script for SelectTopNRows command from SSMS  ******/
-------Developer Name: SAMEER BANDI
-------Date of Initial Development: 10/17/2022 (as mm/dd/yyyy)
-------Reason for Development: To develop a metrics of yesterday's inventory for inventory report
Select ivwh.company_id,
ivwh.default_branch_id, 
ivwh.product_group_id,
ivwh.item_id,item_desc,
ivwh.primary_supplier_id,
YEAR(backup_date) Inv_year,
Month(backup_date) Period,
sum(qty_on_hand) quantity_on_hand,
SUM((qty_on_hand-special_layer_qty)*cost+special_layer_value) Quantity_on_hand_value,
ivwh.backup_date

FROM [SA_Warehouse].[dbo].[inv_value_wh] ivwh

Where CAST(ivwh.backup_date as DATE) = DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) 
                        WHEN 'Sunday' THEN -2 
                        WHEN 'Monday' THEN -3
                        ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))

group by ivwh.company_id,
ivwh.default_branch_id,
ivwh.product_group_id,
ivwh.item_id, 
ivwh.primary_supplier_id,
ivwh.item_desc,
ivwh.backup_date