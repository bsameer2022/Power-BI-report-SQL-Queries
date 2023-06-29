
select 
il.location_id,
(il.moving_average_cost)   as TotalMovingAvgCost,
(il.qty_on_hand) as TotalQtyOnHand,
month(il.backup_date) as month,
year(il.backup_date) as YR,
(il.moving_average_cost * il.qty_on_hand)  as InventoryValue

from dbo.inv_loc il

where year(il.backup_date) in ('2021') 
and  il.location_id =('1100') and il.inv_mast_uid = '73257'
--,'1110','1111','1120','1130','1140','1150','1160','1170','1200','1210','1220','1240','1250','1260','1300','1310','1600','1700','1710','1800','1810','3500','3510','3520','3540')
group by  il.location_id,il.backup_date,il.moving_average_cost , il.qty_on_hand
order by year(il.backup_date)  ASC,month(il.backup_date)  ASC, il.location_id ASC
;
--order by month(il.backup_date) asc;



use SA_Warehouse
select il.inv_mast_uid,
il.location_id,
(SUM(CASE
             WHEN il.moving_average_cost = 0 THEN 'Write off' -- use replacement cost in inv_loc, if that is 0, then use supplier cost from supplier table, but make sure to multiply LCD
             ELSE il.moving_average_cost
         END)/COUNT(il.inv_mast_uid)),
(il.moving_average_cost)   as TotalMovingAvgCost,
(il.qty_on_hand) as TotalQtyOnHand,
month(il.backup_date) as month,
year(il.backup_date) as YR,
(il.moving_average_cost * il.qty_on_hand)  as InventoryValue

from dbo.inv_loc il

where  year(il.backup_date) = 2021 and il.moving_average_cost >=0 and il.qty_on_hand>0
 
and il.location_id =('1100') --and il.inv_mast_uid = '73257'
--order by month(il.backup_date) asc;
group  by il.inv_mast_uid,
il.location_id,

(il.moving_average_cost)  , 
(il.qty_on_hand) ,
(il.backup_date) ,
(il.moving_average_cost * il.qty_on_hand)  