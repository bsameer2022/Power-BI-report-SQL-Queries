select jpl.item_id

    , jpl.uom

    , jpl.price

    , jpl.other_cost_value

    , inv.default_purchasing_unit

    , uom.unit_size

    , uom2.unit_size as 'Contract Unit Size'

    , loc.standard_cost

    -- Converting cost to lowest unit size

    , CASE

        when uom.unit_size > 0 then (loc.standard_cost/uom.unit_size)

        else 0

    END as 'CostEA'

    -- Converting contract price to lowest unit size

    , CASE

    when uom2.unit_size > 0 then (jpl.price/uom2.unit_size)

        else 0

    END as 'ConEA'

    -- The margin when adjustments are made

    , CASE

        when uom2.unit_size > 0 and uom.unit_size > 0 and jpl.price > 0 then ((jpl.price/uom2.unit_size)-(loc.standard_cost/uom.unit_size))/((jpl.price/uom2.unit_size))

        else 0

    END as 'Adjusted Margin'

    -- Margin without adjustments made

    , CASE

        when loc.standard_cost > 0 and jpl.price > 0 then ((jpl.price-loc.standard_cost)/jpl.price)

        else 0

    END as 'Margin'




from P21.dbo.p21_view_job_price_line jpl




left join P21.dbo.p21_view_inv_mast inv

    on jpl.inv_mast_uid=inv.inv_mast_uid




left join P21.dbo.p21_view_item_uom uom

    on uom.inv_mast_uid=jpl.inv_mast_uid

    and uom.unit_of_measure=inv.default_purchasing_unit




left join P21.dbo.p21_view_item_uom uom2

    on uom2.inv_mast_uid=jpl.inv_mast_uid

     and uom2.unit_of_measure=jpl.uom




-- The branch to consider

left join P21.dbo.p21_view_inv_loc loc

    on loc.inv_mast_uid=jpl.inv_mast_uid

    and loc.location_id='1100'




--The contract to consider

where jpl.job_price_hdr_uid in ('5045')