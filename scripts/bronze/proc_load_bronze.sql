/*
===============================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the 'BULK INSERT' command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters of return any values.

Usage Example:
    EXEC bronze.load_bronze;

=================================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
  BEGIN TRY
      PRINT '============================================================';
    	PRINT 'Loading Bronze Layer';
    	PRINT '============================================================';
    	PRINT '------------------------------------------------------------';
    	PRINT 'Loading CRM Tables'
    	PRINT '------------------------------------------------------------';
    	DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time DATETIME ,@batch_end_time DATETIME;
    	SET @batch_start_time = GETDATE(); 

    	SET @start_time = GETDATE(); -- ************** Table No 1
    	PRINT '>> Truncating Table: bronze.crm_cust_info';
    	TRUNCATE TABLE bronze.crm_cust_info; 
    	PRINT '>> Inserting Table: bronze.crm_cust_info';
    	BULK INSERT bronze.crm_cust_info
    	FROM 'datasets\source_crm\cust_info.csv'
    	WITH (
        	FIRSTROW = 2,
        	FIELDTERMINATOR = ',',
        	TABLOCK
    	);
    	SET @end_time = GETDATE();
    	PRINT '>> Load Duration:'+ CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'Seconds';
    	PRINT '---------------';


    	SET @start_time = GETDATE(); --  ************** Table No 2
    	PRINT '>> Truncating Table: bronze.crm_prd_info ';
    	TRUNCATE TABLE bronze.crm_prd_info; 
    	PRINT '>> Inserting Table: bronze.crm_prd_info';
    	BULK INSERT bronze.crm_prd_info 
    	FROM 'datasets\source_crm\prd_info.csv'
    	WITH (
        	FIRSTROW = 2,
        	FIELDTERMINATOR = ',',
        	TABLOCK
    	);
    	SET @end_time = GETDATE();
    	PRINT '>> Load Duration:'+ CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'Seconds';
    	PRINT '---------------';

    
    	SET @start_time = GETDATE();--  ************** Table No 3
    	PRINT '>> Truncating Table: bronze.crm_sales_details_info';
    	TRUNCATE TABLE bronze.crm_sales_details_info;
    	PRINT '>> Inserting Table: bronze.crm_sales_details_info';
    	BULK INSERT bronze.crm_sales_details_info  
    	FROM 'datasets\source_crm\sales_details.csv'
    	WITH (
        	FIRSTROW = 2,
        	FIELDTERMINATOR = ',',
        	TABLOCK
    	);
    	SET @end_time = GETDATE();
    	PRINT '>> Load Duration:'+ CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'Seconds';
    	PRINT '---------------';
    
    	PRINT '------------------------------------------------------------';
    	PRINT 'Loading ERP Tables'
    	PRINT '------------------------------------------------------------';
    
    	
    	SET @start_time = GETDATE(); --  ************** Table No 4
    	PRINT '>> Truncating Table: bronze.erp_cust_az12';
    	TRUNCATE TABLE bronze.erp_cust_az12; 
    	PRINT '>> Inserting Table: bronze.erp_cust_az12';
    	BULK INSERT bronze.erp_cust_az12
    	FROM 'datasets\source_erp\cust_az12.csv'
    	WITH (
        	FIRSTROW = 2,
        	FIELDTERMINATOR = ',',
        	TABLOCK
    	);
    	SET @end_time = GETDATE();
    	PRINT '>> Load Duration:'+ CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'Seconds';
    	PRINT '---------------';
    
    	SET @start_time = GETDATE();--  ************** Table No 5
    	PRINT '>> Truncating Table: bronze.erp_loc_a101';
      TRUNCATE TABLE bronze.erp_loc_a101
    	PRINT '>> Inserting Table: bronze.erp_loc_a101';
    	BULK INSERT bronze.erp_loc_a101 
    	FROM 'datasets\source_erp\loc_a101.csv'
    	WITH (
        	FIRSTROW = 2,
        	FIELDTERMINATOR = ',',
        	TABLOCK
    	);
    	SET @end_time = GETDATE();
    	PRINT '>> Load Duration:'+ CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'Seconds';
    	PRINT '---------------';
    
    
    	SET @start_time = GETDATE();--  ************** Table No 6
    	PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
      TRUNCATE TABLE bronze.erp_px_cat_g1v2
    	PRINT '>> Inserting Table: bronze.erp_px_cat_g1v2';
    	BULK INSERT bronze.erp_px_cat_g1v2
    	FROM 'datasets\source_erp\px_cat_g1v2.csv'
    	WITH (
    	FIRSTROW = 2,
    	FIELDTERMINATOR = ',',
    	TABLOCK
    	);
    	SET @batch_end_time = GETDATE();
    	PRINT 'Loading Bronze Layer is Completed';
    	PRINT '  - Total Load Duration:'+ DATEDIFF(Second,@batch_start_time,@batch_end_time) + 'Seconds';
    	PRINT '===============================================';

	END TRY
	BEGIN CATCH
    	PRINT '===============================================';
    	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
    	PRINT 'Error Message' + ERROR_MESSAGE();
    	PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
    	PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
      PRINT '===============================================';
	END CATCH
END;

