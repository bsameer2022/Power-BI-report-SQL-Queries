select  oehh.order_no
      , oehh.source_id
      , oehh.customer_id
      , oehh.location_id
      , qh.quote_hdr_uid
      , qh.oe_hdr_uid
      , oehh.projected_order
      , qh.complete_flag
      , qh.date_created
      , oehh.order_date
      --, count(oehh.projected_order) as total_Quotes
from P21.dbo.p21_view_quote_hdr qh
left join (select oeh.order_no
                , oeh.projected_order
                , oeh.oe_hdr_uid
                , oeh.location_id
                , oeh.customer_id
                , oeh.order_date
                , oeh.source_id
                , oeh.source_code_no
                --, cd.code_description
                --, count(oeh.projected_order) as Total_Qutoes
            from P21.dbo.p21_view_oe_hdr oeh
            left join P21.dbo.p21_view_oe_hdr oe  
            on oeh.order_no = oe.source_id
             Left join P21.dbo.p21_view_code_p21 cd 
             on oeh.source_code_no = cd.code_no
            where  oeh.delete_flag<>'Y'
                and oeh.cancel_flag<>'Y'
                and oe.source_id is NOT NULL 
                and oe.source_code_no <> '706'
                and oeh.date_created>='2022-01-01') oehh
                on qh.oe_hdr_uid=oehh.oe_hdr_uid

where qh.date_created >= '2022-01-01'
--and oehh.source_id is NOT NULL
--  and  qh.complete_flag = 'N'
