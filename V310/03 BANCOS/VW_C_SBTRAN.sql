 
/****** Object:  View [dbo].[VW_C_SBTRAN]    Script Date: 05/08/2017 10:07:25 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_C_SBTRAN]'))
DROP VIEW [dbo].[VW_C_SBTRAN]
GO

 

/****** Object:  View [dbo].[VW_C_SBTRAN]    Script Date: 05/08/2017 10:07:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_C_SBTRAN]
-- WITH ENCRYPTION

 
AS
SELECT  *
FROM    dbo.SBTRAN
 
    


GO


