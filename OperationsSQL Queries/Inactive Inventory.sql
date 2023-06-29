SELECT DISTINCT
loc.default_branch_id
,il.location_id
,p21_view_location.location_name
,il.product_group_id
,il.item_id
,im.item_desc
,sup.supplier_name
,il.qty_on_hand
,il.moving_average_cost
,il.qty_on_hand * il.moving_average_cost as value_on_hand
,im.vendor_consigned
,il.qty_allocated
,lss.qty_for_production
,COALESCE(cs.critical_spare, 'N') as critical_spare

,CAST(il.date_created AS DATE) as date_created
,CAST(sales.last_order_date AS DATE) as last_order_date
,CAST(purchases.last_po_recived_date AS DATE) as last_po_recived_date
,CAST(tranIn.last_transfer_in AS DATE) as last_transfer_in
,CAST(tranOut.last_transfer_out AS DATE) as last_transfer_out
,CAST(usage.last_usage AS DATE) as last_usage

,DATEDIFF(dd,
    CASE WHEN sales.last_order_date > COALESCE(purchases.last_po_recived_date, '1900') AND sales.last_order_date > COALESCE(tranIn.last_transfer_in, '1900')
        AND sales.last_order_date > COALESCE(tranOut.last_transfer_out, '1900') AND sales.last_order_date > COALESCE(usage.last_usage, '1900') 
        AND sales.last_order_date > il.date_created THEN sales.last_order_date
    WHEN purchases.last_po_recived_date > COALESCE(tranIn.last_transfer_in, '1900') AND purchases.last_po_recived_date > COALESCE(tranOut.last_transfer_out, '1900') 
        AND purchases.last_po_recived_date > COALESCE(usage.last_usage, '1900')
        AND  purchases.last_po_recived_date > il.date_created THEN purchases.last_po_recived_date
    WHEN tranIn.last_transfer_in > COALESCE(tranOut.last_transfer_out, '1900') AND tranIn.last_transfer_in > COALESCE(usage.last_usage, '1900') 
        AND tranIn.last_transfer_in > il.date_created THEN tranIn.last_transfer_in
    WHEN tranOut.last_transfer_out > COALESCE(usage.last_usage, '1900') AND tranOut.last_transfer_out > il.date_created THEN tranOut.last_transfer_out
    WHEN  usage.last_usage > il.date_created THEN usage.last_usage
    ELSE il.date_created END
, GETDATE()) AS age_in_days

,CASE WHEN al.inv_mast_uid IS NULL THEN 'N' ELSE 'Y' END as assembly_item
,trans_type.trans_type
, il.primary_bin

FROM p21_view_inv_loc il
INNER JOIN p21_view_inv_mast im ON im.inv_mast_uid = il.inv_mast_uid
INNER JOIN p21_view_location ON p21_view_location.location_id = il.location_id
LEFT JOIN p21_view_supplier sup ON il.primary_supplier_id = sup.supplier_id
LEFT JOIN p21_view_location loc on loc.location_id = il.location_id

LEFT JOIN (
    SELECT ih.sales_location_id, il.inv_mast_uid, MAX(ih.date_created) as last_order_date
    FROM P21.dbo.p21_view_invoice_hdr ih
    INNER JOIN P21.dbo.p21_view_invoice_line il ON il.invoice_no = ih.invoice_no
    WHERE il.qty_shipped > 0
    GROUP BY ih.sales_location_id, il.inv_mast_uid
) AS sales ON sales.inv_mast_uid = il.inv_mast_uid AND sales.sales_location_id = il.location_id

LEFT JOIN (
    SELECT ph.location_id, pl.inv_mast_uid, MAX(pl.received_date) as last_po_recived_date
    FROM P21.dbo.p21_view_po_hdr ph
    INNER JOIN P21.dbo.p21_view_po_line pl ON ph.po_no = pl.po_no
    WHERE pl.received_date IS NOT NULL
    AND pl.qty_received > 0
    GROUP BY ph.location_id, pl.inv_mast_uid
) AS purchases ON purchases.inv_mast_uid = il.inv_mast_uid AND purchases.location_id = il.location_id

LEFT JOIN (
    SELECT th.to_location_id, tl.inv_mast_uid, MAX(th.received_date) as last_transfer_in
    FROM P21.dbo.p21_view_transfer_hdr th
    INNER JOIN P21.dbo.p21_view_transfer_line tl ON th.transfer_no = tl.transfer_no
    WHERE th.received_date IS NOT NULL
    AND tl.qty_received > 0
    GROUP BY th.to_location_id, tl.inv_mast_uid
) AS tranIn ON tranIn.inv_mast_uid = il.inv_mast_uid AND tranIn.to_location_id = il.location_id

LEFT JOIN (
    SELECT th.from_location_id, tl.inv_mast_uid, MAX(th.received_date) as last_transfer_out
    FROM P21.dbo.p21_view_transfer_hdr th
    INNER JOIN P21.dbo.p21_view_transfer_line tl ON th.transfer_no = tl.transfer_no
    WHERE th.received_date IS NOT NULL
    AND tl.qty_received > 0
    GROUP BY th.from_location_id, tl.inv_mast_uid
) AS tranOut ON tranOut.inv_mast_uid = il.inv_mast_uid AND tranOut.from_location_id = il.location_id

LEFT JOIN (
    SELECT   
    ipu.location_id, ipu.inv_mast_uid, MAX(dp.beginning_date) as last_usage 
    FROM p21_view_inv_period_usage ipu
    INNER JOIN p21_view_demand_period dp ON ipu.demand_period_uid = dp.demand_period_uid
    WHERE ipu.inv_period_usage > 0
    GROUP BY ipu.location_id, ipu.inv_mast_uid
) AS usage ON usage.inv_mast_uid = il.inv_mast_uid AND usage.location_id = il.location_id

LEFT JOIN p21_view_inv_loc_stock_status lss ON lss.location_id = il.location_id AND lss.inv_mast_uid = il.inv_mast_uid

LEFT JOIN sa_view_inv_loc_ud cs (NOLOCK) ON cs.location_id = il.location_id AND cs.inv_mast_uid = il.inv_mast_uid

LEFT JOIN ( SELECT assembly_hdr.inv_mast_uid
    FROM p21_view_assembly_hdr assembly_hdr
    INNER JOIN p21_view_assembly_line assembly_line ON (assembly_hdr.inv_mast_uid = assembly_line.inv_mast_uid)
    WHERE assembly_hdr.delete_flag = 'N'
    and assembly_line.delete_flag = 'N'
    GROUP BY assembly_hdr.inv_mast_uid
) AS al ON al.inv_mast_uid = il.inv_mast_uid

LEFT JOIN (
    SELECT   inv_mast.inv_mast_uid
        ,inv_loc.location_id
        ,CASE oe_hdr.order_type
            WHEN 1706 THEN 'Service Order'
            ELSE 'Sales Order'
        END trans_type
    FROM   p21_view_inv_loc inv_loc
    INNER JOIN p21_view_inv_mast inv_mast ON (inv_mast.inv_mast_uid = inv_loc.inv_mast_uid)
    INNER JOIN p21_view_oe_line oe_line ON (oe_line.inv_mast_uid = inv_loc.inv_mast_uid)
                        AND (((inv_loc.location_id = oe_line.source_loc_id)
                        AND ((COALESCE(oe_line.disposition, 'empty') <> 'T')
                        OR ((oe_line.disposition = 'T')
                        AND (NOT EXISTS (SELECT   oe_line_po.order_number   
                                    FROM   p21_view_oe_line_po oe_line_po
                                    WHERE   oe_line_po.order_number = oe_line.order_no
                                    AND   oe_line_po.line_number = oe_line.line_no
                                    AND   oe_line_po.connection_type = 'T'
                                    AND   oe_line_po.completed <> 'Y'
                                    AND   oe_line_po.quantity_on_po > 0)))))
                        OR   ((inv_loc.location_id = oe_line.ship_loc_id)
                        AND   (oe_line.disposition = 'T')
                        AND   (EXISTS (SELECT   oe_line_po.order_number   
                                FROM   p21_view_oe_line_po oe_line_po
                                WHERE   oe_line_po.order_number = oe_line.order_no
                                    AND   oe_line_po.line_number = oe_line.line_no
                                    AND   oe_line_po.connection_type = 'T'
                                    AND   oe_line_po.completed <> 'Y'
                                    AND   oe_line_po.quantity_on_po > 0))))
                        AND   ((oe_line.qty_allocated + oe_line.qty_on_pick_tickets > 0 )
                            OR   (COALESCE(oe_line.disposition, 'empty') <> 'D'))
                        AND   (oe_line.complete = 'N')
                        AND   ((oe_line.parent_oe_line_uid = 0)
                        OR   (EXISTS (SELECT   oe_line2.oe_line_uid
                                FROM   p21_view_oe_line oe_line2
                                INNER JOIN p21_view_inv_mast inv_mast2 ON (inv_mast2.inv_mast_uid = oe_line2.inv_mast_uid)
                                WHERE   oe_line2.oe_line_uid = oe_line.parent_oe_line_uid
                                    AND   (oe_line2.assembly = 'B'
                                    OR   (oe_line2.assembly = 'N' AND inv_mast2.product_type = 'L')))))
                        AND   (oe_line.scheduled = 'N')
                        AND   (oe_line.qty_allocated + oe_line.qty_on_pick_tickets + oe_line.qty_staged > 0)
    INNER JOIN p21_view_oe_hdr oe_hdr ON (oe_hdr.order_no = oe_line.order_no)
                        AND (oe_hdr.projected_order = 'N')
                        AND (oe_hdr.delete_flag = 'N')
                        AND (oe_hdr.rma_flag = 'N')

    UNION ALL

    SELECT   inv_mast.inv_mast_uid
        ,inv_loc.location_id
        ,'Transfer' trans_type
    FROM   p21_view_inv_loc inv_loc
    INNER JOIN p21_view_inv_mast inv_mast ON (inv_mast.inv_mast_uid = inv_loc.inv_mast_uid)
    INNER JOIN p21_view_transfer_hdr transfer_hdr ON (transfer_hdr.from_location_id = inv_loc.location_id)
                            AND (transfer_hdr.complete_flag <> 'Y')
    INNER JOIN p21_view_location to_loc ON (to_loc.location_id = transfer_hdr.to_location_id)
    INNER JOIN p21_view_transfer_line transfer_line ON (transfer_line.transfer_no = transfer_hdr.transfer_no)
                            AND (transfer_line.inv_mast_uid = inv_loc.inv_mast_uid)
                            AND ((( transfer_line.row_status <> 1 )
                            AND (inv_loc.company_id = to_loc.company_id))
                            OR ((transfer_line.row_status = 0)
                            AND (inv_loc.company_id <> to_loc.company_id)))
                            AND (transfer_line.delete_flag <> 'Y')

    UNION ALL

    SELECT  inv_mast.inv_mast_uid
        ,inv_loc.qty_on_hand
        ,'Schedule' trans_type
    FROM   p21_view_inv_loc inv_loc
    INNER JOIN p21_view_inv_mast inv_mast ON (inv_mast.inv_mast_uid = inv_loc.inv_mast_uid)
    INNER JOIN p21_view_oe_line oe_line ON (oe_line.inv_mast_uid = inv_loc.inv_mast_uid)
                        AND (oe_line.source_loc_id = inv_loc.location_id)
                        AND (oe_line.complete = 'N')
                        AND (oe_line.scheduled = 'Y')
                        AND (oe_line.delete_flag = 'N')
                        AND (oe_line.cancel_flag = 'N')
    INNER JOIN p21_view_oe_hdr oe_hdr ON (oe_hdr.order_no = oe_line.order_no)
                        AND (oe_hdr.projected_order = 'N')
                        AND (oe_line.delete_flag = 'N')
                        AND (oe_line.cancel_flag = 'N')
    INNER JOIN p21_view_oe_line_schedule oe_line_schedule ON (oe_line_schedule.order_no = oe_line.order_no)
                            AND (oe_line_schedule.line_no = oe_line.line_no)
                            AND (oe_line_schedule.release_qty - oe_line_schedule.qty_invoiced - oe_line_schedule.qty_canceled  > 0)
                            AND (oe_line_schedule.allocated_qty + oe_line_schedule.qty_picked + oe_line_schedule.qty_staged > 0)

    UNION ALL

    SELECT   
    inv_mast.inv_mast_uid
    ,inv_loc.location_id
    ,'Production Order' trans_type
    FROM      p21_view_prod_order_line_component prod_order_line_component
    INNER JOIN p21_view_prod_order_hdr prod_order_hdr ON (prod_order_hdr.prod_order_number = prod_order_line_component.prod_order_number)
    INNER JOIN p21_view_prod_order_line prod_order_line ON prod_order_line_component.line_number = prod_order_line.line_number
    AND prod_order_line.prod_order_number = prod_order_line_component.prod_order_number
    INNER JOIN p21_view_inv_loc inv_loc ON inv_loc.inv_mast_uid = prod_order_line_component.inv_mast_uid
    AND inv_loc.location_id =    CASE prod_order_line_component.disposition 
                            WHEN 'T' THEN
                                prod_order_hdr.source_location_id
                            ELSE
                                prod_order_line_component.source_location_id 
                            END 
    INNER JOIN p21_view_inv_mast inv_mast (nolock) ON inv_mast.inv_mast_uid = inv_loc.inv_mast_uid
    WHERE   
    (
        prod_order_line_component.qty_allocated <> 0
        OR prod_order_line_component.qty_on_pick_tickets <> 0 
    )
    AND   prod_order_line_component.qty_per_assembly > 0 
    AND ( prod_order_hdr.delete_flag = 'N' ) 
    AND  ( prod_order_hdr.complete <> 'Y' ) 
    AND  ( prod_order_hdr.cancel = 'N' ) 
    AND  ( prod_order_line.completed = 'N' ) 
    AND  ( prod_order_line.cancel = 'N' ) 
    AND  ( prod_order_line_component.complete = 'N' ) 
    AND (prod_order_hdr.assemble_disassemble = 'A')

    UNION ALL

    SELECT   
    inv_mast.inv_mast_uid
    ,inv_loc.location_id
    ,'Production Order' trans_type
    FROM      p21_view_prod_order_line_component prod_order_line_component
    INNER JOIN p21_view_prod_order_hdr prod_order_hdr ON (prod_order_hdr.prod_order_number = prod_order_line_component.prod_order_number)
    INNER JOIN p21_view_prod_order_line prod_order_line ON prod_order_line_component.line_number = prod_order_line.line_number
    AND prod_order_line.prod_order_number = prod_order_line_component.prod_order_number
    INNER JOIN p21_view_inv_loc inv_loc ON inv_loc.inv_mast_uid = prod_order_line_component.inv_mast_uid
    AND inv_loc.location_id = CASE 
                            WHEN prod_order_line_component.disposition = 'T' 
                            OR (prod_order_hdr.inventory_location_id IS NOT NULL AND prod_order_hdr.source_location_id <> prod_order_hdr.inventory_location_id) THEN
                            prod_order_hdr.source_location_id
                            ELSE
                            prod_order_line_component.source_location_id 
                            END 
    INNER JOIN p21_view_inv_mast inv_mast ON inv_mast.inv_mast_uid = inv_loc.inv_mast_uid
    WHERE
    prod_order_line_component.qty_confirmed <> 0  
    AND   prod_order_line_component.qty_per_assembly > 0 
    AND (prod_order_hdr.assemble_disassemble = 'A')
    AND ( prod_order_hdr.delete_flag = 'N' ) 
    AND  ( prod_order_hdr.complete <> 'Y' )
    AND  ( prod_order_hdr.cancel = 'N' ) 
    AND  ( prod_order_line.completed = 'N' ) 
    AND  ( prod_order_line.cancel = 'N' ) 
    AND  ( prod_order_line_component.complete = 'N' ) 

    UNION ALL

    SELECT 
    inv_mast.inv_mast_uid
    ,inv_loc.location_id
    ,'Production Order' trans_type
    FROM  p21_view_prod_order_line prod_order_line
    INNER JOIN p21_view_prod_order_hdr prod_order_hdr ON   (prod_order_hdr.prod_order_number = prod_order_line.prod_order_number)  
    AND ( prod_order_hdr.delete_flag = 'N' )   
    AND  ( prod_order_hdr.complete <> 'Y' )
    AND  ( prod_order_hdr.cancel = 'N' )   
    AND (prod_order_hdr.assemble_disassemble = 'D')
    INNER JOIN p21_view_inv_mast inv_mast ON inv_mast.inv_mast_uid = prod_order_line.inv_mast_uid
    INNER JOIN p21_view_inv_loc inv_loc ON inv_loc.inv_mast_uid = prod_order_line.inv_mast_uid
    AND inv_loc.location_id = prod_order_hdr.source_location_id
    WHERE  ( prod_order_line.completed = 'N' )   
    AND  ( prod_order_line.cancel = 'N' )   

    UNION ALL

    SELECT   inv_mast.inv_mast_uid
        ,inv_loc.location_id
        ,'Secondary Processing' trans_type
    FROM   p21_view_inv_loc inv_loc
    INNER JOIN p21_view_inv_mast inv_mast ON (inv_mast.inv_mast_uid = inv_loc.inv_mast_uid)
    INNER JOIN p21_view_process_x_transaction process_x_transaction ON (process_x_transaction.raw_inv_mast_uid = inv_loc.inv_mast_uid)
                                AND (process_x_transaction.location_id = inv_loc.location_id)
                                AND (process_x_transaction.raw_qty_allocated > 0)
    WHERE   process_x_transaction.row_status_flag NOT IN (700, 701, 705, 713)

    UNION ALL

    SELECT   inv_mast.inv_mast_uid
        ,inv_loc.location_id
        ,'Inventory Return' trans_type
    FROM   p21_view_inv_loc inv_loc
    INNER JOIN p21_view_inv_mast inv_mast ON (inv_mast.inv_mast_uid = inv_loc.inv_mast_uid)
    INNER JOIN p21_view_inventory_return_line inventory_return_line ON (inventory_return_line.inv_mast_uid = inv_loc.inv_mast_uid)
                                AND (inventory_return_line.row_status_flag = 702)
                                AND (inventory_return_line.unit_quantity * inventory_return_line.quantity_unit_size > 0)
    INNER JOIN p21_view_inventory_return_hdr inventory_return_hdr ON (inventory_return_hdr.inventory_return_hdr_uid = inventory_return_line.inventory_return_hdr_uid)
                                AND (inventory_return_hdr.location_id = inv_loc.location_id)
    WHERE   qty_allocated > 0
) trans_type ON trans_type.inv_mast_uid = il.inv_mast_uid AND trans_type.location_id = il.location_id

where 
(il.date_created  <= Dateadd(year,-1,getdate()) or il.date_created is null)
AND (purchases.last_po_recived_date <= DATEadd(day,-365,getdate()) OR purchases.last_po_recived_date IS NULL)
AND (tranIn.last_transfer_in <= DATEadd(day,-365,getdate()) OR tranIn.last_transfer_in IS NULL )
AND (tranOut.last_transfer_out <= DATEadd(day,-365,getdate()) OR tranOut.last_transfer_out IS NULL )
AND (usage.last_usage <= DATEadd(day,-365,getdate()) OR usage.last_usage IS NULL )
AND (sales.last_order_date <= DATEadd(day,-365,getdate()) OR sales.last_order_date IS NULL)
AND il.qty_on_hand > 0
--AND il.qty_allocated = 0
AND il.qty_in_transit = 0
AND il.order_quantity = 0
AND il.qty_backordered = 0
AND il.delete_flag <> 'Y'
AND il.product_group_id <> 'MAR'
AND im.vendor_consigned <> 'Y' 
AND il.company_id IN ('01', '03')
AND il.location_id NOT IN ('1500')
--AND lss.qty_for_production = 0
--AND lss.qty_in_production = 0
--AND COALESCE(cs.critical_spare, 'N') = 'N' 
--AND il.item_id IN ('20310990','E8-FLIR-DEMO','20273939','WS330/3-42-72','22322E1C3-FAG','20305360-32','WS330/3-42-24')