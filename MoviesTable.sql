USE [Movies]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 3/3/2025 3:32:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Category](
	[Category_num] [dbo].[Category_num] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Category_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 3/3/2025 3:32:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customer](
	[Cust_num] [dbo].[Cust_num] IDENTITY(300,1) NOT NULL,
	[Lname] [varchar](20) NOT NULL,
	[Fname] [varchar](20) NOT NULL,
	[Address1] [varchar](30) NULL,
	[Address2] [varchar](20) NULL,
	[City] [varchar](20) NULL,
	[State] [char](2) NULL,
	[Zip] [char](10) NULL,
	[Phone] [varchar](10) NOT NULL,
	[Join_date] [smalldatetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cust_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Movie]    Script Date: 3/3/2025 3:32:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Movie](
	[Movie_num] [dbo].[Movie_num] NOT NULL,
	[Title] [varchar](50) NOT NULL,
	[Category_Num] [dbo].[Category_num] NOT NULL,
	[Date_purch] [smalldatetime] NULL,
	[Rental_price] [int] NULL,
	[Rating] [char](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[Movie_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rental]    Script Date: 3/3/2025 3:32:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rental](
	[Invoice_num] [dbo].[Invoice_num] NOT NULL,
	[Cust_num] [dbo].[Cust_num] NOT NULL,
	[Rental_date] [smalldatetime] NOT NULL,
	[Due_date] [smalldatetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Invoice_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Rental_Detail]    Script Date: 3/3/2025 3:32:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rental_Detail](
	[Invoice_num] [dbo].[Invoice_num] NOT NULL,
	[Line_num] [int] NOT NULL,
	[Movie_num] [dbo].[Movie_num] NOT NULL,
	[Rental_price] [smallmoney] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Invoice_num] ASC,
	[Line_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Movie]  WITH CHECK ADD FOREIGN KEY([Category_Num])
REFERENCES [dbo].[Category] ([Category_num])
GO
ALTER TABLE [dbo].[Rental]  WITH CHECK ADD FOREIGN KEY([Cust_num])
REFERENCES [dbo].[Customer] ([Cust_num])
GO
ALTER TABLE [dbo].[Rental_Detail]  WITH CHECK ADD FOREIGN KEY([Invoice_num])
REFERENCES [dbo].[Rental] ([Invoice_num])
GO
ALTER TABLE [dbo].[Rental_Detail]  WITH CHECK ADD FOREIGN KEY([Movie_num])
REFERENCES [dbo].[Movie] ([Movie_num])
GO
