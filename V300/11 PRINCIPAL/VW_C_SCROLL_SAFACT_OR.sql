 
/****** Object:  View [dbo].[VW_C_SCROLL_SAFACT_OR]    Script Date: 09/21/2016 14:26:04 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_C_SCROLL_SAFACT_OR]'))
DROP VIEW [dbo].[VW_C_SCROLL_SAFACT_OR]
GO

 
/****** Object:  View [dbo].[VW_C_SCROLL_SAFACT_OR]    Script Date: 09/21/2016 14:26:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_C_SCROLL_SAFACT_OR]
-- WITH ENCRYPTION

 
AS
SELECT   DISTINCT NUMEROD
FROM    dbo.SAFACT
WHERE TipoFac='G' AND CODOPER='01-301' 
    


GO


