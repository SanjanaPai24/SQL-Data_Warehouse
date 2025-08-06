/*
====================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
====================================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Usage:
    EXEC bronze.load_bronze;
====================================================================================
*/

IF OBJECT_ID('bronze.load_bronze', 'P') IS NULL
	EXEC('CREATE PROCEDURE bronze.load_bronze AS BEGIN RETURN; END;' );
GO

ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		SET @start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading Dim Tables';
		PRINT '------------------------------------------------';

		PRINT '---- Truncating Table: bronze.dimCompany ----';
		TRUNCATE TABLE bronze.dimCompany;
		PRINT '---- Inserting Data Into: bronze.dimCompany ----';
		BULK INSERT bronze.dimCompany
		FROM 'C:\SQL_Data\Project2_dataset\dimCompany.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			ROWTERMINATOR='\n'
		);

		PRINT '---- Truncating Table: bronze.dimCoin ----';
		TRUNCATE TABLE bronze.dimCoin;
		PRINT '---- Inserting Data Into: bronze.dimCoin ----';
		BULK INSERT bronze.dimCoin
		FROM 'C:\SQL_Data\Project2_dataset\dimCoin.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			ROWTERMINATOR ='\n'
		);

		--Formating the input date values to load as per DATE datatype
		SET DATEFORMAT dmy;

		PRINT'---- Truncating Table: bronze.dimTime ----';
		TRUNCATE TABLE bronze.dimTime;
		PRINT'---- Inserting Data Into: bronze.dimTime ----';
		BULK INSERT bronze.dimTime
		FROM 'C:\SQL_Data\Project2_dataset\dimTime.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			ROWTERMINATOR='\n'
		);

		PRINT '------------------------------------------------';
		PRINT 'Loading Fact Tables';
		PRINT '------------------------------------------------';

		PRINT'---- Truncating Table: bronze.factCoins ----';
		TRUNCATE TABLE bronze.factCoins;
		PRINT'---- Inserting Data Into: bronze.factCoins ----';
		BULK INSERT bronze.factCoins
		FROM 'C:\SQL_Data\Project2_dataset\factCoins.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			ROWTERMINATOR='\n'
		);

		PRINT'---- Truncating Table: bronze.factStocks ----';
		TRUNCATE TABLE bronze.factStocks;
		PRINT'---- Inserting Data Into: bronze.factStocks ----';
		BULK INSERT bronze.factStocks
		FROM 'C:\SQL_Data\Project2_dataset\factStocks.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			ROWTERMINATOR='\n'
		);
		SET @end_time = GETDATE();

		PRINT '================================================';
		PRINT 'Loading Bronze Layer is completed';
		PRINT '================================================';

		PRINT 'Load duration : '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+ 'seconds';
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END


