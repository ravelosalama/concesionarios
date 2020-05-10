-- NOMBRE DEL OBJETO SEGUN PATRON PARA CONCESIONARIOS VW_C_SBTRAN
-- QUE HACE
-- RESUELVE QUE NECESIDAD
-- QUE OBJETOS: REPORTES, SP, TG, LO REQUIERE
-- HECHO POR:            FECHA:
 
DROP VIEW dbo.VW_C_SBTRAN 

GO
CREATE VIEW dbo.VW_C_SBTRAN
-- WITH ENCRYPTION

 
AS
SELECT  *
FROM    dbo.SBTRAN
 
    

GO
----------------

declare @TNAME CHAR(11)
declare @ALIAS CHAR(11)
SET @TNAME = 'VW_C_SBTRAN'
SET @ALIAS = 'VW_C_SBTRAN'
 
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




