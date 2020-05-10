-- VW_C_SACONF
-- VISTA COMPLETA DE LA TABLA 
-- RESUELVE IDENTIFICAR EN REPORTES Y FORMATOS LA VERSION EN QUE SE IMPRIME EL DOCUMENTO.
-- RESUELVE USO DE CAMPOS DE CONFIGURACION ADICIONAL NO CONTEMPLADOS EN SACONF Y SI EN SA_C_CONFIG
-- EJEMPLOS: VERSION DE CONCESIONARIOS, NIC, LICENCIA COMERCIAL EN FACTURAS, ETC.        
-- QUE OBJETOS: TODOS LOS REPORTES Y FORMATOS
-- HECHO POR:JOSE RAVELO  FECHA:SEP 2016
 
DROP VIEW dbo.VW_C_SACONF

GO

CREATE VIEW dbo.VW_C_SACONF
-- WITH ENCRYPTION

 
AS

SELECT   *
FROM    dbo.SACONF X INNER JOIN SA_C_CONFIG Y ON X.RIF = Y.ID3
         
    

GO
----------------

declare @TNAME CHAR(11)
declare @ALIAS CHAR(11)
SET @TNAME = 'VW_C_SACONF'
SET @ALIAS = 'VW_C_SACONF'
 
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




