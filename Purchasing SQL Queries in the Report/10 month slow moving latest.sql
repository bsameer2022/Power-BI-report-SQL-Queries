/****** Script for SelectTopNRows command from SSMS  ******/

-------Developer Name: SAMEER BANDI

-------Date of Change in the query: 05/23/2023 (as mm/dd/yyyy)

-------Reason for Development: To show 10 month slow inventory items with inventory value report 

-- -- Last day of the month
-- SELECT DATEADD(dd, -DAY(DATEADD(mm, 1, GETDATE())), DATEADD(mm, 1, GETDATE()))
-- -- First day of the month 10 months ago
-- SELECT DATEADD(dd, -DAY(DATEADD(mm, -12, GETDATE()))+1, DATEADD(mm, -12, GETDATE()))

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
Set @StartDate = DATEADD(dd, -DAY(DATEADD(mm, -12, GETDATE()))+1, DATEADD(mm, -12, GETDATE()))
Set @EndDate = DATEADD(dd, -DAY(DATEADD(mm, 1, GETDATE())), DATEADD(mm, 1, GETDATE()))

SELECT 
ph.location_id
,pl.item_id
,pl.item_description
,invl.product_group_id
,sup.supplier_id
,sup.supplier_name
,pl.qty_ordered
,pl.received_date
,ph.date_created
,pl.qty_ordered*pl.unit_price AS ordered_value
,pl.unit_price
,ph.po_no
,COALESCE(SUM(il.qty_shipped),0) as qty_sold
,inl.qty_allocated
,COALESCE(SUM(tl.qty_transferred), 0) as qty_transfered
,MAX(CASE WHEN al.inv_mast_uid IS NOT NULL THEN 1 ELSE 0 END) AS  assembly_item
,invl.qty_on_hand
,(((invl.qty_on_hand-invl.special_layer_qty)*invl.cost)+invl.special_layer_value) as Quantity_on_hand_value
--,inl.qty_on_hand*inl.moving_average_cost as value_on_hand
,network_sales.sales_within_network
,network_sales.qty_sold_within_network
,CASE WHEN COALESCE(SUM(usage.usage),0) = 0
            AND COALESCE(SUM(tl.qty_transferred), 0) = 0
            AND inl.qty_allocated = 0
            AND MAX(CASE WHEN al.inv_mast_uid IS NOT NULL THEN 1 ELSE 0 END) = '0'
            AND invl.qty_on_hand > 0
        THEN 1 ELSE 0 END AS return_candidate

FROM P21.dbo.p21_view_po_hdr AS ph

INNER JOIN P21.dbo.p21_view_po_line AS pl
ON pl.po_no = ph.po_no

INNER JOIN P21.dbo.p21_view_inv_loc AS inl
ON inl.inv_mast_uid = pl.inv_mast_uid
AND inl.location_id = ph.location_id

LEFT JOIN P21.dbo.p21_view_inventory_value_report as invl
on invl.inv_mast_uid = inl.inv_mast_uid 
and invl.location_id = inl.location_id



LEFT JOIN P21.dbo.p21_view_supplier AS sup 
ON inl.primary_supplier_id = sup.supplier_id

INNER JOIN P21.dbo.p21_view_inv_mast AS im
ON pl.inv_mast_uid = im.inv_mast_uid

LEFT JOIN (
    P21.dbo.p21_view_transfer_line AS tl
    LEFT JOIN P21.dbo.p21_view_transfer_hdr AS th
    ON tl.transfer_no = th.transfer_no
) ON tl.inv_mast_uid = pl.inv_mast_uid
    AND th.from_location_id = ph.location_id
    AND th.date_created between @StartDate and @EndDate
    AND th.delete_flag <> 'Y'
 
LEFT JOIN (select ih.sales_location_id
                , il.inv_mast_uid
             ,SUM(il.qty_shipped) as 'qty_shipped'     
           from P21.dbo.p21_view_invoice_hdr ih
           left join P21.dbo.p21_view_invoice_line il
           ON il.invoice_no = ih.invoice_no
           where ih.date_created between @StartDate and @EndDate
           group by ih.sales_location_id, il.inv_mast_uid
) il
ON il.inv_mast_uid = pl.inv_mast_uid
    AND il.sales_location_id = ph.location_id

LEFT JOIN (
    SELECT   
    ipu.location_id, ipu.inv_mast_uid, SUM(ipu.inv_period_usage) as usage, count(DISTINCT dp.beginning_date) as period_count
    FROM p21_view_inv_period_usage ipu
    INNER JOIN p21_view_demand_period dp ON ipu.demand_period_uid = dp.demand_period_uid
    WHERE dp.ending_date between @StartDate and @EndDate
    GROUP BY ipu.location_id, ipu.inv_mast_uid
) AS usage ON usage.inv_mast_uid = inl.inv_mast_uid AND usage.location_id = inl.location_id

LEFT JOIN (
    SELECT il2.inv_mast_uid, COUNT(DISTINCT ih2.sales_location_id) as sales_within_network, SUM(il2.qty_shipped) as qty_sold_within_network
    FROM P21.dbo.p21_view_invoice_hdr AS ih2
    INNER JOIN P21.dbo.p21_view_invoice_line AS il2
    ON il2.invoice_no = ih2.invoice_no
    WHERE ih2.date_created between @StartDate and @EndDate
    GROUP BY il2.inv_mast_uid
) as network_sales ON network_sales.inv_mast_uid = pl.inv_mast_uid 

LEFT JOIN ( SELECT assembly_hdr.inv_mast_uid
    FROM p21_view_assembly_hdr assembly_hdr
    INNER JOIN p21_view_assembly_line assembly_line ON (assembly_hdr.inv_mast_uid = assembly_line.inv_mast_uid)
    WHERE assembly_hdr.delete_flag = 'N'
    and assembly_line.delete_flag = 'N'
    GROUP BY assembly_hdr.inv_mast_uid
) AS al ON al.inv_mast_uid = pl.inv_mast_uid

WHERE pl.received_date between @StartDate and @EndDate
AND (ph.cancel_flag <> 'Y' OR ph.cancel_flag is null)
AND ph.delete_flag <> 'Y'
AND (pl.cancel_flag <> 'Y' OR pl.cancel_flag is null)
AND pl.delete_flag <> 'Y'
AND inl.product_group_id IN ('CIN','ELE','PTP','PVF','HRR','PLB','MBV','REN')
AND pl.item_id = '3697-27'
AND ph.location_id = 1260
GROUP BY
ph.location_id
,pl.item_id
,pl.item_description
,pl.qty_ordered
,pl.unit_price
,ph.po_no
,pl.received_date
,ph.date_created
,inl.qty_allocated
,sup.supplier_id
,invl.product_group_id
,sup.supplier_name
,network_sales.sales_within_network
,network_sales.qty_sold_within_network
,invl.qty_on_hand
,invl.special_layer_qty
,invl.cost
,invl.special_layer_value

--,inl.qty_on_hand,
--inl.moving_average_cost
ORDER BY return_candidate DESC