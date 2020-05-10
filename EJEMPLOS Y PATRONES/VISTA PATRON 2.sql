-- VW_C_SAITEMFAC_DESPACHOS
-- VISTA QUE SELECCIONA SOLO LOS TIPOFAC =F
-- RESUELVE
-- QUE OBJETOS: 302 - AUDITORIA OR DESPACHOS
-- HECHO POR:JOSE RAVELO  FECHA:SEP 2016
 
DROP VIEW dbo.VW_C_SAITEMFAC_DESPACHOS 

GO

CREATE VIEW dbo.VW_C_SAITEMFAC_DESPACHOS
-- WITH ENCRYPTION

 
AS

SELECT   X.CodItem,X.Descrip1,X.Cantidad,Y.Nro_OR,Z.CodOper,X.NumeroD,X.TipoFac
FROM    dbo.SAITEMFAC X 
        INNER JOIN SAFACT_03 Y ON X.NumeroD=Y.NumeroD AND X.TipoFac=Y.TipoFac
        INNER JOIN SAFACT Z    ON X.NumeroD=Z.NumeroD AND X.TipoFac=Z.TipoFac
WHERE   X.TipoFac='F' 
    

GO
----------------

declare @TNAME CHAR(24)
declare @ALIAS CHAR(24)
SET @TNAME = 'VW_C_SAITEMFAC_DESPACHOS'
SET @ALIAS = 'VW_C_SAITEMFAC_DESPACHOS'
 
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




