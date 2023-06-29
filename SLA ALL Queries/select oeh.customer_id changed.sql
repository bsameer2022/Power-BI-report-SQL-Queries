select          oeh.customer_id,

                c.customer_name,

                oeh.order_no,

                oeh.location_id,

                oeh.ship2_name,
                
                MAX(oeh.order_date) as 'Order Date',

                COUNT(oel.item_id) as 'Number of Lines per Order',

                SUM(oel.extended_price) as 'Total Value',

                COUNT(oeh.order_no) as 'NumberofOrders',

                st.class5_id

                , cc.class_description

                , COUNT(st.class5_id)

from P21.dbo.p21_view_oe_hdr oeh

left join P21.dbo.p21_view_oe_line oel

    on oeh.order_no=oel.order_no

left join P21.dbo.p21_view_quote_hdr qhd

    on oeh.oe_hdr_uid=qhd.oe_hdr_uid
    
left join P21.dbo.p21_view_customer c

    on oeh.customer_id=c.customer_id
    
left join P21.dbo.p21_view_ship_to st 
    
    on st.customer_id = oeh.customer_id

left join (select c.class_id

                , c.class_description

            from P21.dbo.p21_view_class c

            where c.class_number=5) cc 
            
    on st.class5_id=cc.class_id 

where   oel.delete_flag <> 'Y'

    and oeh.delete_flag <> 'Y'

    and oeh.completed <> 'Y' 

    and oeh.cancel_flag <> 'Y'

    and oel.cancel_flag <> 'Y'

    and oel.complete <> 'Y'

    and oeh.rma_flag <> 'Y'

    and oel.item_id not like '%FREIGHT%'

    --and oeh.projected_order<>'Y'

    and  oeh.order_date > (GETDATE() - 30)

group by oeh.order_no, oeh.customer_id , c.customer_name , oeh.location_id, ship2_name, st.class5_id, cc.class_description

