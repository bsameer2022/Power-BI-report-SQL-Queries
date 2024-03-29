
-- This query gives the results with customer name, customer id and open order details with the ship2 name,
-- pick tickets and quantity of orders and other open order attributes in detail

use p21

SELECT  
----------order details------------
customer_name
, oeh.customer_id
, oeh.po_no
, oel.user_line_no as po_line_no
, oeh.order_no
, oeh.order_date
, oeh.ship2_name
, oel.item_id
, invm.item_desc
--------order details--------------
--------order entry line-----------
, oel.qty_ordered - (oel.qty_canceled + oel.qty_invoiced) as qty_balance
, oel.qty_allocated
, oel.qty_on_pick_tickets
, oel.required_date
, olpd.promise_date + 4 as estimated_delivery_date
, oel.qty_ordered
, oel.unit_price
, oel.extended_price
--, oel.order_cost_edited
, oel.po_cost 
, oel.line_no
, oel.qty_invoiced
, oel.source_loc_id
, oel.date_created
--------Order Entry line-----------
from P21.dbo.p21_view_oe_hdr oeh

left join P21.dbo.p21_view_oe_line oel

    on oeh.order_no=oel.order_no

left join P21.dbo.p21_view_customer c

    on oeh.customer_id=c.customer_id

JOIN p21_view_inv_mast invm

    on invm.inv_mast_uid = oel.inv_mast_uid

LEFT JOIN p21_view_oe_line_promise_date olpd

    on olpd.oe_line_uid = oel.oe_line_uid

JOIN p21_view_contacts con

   on con.id = oeh.contact_id


   where oeh.order_date > GETDATE() - 45 and oel.user_line_no  <> 'NULL'

   and oeh.completed <> 'Y' 

    and oeh.cancel_flag <> 'Y'

    and oel.cancel_flag <> 'Y'

    and oel.complete <> 'Y'

    and oeh.rma_flag <> 'Y'

    and oel.item_id not like '%FREIGHT%'

    and oeh.delete_flag<>'Y'

    and oel.delete_flag<>'Y'

    and oeh.projected_order<>'Y'

    and oeh.completed<>'Y' 