select          oeh.customer_id,
                cc.customer_name,
                oeh.order_no,
                oeh.location_id,
                cd.code_no,
                cd.code_description,
                oeh.ship2_name,
                MAX(oeh.order_date) as 'Order Date',
                SUM(oel.extended_price) as 'Total Value',
                COUNT(oel.item_id) as 'Number of Lines'

from P21.dbo.p21_view_oe_hdr oeh

left join P21.dbo.p21_view_oe_line oel

    on oeh.order_no=oel.order_no

left join P21.dbo.p21_view_quote_hdr qhd

    on oeh.oe_hdr_uid=qhd.oe_hdr_uid

left join (select distinct c.customer_name

                        , c.customer_id

            from P21.dbo.p21_view_customer c) cc

    on oeh.customer_id=cc.customer_id

left join P21.dbo.p21_view_ship_to st

    on st.ship_to_id = oeh.address_id

    and oeh.company_id=st.company_id

LEFT JOIN p21_view_code_p21 cd
 on oeh.source_code_no = cd.code_no

where oel.delete_flag <> 'Y'
and   oeh.delete_flag <> 'Y'
--and   cd.code_no  not like '%709%'
and   oeh.completed <> 'Y'
and   oeh.cancel_flag <> 'Y'
and   oel.cancel_flag <> 'Y'
and   oel.complete <> 'Y'
and   oeh.rma_flag <> 'Y'
and   oel.item_id not like '%FREIGHT%'
and   oeh.order_date > (GETDATE() - 30)
and cd.code_description like '%S%'

group by oeh.source_code_no
       , cd.code_no
       , cd.code_description
       , oeh.order_no
       , oeh.customer_id
       , cc.customer_name
       , oeh.location_id
       , oeh.ship2_name
