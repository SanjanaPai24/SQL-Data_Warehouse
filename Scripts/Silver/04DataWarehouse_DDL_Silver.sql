/*
================================================================================
DDL Script: Create Silver Tables
================================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	Run this script to re-define the DDL structure of 'silver' Tables
================================================================================
*/

IF OBJECT_ID('silver.dimCompany', 'U') IS NOT NULL
    DROP TABLE silver.dimCompany;
GO

CREATE TABLE silver.dimCompany (
	keyCompany INT,
	stockCodeCompany NVARCHAR(32),
	nameCompany NVARCHAR(64),
	sectorCodeCompany NVARCHAR(32),
	sectorCompany NVARCHAR(256),
	segmentCompany NVARCHAR(256),
	createDate DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.dimCoin', 'U') IS NOT NULL
	DROP TABLE silver.dimCoin;
GO

CREATE TABLE silver.dimCoin (
	keyCoin INT,
	abbrevCoin NVARCHAR(8),
	nameCoin NVARCHAR(16),
	symbolCoin NVARCHAR(8),
	createDate DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.dimTime', 'U') IS NOT NULL
	DROP TABLE silver.dimTime;
GO

CREATE TABLE silver.dimTime(
	keyTime INT,
	datetime DATE,
	dayTime	INT,
	dayWeekTime	INT,
	dayWeekAbbrevTime NVARCHAR(8),	
	dayWeekCompleteTime	NVARCHAR(16),
	monthTime INT,
	monthAbbrevTime NVARCHAR(8),	
	monthCompleteTime NVARCHAR(16),
	bimonthTime INT,
	quarterTime INT,
	semesterTime INT,
	yearTime INT,
	createDate DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.factCoins', 'U') IS NOT NULL
	DROP TABLE silver.factCoins;
GO

CREATE TABLE silver.factCoins(
	keyTime INT,
	keyCoin INT,
	valueCoin FLOAT,
	createDate DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.factStocks', 'U') IS NOT NULL
	DROP TABLE silver.factStocks;
GO

CREATE TABLE silver.factStocks(
	keyTime INT,	
	keyCompany INT,
	openValueStock FLOAT,	
	closeValueStock FLOAT,	
	highValueStock FLOAT,
	lowValueStock FLOAT,
	quantityStock FLOAT,
	createDate DATETIME2 DEFAULT GETDATE()
);
GO

