
select --quote_no,
oq.quote_number,
oq.Quote_value,
qv.location_id

from p21_quotation_view qv

left join p21_view_GetOpenQuotes oq
       on oq.quote_number = qv.order_no

where

-- in (select quote_number
-- from p21_view_GetOpenQuotes 

-- where 
oq.expiration_date < getdate()

and year(oq.expiration_date) = 2022

and qv.quote_flag = 'N'

group by qv.location_id

select quote_number, Quote_value from p21_view_GetOpenQuotes where expiration_date < getdate() 
and year(expiration_date) = 2022 


select quote_no,customer_id,location_id 
from p21_quotation_view where quote_no in
 (select quote_number,Quote_value from p21_view_GetOpenQuotes
where expiration_date < getdate() 
and year(expiration_date) = 2022   ) 
and quote_flag = 'N'

