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

### SSIS Data Flow Task – `CustomerTransactions`
1. Create a Data Flow Task named `CustomerTransactions`.
2. Add components:
   - **OLE DB Source**: connect to `financial_transactions_db`
   - **OLE DB Destination**: connect to `financial_data_warehouse`
3. Execute the task to transfer initial data.

### Project Connection Configuration
1. In SSIS, right-click both connections (`financial_transactions_db` and `financial_data_warehouse`) in the Connection Manager.
2. Select **Convert to Project Connection** so they appear in the Solution Manager.


### Data Enrichment via SQL Join
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

### Handling Duplicate Data
To prevent duplication errors, add an **Execute SQL Task** before the Data Flow Task with:

```sql
TRUNCATE TABLE dbo.financial_transactions
```

Then re-run the task.

### Import `exchange_rates.xlsx`
1. Create a Data Flow Task named `ExchangeRates`.
2. Add components:
   - **Excel Source**: connect to the Excel file
   - **Data Conversion**: convert data types as needed
   - **OLE DB Destination**: connect to `dbo.exchange_rates`
3. Run the task.

### Import `suppliers.csv`
1. Create a Data Flow Task named `Suppliers`.
2. Add components:
   - **Flat File Source**: connect to the CSV file
   - **Data Conversion**
   - **OLE DB Destination**: connect to `dbo.suppliers`
3. Run the task.

### Truncate Before Import
To avoid duplicates, add **Execute SQL Tasks** before each import task:

```sql
TRUNCATE TABLE dbo.exchange_rates
TRUNCATE TABLE dbo.suppliers
```


### Currency Conversion
Add a new column to store converted amounts:

```sql
ALTER TABLE dbo.financial_transactions 
ADD amount_USD FLOAT
```

### Supplier Contact Enrichment
Add supplier contact details to the warehouse table:

```sql
ALTER TABLE dbo.financial_transactions 
ADD supplier_contact_name VARCHAR(100), 
    supplier_phone VARCHAR(20)
```
<div align="center">
<img width = "80%" src = "https://github.com/anandawln/ETL-with-SSIS/blob/main/assets/suppliers_cf.png">
</div>


## 🔧 Setting Project Parameters for Connection Strings

To make your SSIS package deployment more flexible and environment-aware, it's recommended to parameterize your **Connection Managers** using **Project Parameters**. This allows you to dynamically assign connection strings based on the selected environment (e.g., Dev, Test, Prod).

### Steps to Parameterize Connection Strings

1. **Open Connection Managers**
   - In your SSIS project (inside Visual Studio), go to the **Connection Managers** pane at the bottom.

2. **Parameterize Each Connection**
   - Right-click on each connection (e.g., OLE DB, Flat File, Excel).
   - Select **Parameterize**.
   - Choose the property to parameterize—typically the **ConnectionString**.
   - Confirm and apply. This will automatically create a new entry in `Project.params`.

3. **Verify Project Parameters**
   - Go to the **Project.params** file to confirm that the parameters have been created.
   - You should see entries like `ConnectionString_Dev`, `ConnectionString_Prod`, etc., depending on your naming convention.

4. **Link Parameters to Environment Variables**
   - After deploying the project to SSISDB:
     - Go to **Configure** → **Parameters** tab.
     - Check **Use Environment Variable** for each connection string parameter.
     - Map it to the corresponding variable in your environment (e.g., `Dev.ConnectionString`).

<div align="center">
<img width = "80%" src = "https://github.com/anandawln/ETL-with-SSIS/blob/main/assets/params.png">
</div>

# 🚀 Deploying the SSIS Package to SQL Server
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

### SSIS Deployment with Environment Parameters and SQL Server Agent Job

This guide outlines the steps to deploy an SSIS package to **SSISDB** using **Environment Parameters**, and schedule its execution via **SQL Server Agent Job**. Ideal for Dev/Test/Prod scenarios requiring dynamic configuration.

### Deployment Steps

### 1. Create an Environment in SSISDB
- Open **Integration Services Catalogs** in SSMS.
- Right-click on your project folder in `SSISDB`, select **Create Environment**.
- Name the environment, e.g., `Dev`.

### 2. Add Environment Variables
- Right-click on the `Dev` environment, select **Properties**.
- Go to the **Variables** tab and add variables that match the parameters used in your package (e.g., `ConnectionString`, `FilePath`, etc.).
- Ensure the variable names and data types match the package parameters.

### 3. Link Environment to Project
- Right-click on the project in SSISDB, select **Configure**.
- Navigate to the **References** tab, click **Add Reference**, and select the `Dev` environment.
- Once linked, go to the **Parameters** tab.
- For each parameter, check **Use Environment Variable** and map it to the corresponding variable from `Dev`.

### 4. Create a SQL Server Agent Job
- Open **SQL Server Agent** → right-click → **New Job**.
- Name the job according to your project/package.

#### 4.1 Add a Job Step
- Go to the **Steps** tab → click **New**.
- Name the step and select **SQL Server Integration Services Package** as the type.
- Choose the correct server and SSIS package from SSISDB.
- In the **Configuration** section, check the **Environment** box and select `Dev`.
- Ensure there are no red warnings under parameter values.

### 5. Run and Schedule the Job
- After creating the job, right-click → **Start Job at Step** to run it manually.
- To schedule automatic execution:
  - Go to the **Schedules** tab → click **New**.
  - Set the frequency, time, and enable the schedule as needed.

### Additional Tips
- Make sure all required parameters are exposed as **Package Parameters**, not just **Project Parameters**, for better flexibility.
- Use consistent and descriptive variable names for easier mapping.
- Check SQL Server Agent logs for troubleshooting if the job fails.

### Recommended SSISDB Structure and Settings for Scheduling
Use SQL Server Agent to schedule packages, ensuring they run automatically at set intervals. 
<div align="center">
<img width = "80%" src = "https://github.com/anandawln/ETL-with-SSIS/blob/main/assets/scheduling.png">
</div>

## 🌐 Integrating Exchange Rates via API (SSIS + C#)

### Duplicate and Modify SSIS Package
1. Copy the existing SSIS package `financial_transactions.dtsx`.
2. Rename the copy to `financial_transactions-API.dtsx`.
3. Open the new package and navigate to the **Data Flow** tab under the `ExchangeRates` task.

### Replace Excel Source with API
1. In the **SSIS Toolbox**, drag in a **Script Component** and set its type to **Source**.
2. This component will replace the previous Excel source (`exchange_rates.xlsx`) as the new data provider.

### Configure Script Component Output
Define the following output columns:
- `from_currency` (string)
- `to_currency` (string)
- `exchange_rate` (float or decimal)
- `effective_date` (DT_DATE)

Make sure the data types match the expected API response format.

### Implement C# Script for API Call
1. Click **Edit Script** on the Script Component.
2. Write the logic inside the `CreateNewOutputRows()` method to:
   - Perform an HTTP GET request to the exchange rate API.
   - Parse the JSON response.
   - Populate the output buffer with the parsed data.

💡 You can refer to the sample script in [`scriptAPI.cs`](settings/scriptAPI.cs)
### Updated Data Flow Sequence
```text
Script Component (Exchange API)
        ↓
Data Conversion
        ↓
Derived Column (optional logic, e.g. converting to base currency)
        ↓
OLE DB Destination → dbo.exchange_rates
```

### Pre-Load Cleanup
To avoid duplicate entries, add an **Execute SQL Task** before the Data Flow Task:

```sql
TRUNCATE TABLE dbo.exchange_rates
```

### Additional Notes
- Ensure internet connectivity during package execution.
- If the API has rate limits, consider adding retry logic or delay handling in the script.
- Validate incoming data (e.g., exchange rates should not be zero or negative).
- Add logging inside the script for easier debugging and monitoring.

---
