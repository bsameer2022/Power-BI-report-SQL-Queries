-------Developer Name: SAMEER BANDI
-------Date of Initial Development: 10/17/2022 (as mm/dd/yyyy)
-------Reason for Development: To develop a inventory transfers report

SELECT
      [from_location_id]
      ,[to_location_id]
      ,[shipping_date]
      ,[received_date]
      ,[company_id]
      ,[approved]
      ,[transfer_date]
      ,[year_for_period]
      ,[period]
      ,[item_id]
      ,[inv_mast_uid]
      ,[qty_to_transfer]
      ,[qty_transferred]
      ,[qty_received]
      ,[delete_flag]
      ,[date_created]
      ,[date_last_modified]
      ,[unit_of_measure]
      ,[line_no]
      ,[from_location_name]
      ,[to_location_name]
      ,[company_name]
      ,[item_desc]

  FROM [P21].[dbo].[p21_transfer_view]
  where transfer_date > (GETDATE() -1 )