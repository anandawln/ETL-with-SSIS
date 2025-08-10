USE financial_data_warehouse;
GO

/*
alter table dbo.financial_transactions
add [customer_name] [varchar](50) NULL,
	[email] [varchar](100) NULL,
	[phone] [varchar](20) NULL

select * from dbo.financial_transactions 


-- Mengubah nama kolom 'email' menjadi 'customer_email'
EXEC sp_rename 'dbo.financial_transactions.email', 'customer_email', 'COLUMN';
GO

-- Mengubah nama kolom 'phone' menjadi 'customer_phone'
EXEC sp_rename 'dbo.financial_transactions.phone', 'customer_phone', 'COLUMN';
GO

truncate table dbo.financial_transactions

select * from dbo.financial_transactions 
*/

create table dbo.exchange_rates
( 
from_currency varchar(10),
to_currency varchar(10),
exchange_rate float,
effective_date date
)

create table dbo.suppliers
(
supplier_id int,
supplier_name varchar(100),
contact_name varchar(100),
phone varchar(25)
)

select * from dbo.exchange_rates
select * from dbo.suppliers

alter table dbo.financial_transactions
add amount_USD

