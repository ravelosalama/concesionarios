 

/****** Object:  View [dbo].[VW_SASE_RETIVACXC]    Script Date: 09/04/2016 01:16:09 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_SASE_RETIVACXC]'))
DROP VIEW [dbo].[VW_SASE_RETIVACXC]
GO

 
/****** Object:  View [dbo].[VW_SASE_RETIVACXC]    Script Date: 09/04/2016 01:16:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_SASE_RETIVACXC] AS 
   SELECT * FROM SA_C_RETIVAVTA WITH (NOLOCK) 
GO


