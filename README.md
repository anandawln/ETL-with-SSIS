# 📊 Build Data Warehouse for Finance Case and ETL Pipeline using SSIS
## 📝 Business Request
- The business has customer purchase data in local currency, but needs that data converted and needs the customer contact information with it
- The purchase data is in SQL Server, the currency conversion data is in excel, and the customer contract information is in a csv file
- The task is to bring this data together in a new SQL Server database for the business

## 📌 Requirements
- SQL Server Developer Edition 2022
- Visual Studio Installer (SSMS & Visual Studio Community 2022 [SSIS Extension])

## 🛠️ ETL and Data Warehousing
### Source Data to SQL Server Database
- Create a database named financial_transactions_db
```sql
CREATE DATABASE financial_transactions_db;
```
- Create financial_transactions table with the following contents
```sql
CREATE TABLE financial_transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    supplier_name VARCHAR(50),
    transaction_date DATE,
    amount DECIMAL(10, 2),
    currency VARCHAR(10)
);
```
- Insert the data
```sql
INSERT INTO financial_transactions (transaction_id, customer_id, supplier_name, transaction_date, amount, currency)
VALUES
    (1, 101, 'ABC Corp', '2024-01-15', 1000.00, 'USD'),
    (2, 102, 'XYZ Ltd', '2024-01-20', 1500.50, 'EUR'),
    (3, 103, 'Global Inc', '2024-02-05', 2000.00, 'GBP'),
    (4, 104, 'ABC Corp', '2024-02-10', 500.25, 'USD');
```
- Create customer_details table
```sql
CREATE TABLE customer_details (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20)
);
```

- Insert the data
```sql
INSERT INTO customer_details (customer_id, customer_name, email, phone)
VALUES
    (101, 'John Doe', 'john.doe@example.com', '123-456-7890'),
    (102, 'Jane Smith', 'jane.smith@example.com', '234-567-8901'),
    (103, 'Mike Johnson', 'mike.johnson@example.com', '345-678-9012'),
    (104, 'Emily Davis', 'emily.davis@example.com', '456-789-0123');
```

### Creating Warehouse Destination for ETL
- Create a Data Warehouse database named financial_data_warehouse
```sql
CREATE DATABASE financial_data_warehouse;
```
- Create the table
```sql
USE [financial_data_warehouse]
GO

/****** Object:  Table [dbo].[financial_transactions] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[financial_transactions](
	[transaction_id] [int] NOT NULL,
	[customer_id] [int] NULL,
	[supplier_name] [varchar](50) NULL,
	[transaction_date] [date] NULL,
	[amount] [decimal](10, 2) NULL,
	[currency] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
```
### Initialize ETL


## 🔄Transformations
## ⚙️ Parameters
<div align="center">
<img width = "80%" src = "https://github.com/anandawln/ETL-with-SSIS/blob/main/assets/params.png">
</div>

## 🖥️ Server Convigurations
## 🚀 Deploying the SSIS Package to SQL Server

<div align="center">
<img width = "50%" src = "https://github.com/anandawln/ETL-with-SSIS/blob/main/assets/deploy_passed.png">
</div>

<div align="center">
<img width = "30%" src = "https://github.com/anandawln/ETL-with-SSIS/blob/main/assets/deploy_check.png">
</div>



## ⏰ Scheduling  
<div align="center">
<img width = "80%" src = "https://github.com/anandawln/ETL-with-SSIS/blob/main/assets/scheduling.png">
</div>

## 🌐 Advanced API Call with C#
