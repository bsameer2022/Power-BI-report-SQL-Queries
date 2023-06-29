select  oehh.order_no

      , oehh.customer_id

      , oehh.location_id

      , qh.quote_hdr_uid

      , qh.oe_hdr_uid

      , oehh.projected_order

      , qh.complete_flag

      , qh.date_created

      , oehh.order_date

      , oehh.delete_flag

      , oehh.cancel_flag

      --, count(oehh.projected_order) as total_Quotes

from P21.dbo.p21_view_quote_hdr qh

left join (select oeh.order_no

                , oeh.projected_order

                , oeh.oe_hdr_uid

                , oeh.location_id

                , oeh.customer_id

                , oeh.order_date

                , oeh.delete_flag

                , oeh.cancel_flag

            from P21.dbo.p21_view_oe_hdr oeh

            where oeh.date_created>='2022-01-01') oehh

                on qh.oe_hdr_uid=oehh.oe_hdr_uid





where qh.date_created>= '2022-01-01'

    and oehh.customer_id is not NULL

--      and oehh.order_no <> 'NULL'





group by   oehh.order_no

         , oehh.customer_id

         , oehh.location_id

         , oehh.order_date

         , qh.quote_hdr_uid

         , qh.oe_hdr_uid

         , oehh.projected_order

         , qh.complete_flag

         , qh.date_created

        , oehh.delete_flag

        , oehh.cancel_flag

--  and  qh.complete_flag = 'N'