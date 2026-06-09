/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure orchestrates the ingestion of data from external CSV 
    files into the 'bronze' schema tables.
    
    The procedure executes the following sequential steps:
    1. Truncates target bronze tables to ensure a clean data reload.
    2. Executes 'BULK INSERT' commands to populate bronze tables with source data.

Parameters:
    None

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY

        SET @batch_start_time = GETDATE()
        PRINT '====================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '====================================================';


        PRINT '-----------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '-----------------------------------------------------';

        PRINT '>> Truncating Table: bronze.crm_cust_info'
        TRUNCATE TABLE bronze.crm_cust_info;

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into: bronze.crm_cust_info'
        BULK INSERT bronze.crm_cust_info
        FROM '/tmp/cust_info.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        PRINT '>> Truncating Table: bronze.crm_prd_info'
        TRUNCATE TABLE bronze.crm_prd_info;

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into: bronze.crm_prd_info'
        BULK INSERT bronze.crm_prd_info
        FROM '/tmp/prd_info.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '>> Truncating Table: bronze.crm_sales_details'
        TRUNCATE TABLE bronze.crm_sales_details

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into: bronze.crm_sales_details'
        BULK INSERT bronze.crm_sales_details
        FROM '/tmp/sales_details.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '-----------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '-----------------------------------------------------';

        PRINT '>> Truncating Table: bronze.erp_loc_a101'
        TRUNCATE TABLE bronze.erp_loc_a101

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into: bronze.erp_loc_a101'
        BULK INSERT bronze.erp_loc_a101
        FROM '/tmp/LOC_A101.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '>> Truncating Table: bronze.erp_cust_az12'
        TRUNCATE TABLE bronze.erp_cust_az12

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into: bronze.erp_cust_az12'
        BULK INSERT bronze.erp_cust_az12
        FROM '/tmp/CUST_AZ12.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2'
        TRUNCATE TABLE bronze.erp_px_cat_g1v2

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2'
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/tmp/PX_CAT_G1V2.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        SET @batch_end_time = GETDATE();
        PRINT 'Load Duration FOR BATCH TIME: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR OCCURED DURING LOADING THE BRONZE LAYER'
        PRINT 'Error Message' + ERROR_MESSAGE();
        PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
    END CATCH

END
