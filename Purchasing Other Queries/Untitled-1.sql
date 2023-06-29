
select loc.location_id,
 loc.inv_mast_uid,
 loc.moving_average_cost as TotalMovAvgCost ,
(loc.qty_on_hand) as TotalQtyOnHand,
(loc.moving_average_cost * loc.qty_on_hand)  as InventoryValueOnHand,
loc.backup_date,
(loc.moving_average_cost*loc.qty_allocated) AS Value_Alloc,
loc.product_group_id,
--sup.supplier_id,
loc.primary_supplier_id,
loc.inv_max as InventoryMax,
loc.inv_min as InventoryMin

from dbo.inv_loc loc
--  inner  join P21.dbo.inventory_supplier sup 
--         on   loc.primary_supplier_id = sup.supplier_id

where  year(loc.backup_date) in ('2021','2022') 
    and loc.moving_average_cost >= 0
    and loc.qty_on_hand > 0
    and loc.company_id in ('01','03')
    
    --and loc.location_id =('1100')
group by loc.inv_mast_uid
		,loc.location_id
		,loc.qty_on_hand
		,loc.backup_date
		,loc.moving_average_cost
        ,loc.qty_allocated
        ,loc.product_group_id
        --,sup.supplier_id
        ,loc.primary_supplier_id

