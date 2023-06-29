/****** Script for SelectTopNRows command from SSMS  ******/

-------Developer Name: SAMEER BANDI

-------Date of Initial Development: 10/10/2022 (as mm/dd/yyyy)

-------Reason for Development: To develop a metrics of inventory value over period of time for inventory report

select 
loc.location_id,
loc.inv_mast_uid,
loc.moving_average_cost as TotalMovAvgCost ,
(loc.qty_on_hand) as TotalQtyOnHand,
(loc.moving_average_cost * loc.qty_on_hand)  as InventoryValueOnHand,
loc.backup_date,
(loc.moving_average_cost*loc.qty_allocated) AS Value_Alloc,
loc.product_group_id
from dbo.inv_loc loc

where  year(loc.backup_date) in ('2021','2022') 
    and month(loc.backup_date) in (1,2,3,4,5,6,7,8,9,10)
    and loc.moving_average_cost >= 0
    and loc.qty_on_hand > 0
    --and loc.location_id =('1100')
group by loc.inv_mast_uid
		,loc.location_id
		,loc.qty_on_hand
		,loc.backup_date
		,loc.moving_average_cost
        ,loc.qty_allocated
        ,loc.product_group_id
