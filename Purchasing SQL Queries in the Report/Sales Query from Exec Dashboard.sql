
DECLARE @StartCorporateID DECIMAL = 0;
DECLARE @EndCorporateID DECIMAL = 99999999;
DECLARE @StartCustomer DECIMAL = 0;
DECLARE @EndCustomer DECIMAL = 99999999;
DECLARE @StartSupplierId DECIMAL = 0;
DECLARE @EndSupplierID DECIMAL = 99999999;
DECLARE @StartSalesRep DECIMAL = 0;
DECLARE @EndSalesRep DECIMAL = 99999999;
DECLARE @StartTaker VARCHAR(30) =' ' 
DECLARE @EndTaker VARCHAR(30) = 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
DECLARE @StartBranchId VARCHAR(8) =' ' 
DECLARE @EndBranchID VARCHAR(8) ='ZZZZZZZZ'
DECLARE @StartLocationId DECIMAL = 0 
DECLARE @EndLocationID DECIMAL = 99999999
DECLARE @StartShipToID DECIMAL = 0 
DECLARE @EndShipToID DECIMAL = 99999999
DECLARE @StartProductGroupID VARCHAR(8) = ' '
DECLARE @EndProductGroupID VARCHAR(8) = 'ZZZZZZZZ'
DECLARE @StartItemID VARCHAR(40) = ' ' 
DECLARE @EndItemID VARCHAR(40) = 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
DECLARE @BeginInvoiceDate DATETIME = getdate() - 365 --'1990-01-01';
--DECLARE @EndInvoiceDate DATETIME = year(getdate()) & '-' & Month(getdate()) & '-' & Day(getdate()) & ' 00:00:00'; --Year(CURRENT_TIMESTAMP) & '-' & MONTH(CURRENT_TIMESTAMP) & '-' & Day(CURRENT_TIMESTAMP) & ' 00:00:00'  --'2049-12-31 23:59:59'
DECLARE @EndInvoiceDate DATETIME = Concat(dateadd(day,0,cast(getdate() as date)) , ' 23:59:59');
DECLARE @year_end INT = YEAR(CURRENT_TIMESTAMP);
DECLARE @year_start INT = @year_end -1;



/**
Customer Classes
Value    =             Description
' '             =             Start Blank
'ZZZZZZZZ'           =             End Blank
'AFF'      =             Affiliate
'EMP'     =             Employee
'MOO'   =             Moore Customer
'N/A'      =             not applicable
'PET'       =             Petro Service
'RP'         =             Related Party
'SSS'       =             Soucie Salo Sudbury customer
'SST'       =             Soucie Salo Timmins Customer
'TRA'      =             Trade
'WABPRA'            =             Wabush Praxair
*/

DECLARE @StartClass1ID VARCHAR(8) = ' ' 
DECLARE @EndClass1ID VARCHAR(8) = 'ZZZZZZZZ'
DECLARE @StartClass2ID VARCHAR(8) = ' ' 
DECLARE @EndClass2ID VARCHAR(8) = 'ZZZZZZZZ'
DECLARE @StartClass3ID VARCHAR(8) = ' ' 
DECLARE @EndClass3ID VARCHAR(8) = 'ZZZZZZZZ'
DECLARE @StartClass4ID VARCHAR(8) = ' ' 
DECLARE @EndClass4ID VARCHAR(8) = 'ZZZZZZZZ'
DECLARE @StartClass5ID VARCHAR(8) = ' ' 
DECLARE @EndClass5ID VARCHAR(8) = 'ZZZZZZZZ'

DECLARE @StartPeriod INT = 1 
DECLARE @EndPeriod INT = 12 
DECLARE @StartYear INT = 1990 
DECLARE @EndYear INT = 2049

/**
'Y'            =             Yes
'N'           =             No
*/
DECLARE @ForeignCurrencyEnabled CHAR(1) ='Y'
DECLARE @StartCurrencyId INT = 0 
DECLARE @EndCurrencyID INT = 99999999

/**
'Y'            =             Yes
'N'           =             No
'O'           =             Only
*/
DECLARE @IncludeNonStock CHAR(1) = 'Y'

/**
'Y'            =             Yes
'N'           =             No
'O'           =             Only
*/
DECLARE @ShowAssemblyComponents CHAR(1) = 'N'

/**
Cost Basis
'CC'         =             Commission Cost
'OC'        =             Other Cost
'IC'          =             Inventory Cost
*/
DECLARE @CostBasis CHAR(2) = 'IC'

/**
'B'           =             Both
'C'           =             Include Credit Memos
'D'           =             Include Debit Memos
'N'           =             None
*/
DECLARE @IncludeCreditAndDebitMemos CHAR(1) = 'N';

/**
'Y'            =             Yes
'N'           =             No
*/
DECLARE @IncludeOtherChargeItems CHAR(1) = 'Y'

/**
Show Cost
*/

/**
Show Profit $
*/

/**
Show Profit %
*/

/**
All Vendor Items
'N'
'Y'
'O'
*/

/**
'Y'
'N'
*/
DECLARE @ContractPricingEnabled CHAR(1) = 'Y'
DECLARE @BegContractNumber VARCHAR(24) = ' '  
DECLARE @EndContractNumber VARCHAR(24) = 'ZZZZZZZZZZZZZZZZZZZZZZZZ'

/**
Limit By Territory
'Y'
'N'
'O'
*/

--DECLARE @TerritoryID
--DECLARE @TerritoryLimitAffects

/**
Consignment Usage Order
'Yes'
'No'
'Only'
*/
DECLARE @ConsignmentUsageOrder VARCHAR(4) = 'Yes'

/**
Use Dealer Commission Cost
'Y'
'N'
*/
DECLARE @UseDealerCommissionCost CHAR(1) = 'N'

/**
'Y'
'N'
'O'
*/
DECLARE @IncludeServiceOrders CHAR(1) = 'N'

/**
'Y'
'N'
'O'
*/
DECLARE @ShowServicePartsLabor  CHAR(1) = 'N' 

/**
'Y'
'N'
'O'
*/
DECLARE @IncludeVendorConsigned CHAR(1) = 'N'


DECLARE @UseInvoiceNumberPrefixes CHAR(1) = 'N';
DECLARE @BeginInvNoDisplay VARCHAR(10)= ' '  ;
DECLARE @EndInvNoDisplay VARCHAR(10) = 'ZZZZZZZZZZ';

DECLARE @UseRevisionTracking CHAR(1) = 'N';
DECLARE @BegRevisionLevel VARCHAR(9) = ' ' ;
DECLARE @EndRevisionLevel VARCHAR(9) = 'ZZZZZZZZZ';

/**
'Y'
'N'
'O'
*/
DECLARE @ShowProgressBillings CHAR(1) = 'N'

/**
'Y'
'N'
'O'
*/
DECLARE @ShowManufacturerRepOrders CHAR(1) = 'N'

/** Computed */
DECLARE @StartYearAndPeriod INT = (@StartYear * 100) + @StartPeriod
DECLARE @EndYearAndPeriod INT = (@EndYear * 100) + @EndPeriod

SELECT 
year_for_period AS YEAR,
Period,
branch_id As 'Branch ID',
branch_description 'Branch Name',
p21_sales_history_report_view.item_id As 'Item ID',
p21_sales_history_report_view.location_name,
p21_sales_history_report_view.ship_to_id AS 'Ship to ID',
ship2_name as 'Ship to Name',
contract_no as 'Contact No',
Supplier_ID as 'Supplier ID',
Supplier_Name as 'Supplier Name',
corpaddr.corp_address_id AS 'Corporate ID',
corpaddr.name AS 'Corporate Name',
p21_sales_history_report_view.customer_id as 'Customer ID',
p21_sales_history_report_view.customer_name as 'Customer Name',
product_group_id as 'Product_Group_Code',
--p21_sales_history_report_view.class_5id AS 'Ship To Type ID', --ShipTo Type (ShipTo Class 5 Description)
ship2_class.class_description AS 'Ship To Type',
--customer.class_1id 'Customer Tier ID', --Customer Tier (Customer Class 1 Description)
cust_class.class_description AS 'Customer Tier',
customer.salesrep_id as 'salesrep_name',
--rep.first_name AS salesrep_First_Name,
--rep.last_name AS salesrep_last_name,
invoice_date as 'Invoice Date'

               -- customer_info
                --, order_no
                , CASE 
                                WHEN @ShowServicePartsLabor = 'Y' AND invoice_line_type = 0 AND order_type = 1706 THEN 0
                                WHEN @ShowServicePartsLabor = 'N' AND invoice_line_type = 0 AND order_type= 1706 THEN sales_price_home
                                WHEN invoice_line_type IN (981, 982, 1719, 1577) THEN sales_price_home
                                ELSE assembly_sales_price_home
                END AS 'Sale'
   , CASE
                                WHEN order_type = 1706 THEN
                                                (
                                                CASE 
                                                                WHEN invoice_line_type IN (1719, 1577) THEN
                                                                                (
                                                                                                CASE
                                                                                                                WHEN @ShowServicePartsLabor = 'Y' THEN 
                                                                                                                                (
                                                                                                                                                CASE
                                                                                                                                                                WHEN @CostBasis = 'IC' THEN cogs_amount_home
                                                                                                                                                                WHEN @CostBasis = 'OC' THEN line_other_cost_home
                                                                                                                                                                WHEN @CostBasis = 'CC' THEN line_commission_cost_home
                                                                                                                                                                ELSE 0
                                                                                                                                                END
                                                                                                                                ) 
                                                                                                                ELSE 0
                                                                                                END
                                                                                )
                                                                WHEN invoice_line_type = 0 THEN
                                                                                (
                                                                                                CASE
                                                                                                                WHEN @ShowServicePartsLabor = 'N' THEN 
                                                                                                                (
                                                                                                                                CASE
                                                                                                                                                WHEN @CostBasis = 'IC' THEN sum_cogs_home
                                                                                                                                                WHEN @CostBasis = 'OC' THEN sum_other_cost_home
                                                                                                                                                WHEN @CostBasis = 'CC' THEN sum_cmsn_cost_home
                                                                                                                                                ELSE 0
                                                                                                                                END
                                                                                                                )
                                                                                                                ELSE 0
                                                                                                END
                                                                                )
                                                                ELSE 0
                                                END
                                                )      
                                ELSE
                                                -- 7/15/09 - JAB - Scopus #688801 - Total Component Cost when selecting Components Only
                                                (
                                                CASE 
                                                                WHEN @ShowAssemblyComponents = 'O' THEN 
                                                                (
                                                                                
                                                                                CASE    
                                                                                                WHEN @CostBasis = 'IC' THEN
                                                                                                                (
                                                                                                                                CASE 
                                                                                                                                                WHEN invoice_line_type = 0 THEN assembly_cogs_amt_home
                                                                                                                                                WHEN invoice_line_type IN (981,982,1577,1719) THEN cogs_amount_home
                                                                                                                                                ELSE 0
                                                                                                                                END
                                                                                                                )
                                                                                                WHEN @CostBasis = 'OC' THEN line_other_cost_home
                                                                                                WHEN @CostBasis = 'CC'  THEN line_commission_cost_home
                                                                                                ELSE 0
                                                                                END

                                                                )
                                                                ELSE 
                                                                (
                                                                                CASE 
                                                                                                WHEN @CostBasis = 'IC' THEN assembly_cogs_amt_home
                                                                                                WHEN @CostBasis = 'OC' THEN assembly_other_cost_home
                                                                                                WHEN @CostBasis = 'CC' THEN assembly_commission_cost_home
                                                                                                ELSE 0
                                                                                END
                                                    )
                                                END
                                                )
                END AS 'Cost',
                                                                CASE 
                                WHEN @ShowServicePartsLabor = 'Y' AND invoice_line_type = 0 AND order_type = 1706 THEN 0
                                WHEN @ShowServicePartsLabor = 'N' AND invoice_line_type = 0 AND order_type= 1706 THEN sales_price_home
                                WHEN invoice_line_type IN (981, 982, 1719, 1577) THEN sales_price_home
                                ELSE assembly_sales_price_home
                END
                                                                -
                                                                CASE
                                WHEN order_type = 1706 THEN
                                                (
                                                CASE 
                                                                WHEN invoice_line_type IN (1719, 1577) THEN
                                                                                (
                                                                                                CASE
                                                                                                                WHEN @ShowServicePartsLabor = 'Y' THEN 
                                                                                                                                (
                                                                                                                                                CASE
                                                                                                                                                                WHEN @CostBasis = 'IC' THEN cogs_amount_home
                                                                                                                                                                WHEN @CostBasis = 'OC' THEN line_other_cost_home
                                                                                                                                                                WHEN @CostBasis = 'CC' THEN line_commission_cost_home
                                                                                                                                                                ELSE 0
                                                                                                                                                END
                                                                                                                                ) 
                                                                                                                ELSE 0
                                                                                                END
                                                                                )
                                                                WHEN invoice_line_type = 0 THEN
                                                                                (
                                                                                                CASE
                                                                                                                WHEN @ShowServicePartsLabor = 'N' THEN 
                                                                                                                (
                                                                                                                                CASE
                                                                                                                                                WHEN @CostBasis = 'IC' THEN sum_cogs_home
                                                                                                                                                WHEN @CostBasis = 'OC' THEN sum_other_cost_home
                                                                                                                                                WHEN @CostBasis = 'CC' THEN sum_cmsn_cost_home
                                                                                                                                                ELSE 0
                                                                                                                                END
                                                                                                                )
                                                                                                                ELSE 0
                                                                                                END
                                                                                )
                                                                ELSE 0
                                                END
                                                )      
                                ELSE
                                                -- 7/15/09 - JAB - Scopus #688801 - Total Component Cost when selecting Components Only
                                                (
                                                CASE 
                                                                WHEN @ShowAssemblyComponents = 'O' THEN 
                                                                (
                                                                                
                                                                                CASE    
                                                                                                WHEN @CostBasis = 'IC' THEN
                                                                                                                (
                                                                                                                                CASE 
                                                                                                                                                WHEN invoice_line_type = 0 THEN assembly_cogs_amt_home
                                                                                                                                                WHEN invoice_line_type IN (981,982,1577,1719) THEN cogs_amount_home
                                                                                                                                                ELSE 0
                                                                                                                                END
                                                                                                                )
                                                                                                WHEN @CostBasis = 'OC' THEN line_other_cost_home
                                                                                                WHEN @CostBasis = 'CC'  THEN line_commission_cost_home
                                                                                                ELSE 0
                                                                                END

                                                                )
                                                                ELSE 
                                                                (
                                                                                CASE 
                                                                                                WHEN @CostBasis = 'IC' THEN assembly_cogs_amt_home
                                                                                                WHEN @CostBasis = 'OC' THEN assembly_other_cost_home
                                                                                                WHEN @CostBasis = 'CC' THEN assembly_commission_cost_home
                                                                                                ELSE 0
                                                                                END
                                                    )
                                                END
                                                )
                END
                                                                as profit
FROM 
                p21_sales_history_report_view 
                INNER JOIN P21_view_customer customer ON customer.customer_id=p21_sales_history_report_view.customer_id AND customer.company_id=p21_sales_history_report_view.company_id
                INNER JOIN p21_view_address address ON address.id=customer.customer_id
                INNER JOIN p21_view_address corpaddr ON corpaddr.id=address.corp_address_id
                                LEFT OUTER JOIN p21_view_ship_to st ON st.ship_to_id = p21_sales_history_report_view.ship_to_id and p21_sales_history_report_view.company_id = st.company_id
                LEFT OUTER JOIN p21_view_contacts rep ON rep.id=p21_sales_history_report_view.salesrep_id
                LEFT OUTER JOIN p21_view_class ship2_class ON ship2_class.class_id= st.class5_id AND ship2_class.delete_flag <> 'Y' AND ship2_class.class_type='CS' AND ship2_class.class_number=5 --ShipTo Type (ShipTo Class 5 Description)
                LEFT OUTER JOIN p21_view_class cust_class ON cust_class.class_id=customer.class_1id  AND cust_class.delete_flag <> 'Y' AND cust_class.class_type='CS' AND cust_class.class_number=1 -- 'Customer Class 1', --Customer Tier (Customer Class 1 Description)

WHERE 
                1=(
                                CASE 
                                                WHEN @UseInvoiceNumberPrefixes = 'N' THEN 1
                                                ELSE (
                                                                CASE 
                                                                                WHEN (@BeginInvNoDisplay= ' '  AND @EndInvNoDisplay = 'ZZZZZZZZZZ') THEN 1
                                                                                WHEN (p21_sales_history_report_view.inv_no_display >= @BeginInvNoDisplay AND p21_sales_history_report_view.inv_no_display <= @EndInvNoDisplay) THEN 1
                                                                                ELSE 0
                                                                END
                                                )
                                END
                ) 
                AND
                (
                                @ConsignmentUsageOrder = 'Yes' 
                                OR (@ConsignmentUsageOrder = 'No' AND p21_sales_history_report_view.consignment_flag = 'N')
                                OR (@ConsignmentUsageOrder = 'Only' AND p21_sales_history_report_view.consignment_flag = 'Y')
                ) 
                AND
                1=(
                                CASE 
                                                WHEN @UseRevisionTracking ='N' THEN 1
                                                ELSE 
                                                                CASE 
                                                                                WHEN @BegRevisionLevel = ' ' AND @EndRevisionLevel = 'ZZZZZZZZZ' THEN 1
                                                                                WHEN (p21_sales_history_report_view.revision_level>=@BegRevisionLevel AND p21_sales_history_report_view.revision_level<=@EndRevisionLevel) THEN 1
                                                                                ELSE 0
                                                                END
                                END    
                ) 
                AND
                (
                                (p21_sales_history_report_view.detail_type IS NULL)
                                OR p21_sales_history_report_view.detail_type = 0 
                                OR (p21_sales_history_report_view.detail_type IN (0,1,2) AND @ShowAssemblyComponents IN ('Y','O'))
                ) 
                AND p21_sales_history_report_view.projected_order = 'N' 
                AND 1=(
                                CASE
                                                WHEN @IncludeVendorConsigned = 'Y' THEN 1
                                                WHEN @IncludeVendorConsigned = 'N' AND (p21_sales_history_report_view.vendor_consigned = 'N') THEN 1
                                                WHEN @IncludeVendorConsigned = 'O' AND (p21_sales_history_report_view.vendor_consigned = 'Y') THEN 1
                                                ELSE 0
                                END
                )
                AND 1=(   
                                CASE 
                                                WHEN @IncludeNonStock = 'Y' THEN 1
                                                WHEN @IncludeNonStock = 'N' AND p21_sales_history_report_view.stockable = 'Y' THEN 1
                                                WHEN @IncludeNonStock = 'O' AND p21_sales_history_report_view.stockable = 'N' THEN 1
                                                ELSE 0
                                END
                )
                AND 1=(
                                CASE 
                                                WHEN @StartClass5ID=' ' AND @EndClass5ID='ZZZZZZZZ' THEN 1
                                                WHEN
                                                                (
                                                                                -- Scopus #664282 - JAB - 7/24/09 - Change formula to exclude records with an N/A type.  Code is never NULL.
                                                                                --    IsNull(p21_sales_history_report_view.class_5id) OR
                                                                                p21_sales_history_report_view.class_5id <> 'N/A' AND (p21_sales_history_report_view.class_5id >= @StartClass5ID AND p21_sales_history_report_view.class_5id <= @EndClass5ID)
                                                                ) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1 = (
                                CASE 
                                                WHEN @StartClass4ID=' ' AND @EndClass4ID='ZZZZZZZZ' THEN 1
                                                WHEN
                                                                (
                                                                                -- Scopus #664282 - JAB - 7/24/09 - Change formula to exclude records with an N/A type.  Code is never NULL.
                                                                                --    IsNull(p21_sales_history_report_view.class_4id) OR
                                                                                p21_sales_history_report_view.class_4id <> 'N/A' AND (p21_sales_history_report_view.class_4id >= @StartClass4ID AND p21_sales_history_report_view.class_4id <= @EndClass4ID)
                                                                ) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN @StartClass3ID=' ' AND @EndClass3ID='ZZZZZZZZ' THEN 1
                                                WHEN
                                                                (
                                                                                -- Scopus #664282 - JAB - 7/24/09 - Change formula to exclude records with an N/A type.  Code is never NULL.
                                                                                --    IsNull(p21_sales_history_report_view.class_3id) OR
                                                                                p21_sales_history_report_view.class_3id <> 'N/A' AND (p21_sales_history_report_view.class_3id >= @StartClass3ID AND p21_sales_history_report_view.class_3id <= @EndClass3ID)
                                                                ) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN @StartClass2ID=' ' AND @EndClass2ID='ZZZZZZZZ' THEN 1
                                                WHEN
                                                                (
                                                                                -- Scopus #664282 - JAB - 7/24/09 - Change formula to exclude records with an N/A type.  Code is never NULL.
                                                                                --    IsNull(p21_sales_history_report_view.class_2id) OR
                                                                                p21_sales_history_report_view.class_2id <> 'N/A' AND (p21_sales_history_report_view.class_2id >= @StartClass2ID AND p21_sales_history_report_view.class_2id <= @EndClass2ID)
                                                                ) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN @StartClass1ID=' ' AND @EndClass1ID='ZZZZZZZZ' THEN 1
                                                WHEN
                                                                (
                                                                                -- Scopus #664282 - JAB - 7/24/09 - Change formula to exclude records with an N/A type.  Code is never NULL.
                                                                                --    IsNull(p21_sales_history_report_view.class_1id) OR
                                                                                p21_sales_history_report_view.class_1id <> 'N/A' AND (p21_sales_history_report_view.class_1id >= @StartClass1ID AND p21_sales_history_report_view.class_1id <= @EndClass1ID)
                                                                ) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE
                                                WHEN (@StartCorporateID = 0 and @EndCorporateID = 99999999) THEN 1
                                                WHEN (p21_sales_history_report_view.corp_address_id IS NULL) OR (p21_sales_history_report_view.corp_address_id >= @StartCorporateID AND p21_sales_history_report_view.corp_address_id <= @EndCorporateID)  THEN 1
                                                ELSE 0
                                END
   )
   --AND p21_sales_history_report_view.company_id = @CompanyID 
   AND 1=(
                                CASE
                                                WHEN @ShowProgressBillings='Y' THEN 1
                                                WHEN @ShowProgressBillings='N' AND (p21_sales_history_report_view.progress_bill_flag='N' or (p21_sales_history_report_view.progress_bill_flag IS NULL)) THEN 1
                                                WHEN @ShowProgressBillings='O' AND (p21_sales_history_report_view.progress_bill_flag='Y') THEN 1
                                                ELSE 0
                                END
                ) 
                AND ( 
                                (@ShowAssemblyComponents = 'Y' AND p21_sales_history_report_view.invoice_line_type IN (0, 981, 982, 1577, 1719, 1918, 4))
                                OR (@ShowAssemblyComponents = 'N' AND (p21_sales_history_report_view.invoice_line_type <> 981 OR p21_sales_history_report_view.invoice_line_type <> 982) )
                                OR (@ShowAssemblyComponents = 'O' AND p21_sales_history_report_view.invoice_line_type IN (981, 982))
                ) 
                AND 1=(
                                CASE 
                                                WHEN @ShowServicePartsLabor= 'Y' THEN 1
                                                WHEN @ShowServicePartsLabor= 'N' AND  (p21_sales_history_report_view.invoice_line_type <> 1719 AND  p21_sales_history_report_view.invoice_line_type <> 1577) THEN 1
                                                WHEN @ShowServicePartsLabor= 'O' AND  (p21_sales_history_report_view.invoice_line_type IN (1577, 1719)) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE
                                                WHEN @IncludeServiceOrders = 'Y' THEN 1
                                                WHEN @IncludeServiceOrders = 'N' AND (p21_sales_history_report_view.order_type<>1706) THEN 1
                                                WHEN @IncludeServiceOrders = 'O' AND (p21_sales_history_report_view.order_type =1706) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN @ShowManufacturerRepOrders = 'Y' THEN 1
                                                --12.12 JC 03/18/13 - Scopus#1127398 - Account for Consigned MRO order type/code=3056
                                                --WHEN @ShowManufacturerRepOrders = 'N' THEN (IsNull(p21_sales_history_report_view.order_type) OR p21_sales_history_report_view.order_type<> 1877)
                                                --12.12.1065 (Main) JC 04/22/13 - Scopus#1136970/1137378 - Correct issues with MRO's not being excluded when MRO parameter is set to "N" (Exclude MRO's).
                                                --Before 04/22/13 Change:
                                                --WHEN @ShowManufacturerRepOrders = 'N' THEN (IsNull(p21_sales_history_report_view.order_type) OR p21_sales_history_report_view.order_type<> 1877 OR p21_sales_history_report_view.order_type<> 3056)
                                                --After 04/22/13 Change:
                                                WHEN @ShowManufacturerRepOrders = 'N' AND ((p21_sales_history_report_view.order_type IS NULL) OR (p21_sales_history_report_view.order_type <> 1877 AND p21_sales_history_report_view.order_type <>  3056)) THEN 1
                                                --WHEN @ShowManufacturerRepOrders = 'O' THEN (p21_sales_history_report_view.order_type=1877)
                                                --12.12.1070 (Main) JC 04/26/13 - Scopus#1136970/1137378 - Streamline option for "O"nly MRO orders
                                                --Before 04/26/13
                                                --WHEN @ShowManufacturerRepOrders = 'O' THEN (p21_sales_history_report_view.order_type IN (1877, 3056))
                                                --AFTER
                                                WHEN @ShowManufacturerRepOrders = 'O' AND (p21_sales_history_report_view.order_type IN (1877, 3056)) THEN 1 --which means include in the report
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN @ContractPricingEnabled = 'N' THEN 1
                                                WHEN @BegContractNumber= ' '  AND @EndContractNumber = 'ZZZZZZZZZZZZZZZZZZZZZZZZ' THEN 1
                                                WHEN (p21_sales_history_report_view.contract_no >= @BegContractNumber AND p21_sales_history_report_view.contract_no <= @EndContractNumber) THEN 1
                                                ELSE 0
                                END
                )
                AND 1=(
                                --12/30/08-Always include Rebill Credits
                                --Pil 04/07/09-DT#1048182 - Change p21_view_sales_history_report_view.record_type_cd to 2638 (Rebill credits) instead of 2594 (Rebill Invoice)
                                --Pil 04/24/09-JC-DT#1048182 - We should be looking at invoice_hdr.source_type_cd rather than record_type_cd
                                --OLD - Prior to 4/24/09 CASE WHEN (p21_sales_history_report_view.invoice_adjustment_type='C' and p21_sales_history_report_view.record_type_cd=2638) THEN true
                                CASE 
                                                WHEN (p21_sales_history_report_view.invoice_adjustment_type='C' and p21_sales_history_report_view.source_type_cd=2638) THEN 1
                                                WHEN @IncludeCreditAndDebitMemos = 'B' THEN 1
                                                WHEN @IncludeCreditAndDebitMemos = 'C' 
                                                                AND ((p21_sales_history_report_view.invoice_adjustment_type = 'C' OR p21_sales_history_report_view.invoice_adjustment_type<> 'D') AND p21_sales_history_report_view.rma_flag IN ('Y','N')) 
                                                                THEN 1
                                                WHEN @IncludeCreditAndDebitMemos = 'D' 
                                                                AND ((p21_sales_history_report_view.invoice_adjustment_type = 'D' OR p21_sales_history_report_view.invoice_adjustment_type<> 'C') AND p21_sales_history_report_view.rma_flag IN ('Y','N')) 
                                                                THEN 1
                                                WHEN @IncludeCreditAndDebitMemos = 'N' AND (p21_sales_history_report_view.invoice_adjustment_type <> 'C' AND p21_sales_history_report_view.invoice_adjustment_type <> 'D') THEN 1
                                                ELSE 0
                                END 
                )
                AND 1=(
                                CASE 
                                                WHEN @StartPeriod= 1 AND @EndPeriod= 12 AND @StartYear= 1990 AND @EndYear= 2049 THEN 1
                                                WHEN (p21_sales_history_report_view.year_and_period >= @StartYearAndPeriod AND p21_sales_history_report_view.year_and_period <= @EndYearAndPeriod) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN @ForeignCurrencyEnabled ='N' THEN 1
                                                WHEN @StartCurrencyId = 0 AND @EndCurrencyID = 99999999 THEN 1
                                                WHEN (p21_sales_history_report_view.currency_id>=@StartCurrencyId AND p21_sales_history_report_view.currency_id<=@EndCurrencyID) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN @IncludeOtherChargeItems = 'Y' THEN 1
                                                WHEN (p21_sales_history_report_view.other_charge_item = 'N') THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN @StartTaker=' ' AND @EndTaker='ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ' THEN 1
                                                WHEN (p21_sales_history_report_view.taker >= @StartTaker AND p21_sales_history_report_view.taker <= @EndTaker) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN @StartSalesRep='0' AND @EndSalesRep='99999999' THEN 1
                                                WHEN (p21_sales_history_report_view.salesrep_id >= @StartSalesRep AND p21_sales_history_report_view.salesrep_id <= @EndSalesRep) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN @StartLocationId = 0 and @EndLocationID = 99999999 THEN 1
                                                WHEN ( p21_sales_history_report_view.sales_location_id >= @StartLocationId AND p21_sales_history_report_view.sales_location_id <= @EndLocationID) THEN 1
                                                ELSE 0
                                END
                )
                AND 1=(
                                CASE 
                                                WHEN @StartProductGroupID = ' ' and @EndProductGroupID = 'ZZZZZZZZ' THEN 1
                                                WHEN (p21_sales_history_report_view.invoice_line_type = 1577) 
                                                                OR (p21_sales_history_report_view.product_group_id >= @StartProductGroupID AND p21_sales_history_report_view.product_group_id <= @EndProductGroupID) 
                                                                THEN 1
                                                ELSE 0
                                END  
                ) 
                AND 1=(
                                CASE 
                                                WHEN @StartCustomer = 0 and @EndCustomer = 99999999 THEN 1
                                                WHEN ( p21_sales_history_report_view.customer_id >= @StartCustomer AND p21_sales_history_report_view.customer_id <= @EndCustomer ) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE
                                                WHEN @StartBranchId=' ' AND @EndBranchID='ZZZZZZZZ' THEN 1
                                                WHEN (p21_sales_history_report_view.branch_id >= @StartBranchId AND p21_sales_history_report_view.branch_id <= @EndBranchID) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN @BeginInvoiceDate = '2022-01-01' AND @EndInvoiceDate = '2049-12-31 23:59:59' THEN 1
                                                WHEN (p21_sales_history_report_view.invoice_date <= @EndInvoiceDate   AND p21_sales_history_report_view.invoice_date >= @BeginInvoiceDate) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE
                                                WHEN @StartItemID = ' ' and @EndItemID = 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ' THEN 1
                                                WHEN (p21_sales_history_report_view.item_id >= @StartItemID AND p21_sales_history_report_view.item_id <= @EndItemID) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN @StartShipToID = 0 and @EndShipToID =  99999999 THEN 1
                                                WHEN ( p21_sales_history_report_view.ship_to_id >= @StartShipToID  AND p21_sales_history_report_view.ship_to_id <= @EndShipToID ) THEN 1
                                                ELSE 0
                                END
                ) 
                AND 1=(
                                CASE 
                                                WHEN (p21_sales_history_report_view.labor_system_setting = 'Y') THEN
                                                                (
                                                                                CASE 
                                                                                                WHEN @StartSupplierId = 0 and @EndSupplierID = 99999999 THEN 1
                                                                                                WHEN @StartSupplierId = 0 
                                                                                                                AND ((p21_sales_history_report_view.supplier_id IS NULL) 
                                                                                                                OR (p21_sales_history_report_view.invoice_line_type = 1577 AND p21_sales_history_report_view.supplier_id = 0) 
                                                                                                                OR (p21_sales_history_report_view.supplier_id >= @StartSupplierId AND  p21_sales_history_report_view.supplier_id <= @EndSupplierID)) 
                                                                                                                THEN 1
                                                                                                ELSE 0
                                                                                END
                                                                )
                                                WHEN (p21_sales_history_report_view.supplier_id >= @StartSupplierId AND  p21_sales_history_report_view.supplier_id <= @EndSupplierID) THEN 1
                                                ELSE
                                                                (
                                                                                CASE 
                                                                                                WHEN @StartSupplierId = 0 and @EndSupplierID = 99999999 THEN 1
                                                                                                WHEN
                                                                                                                (
                                                                                                                                (p21_sales_history_report_view.supplier_id IS NULL) 
                                                                                                                                OR (p21_sales_history_report_view.invoice_line_type = 1577 AND p21_sales_history_report_view.supplier_id = 0) 
                                                                                                                                OR (p21_sales_history_report_view.supplier_id >= @StartSupplierId AND  p21_sales_history_report_view.supplier_id <= @EndSupplierID)
                                                                                                                ) THEN 1
                                                                                                ELSE 0
                                                                                END
                                                                )
                                END
                )

AND branch_id in (1100,1110,1111,1120,1130,1140,1150,1160,1170,1200,1210,1220,1230,1240,1250,1260,1300,1310,1600,1601,1700,1701,1710,1711,1800,1801,1810,1811,3500,3510,3520,3540,4500,5250,8000)
and p21_sales_history_report_view.company_id in (01,03)
AND invoice_class<>'M'



