-- VW_C_ORDENES_DE_REPACION
-- VISTA QUE SELECCIONA SOLO LOS TIPOFAC =G
-- RESUELVE
-- QUE OBJETOS: 301 - REPORTE DE VEHICULOS RECIBIDOS EN TALLER
-- HECHO POR:JOSE RAVELO  FECHA:MAY 2017
 
DROP VIEW dbo.VW_C_ORDENES_DE_REPACION 

GO

CREATE VIEW dbo.VW_C_ORDENES_DE_REPACION
-- WITH ENCRYPTION

 
AS

SELECT     X.TipoFac, X.NumeroD, X.Placa, X.Kilometraje, X.Liquidacion, X.Status, X.Cierre_OR, X.Apertura_OR, X.CodSucu, Y.Modelo, Y.Serial, Y.Serial_motor, Y.Color
FROM         SAFACT_01 AS X INNER JOIN
                      SAPROD_12_01 AS Y ON X.Placa = Y.CodProd
WHERE     (X.TipoFac = 'G') AND (X.Kilometraje > 0)
    

GO
----------------

declare @TNAME CHAR(24)
declare @ALIAS CHAR(24)
SET @TNAME = 'VW_C_ORDENES_DE_REPACION'
SET @ALIAS = 'VW_C_ORDENES_DE_REPACION'
 
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




