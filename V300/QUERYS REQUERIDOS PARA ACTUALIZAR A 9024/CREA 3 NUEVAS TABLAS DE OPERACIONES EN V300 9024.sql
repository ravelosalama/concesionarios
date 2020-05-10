   
/****** Object:  Table [dbo].[SAOPER_03]    Script Date: 09/28/2016 15:38:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SAOPER_03]') AND type in (N'U'))
DROP TABLE [dbo].[SAOPER_03]
GO

 
/****** Object:  Table [dbo].[SAOPER_03]    Script Date: 09/28/2016 15:38:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SAOPER_03](
	[CodOper] [varchar](10) NOT NULL,
	[NroUnico] [int] IDENTITY(1,1) NOT NULL,
	[FecTrn] [datetime] NOT NULL,
	[Usuario] [varchar](10) NULL,
	[Tercero] [varchar](15) NULL,
	[Documento] [varchar](20) NULL,
	[Argumento_1] [varchar](35) NULL,
	[Argumento_2] [varchar](35) NULL,
	[Argumento_3] [varchar](35) NULL,
	[Argumento_4] [varchar](35) NULL,
	[Motivo] [varchar](60) NULL,
	[RESULTADO] [text] NULL,
 CONSTRAINT [SAOPER_03_IX0] PRIMARY KEY CLUSTERED 
(
	[CodOper] ASC,
	[NroUnico] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



/****** Object:  Table [dbo].[SAOPER_02]    Script Date: 09/28/2016 15:38:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SAOPER_02]') AND type in (N'U'))
DROP TABLE [dbo].[SAOPER_02]
GO

 
/****** Object:  Table [dbo].[SAOPER_02]    Script Date: 09/28/2016 15:38:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SAOPER_02](
	[CodOper] [varchar](10) NOT NULL,
	[NroUnico] [int] IDENTITY(1,1) NOT NULL,
	[FecTrn] [datetime] NOT NULL,
	[Usuario] [varchar](10) NULL,
	[Tercero] [varchar](15) NULL,
	[Documento] [varchar](20) NULL,
	[Motivo] [varchar](60) NULL,
	[RESULTADO] [text] NULL,
 CONSTRAINT [SAOPER_02_IX0] PRIMARY KEY CLUSTERED 
(
	[CodOper] ASC,
	[NroUnico] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



/****** Object:  Table [dbo].[SAOPER_01]    Script Date: 09/28/2016 15:37:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SAOPER_01]') AND type in (N'U'))
DROP TABLE [dbo].[SAOPER_01]
GO

 
/****** Object:  Table [dbo].[SAOPER_01]    Script Date: 09/28/2016 15:37:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SAOPER_01](
	[CodOper] [varchar](10) NOT NULL,
	[NroUnico] [int] IDENTITY(1,1) NOT NULL,
	[FecTrn] [datetime] NOT NULL,
	[Usuario] [varchar](35) NULL,
	[Proceso] [varchar](35) NULL,
	[Documento] [varchar](20) NULL,
	[Periodo_Desde] [datetime] NULL,
	[Periodo_Hasta] [datetime] NULL,
	[RESULTADO] [text] NULL,
 CONSTRAINT [SAOPER_01_IX0] PRIMARY KEY CLUSTERED 
(
	[CodOper] ASC,
	[NroUnico] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


