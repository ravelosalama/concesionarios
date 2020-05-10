-- NOMBRE DEL OBJETO SEGUN PATRON PARA CONCESIONARIOS VW_C_XXXXXXXXX
-- QUE HACE
-- RESUELVE QUE NECESIDAD
-- QUE OBJETOS: REPORTES, SP, TG, LO REQUIERE
-- HECHO POR:            FECHA:
 
DROP VIEW dbo.VW_C_REPUESTOSDESPACHADOS

GO

DROP VIEW dbo.VW_C_DESPACHOS_VIVOS

GO



CREATE VIEW dbo.VW_C_DESPACHOS_VIVOS
-- WITH ENCRYPTION

 
AS
-- VISTA DE REPUESTOS DESPACHADOS PARA TALLER VIVOS (DESPACHOS NO REVERSADOS Y EN OR PENDIENTES)
 
 
              SELECT X.CodItem,X.Cantidad,X.CodUbic,X.NumeroD,X.TipoFac,Y.Nro_OR,Z.NumeroR,Z.CodOper,X.Costo,X.Precio,X.Descrip1,X.FechaE,X.FechaL
			  FROM dbo.SAITEMFAC AS X 
			  INNER JOIN dbo.SAFACT_03 AS Y ON (X.TipoFac = Y.TipoFac and X.NumeroD = Y.NumeroD) 
			  INNER JOIN SAFACT AS Z ON X.TIPOFAC=Z.TIPOFAC AND X.NUMEROD=Z.NUMEROD 
			  WHERE X.TipoFac = 'F' AND Z.Codoper='01-303' AND (Z.NUMEROR IS NULL OR Z.NUMEROR='') AND Z.Descrip NOT LIKE '%FACTURADA%'  
   

GO
----------------

declare @TNAME CHAR(20)
declare @ALIAS CHAR(20)
SET @TNAME = 'VW_C_DESPACHOS_VIVOS'
SET @ALIAS = 'VW_C_DESPACHOS_VIVOS'
 
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




