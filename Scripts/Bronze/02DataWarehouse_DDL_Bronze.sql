/*
================================================================================
DDL Script: Create Bronze Tables
================================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	Run this script to re-define the DDL structure of 'bronze' Tables
================================================================================
*/

IF OBJECT_ID('bronze.dimCompany', 'U') IS NOT NULL
    DROP TABLE bronze.dimCompany;
GO

CREATE TABLE bronze.dimCompany (
	keyCompany INT,
	stockCodeCompany NVARCHAR(32),
	nameCompany NVARCHAR(64),
	sectorCodeCompany NVARCHAR(32),
	sectorCompany NVARCHAR(256),
	segmentCompany NVARCHAR(256)
);
GO

IF OBJECT_ID('bronze.dimCoin', 'U') IS NOT NULL
	DROP TABLE bronze.dimCoin;
GO

CREATE TABLE bronze.dimCoin (
	keyCoin INT,
	abbrevCoin NVARCHAR(8),
	nameCoin NVARCHAR(16),
	symbolCoin NVARCHAR(8)
);
GO

IF OBJECT_ID('bronze.dimTime', 'U') IS NOT NULL
	DROP TABLE bronze.dimTime;
GO

CREATE TABLE bronze.dimTime(
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
	yearTime INT
);
GO

IF OBJECT_ID('bronze.factCoins', 'U') IS NOT NULL
	DROP TABLE bronze.factCoins;
GO

CREATE TABLE bronze.factCoins(
	keyTime INT,
	keyCoin INT,
	valueCoin FLOAT
);
GO

IF OBJECT_ID('bronze.factStocks', 'U') IS NOT NULL
	DROP TABLE bronze.factStocks;
GO

CREATE TABLE bronze.factStocks(
	keyTime INT,	
	keyCompany INT,
	openValueStock FLOAT,	
	closeValueStock FLOAT,	
	highValueStock FLOAT,
	lowValueStock FLOAT,
	quantityStock FLOAT
);
GO
