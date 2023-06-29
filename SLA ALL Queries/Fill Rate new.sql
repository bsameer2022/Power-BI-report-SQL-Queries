select top 100 oeh.order_no, 
               atoeh.key1_value,
               oel.item_id,
               oel.line_no,
               oel.qty_ordered,
               atoeh.new_value,
               atoeh.old_value,
              
               oeh.location_id,
               oeh.customer_id,
               oeh.order_type,
               oeh.date_created,
               atoeh.key1_cd,
               atoeh.column_changed,
               atoeh.column_description,
               aa.MinDate
               
               
from p21_view_audit_trail_oe_hdr_1319 atoeh

 inner join (select a.item_id
                 , a.key1_value
                 , MIN(a.date_created) as 'MinDate'
             from p21_view_audit_trail_oe_hdr_1319 a
             where (a.item_id NOT LIKE '%FREIGHT%'
                  and a.column_changed = 'qty_allocated'
                     and a.old_value like '0.0000%'
                     and a.new_value not like '0.0000%')
                     and a.key1_cd = 'order_no'
                     and a.date_created >= (GETDATE()-60)
                     group by a.item_id,
                     a.key1_value) aa 

     on  aa.item_id=atoeh.item_id
     and aa.key1_value=atoeh.key1_value
     and aa.MinDate=atoeh.date_created

 LEFT JOIN P21.dbo.p21_view_oe_hdr oeh 
         on atoeh.key1_value = oeh.order_no

  LEFT JOIN P21.dbo.p21_view_oe_line oel
         on oeh.order_no=oel.order_no

where oeh.completed <> 'T'
  and oeh.completed <> 'Y'
  and oeh.delete_flag <> 'Y'
  and oeh.projected_order <>'Y'
  and oeh.cancel_flag <> 'Y'
  and oel.item_id NOT LIKE '%FREIGHT%'

  and (atoeh.column_changed = 'qty_allocated'
      and atoeh.old_value like '0.0000%'
      and atoeh.new_value not like '0.0000%')

  and atoeh.key1_cd = 'order_no'
  and atoeh.date_created >= (GETDATE()-60)
  and oel.delete_flag <>'Y'
  and oel.cancel_flag<>'Y'
  and oeh.order_type NOT IN (1706,2858)
  and oel.item_id NOT IN ('LAB')
  and oel.qty_ordered >= 1
  and oeh.order_no  in (4712945)

group by       oeh.order_no, 
               oel.item_id,
               oel.line_no,
               oeh.customer_id,
               oeh.date_created,
               atoeh.key1_cd,
               atoeh.column_changed,
               atoeh.column_description,
               atoeh.key1_value,
               atoeh.new_value,
               atoeh.old_value,
               aa.MinDate,
               oeh.location_id,
               oeh.order_type,
               oel.qty_ordered

order by oeh.date_created ASC

select a.item_id
                , a.key1_value
                , a.column_changed
                , a.new_value
                , a.old_value
                , MIN(a.date_created) as 'MinDate'
            from p21_view_audit_trail_oe_hdr_1319 a
            where (a.item_id NOT LIKE '%FREIGHT%'
                 and a.column_changed = 'qty_allocated'
                    and a.old_value like '0.0000%'
                    and a.new_value not like '0.0000%')
                    and a.key1_cd = 'order_no'
                    and a.date_created >= (GETDATE()-60)
                    group by a.item_id,
                    a.key1_value,
                    a.column_changed,
                    a.new_value,
                    a.old_value


