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
- Create a table with the following contents
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
## 🔄Transformations
## ⚙️ Parameters
## 🖥️ Server Convigurations
## 🚀 Deploying the SSIS Package to SQL Server
## ⏰ Scheduling  
## 🌐 Advanced API Call with C#
