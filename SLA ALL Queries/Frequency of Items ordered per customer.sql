select     oel.item_id
        , oeh.location_id
        , COUNT(oel.item_id) as 'Frequency'
        

from p21.dbo.p21_view_oe_hdr oeh 

left join p21.dbo.p21_view_oe_line oel 

    on oeh.order_no = oel.order_no

where   year(oeh.order_date) = 2022
        and month(oeh.order_date) = 11

    and oel.user_line_no  <> 'NULL'

    --and oeh.completed <> 'Y' 

    and oeh.cancel_flag <> 'Y'

    and oel.cancel_flag <> 'Y'

   -- and oel.complete <> 'Y'

    and oeh.rma_flag <> 'Y'

    and oel.item_id not like '%FREIGHT%'

    and oeh.delete_flag<>'Y'

    and oel.delete_flag<>'Y'

    and oeh.projected_order<>'Y'

group by  oel.item_id
        , oeh.customer_id
        , oeh.location_id

order by COUNT(oel.item_id) DESC
