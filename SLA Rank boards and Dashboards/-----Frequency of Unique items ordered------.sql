

-----Frequency of Unique items ordered------ 

select distinct c.customer_name
      , oel.item_id
      , invm.item_desc
      , oel.unit_price
      , oeh.customer_id
      , oeh.location_id
      , COUNT(oel.item_id) as 'Frequency'
      , order_date
     
from p21.dbo.p21_view_oe_hdr oeh 

left join p21.dbo.p21_view_oe_line oel 

    on oeh.order_no = oel.order_no

 left join ( select distinct c.customer_id, c.customer_name
 from P21.dbo.p21_view_customer c) c

    on oeh.customer_id=c.customer_id

JOIN p21_view_inv_mast invm

    on invm.inv_mast_uid = oel.inv_mast_uid

where  oeh.order_date >= GETDATE() - 30 

   and oel.user_line_no  <> 'NULL'
   --and oeh.completed <> 'Y' 
    and oeh.cancel_flag <> 'Y'
    and oel.cancel_flag <> 'Y'
    --and oel.complete <> 'Y'
    and oeh.rma_flag <> 'Y'
    and oel.item_id not like '%FREIGHT%'
    and oeh.delete_flag<>'Y'
    and oel.delete_flag<>'Y'
    and oeh.projected_order<>'Y'
    and oeh.customer_id = '100078'
    and oeh.location_id = '1100'

group by  c.customer_name
        , oel.item_id
        , invm.item_desc
        , oeh.customer_id
        , oeh.location_id
        , oel.unit_price
        , order_date

--order by COUNT(oel.item_id) desc