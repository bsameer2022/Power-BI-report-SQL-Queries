--Developer Name: SAMEER BANDI
--Date of Initial Development: 11/07/2022 (as mm/dd/yyyy)
--Reason for Development: To develop inactive inventory history  report



SELECT DISTINCT
ii.location_id
--,view_location.location_name
,ii.product_group_id
,ii.inv_mast_uid
,ii.item_id
,ii.item_desc
,ii.supplier_name
,ii.qty_on_hand
,ii.moving_average_cost
,ii.qty_on_hand * moving_average_cost as value_on_hand
,ii.value_on_hand
,ii.last_order_date
,ii.last_po_recived_date
,ii.last_transfer_in
,ii.last_transfer_out
,ii.last_usage
,ii.age_in_days
--,vendor_consigned
,ii.qty_allocated
,ii.qty_for_production
,ii.backup_date


from dbo.inactive_inv ii

where year(backup_date) in (2021,2022) 

order by backup_date