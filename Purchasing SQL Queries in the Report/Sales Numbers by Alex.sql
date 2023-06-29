--Developer Name: SAMEER BANDI
--Date of Initial Development: 15/05/2023 (as mm/dd/yyyy)
--Reason for Development: To develop Sales of the inventory rolling 12 months


SELECT  ih.corp_address_id,
        ih.customer_id,
        jph2.contract_no,
        cc.customer_name,
        ih.ship_to_id,
        ih.invoice_date,
		il.item_id,
        il.inv_mast_uid,
        im.product_type AS 'temp_reg_check',
        MAX (im.item_desc) AS 'item_desc',
        il.extended_price AS 'sales',
        il.invoice_line_uid,
        il.qty_shipped,
        il.cogs_amount AS 'cost',
        ih.sales_location_id AS 'invoice_branch_location',
        ih.invoice_no,
        ih.order_no,
        CASE WHEN jph2.contract_no IS NOT NULL THEN 'Y' 
			ELSE 'N' 
		END AS 'contract_sale_flag',
        ih.salesrep_id AS 'acc_manager_id',
        con.contact_name AS 'account_manager',
        sup.supplier_id,
        sup.supplier_name,
        sup.supplier_part_no,
	jph2.start_date AS 'contract_term_start_date',
	jph2.end_date AS 'contract_term_end_date',
    MIN (jph2.date_created) AS 'contract_start_date',
    st.class5_id AS 'solution_type',
    COALESCE (vc1.class_description,'UNDEFINED') AS 'class1',
    COALESCE (vc2.class_description,'UNDEFINED') AS 'class2',
    il.product_group_id,
    jph2.job_description,
	CASE
		when ih.ship2_name = 'IPP - New Pulp Dryer Project' 
			or ih.ship2_name = 'IPP New Pulp Dryer Project' 
			or ih.ship2_name = 'IPP-New Pulp Dryer Project'
			or ih.ship2_name = 'IPP – New Pulp Dryer Project' then 'IPP New Pulp Dryer Project'
    	else ih.ship2_name
	END as 'ship2_name',
    CASE WHEN jph2.end_date >= (GETDATE()-2) THEN 'Active' 
		ELSE 'Inactive' 
	END AS 'Active',
	ih.ship2_address1,
	ih.ship2_state

FROM p21.dbo.p21_view_invoice_hdr ih

LEFT JOIN p21.dbo.p21_view_invoice_line il
    ON il.invoice_no = ih.invoice_no
    
LEFT JOIN p21.dbo.p21_view_inv_mast im
    ON im.inv_mast_uid = il.inv_mast_uid
    
LEFT JOIN (select distinct c.customer_id
                , c.customer_name
            from p21.dbo.p21_view_customer c) cc
    ON cc.customer_id = ih.customer_id
    
LEFT JOIN p21.dbo.p21_view_oe_line oeline
    ON oeline.order_no = ih.order_no
    AND oeline.inv_mast_uid = il.inv_mast_uid
    AND oeline.line_no = il.oe_line_number
    
LEFT JOIN (SELECT  jph.job_price_hdr_uid,
                    jph.contract_no,
                    jph.contact_id,
                    jph.taker,
                    jpl.job_price_line_uid,
                    jpl.item_id,
                    jpl.inv_mast_uid,
                    jpl.row_status_flag,
                    jph.start_date,
                    jph.end_date,
                    jph.cancelled,
                    jph.job_description,
                    jph.date_created
            FROM p21.dbo.p21_view_job_price_hdr jph
            LEFT JOIN p21.dbo.p21_view_job_price_line jpl
            ON jpl.job_price_hdr_uid = jph.job_price_hdr_uid
            GROUP BY    jph.job_price_hdr_uid,
                        jph.contract_no,
                        jph.contact_id,
                        jph.taker,
                        jpl.job_price_line_uid,
                        jpl.item_id,
                        jpl.inv_mast_uid,
                        jpl.row_status_flag,
                        jph.start_date,
                        jph.end_date,
                        jph.cancelled,
                        jph.job_description,
                        jph.date_created)
            AS jph2 ON jph2.job_price_line_uid = oeline.job_price_line_uid
            AND jph2.inv_mast_uid = oeline.inv_mast_uid
    
LEFT JOIN (SELECT  s.supplier_id,
                    s.supplier_name,
                    MAX (vins.supplier_part_no) AS 'supplier_part_no',
                    vins.inv_mast_uid
            -- Put supplier part no in a MAX to avoid potetntial duplication
            FROM p21.dbo.p21_view_supplier s
            LEFT JOIN p21.dbo.p21_view_inventory_supplier vins
            ON vins.supplier_id = s.supplier_id
            GROUP BY    s.supplier_id,
                        s.supplier_name,
                        --vins.supplier_part_no,
                        vins.inv_mast_uid)
            AS sup ON sup.supplier_id = il.supplier_id
            AND sup.inv_mast_uid = il.inv_mast_uid

LEFT JOIN p21.dbo.p21_view_contacts con
    ON con.id = ih.salesrep_id
    
LEFT JOIN p21.dbo.p21_view_ship_to st
    ON st.ship_to_id = ih.ship_to_id
    
LEFT JOIN p21.dbo.p21_view_class vc1
    ON vc1.class_id = im.class_id1
    AND vc1.class_type = 'IV'
    AND vc1.class_number = '1'
    AND vc1.delete_flag = 'N'
    
LEFT JOIN p21.dbo.p21_view_class vc2
    ON vc2.class_id = im.class_id2
    AND vc2.class_type = 'IV'
    AND vc2.class_number = '2'
    AND vc2.delete_flag = 'N'

WHERE ih.invoice_date  >= GETDATE()-365
--between  DATEADD (yy, -1, DATEADD(dd, -DAY(GETDATE()-1), GETDATE()))
--AND DATEADD (dd, -DAY(GETDATE()), GETDATE())
    AND il.item_id NOT IN (SELECT tj.jurisdiction_id FROM p21.dbo.p21_view_tax_jurisdiction tj)
    AND il.item_id NOT LIKE ('%FREIGHT%')
    AND (il.invoice_line_uid_parent = 0 OR il.invoice_line_type IN (1577, 1719))
	AND il.item_id in ('20305409-48','IRVINGPAPERBELT')
GROUP BY ih.corp_address_id,
        ih.customer_id,
        jph2.contract_no,
        cc.customer_name,
        ih.ship_to_id,
        ih.invoice_date,
		il.item_id,
        il.inv_mast_uid,
        im.product_type,
        il.extended_price,
        il.invoice_line_uid,
        il.qty_shipped,
        il.cogs_amount,
        ih.sales_location_id,
        ih.invoice_no,
        ih.order_no,
        CASE WHEN jph2.contract_no IS NOT NULL THEN 'Y' 
			ELSE 'N' 
		END,
        ih.salesrep_id,
        con.contact_name,
        sup.supplier_id,
        sup.supplier_name,
        sup.supplier_part_no,
	jph2.start_date,
	jph2.end_date,
    st.class5_id,
    COALESCE (vc1.class_description,'UNDEFINED'),
    COALESCE (vc2.class_description,'UNDEFINED'),
    il.product_group_id,
    jph2.job_description,
	CASE
		when ih.ship2_name = 'IPP - New Pulp Dryer Project' 
			or ih.ship2_name = 'IPP New Pulp Dryer Project' 
			or ih.ship2_name = 'IPP-New Pulp Dryer Project'
			or ih.ship2_name = 'IPP – New Pulp Dryer Project' then 'IPP New Pulp Dryer Project'
    	else ih.ship2_name
	END,
    CASE WHEN jph2.end_date >= (GETDATE()-2) THEN 'Active' 
		ELSE 'Inactive' 
	END,
	ih.ship2_address1,
	ih.ship2_state