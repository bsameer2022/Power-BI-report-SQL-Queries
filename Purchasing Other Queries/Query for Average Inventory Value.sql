use SA_Warehouse

select il.inv_mast_uid,(il.moving_average_cost),il.qty_on_hand,
sum(il.qty_on_hand) as TotalQtyInHand,
year(il.backup_date) as currentyear,
month(il.backup_date) as currentYearmonths,
((il.moving_average_cost * il.qty_on_hand))  as InventoryValue

from dbo.inv_loc il
where year(il.backup_date) in ('2021','2022') and month(il.backup_date) in ('1','2','3','4','5','6','7','8','9','10','11','12')
and il.location_id =('1100') and il.inv_mast_uid = '73257'

group by year(il.backup_date),month(il.backup_date),
il.inv_mast_uid,
(il.moving_average_cost),(il.qty_on_hand)

--('1100','1110','1111','1120','1130','1140','1150','1160','1170',
--'1200','1210','1220','1240','1250','1260','1300','1310','1600',
--'1700','1710','1800','1810','3500','3510','3520','3540')