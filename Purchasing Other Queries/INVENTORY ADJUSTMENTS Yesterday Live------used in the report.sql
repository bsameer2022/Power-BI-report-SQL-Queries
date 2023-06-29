-----   --INVENTORY ADJUSTMENTS Yesterday----
-------Developer Name: SAMEER BANDI
-------Date of Initial Development: 10/17/2022 (as mm/dd/yyyy)
-------Reason for Development: To develop a inventory adjustments report
SELECT iah.adjustment_number
      ,iah.location_id
      ,iah.inv_adj_description
      ,iah.reason_id
      ,ial.cost
      ,ial.item_id
      ,ial.line_number
      ,ial.quantity
      ,ial.vendor_id
      ,iah.reason_id
      ,iar.reason
      ,iah.date_last_modified


  FROM [P21].[dbo].[p21_view_inv_adj_hdr] iah
  left join  [P21].[dbo].[p21_view_inv_adj_line] ial
  on  ial.adjustment_number = iah.adjustment_number
  left join [P21].[dbo].[p21_view_reason] iar
  on iah.reason_id = iar.id
  

  where CAST(iah.date_last_modified as DATE) = DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) 
                        WHEN 'Sunday' THEN -2 
                        WHEN 'Monday' THEN -3
                        ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))