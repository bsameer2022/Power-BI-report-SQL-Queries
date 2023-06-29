--Developer Name: SAMEER BANDI
--Date of Initial Development: 06/27/2023 (as mm/dd/yyyy)
--Reason for Development: To create a dataset of current ship to salesreps

SELECT DISTINCT
con.id
, con.first_name
, con.last_name
, con.email_address
FROM
p21_view_ship_to_salesrep ships
JOIN p21_view_contacts con on con.id = ships.salesrep_id
WHERE
con.delete_flag = 'N'