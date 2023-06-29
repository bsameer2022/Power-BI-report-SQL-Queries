select top 10 * from  [dbo].[p21_view_po_hdr]

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '[po_hdr]'

SELECT name
FROM sys.columns
WHERE object_id = OBJECT_ID('po_line')