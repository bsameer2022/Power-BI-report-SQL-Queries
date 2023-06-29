--Developer Name: SAMEER BANDI
--Date of Initial Development: 06/27/2023 (as mm/dd/yyyy)
--Reason for Development: To create a dataset of current customer taker
SELECT DISTINCT
us.id,
us.name as Taker
FROM
p21_view_users us
JOIN p21_view_oe_hdr oeh on oeh.taker = us.id
WHERE
us.delete_flag = 'N' 