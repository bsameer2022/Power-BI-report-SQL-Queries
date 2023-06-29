select v.vendor_id
     , v.vendor_name
     , oel.order_no
     , oeh.order_type
     , invm.product_type
     , invm.item_id
     , invm.item_desc
     , oel.supplier_id
     , cd.code_no
     , cd.code_description
     , oeh.order_date
     , oeh.location_id

from P21.dbo.p21_view_oe_hdr oeh

LEFT JOIN p21_view_code_p21 cd
       on oeh.source_code_no = cd.code_no

LEFT JOIN P21.dbo.p21_view_oe_line oel 
       on oel.order_no = oeh.order_no

-- LEFT JOIN P21.dbo.p21_view_supplier s 
--        on s.supplier_id = oel.supplier_id

LEFT JOIN P21.dbo.p21_view_customer c 
       on c.customer_id = oeh.customer_id    

LEFT JOIN P21.dbo.p21_view_vendor v 
       on oel.supplier_id  = v.vendor_id

LEFT JOIN P21.dbo.p21_view_inv_mast invm
      on invm.inv_mast_uid = oel.inv_mast_uid

where cd.code_no in ('919','1706')
  and invm.product_type in ('R', 'T')
  and oeh.order_date  > GETDATE() - 365
  and oeh.delete_flag <> 'Y' 
  and oeh.completed <> 'Y' 
  and oeh.cancel_flag <> 'Y'
  and oel.delete_flag <> 'Y'
  and oel.cancel_flag <> 'Y'
  and oel.complete <> 'Y'
group by oeh.order_no,
         oeh.order_date,
         oeh.location_id,
         oeh.order_type,
         v.vendor_id,
         v.vendor_name,
         invm.product_type,
         invm.item_id,
         invm.item_desc,
         cd.code_no,
         cd.code_description,
         oel.order_no,
         oel.supplier_id,
         oel.oe_hdr_uid

--order by v.vendor_id
