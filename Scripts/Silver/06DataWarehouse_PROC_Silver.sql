/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.

Usage:
    EXEC silver.load_silver;
===============================================================================
*/

IF OBJECT_ID('silver.load_silver','P') IS NULL
	EXEC('CREATE PROCEDURE silver.load_silver AS BEGIN RETURN; END;');
GO

ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		SET @start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading silver Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading Dim Tables';
		PRINT '------------------------------------------------';

		PRINT '---- Truncating Table: silver.dimCompany ----';
		TRUNCATE TABLE silver.dimCompany;
		PRINT '---- Inserting Data Into: silver.dimCompany ----';
		INSERT INTO silver.dimCompany (
			keyCompany ,
			stockCodeCompany ,
			nameCompany ,
			sectorCodeCompany ,
			sectorCompany ,
			segmentCompany
		)
		SELECT 
			keyCompany ,
			stockCodeCompany ,
			nameCompany ,
			sectorCodeCompany ,
			sectorCompany ,
			segmentCompany
		FROM bronze.dimCompany;

		PRINT '---- Truncating Table: silver.dimCoin ----';
		TRUNCATE TABLE silver.dimCoin;
		PRINT '---- Inserting Data Into: silver.dimCoin ----';
		INSERT INTO silver.dimCoin (
			keyCoin ,
			abbrevCoin ,
			nameCoin ,
			symbolCoin 
		)
		SELECT 
			keyCoin ,
			abbrevCoin ,
			nameCoin ,
			symbolCoin
		FROM bronze.dimCoin;

		PRINT'---- Truncating Table: silver.dimTime ----';
		TRUNCATE TABLE silver.dimTime;
		PRINT'---- Inserting Data Into: silver.dimTime ----';
		INSERT INTO silver.dimTime (
			keyTime ,
			datetime ,
			dayTime	,
			dayWeekTime	,
			dayWeekAbbrevTime ,	
			dayWeekCompleteTime	,
			monthTime ,
			monthAbbrevTime ,	
			monthCompleteTime ,
			bimonthTime ,
			quarterTime ,
			semesterTime ,
			yearTime 						
		)
		SELECT 
			keyTime ,
			datetime ,
			dayTime	,
			dayWeekTime	,
			dayWeekAbbrevTime ,	
			dayWeekCompleteTime	,
			monthTime ,
			monthAbbrevTime ,	
			monthCompleteTime ,
			bimonthTime ,
			quarterTime ,
			semesterTime ,
			yearTime
		FROM bronze.dimTime;

		PRINT '------------------------------------------------';
		PRINT 'Loading Fact Tables';
		PRINT '------------------------------------------------';

		PRINT'---- Truncating Table: silver.factCoins ----';
		TRUNCATE TABLE silver.factCoins;
		PRINT'---- Inserting Data Into: silver.factCoins ----';
		INSERT INTO silver.factCoins (
			keyTime ,
			keyCoin ,
			valueCoin 
		)
		SELECT
			keyTime ,
			keyCoin ,
			valueCoin
		FROM 
			(SELECT *, ROW_NUMBER() OVER (PARTITION BY keyTime, keyCoin Order BY KeyTime) as flag
			FROM bronze.factCoins)t
		WHERE flag=1;--Incase of duplicates, select first row records

		PRINT'---- Truncating Table: silver.factStocks ----';
		TRUNCATE TABLE silver.factStocks;
		PRINT'---- Inserting Data Into: silver.factStocks ----';
		INSERT INTO silver.factStocks (
			keyTime ,	
			keyCompany ,
			openValueStock ,	
			closeValueStock ,	
			highValueStock ,
			lowValueStock ,
			quantityStock 
		)
		SELECT
			keyTime ,	
			keyCompany ,
			openValueStock ,	
			closeValueStock ,	
			highValueStock ,
			lowValueStock ,
			quantityStock
		FROM bronze.factStocks;
		
		SET @end_time = GETDATE();

		PRINT '================================================';
		PRINT 'Loading silver Layer is completed';
		PRINT '================================================';

		PRINT 'Load duration : '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+ 'seconds';
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
