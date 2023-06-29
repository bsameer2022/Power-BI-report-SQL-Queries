---Open Orders--------- 

select    customer_name
        , oeh.customer_id
        , oeh.po_no
        , oel.user_line_no as po_line_no
        , oeh.order_no
        , oeh.order_date
        , oeh.ship2_name
        , oel.item_id    
        , invm.item_desc
        , oel.qty_ordered - (oel.qty_canceled + oel.qty_invoiced) as qty_balance
        , oel.qty_allocated
        , oel.qty_on_pick_tickets
        , oeh.requested_date
        , oel.required_date
        , olpd.promise_date + 4 as estimated_delivery_date
        , oeh.contact_id
        , concat (con.first_name,' ',con.last_name) as ContactName
        , oeh.location_id

from P21.dbo.p21_view_oe_hdr oeh

left join P21.dbo.p21_view_oe_line oel
       on oeh.order_no=oel.order_no

 left join ( select distinct c.customer_id, c.customer_name
  from P21.dbo.p21_view_customer c) c
    on oeh.customer_id=c.customer_id

inner JOIN  (select distinct con.id, con.first_name, con.last_name
 from p21_view_contacts con) con
   on con.id = oeh.contact_id

LEFT JOIN p21_view_oe_line_promise_date olpd
       on olpd.oe_line_uid = oel.oe_line_uid

LEFT JOIN p21_view_inv_mast invm
  on invm.inv_mast_uid = oel.inv_mast_uid


where   oel.delete_flag <> 'Y'
    and oeh.delete_flag <> 'Y'
    and oeh.completed <> 'Y' 
    and oeh.cancel_flag <> 'Y'
    and oel.cancel_flag <> 'Y'
    and oel.complete <> 'Y'
    and oeh.rma_flag <> 'Y'
    and oel.item_id not like '%FREIGHT%'
    and oeh.projected_order<>'Y'
    and oeh.order_date >= (GETDATE() - 30)
    and oeh.location_id='1100'
    and oeh.customer_id = '100078'
    and oel.qty_ordered > 0
    AND oel.complete<>'Y' 
    AND oel.delete_flag<>'Y' 

-- and (p21_view_po_line.delete_flag <> 'Y' or p21_view_po_line.delete_flag is null)

-- and (p21_view_oe_line_po.delete_flag <> 'Y' or p21_view_oe_line_po.delete_flag is null)

-- and (p21_view_oe_line_po.completed <>'Y' or p21_view_oe_line_po.completed is null)

   and  oeh.order_date >= GETDATE() - 30 and oel.user_line_no  <> 'NULL'

--group by oeh.order_no, oeh.customer_id , c.customer_name , oeh.location_id, ship2_name


