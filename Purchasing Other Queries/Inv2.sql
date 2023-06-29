select loc.inv_mast_uid
     , loc.location_id
     , ((
         CASE
             WHEN loc.moving_average_cost = 0 THEN 'Write off' -- use replacement cost in inv_loc, if that is 0, then use supplier cost from supplier table, but make sure to multiply LCD
             ELSE loc.moving_average_cost
         END)) 'AvgCost'
     , (loc.qty_on_hand) 'qoh'
	 , (loc.moving_average_cost * loc.qty_on_hand) as InventoryValue
	 , CONCAT(YEAR(loc.backup_date),'-',MONTH(loc.backup_date)) as YEAROFINVENTORY

from SA_Warehouse.dbo.inv_loc loc 

where loc.moving_average_cost >= 0
    and loc.qty_on_hand > 0
    and year(loc.backup_date) = '2021' --and loc.backup_date < '2022'
    and loc.location_id = '1100'
    and loc.inv_mast_uid = '73257'


group by loc.inv_mast_uid
    , loc.location_id,loc.moving_average_cost , loc.qty_on_hand
    , CONCAT(YEAR(loc.backup_date),'-',MONTH(loc.backup_date)) 