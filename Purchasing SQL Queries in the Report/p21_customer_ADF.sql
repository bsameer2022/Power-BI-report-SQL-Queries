SELECT DISTINCT
us.id,
us.name as Taker
FROM
p21_view_users us
JOIN p21_view_oe_hdr oeh on oeh.taker = us.id
WHERE
us.delete_flag = 'N' 