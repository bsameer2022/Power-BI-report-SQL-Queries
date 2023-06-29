---Open Orders and value--------- 

select          oeh.customer_id,

                c.customer_name,

                oeh.order_no,

                oeh.location_id,

                oeh.ship2_name,
                
                MAX(oeh.order_date) as 'Order Date',

                COUNT(oel.item_id) as 'Number of Lines per Order',

                SUM(oel.extended_price) as 'Total Value'

                --COUNT(oeh.order_no) as 'NumberofOrders'


from P21.dbo.p21_view_oe_hdr oeh

left join P21.dbo.p21_view_oe_line oel
       on oeh.order_no=oel.order_no

left join P21.dbo.p21_view_quote_hdr qhd
       on oeh.oe_hdr_uid=qhd.oe_hdr_uid
    
 left join ( select distinct c.customer_id, c.customer_name
  from P21.dbo.p21_view_customer c) c
    on oeh.customer_id=c.customer_id

where   oel.delete_flag <> 'Y'
    and oeh.delete_flag <> 'Y'
    and oeh.completed <> 'Y' 
    and oeh.cancel_flag <> 'Y'
    and oel.cancel_flag <> 'Y'
    and oel.complete <> 'Y'
    and oeh.rma_flag <> 'Y'
    and oel.item_id not like '%FREIGHT%'
    and oeh.projected_order<>'Y'
    and  oeh.order_date >= (GETDATE() - 30)
    and oeh.location_id='1100'
    and oeh.customer_id = '100078'

group by oeh.order_no, oeh.customer_id , c.customer_name , oeh.location_id, ship2_name


