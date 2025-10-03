/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze) with Commit/Rollback
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Wraps the load process in a single transaction.
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from CSV files to bronze tables.
    - Commits transaction if successful, otherwise rolls back.
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, 
            @end_time DATETIME, 
            @batch_start_time DATETIME, 
            @batch_end_time DATETIME; 

    BEGIN TRY
        BEGIN TRAN;   -- ✅ Start transaction

        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------';

        -- 1. Customer Info
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> crm_cust_info Loaded in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec';

        -- 2. Product Info
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_prd_info;
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> crm_prd_info Loaded in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec';

        -- 3. Sales Details
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> crm_sales_details Loaded in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec';

        PRINT '------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------------';

        -- 4. Location
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_loc_a101;
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> erp_loc_a101 Loaded in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec';

        -- 5. Customer
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_cust_az12;
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> erp_cust_az12 Loaded in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec';

        -- 6. Product Category
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> erp_px_cat_g1v2 Loaded in ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec';

        SET @batch_end_time = GETDATE();
        PRINT '=========================================='
        PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' sec';
        PRINT '=========================================='

        COMMIT TRAN;   -- ✅ Commit all if success
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;  -- ❌ Rollback if error
        PRINT '=========================================='
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER'
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================='
    END CATCH
END;
GO

-- Run the procedure
EXEC bronze.load_bronze;
