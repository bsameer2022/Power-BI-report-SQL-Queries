select distinct cd.code_no,
                cd.code_description 
from p21_view_codes cd

where cd.code_description like '%sales order%'