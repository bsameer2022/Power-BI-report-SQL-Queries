use SA_Warehouse
select loc.inv_mast_uid
    , loc.location_id
    , CONCAT(YEAR(loc.backup_date),'-',MONTH(loc.backup_date))
    , (AVG(
        CASE
            WHEN loc.moving_average_cost = 0 THEN 1000000 -- use replacement cost in inv_loc, if that is 0, then use supplier cost from supplier table, but make sure to multiply LCD
            ELSE loc.moving_average_cost
        END)/COUNT(loc.inv_mast_uid)) 'AvgCost'
    , AVG(loc.qty_on_hand) 'qoh'

from SA_Warehouse.dbo.inv_loc loc

where --loc.moving_average_cost = 0
    loc.qty_on_hand > 0
    and loc.backup_date > '2021-01-01'
    and loc.location_id = '1100'
    and loc.inv_mast_uid = '73257'

group by loc.inv_mast_uid
    , loc.location_id
    , CONCAT(YEAR(loc.backup_date),'-',MONTH(loc.backup_date))