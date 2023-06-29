--Developer Name: SAMEER BANDI
--Date of Initial Development: 06/27/2023 (as mm/dd/yyyy)
--Reason for Development: To create a dataset of current product groups

select distinct
revenue_account_no,
cos_account_no,
parker_product_code,
landed_cost_account_no,
rma_revenue_account_no,
company_id,
product_group_id,
product_group_desc,
asset_account_no,
delete_flag,
date_created,
date_last_modified,
last_maintained_by,
product_group_uid

from p21_view_product_group pg
where delete_flag = 'N'

 