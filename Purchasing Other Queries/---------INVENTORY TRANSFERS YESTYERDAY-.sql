---------INVENTORY TRANSFERS YESTYERDAY--------------

SELECT
      tv.[from_location_id]
      ,tv.[to_location_id]
      ,tv.[shipping_date]
      ,tv.[received_date]
      ,tv.[company_id]
      ,tv.[approved]
      ,tv.[transfer_date]
      ,tv.[year_for_period]
      ,tv.[period]
      ,tv.[item_id]
      ,tv.[inv_mast_uid]
      ,tv.[qty_to_transfer]
      ,tv.[qty_transferred]
      ,tv.[qty_received]
      ,tv.[delete_flag]
      ,tv.[date_created]
      ,tv.[date_last_modified]
      ,tv.[unit_of_measure]
      ,tv.[line_no]
      ,tv.[from_location_name]
      ,tv.[to_location_name]
      ,tv.[company_name]
      ,tv.[item_desc]

  FROM [P21].[dbo].[p21_transfer_view] tv
  
  where CAST(tv.transfer_date as DATE) = DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) 
                        WHEN 'Sunday' THEN -2 
                        WHEN 'Monday' THEN -3
                        ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))
