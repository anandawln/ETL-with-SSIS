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
---

### 🏗️ Step 1: Source Database Setup (`financial_transactions_db`)
1. Create a database named `financial_transactions_db` in SQL Server Management Studio (SSMS).
2. Create the table `financial_transactions` with columns:
   - `transaction_id`, `customer_id`, `supplier_name`, `transaction_date`, `amount`, `currency`
3. Insert transaction data into the table.
4. Create the table `customer_details` with columns:
   - `customer_id`, `customer_name`, `email`, `phone`
5. Insert customer data into the table.

### 📁 Step 2: External Data Sources
Include two external files:
- `exchange_rates.xlsx` containing: `from_currency`, `to_currency`, `exchange_rate`, `effective_date`
- `suppliers.csv` containing: `supplier_id`, `supplier_name`, `contact_name`, `phone`

### 🏢 Step 3: Target Data Warehouse Setup (`financial_data_warehouse`)
1. Create a new database named `financial_data_warehouse`.
2. Create the table `financial_transactions` with the same structure as the source table.

### 🔄 Step 4: SSIS Data Flow Task – `CustomerTransactions`
1. Create a Data Flow Task named `CustomerTransactions`.
2. Add components:
   - **OLE DB Source**: connect to `financial_transactions_db`
   - **OLE DB Destination**: connect to `financial_data_warehouse`
3. Execute the task to transfer initial data.

### 🔗 Step 5: Project Connection Configuration
1. In SSIS, right-click both connections (`financial_transactions_db` and `financial_data_warehouse`) in the Connection Manager.
2. Select **Convert to Project Connection** so they appear in the Solution Manager.

### 🔍 Step 6: Data Enrichment via SQL Join
1. Use the following SQL query to enrich transaction data with customer details:

```sql
SELECT 
  t.*, 
  c.customer_name, 
  c.email AS customer_email, 
  c.phone AS customer_phone 
FROM dbo.financial_transactions t
INNER JOIN dbo.customer_details c 
  ON t.customer_id = c.customer_id
```

2. In SSIS, edit the OLE DB Source and switch to **SQL Command** mode. Paste the query above.
3. Add new columns to the destination table:

```sql
ALTER TABLE dbo.financial_transactions 
ADD 
  customer_name VARCHAR(50) NULL, 
  customer_email VARCHAR(100) NULL, 
  customer_phone VARCHAR(20) NULL
```

4. Re-run the task to load enriched data.

### ⚠️ Step 7: Handling Duplicate Data
To prevent duplication errors, add an **Execute SQL Task** before the Data Flow Task with:

```sql
TRUNCATE TABLE dbo.financial_transactions
```

Then re-run the task.

### 📥 Step 8: Import `exchange_rates.xlsx`
1. Create a Data Flow Task named `ExchangeRates`.
2. Add components:
   - **Excel Source**: connect to the Excel file
   - **Data Conversion**: convert data types as needed
   - **OLE DB Destination**: connect to `dbo.exchange_rates`
3. Run the task.

### 📥 Step 9: Import `suppliers.csv`
1. Create a Data Flow Task named `Suppliers`.
2. Add components:
   - **Flat File Source**: connect to the CSV file
   - **Data Conversion**
   - **OLE DB Destination**: connect to `dbo.suppliers`
3. Run the task.

### 🧹 Step 10: Truncate Before Import
To avoid duplicates, add **Execute SQL Tasks** before each import task:

```sql
TRUNCATE TABLE dbo.exchange_rates
TRUNCATE TABLE dbo.suppliers
```

### 💱 Step 11: Currency Conversion
Add a new column to store converted amounts:

```sql
ALTER TABLE dbo.financial_transactions 
ADD amount_USD FLOAT
```

### 📞 Step 12: Supplier Contact Enrichment *(Optional Enhancement)*
Add supplier contact details to the warehouse table:

```sql
ALTER TABLE dbo.financial_transactions 
ADD supplier_contact_name VARCHAR(100), 
    supplier_phone VARCHAR(20)
```

---
## ⚙️ Parameters
<div align="center">
<img width = "80%" src = "https://github.com/anandawln/ETL-with-SSIS/blob/main/assets/params.png">
</div>

## 🖥️ Server Convigurations
## 🚀 Deploying the SSIS Package to SQL Server
To deploy an SSIS package from Visual Studio to the SSIS Catalog in SQL Server Management Studio (SSMS), follow these steps:  
- Open Visual Studio, then in the **Solution Explorer** panel, right-click the SSIS project you want to deploy.  
- Select the **Deploy** option to begin the deployment process.  
- Follow all steps in the **Integration Services Deployment Wizard** until completion.  
- If you encounter any issues during deployment, refer to the Refer to the [`debugging.md`](settings/debugging.md) file for troubleshooting guidance.
- Once deployment is successful, the catalog name will appear under the **Integration Services Catalogs** section in SSMS.  
<p align="center">
  <img src="https://github.com/anandawln/ETL-with-SSIS/blob/main/assets/deploy_passed.png" width="45%"/>
  <img src="https://github.com/anandawln/ETL-with-SSIS/blob/main/assets/deploy_check.png" width="40%"/>
</p>

## ⏰ Scheduling  
Use SQL Server Agent to schedule packages, ensuring they run automatically at set intervals. 
<div align="center">
<img width = "80%" src = "https://github.com/anandawln/ETL-with-SSIS/blob/main/assets/scheduling.png">
</div>

## 🌐 Advanced API Call with C#

