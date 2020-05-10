-- VISTA MASTER VEHICULOS PARA FORMATOS DE OR, PREFAC TODAS Y FACTURA TODAS Y REPORTES
-- CREADO POR: JOSE RAVELO ABR-2016

DROP VIEW dbo.VW_MASTER_VEHICULOS

GO
CREATE VIEW dbo.VW_MASTER_VEHICULOS
-- WITH ENCRYPTION

 
AS

SELECT     X.CodProd, X.Descrip, X.CodInst, X.Descrip2, X.Descrip3, X.Refere, A.Marca, Y.Modelo, Y.Serial, Y.Serial_motor, Y.Color, Y.Factura_compra, Y.Factura_venta, Y.Fecha_venta, Y.Kilometraje, 
                      Y.Atributos, Y.Concesionario, Z.Ano, Z.Cilindros, Z.Puestos, Z.Clase, Z.Uso, Z.Tipo,Z.Peso
FROM         SAPROD AS X LEFT OUTER JOIN
                      SAPROD_12_01 AS Y ON X.CodProd = Y.CodProd LEFT OUTER JOIN
                      SAPROD_11_01 AS Z ON Y.Modelo = Z.CodProd LEFT OUTER JOIN SAPROD A ON A.CodProd=Z.CODPROD
WHERE     (X.CodInst = '12')
    

GO
----------------

declare @TNAME CHAR(19)
declare @ALIAS CHAR(19)
SET @TNAME = 'VW_MASTER_VEHICULOS'
SET @ALIAS = 'VW_MASTER_VEHICULOS'
 
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




