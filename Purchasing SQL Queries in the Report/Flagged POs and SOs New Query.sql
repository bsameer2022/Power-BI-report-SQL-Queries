 /****** Script for SelectTopNRows command from SSMS  ******/

-------Developer Name: SAMEER BANDI

-------Date of Change in the query: 05/23/2023 (as mm/dd/yyyy)

-------Reason for Development: To show the POs and the SOs impacting the inventory value in real time


  SELECT distinct 
                CASE
                                WHEN s1.location_id IS NULL THEN s2.location_id
                                WHEN s2.location_id IS NULL THEN s1.location_id
                                ELSE s1.location_id
                END AS location ,
				s1.supplier_name,
				s1.product_group_id,
				s1.inv_min as 'MIN',s1.inv_max as 'MAX',
                CASE
                                WHEN s1.item_id IS NULL THEN s2.item_id
                                WHEN s2.item_id IS NULL THEN s1.item_id
                                ELSE s1.item_id
                END AS item ,
                CASE           WHEN s2.qty_open_so is NULL THEN 0
				               ELSE s2.qty_open_so 
	            END AS qty_open_so,
			    CASE           WHEN s1.qty_due_on_po is NULL THEN 0
							   ELSE s1.qty_due_on_po
		       END AS qty_due_on_po,
			   CASE 
							   WHEN (s1.qty_due_on_po - s2.qty_open_so) = 0 THEN 0
							   WHEN(s1.qty_due_on_po is  NULL)  THEN 0
							   WHEN(s2.qty_open_so is  NULL) THEN (s1.qty_due_on_po/s1.unit_size)* s1.unit_price
							   ELSE ((s1.qty_due_on_po/s1.unit_size) - (s2.qty_open_so/s1.unit_size)) * s1.unit_price
		      END as Inventory_Value_Impact,
							   s1.unit_of_measure as PO_UOM ,s2.unit_of_measure as SO_UOM,
			 CASE
							   when s1.unit_of_measure != s2.unit_of_measure THEN 'No UOM match'
							   WHEN s1.unit_of_measure is NULL THEN 'No UOM on PO'
							   WHEN s2.unit_of_measure is NULL THEN 'No UOM SO'
				               ELSE 'UOM Match on POs and SOs'
			END AS UOM,

           CASE
                                WHEN s1.item_id IS NULL THEN 'only Sales order'  
                                WHEN s2.item_id IS NULL THEN 'only Purchase order'
                                ELSE 'Both SO and PO'
          END AS status,
		  CASE
                                WHEN s1.qty_due_on_po IS NULL THEN  s2.qty_open_so
                                WHEN s2.qty_open_so IS NULL THEN (s1.qty_due_on_po) - 0
								ELSE (s1.qty_due_on_po) - (s2.qty_open_so)
         END as PO_and_SO_Qtydifference,
		 s1.stockable

FROM            (
                         SELECT  
								  poh.location_id,
                                  pol.item_id ,
								  pol.unit_size,
								  pol.unit_price,
								  pol.unit_of_measure,
								  poh.supplier_id,
								  invs.supplier_name,
								  invl.product_group_id,
								  invl.stockable,
								  invl.inv_min,
								  invl.inv_max,
                                  Sum(pol.qty_ordered - pol.qty_received) AS qty_due_on_po
                         FROM     p21_view_po_hdr poh
                         JOIN     p21_view_po_line pol
                         ON       pol.po_no = poh.po_no
                         JOIN     p21_view_inv_loc invl
                         ON       invl.inv_mast_uid = pol.inv_mast_uid
                         AND      invl.location_id = poh.location_id
						 Join	  p21_view_supplier invs
						 on		  invs.supplier_id = poh.supplier_id	
						 WHERE    poh.approved = 'Y'
                         AND      poh.complete = 'N'
						 and	  pol.complete = 'N'
                         AND      invl.stockable in ('Y', 'N') 
						 and      invl.location_id in ('1100','1110','1111','1120','1130','1160','1170','1200',					  '1210','1220','1260','1300','1310','1600','1700','1710','1800','1810','3500','3510','3520','3540')
						 AND      pol.item_id  = '07SQSSLABOUR'
                         GROUP BY poh.supplier_id,
								  invs.supplier_name,
								  invl.product_group_id,
								  poh.location_id,
                                  pol.item_id,
								  pol.unit_price,
								  pol.unit_size,
								  pol.unit_of_measure,
								  invl.stockable,
								  invl.inv_min,
								  invl.inv_max
								  ) s1
FULL OUTER JOIN
                (
                           SELECT 
								  sum(oel.qty_ordered - oel.qty_canceled - oel.qty_invoiced - oel.qty_on_pick_tickets) AS qty_open_so,
                                  oel.item_id,invl.inv_min,
								  invl.inv_max,
                                  oeh.location_id ,oel.unit_of_measure,invl.stockable
                         FROM     p21_view_oe_line oel
                         JOIN     p21_view_oe_hdr oeh
                         ON       oeh.order_no = oel.order_no
                         JOIN     p21_view_inv_loc invl
                         ON       invl.inv_mast_uid = oel.inv_mast_uid
                         AND      invl.location_id = oeh.location_id
                         WHERE    
						              oeh.completed = 'N'
							      AND oel.item_id  = '07SQSSLABOUR'
                                  and invl.stockable in ('Y', 'N')
                                  and oeh.cancel_flag = 'N'
                                  and oel.cancel_flag = 'N'
								  and oel.complete = 'N'
								  and oeh.projected_order = 'N'
								  and oel.qty_ordered > 0
								  and oel.disposition <> 'P'
								  and invl.location_id in ('1100','1110','1111','1120','1130','1160','1170','1200',					  '1210','1220','1260','1300','1310','1600','1700','1710','1800','1810','3500','3510','3520','3540')



                         GROUP BY oel.item_id,
                                  oeh.location_id,
								 oel.unit_of_measure,
								 invl.stockable,
								 invl.inv_min,
								  invl.inv_max
								  ) s2

                         ON              s1.location_id = s2.location_id
                         AND             s1.item_id = s2.item_id
						 AND             s1.qty_due_on_po IS NOT NULL
						 