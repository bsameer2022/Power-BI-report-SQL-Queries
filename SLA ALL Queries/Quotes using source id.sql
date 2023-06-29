select  
 distinct oeh.location_id,
  (  qhd.quote_hdr_uid) ,
  oeh.source_id,
   (oel.extended_price) as TotalValue

 from  P21.dbo.p21_view_oe_hdr oeh

left join P21.dbo.p21_view_quote_hdr qhd
       on oeh.oe_hdr_uid=qhd.oe_hdr_uid

 left join P21.dbo.p21_view_oe_line oel
        on oeh.order_no = oel.order_no

  where oeh.source_id is  NULL

        --and oeh.source_id = oeh.order_no

        -- and oeh.source_code_no= 709

        and  qhd.complete_flag <> 'Y'

        and oel.delete_flag <> 'Y'

        and oeh.delete_flag <> 'Y'

        and oeh.projected_order = 'Y' 

        and oeh.cancel_flag = 'N'

        and qhd.expiration_date < GETDATE()

        and Year(qhd.expiration_date) = 2022

-- group by oeh.location_id


-- order by   SUM(oel.extended_price) desc


