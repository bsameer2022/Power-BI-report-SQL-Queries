create view Inventory_Loc2023
AS
SELECT
   *
   FROM
    OPENROWSET(
        BULK 'https://dadevstoragesource.blob.core.windows.net/sourcep21/Inventory/Inventory_Loc/year=2023/month=*/Day=*/*.parquet',
        FORMAT = 'PARQUET'
    ) 
    WITH (
            company_id varchar(8),
            location_id decimal(19) ,
            item_id varchar(40),
            item_desc varchar(40),
            product_group_id varchar(8),
            inv_mast_uid int ,
            primary_supplier_id decimal(19,0),
            qty_on_hand decimal(19,9),
            qty_allocated decimal(19,9),
            date_created varchar(40),
            date_last_modified varchar(40),
            last_rec_po decimal(19,9),
            gl_account_no varchar(32),
            next_due_in_po_cost decimal(19,9),
            next_due_in_po_date varchar(40),
            revenue_account_no varchar(32),
            cos_account_no varchar(32),
            sellable char(1),
            protected_stock_qty decimal(19,9),
            inv_min decimal(19,9),
            inv_max decimal(19,9),
            safety_stock decimal(19,9),
            stockable char(1),
            replenishment_location decimal(19,0),
            average_monthly_usage decimal(2,0),
            price1 decimal(19,9),
            price2 decimal(19,9),
            price3 decimal(19,9),
            price4 decimal(19,9),
            price5 decimal(19,9),
            price6 decimal(19,9),
            price7 decimal(19,9),
            price8 decimal(19,9),
            price9 decimal(19,9),
            price10 decimal(19,9),
            replenishment_method varchar(8),
            qty_backordered decimal(19,9),
            qty_in_transit decimal(19,9),
            track_bins char(1),
            primary_bin varchar(10),
            date_last_counted varchar(40),
            requisition char(1),
            on_backorder_flag char(1),
            buy char(1),
            make char(1),
            discontinued char(1),
            demand_pattern_cd int ,
            demand_pattern_evaluation_date varchar(40),
            demand_forecast_formula_uid int,
            demand_pattern_behavior_cd int,
            price_family_uid int,
            delete_flag char(1),
            TodaysDate varchar(40)
    )
AS [result]

-- drop view Inventory_Loc2023

-- select top 10 * from InventoryLocevery2days
-- order by backup_date1 desc


-- CREATE VIEW InventoryLocevery2days
-- 	AS SELECT *, Cast(TodaysDate as date) backup_date1 FROM Inventory_Loc2023
-- WHERE
-- CAST(TodaysDate as DATE) >= DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE())       
--                    WHEN 'Sunday' THEN -2 
--                    WHEN 'Monday' THEN -3   
--                    ELSE -1 END, DATEADD(DAY, -1, GETDATE()))
-- and 
-- Cast(Todaysdate as DATE)  <= GETDATE()





