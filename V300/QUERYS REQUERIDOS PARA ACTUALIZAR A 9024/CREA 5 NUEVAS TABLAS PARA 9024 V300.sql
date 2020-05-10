 
/****** Object:  Table [dbo].[SA_REGERROR]    Script Date: 09/28/2016 14:43:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SA_REGERROR]') AND type in (N'U'))
DROP TABLE [dbo].[SA_REGERROR]
GO


 
/****** Object:  Table [dbo].[SA_REGERROR]    Script Date: 09/28/2016 14:43:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SA_REGERROR](
	[NROUNICO] [int] IDENTITY(1,1) NOT NULL,
	[CODERR] [varchar](10) NOT NULL,
	[CODUSUA] [varchar](10) NOT NULL,
	[CODESTA] [varchar](10) NOT NULL,
	[CODOPER] [varchar](10) NULL,
	[TIPODOC] [varchar](1) NULL,
	[NUMEROD] [varchar](20) NULL,
	[FECHAT] [datetime] NOT NULL,
	[OBSERVACION] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



 
/****** Object:  Table [dbo].[SA_C_CONFIG]    Script Date: 09/28/2016 14:35:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SA_C_CONFIG]') AND type in (N'U'))
DROP TABLE [dbo].[SA_C_CONFIG]
GO

 
/****** Object:  Table [dbo].[SA_C_CONFIG]    Script Date: 09/28/2016 14:35:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SA_C_CONFIG](
	[ADAPTACION] [varchar](60) NULL,
	[ID3] [varchar](12) NULL,
	[DESCRIPCION] [varchar](60) NULL,
	[VERSION] [varchar](60) NULL,
	[ENCABEZADO] [varchar](100) NULL,
	[PIE] [varchar](100) NULL,
	[LOGO] [image] NULL,
	[LOGO2] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

 
/****** Object:  Table [dbo].[SA_CTRANSAC]    Script Date: 09/28/2016 14:43:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SA_CTRANSAC]') AND type in (N'U'))
DROP TABLE [dbo].[SA_CTRANSAC]
GO

 

/****** Object:  Table [dbo].[SA_CTRANSAC]    Script Date: 09/28/2016 14:43:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SA_CTRANSAC](
	[NROUNICO] [int] IDENTITY(1,1) NOT NULL,
	[NROPPAL] [int] NOT NULL,
	[TIPODOC] [varchar](1) NOT NULL,
	[NUMEROD] [varchar](20) NOT NULL,
	[CODTERCERO] [varchar](15) NOT NULL,
	[CODOPER] [varchar](10) NOT NULL,
	[CODUSUA] [varchar](10) NOT NULL,
	[CODESTA] [varchar](10) NOT NULL,
	[FECHAT] [datetime] NOT NULL,
 CONSTRAINT [SA_CTRANSAC_IX0] PRIMARY KEY CLUSTERED 
(
	[NROUNICO] ASC,
	[TIPODOC] ASC,
	[NUMEROD] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

 
/****** Object:  Table [dbo].[SA_CERROR]    Script Date: 09/28/2016 14:43:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SA_CERROR]') AND type in (N'U'))
DROP TABLE [dbo].[SA_CERROR]
GO

 
/****** Object:  Table [dbo].[SA_CERROR]    Script Date: 09/28/2016 14:43:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SA_CERROR](
	[CODERR] [varchar](10) NOT NULL,
	[DESCRIPCION] [varchar](200) NOT NULL,
	[OBJETO] [varchar](50) NULL,
	[OBSERVACION] [varchar](200) NULL,
	[CodSucu] [varchar](5) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__SA_C_RETI__ENTER__1CBEA81B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SA_C_RETIVAVTA] DROP CONSTRAINT [DF__SA_C_RETI__ENTER__1CBEA81B]
END

GO

 

/****** Object:  Table [dbo].[SA_C_RETIVAVTA]    Script Date: 09/28/2016 14:35:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SA_C_RETIVAVTA]') AND type in (N'U'))
DROP TABLE [dbo].[SA_C_RETIVAVTA]
GO

 

/****** Object:  Table [dbo].[SA_C_RETIVAVTA]    Script Date: 09/28/2016 14:35:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SA_C_RETIVAVTA](
	[NROPPAL] [int] NULL,
	[FechaPAGO] [datetime] NULL,
	[NUMEROD] [varchar](10) NULL,
	[MONTO] [decimal](28, 3) NULL,
	[ENTERADA] [smallint] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SA_C_RETIVAVTA] ADD  DEFAULT ((0)) FOR [ENTERADA]
GO




