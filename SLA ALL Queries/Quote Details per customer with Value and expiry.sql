select    DISTINCT oeh.customer_id,

                   oeh.order_no,
   
                   oeh.location_id,
                   
                   MAX(oeh.order_date) as 'Order Date',
   
                   SUM(oel.extended_price) as 'Total Value',
   
                   MAX(qhd.date_last_modified) as 'Last Modified' ,
   
                   MAX(qhd.expiration_date) as 'Expiration Date',
   
                   COUNT(oeh.customer_id) as 'NumberQuotes'


from P21.dbo.p21_view_oe_hdr oeh

left join P21.dbo.p21_view_oe_line oel

    on oeh.order_no=oel.order_no

left join P21.dbo.p21_view_quote_hdr qhd

    on oeh.oe_hdr_uid=qhd.oe_hdr_uid

left join P21.dbo.p21_view_quote_line ql

    on oel.oe_line_uid=ql.oe_line_uid

where ql.line_complete_flag <> 'Y'

      and qhd.complete_flag <> 'Y'

      and oel.delete_flag <> 'Y'

      and oeh.delete_flag <> 'Y'

      and oeh.projected_order = 'Y' 

      and qhd.expiration_date >= GETDATE()

group by oeh.location_id,oeh.order_no, oeh.customer_id , oeh.location_id, ship2_name

order by oeh.location_id,oeh.order_no , NumberQuotes