select         oeh.order_no, 
               oel.item_id,
               oel.qty_ordered,
               aa.new_value,
               aa.old_value,
               oeh.date_created,
               aa.MinDate,
              ((aa.new_value / oel.qty_ordered)*100) as FillRate,
               oeh.location_id,
               oeh.customer_id,
               oeh.order_type
            
from  P21.dbo.p21_view_oe_hdr oeh 

LEFT JOIN P21.dbo.p21_view_oe_line oel
         on oeh.order_no  = oel.order_no
      
LEFT JOIN p21_view_audit_trail_oe_hdr_1319 atoeh
          on atoeh.key1_value = oeh.order_no

 inner join (select a.item_id,
                    a.new_value,
                    a.old_value,
                    a.key1_value,
                    a.key1_cd,
                    a.column_changed,
                    a.column_description,
                  MIN(a.date_created) as 'MinDate'
             from p21_view_audit_trail_oe_hdr_1319 a
             where (a.item_id NOT LIKE '%FREIGHT%'
                  and a.column_changed = 'qty_allocated'
                     and a.old_value like '0.0000%'
                     and a.new_value not like '0.0000%')
                     and a.key1_cd = 'order_no'
                     --and a.key1_value = '4690656'
                     and a.date_created >= (GETDATE()-30)
                     group by a.item_id, a.old_value, a.new_value,a.key1_value,
                     a.key1_cd,
                     a.column_changed,
                     a.column_description) aa 

     on  oel.item_id=aa.item_id
     and aa.key1_value=oel.order_no
     --and aa.MinDate=oel.date_created

where  oeh.completed <> 'N'
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
  and oel.qty_ordered >= aa.new_value
 
 group by       oeh.order_no, 
                oel.item_id,
                oel.line_no,
                oel.qty_ordered,
                oeh.customer_id,
                oeh.date_created,
                atoeh.key1_cd,
                atoeh.column_changed,
                atoeh.column_description,
                atoeh.key1_value,
                aa.new_value,
                aa.old_value,
                aa.MinDate,
                oeh.location_id,
                oeh.order_type

order by  aa.MinDate DESC
