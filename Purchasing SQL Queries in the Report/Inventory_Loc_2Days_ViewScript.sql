CREATE VIEW InventoryLocevery2days
	AS SELECT *, Cast(TodaysDate as date) backup_date2 FROM Inventory_Loc2023
WHERE
CAST(TodaysDate as DATE) >= DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE())       
                   WHEN 'Sunday' THEN -2 
                   WHEN 'Monday' THEN -3   
                   ELSE -1 END, DATEADD(DAY, -1, GETDATE()))
and 

Cast(Todaysdate as DATE)  <= GETDATE()

drop view InventoryLocevery2days

select top 10 * from InventoryLocevery2days
order by backup_date2 desc

select top 10 * from InventoryValueReport2023
where backup_date like '2023-03-02%'

drop view inventoryLoc2023