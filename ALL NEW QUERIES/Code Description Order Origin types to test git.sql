select  distinct  code_no, 
code_description

from p21_view_code_p21 cd

LEFT JOIN P21.dbo.p21_view_oe_hdr oeh
       on oeh.source_code_no = cd.code_no
 where code_no in ('919','1706') 
 and   oeh.order_date > (GETDATE() - 365)
left join (select distinct c.customer_name

                       , c.customer_id

           from P21.dbo.p21_view_customer c) cc
on oeh.customer_id=cc.customer_id

where code_description = 'shipped'
and   oeh.order_date > (GETDATE() - 30)

group by cc.customer_name,order_no, 
code_no, 
code_description

706,707,708,709,,1343,1446,1706