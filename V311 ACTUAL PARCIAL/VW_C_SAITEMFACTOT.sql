/****** VISTA ELABORADA POR: JOSE RAVELO EN JUN 2017 ******/
-- SE CREA PARA REPORTE VENTAS DESPLEGADO




IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_C_SAITEMFACTOT]'))
DROP VIEW [dbo].[VW_C_SAITEMFACTOT]
GO

 
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW dbo.VW_C_SAITEMFACTOT 
-- WITH ENCRYPTION

 
AS


select X.NumeroD,X.TipoFac, SUM(X.Cantidad*X.Precio*Z.Signo) AS MTOTOT
FROM SAITEMFAC X INNER JOIN SASERV Y ON X.CodItem=Y.CODSERV INNER JOIN SAFACT Z ON X.NUMEROD=Z.NUMEROD AND X.TIPOFAC=Z.TIPOFAC
WHERE (X.TipoFac='A' OR X.TIPOFAC='B') AND X.EsServ='1' and Y.CodInst='14'
GROUP BY X.NumeroD,X.TIPOFAC
 
 

 


GO
----------------

declare @TNAME CHAR(17)
declare @ALIAS CHAR(17)
SET @TNAME = 'VW_C_SAITEMFACTOT'
SET @ALIAS = 'VW_C_SAITEMFACTOT'
 
Delete SATABL
Where TableName=@TNAME
 
DELETE SAFIEL
Where TableName=@TNAME

Insert Into SATABL
(tablename, tablealias)
Values (@TNAME, @ALIAS)

Insert Into  SAFIEL 
(TableName, FieldName, FieldAlias, DataType, Selectable, Searchable, Sortable, AutoSearch, Mandatory)
 
(
Select A.Name As TableName, B.Name As FieldName, B.Name As FieldAlias, 
       Case B.XType
    When 56  Then 'dtLongInt'
	When 58  Then 'dtInteger'
	When 106 Then 'dtDouble'
        When 167 Then 'dtString'
        When 61  Then 'dtDateTime'
	When 35  Then 'dtMemo'
        When 52  Then 'dtInteger'
	When 34  Then 'dtGraphic'
	When 165 Then 'dtBlob'        
        End As DataType,
       'T' Selectable, 
       'T' Searchable,  
       'T' Sortable, 
       'F' AutoSearch, 
       'F' Mandatory
from SysObjects A, syscolumns B 
where A.name=@TNAME
and   A.Id=B.Id
) 





