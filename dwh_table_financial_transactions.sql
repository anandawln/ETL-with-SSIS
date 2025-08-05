USE [financial_data_warehouse]
GO

/****** Object:  Table [dbo].[financial_transactions]    Script Date: 05/08/2025 17:33:46 ******/
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

SELECT * FROM financial_transactions;
