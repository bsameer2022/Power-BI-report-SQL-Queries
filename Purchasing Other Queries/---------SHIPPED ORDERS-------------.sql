---------SHIPPED ORDERS-------------

SELECT oeh.order_no 
     , oeh.customer_id
     , oeh.location_id
     , c.customer_name
     , oeh.po_no
     , oel.user_line_no
     , oel.customer_part_number
     , oel.item_id
     , oel.qty_ordered
     , invm.item_desc
     , oeh.ship2_name
     , oeptd.ship_quantity
     , oeh.order_date
     , oel.required_date
     , oept.ship_date
     , oept.carrier_id
     , oeh.front_counter
     , car.name
     , CASE 
     When  oept.ship_date >  oel.required_date
     THEN 'Shipped Late'
     ELSE 'on Time or Within Required Date'
     END As On_Time_Delivery_Status
     ,oel.extended_price

     
    --  , CASE 
    --  When  oept.ship_date <=  oel.required_date 
    --  THEN 'Shipped On Time'
    --  ELSE 'Shipped Late or On Due Date'
    --  END AS Delivery_status2
    --   , CASE 
    --   When  oept.ship_date =  oel.required_date 
    --   THEN 'Shipped on Due Date'
    --   ELSE 'Shipped on Time or Late'
    --   END AS Delivery_status3

FROM p21_view_oe_pick_ticket OEPT

JOIN p21_view_oe_pick_ticket_detail oeptd 
  on oeptd.pick_ticket_no = oept.pick_ticket_no

JOIN p21_view_address car 
  on car.id = oept.carrier_id

JOIN p21_view_oe_hdr oeh
  on oeh.order_no = oept.order_no

JOIN p21_view_oe_line oel 
  on oel.line_no = oeptd.oe_line_no 
 and oel.order_no = oept.order_no

JOIN p21_view_inv_mast invm 
  on invm.inv_mast_uid = oel.inv_mast_uid

left join P21.dbo.p21_view_customer c 
       on oeh.customer_id=c.customer_id

WHERE OEPT.delete_flag = 'N'
  and oeh.front_counter = 'N'
  and item_desc NOT LIKE '%FREIGHT%'
  and customer_part_number <> 'FREIGHTOUT'
  and customer_part_number <> 'FREIGHTIN'
  and oel.item_id <> 'FREIGHTOUT'
  and oel.item_id <> 'FREIGHTIN'
  and invm.item_desc <> 'FREIGHTOUT'
  and invm.item_desc <> 'FREIGHTIN'
  --and oept.ship_date >  oel.required_date
  and oeh.order_date > (GETDATE() - 30)
  and oept.ship_date > (GETDATE() - 1)
  and OEPT.ship_date is not null

  group by  oeh.order_no 
          , oeh.customer_id
          , oeh.location_id
          , c.customer_name
          , oeh.po_no
          , oel.user_line_no
          , oel.customer_part_number
          , oel.item_id
          , oel.qty_ordered
          , invm.item_desc
          , oeh.ship2_name
          , oeptd.ship_quantity
          , oeh.order_date
          , oel.required_date
          , oept.ship_date
          , oept.carrier_id
          , car.name
          , oeh.front_counter
          ,oel.extended_price