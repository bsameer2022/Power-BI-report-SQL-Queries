--Developer Name: SAMEER BANDI
--Date of Initial Development: 06/27/2023 (as mm/dd/yyyy)
--Reason for Development: To create a dataset of current customer and status
select credit_limit,
credit_limit_used,
salesrep_id,
terms_account_no,
freight_account_no,
class_1id,
class_2id,
class_3id,
class_4id,
class_5id,
accept_partial_orders,
acceptable_wait_time,
price_file_id,
edi_or_paper,
interchg_receiver_id,
sic_code,
federal_exemption_number,
other_exemption_number,
state_excise_tax_exemption_no,
credit_status,
pick_ticket_type,
customer_name,
pricing_method_cd,
source_price_cd,
multiplier,
default_rebate_location_id,
pending_payment_account_no,
remit_to_address_id,
default_branch_id,
cust_part_no_group_hdr_uid,
date_acct_opened,
service_terms_id,
promise_date_buffer,
use_vendor_contracts_flag,
national_account_flag
 from p21_view_customer vc 
 where vc.delete_flag = 'N'