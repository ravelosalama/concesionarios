 

/****** Object:  View [dbo].[VW_SBDTRN]    Script Date: 09/28/2016 15:04:45 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_SBDTRN]'))
DROP VIEW [dbo].[VW_SBDTRN]
GO
 
/****** Object:  View [dbo].[VW_SBDTRN]    Script Date: 09/28/2016 15:04:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create view [dbo].[VW_SBDTRN] AS
select t2.codbanc, t2.nope, t2.codcta, t2.descripcion, t2.monto, t2.mtodb, t2.mtocr 
from sbtran t1 
inner join sbdtrn t2 
on t1.nope=t2.nope 
where t1.cdcd=0
union all
select t2.codbanc, t1.operel, t2.codcta, t2.descripcion, t2.monto, t2.mtodb, t2.mtocr 
from sbtran t1 
inner join sbdtrn t2 
on t1.nope=t2.nope 
where t1.cdcd=3 and operel<>0

GO


