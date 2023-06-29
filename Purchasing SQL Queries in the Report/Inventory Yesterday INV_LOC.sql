-------Developer Name: SAMEER BANDI
-------Date of Initial Development: 12/15/2022 (as mm/dd/yyyy)
-------Reason for Development: To develop a inventory value and metrics report
SELECT   distinct 
il.company_id,
il.location_id,
il.product_group_id,
il.inv_mast_uid,
il.primary_supplier_id,
il.qty_on_hand,
SUM(il.qty_on_hand * il.moving_average_cost) Quantity_on_hand_value,
il.qty_allocated,
SUM(il.qty_allocated *il.moving_average_cost) Quantity_Allocated_Value,
il.backup_date

FROM [SA_Warehouse].[dbo].[inv_loc] il

  where  Year(il.backup_date) =2022
     and month(il.backup_date) = 12
     and day(il.backup_date) = 14 
     and il.company_id in ('01','03')
	 and il.qty_on_hand > 0
	 
 and CAST(il.backup_date as DATE) = DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) 
                        WHEN 'Sunday' THEN -2 
                        WHEN 'Monday' THEN -3
                        ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))
group by il.company_id,
il.location_id, 
il.product_group_id,
il.inv_mast_uid,
il.primary_supplier_id,
il.qty_on_hand,
il.moving_average_cost,
il.qty_allocated,
il.backup_date