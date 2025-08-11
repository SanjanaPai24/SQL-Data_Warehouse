--Checking data in dimCoin
Select * from bronze.dimCoin;

Select keyCoin, COUNT(keyCoin) from bronze.dimCoin
group by keyCoin
having COUNT(keyCoin)>1;

--Checking data in factCoins
Select * from bronze.factCoins;

Select distinct keycoin from bronze.factCoins;

Select keyTime,COUNT(keytime) from bronze.factCoins
group by keyTime
having COUNT(keyTime)>2;

Select valueCoin from bronze.factCoins
where valueCoin<0;

Select * from bronze.factCoins 
where keyCoin NOT IN (Select keyCoin from bronze.dimCoin);

Select * from bronze.factCoins 
where keyTime NOT IN (Select keyTime from bronze.dimTime);

--Checking data in dimTime
Select * from bronze.dimTime ;

Select COUNT(keyTime), keyTime from bronze.dimTime 
group by keyTime
having COUNT(keyTime)>1;

Select distinct dayWeekTime, dayWeekAbbrevTime, dayWeekCompleteTime from bronze.dimTime
order by dayWeekTime;

Select distinct monthTime, monthAbbrevTime, monthCompleteTime from bronze.dimTime
order by monthTime;

Select DATEPART(YEAR,datetime), yearTime from bronze.dimTime 
where DATEPART(YEAR,datetime)= yearTime;

Select count(yearTime), yearTime from bronze.dimTime 
group by yearTime
order by yearTime;

Select distinct DATEPART(MONTH,datetime), quarterTime from bronze.dimTime
order by quarterTime,DATEPART(MONTH,datetime) ;

Select distinct DATEPART(MONTH,datetime), bimonthTime from bronze.dimTime
order by bimonthTime,DATEPART(MONTH,datetime) ;

Select distinct DATEPART(MONTH,datetime), semesterTime from bronze.dimTime
order by semesterTime,DATEPART(MONTH,datetime) ;

Select datetime from bronze.dimTime 
where datetime > GETDATE() OR datetime<'1900-01-01';

--Checking data in dimCompany
Select * from bronze.dimCompany;

Select keyCompany, COUNT(keyCompany) from bronze.dimCompany
group by keyCompany
having COUNT(keyCompany)>1;

Select * from bronze.dimCompany
where keyCompany IS NULL;

Select distinct sectorCodeCompany from bronze.dimCompany;

Select COUNT(sectorCodeCompany), sectorCodeCompany FROM (
Select DISTINCT sectorCompany,sectorCodeCompany from bronze.dimCompany) t
group by sectorCodeCompany
having COUNT(sectorCodeCompany)>1;

Select COUNT(stockCodeCompany), stockCodeCompany from (
Select distinct stockCodeCompany,nameCompany from bronze.dimCompany)t
group by stockCodeCompany
having COUNT(stockCodeCompany)>1;

Select distinct segmentCompany from bronze.dimCompany;

Select distinct segmentCompany, sectorCodeCompany from bronze.dimCompany
order by sectorCodeCompany;

--Checking data in factStocks
Select * from bronze.factStocks;

Select * from bronze.factStocks
where keyTime NOT IN (Select keyTime from bronze.dimTime);

Select * from bronze.factStocks
where keyCompany NOT IN (Select keyCompany from bronze.dimCompany);

Select * from bronze.factStocks 
where highValueStock < lowValueStock;

Select * from bronze.factStocks 
where quantityStock<0;

Select * from bronze.factStocks 
where openValueStock<0 OR closeValueStock<0 OR highValueStock<0 OR lowValueStock<0;
