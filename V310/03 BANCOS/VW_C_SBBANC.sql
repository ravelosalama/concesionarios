 
/****** Object:  View [dbo].[VW_C_SBBANC]    Script Date: 05/08/2017 10:08:39 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_C_SBBANC]'))
DROP VIEW [dbo].[VW_C_SBBANC]
GO

 
/****** Object:  View [dbo].[VW_C_SBBANC]    Script Date: 05/08/2017 10:08:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_C_SBBANC]
-- WITH ENCRYPTION

 
AS
SELECT  *
FROM    dbo.SBBANC
 
    


GO


