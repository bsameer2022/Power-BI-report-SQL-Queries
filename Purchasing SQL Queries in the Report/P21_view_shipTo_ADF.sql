--Developer Name: SAMEER BANDI
--Date of Initial Development: 06/27/2023 (as mm/dd/yyyy)
--Reason for Development: To create a dataset of current ship to locations

select 
company_id,
ship_to_id,
customer_id,
default_branch,
accept_partial_orders,
date_created,
date_last_modified,
last_maintained_by,
delete_flag,
federal_exemption_number,
state_exemption_number,
other_exemption_number,
preferred_location_id,
default_ship_time,
default_carrier_id,
delivery_instructions,
acceptable_wait_time,
class1_id,
class2_id,
class3_id,
class4_id,
class5_id,
packing_basis,
terms_id,
invoice_type,
state_excise_tax_exemption_no,
pick_ticket_type,
tax_group_id,
days_early,
days_late,
transit_days,
freight_code_uid,
shipping_route_uid

from p21_view_ship_to
where delete_flag = 'N'




