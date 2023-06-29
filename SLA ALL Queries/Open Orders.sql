Use P21

select  oeh.order_no

,  oeh.order_date  

,  oel.user_line_no as po_line_no, oel.item_id,oel.qty_ordered - (oel.qty_canceled + oel.qty_invoiced) as qty_balance

,  oel.qty_allocated

,  oel.qty_on_pick_tickets

,  oel.required_date

from 

 p21_view_oe_hdr oeh JOIN p21_view_oe_line oel

    on oel.oe_hdr_uid = oeh.oe_hdr_uid,

P21.dbo.p21_view_job_price_customer_shipto jpcs

    left join P21.dbo.p21_view_customer c

    on jpcs.customer_id=c.customer_id

    where oeh.order_date > GETDATE() - 3 and oel.user_line_no  <> 'NULL'
    
    and  oeh.completed <> 'Y' 

    and oeh.cancel_flag <> 'Y'

    and oel.cancel_flag <> 'Y'

    and oel.complete <> 'Y'

   -- and oeh.customer_id in ('100084')

    and oeh.rma_flag <> 'Y'

    and oel.item_id not like '%FREIGHT%'

    and oeh.delete_flag<>'Y'

    and oel.delete_flag<>'Y'

    and oeh.projected_order<>'Y'

    and oeh.completed<>'Y' 
    