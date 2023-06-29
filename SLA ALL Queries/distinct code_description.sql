select distinct code_description 
--      , oeh.order_date
--      , oeh.location_id
--      , oeh.order_type
     , code_no


from P21.dbo.p21_view_oe_hdr oeh

LEFT JOIN p21_view_code_p21 cd
       on oeh.source_code_no = cd.code_no

-- LEFT JOIN P21.dbo.p21_view_oe_line oel 
--        on oel.order_no = oeh.order_no   

--  LEFT JOIN P21.dbo.p21_view_inv_mast invm
--       on invm.inv_mast_uid = oel.inv_mast_uid
