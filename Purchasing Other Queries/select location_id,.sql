select location_id,
 inv_mast_uid,
 loc.moving_average_cost as TotalMovAvgCost ,
(loc.qty_on_hand) as TotalQtyOnHand,
(loc.qty_allocated) as QtyAllocated,
(loc.moving_average_cost * loc.qty_on_hand)  as InventoryValue,
loc.backup_date
from [SA_Warehouse].dbo.inv_loc loc

where  year(loc.backup_date) in ('2021','2022') 
    and loc.moving_average_cost >= 0
    and loc.qty_on_hand > 0
    --and loc.location_id =('1100')
group by loc.inv_mast_uid
		,loc.location_id
		,loc.qty_on_hand
        ,loc.qty_allocated
		,loc.backup_date
		,loc.moving_average_cost