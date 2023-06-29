select  oeh.customer_id
    , oeh.order_no

    , oeh.location_id

    ,  customer_name 

	,  oeh.ship2_name

    , oeh.order_no

    ,  COUNT(oeh.customer_id) as 'NumberQuotes'

from P21.dbo.p21_view_oe_hdr oeh

    left join P21.dbo.p21_view_oe_line oel

         on oeh.order_no=oel.order_no

    left join P21.dbo.p21_view_customer c

        on oeh.customer_id=c.customer_id

    where oeh.projected_order='Y' 

    and  oeh.order_date > (GETDATE() - 30)

    and oel.item_id not like '%FREIGHT%'

    group by  oeh.customer_id
            , c.customer_name
            , oeh.order_no
            , ship2_name
            , oeh.location_id
    order by  NumberQuotes DESC
