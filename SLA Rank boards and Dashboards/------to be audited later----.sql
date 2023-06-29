------to be audited later----

SELECT    customer_name
        , oeh.customer_id
        , oeh.po_no
        , oel.user_line_no as po_line_no
        , oeh.order_no
        , oeh.order_date
        , oeh.ship2_name
        , oel.item_id
        --, invm.item_desc
        , oel.qty_ordered - (oel.qty_canceled + oel.qty_invoiced) as qty_balance
        , oel.qty_allocated
        , oel.qty_on_pick_tickets
        , oeh.requested_date
        , oel.required_date
        --, olpd.promise_date + 4 as estimated_delivery_date
        , oeh.contact_id
        , concat (con.first_name,' ',con.last_name) as ContactName
        ,  oeh.location_id

from P21.dbo.p21_view_oe_hdr oeh

left join P21.dbo.p21_view_oe_line oel

    on oeh.order_no=oel.order_no

 left join ( select distinct c.customer_id, c.customer_name
 from P21.dbo.p21_view_customer c) c

    on oeh.customer_id=c.customer_id

--JOIN p21_view_inv_mast invm

  --  on invm.inv_mast_uid = oel.inv_mast_uid

--LEFT JOIN p21_view_oe_line_promise_date olpd

  --  on olpd.oe_line_uid = oel.oe_line_uid

inner JOIN  (select distinct con.id, con.first_name, con.last_name
 from p21_view_contacts con) con
   on con.id = oeh.contact_id


 --INNER JOIN p21_view_address 
 --   ON oeh.customer_id=p21_view_address.id
 left JOIN p21_view_inv_mast 
    ON oel.inv_mast_uid=p21_view_inv_mast.inv_mast_uid
 LEFT OUTER JOIN p21_view_oe_line_po 
    ON (oel.order_no=p21_view_oe_line_po.order_number AND oel.line_no=p21_view_oe_line_po.line_number)
 --INNER JOIN p21_view_address a 
 -- ON oel.supplier_id=a.id
 --LEFT OUTER JOIN p21_view_oe_line_notepad 
 --   ON (oel.order_no=p21_view_oe_line_notepad.order_no AND oel.line_no=p21_view_oe_line_notepad.line_no)
-- LEFT OUTER JOIN p21_view_po_line 
   -- ON (p21_view_oe_line_po.po_no=p21_view_po_line.po_no AND p21_view_oe_line_po.po_line_number=p21_view_po_line.line_no)
 
 WHERE  oel.qty_ordered > 0

AND oel.complete<>'Y' 
  AND oel.delete_flag<>'Y' 

--and (p21_view_po_line.delete_flag <> 'Y' or p21_view_po_line.delete_flag is null)

and (p21_view_oe_line_po.delete_flag <> 'Y' or p21_view_oe_line_po.delete_flag is null)

and (p21_view_oe_line_po.completed <>'Y' or p21_view_oe_line_po.completed is null)

   and  oeh.order_date >= GETDATE() - 30 and oel.user_line_no  <> 'NULL'

    and oeh.completed <> 'Y' 

    and oeh.cancel_flag <> 'Y'

    and oel.cancel_flag <> 'Y'

    and oel.complete <> 'Y'

  and oeh.customer_id in ('100078')
  and oeh.location_id = '1100'

    and oeh.rma_flag <> 'Y'

    and oel.item_id not like '%FREIGHT%'

    and oeh.delete_flag<>'Y'

    and oel.delete_flag<>'Y'

    and oeh.projected_order<>'Y'

    and oeh.completed<>'Y' 
