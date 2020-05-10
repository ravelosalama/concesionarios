-- VISTA MAESTRA DE TRANSACCIONES DE VENTAS SAFACT + SAFACT_01 + SAFACT_02 + SAFACT_03
-- OBJETOS QUE USAN ESTA VISTA: REPORTES
--                              SP_C_01_301  
-- CREADO POR: JOSE RAVELO MAY - 2016

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_MASTER_TRANSAC_01]'))
DROP VIEW [dbo].[VW_MASTER_TRANSAC_01]
GO
 
CREATE VIEW dbo.VW_MASTER_TRANSAC_01
-- WITH ENCRYPTION

 
AS

 SELECT     X.TipoFac, X.NumeroD, X.NroCtrol, X.CodSucu, X.CodEsta, X.CodUsua, X.CodClie, X.CodVend, X.CodUbic, X.Descrip, X.Direc1, X.Direc2, X.Direc3, X.Pais, X.Estado, X.Ciudad, X.Telef, X.ID3, X.NIT, 
                      X.Monto, X.MtoTax, X.Fletes, X.TGravable, X.TExento, X.CostoPrd, X.CostoSrv, X.DesctoP, X.RetenIVA, X.FechaE, X.FechaV, X.CancelI, X.CancelA, X.CancelE, X.CancelC, X.CancelT, X.CancelG, 
                      X.Cambio, X.EsConsig, X.MtoExtra, X.Descto1, X.PctAnual, X.MtoInt1, X.Descto2, X.PctManejo, X.MtoInt2, X.MtoFinanc, X.DetalChq, X.TotalPrd, X.TotalSrv, X.OrdenC, X.CodOper, X.NGiros, 
                      X.NMeses, X.MtoComiVta, X.MtoComiCob, X.MtoComiVtaD, X.MtoComiCobD, X.Notas1, X.Notas2, X.Notas3, X.Notas4, X.Notas5, X.Notas6, X.Notas7, X.Notas8, X.Notas9, X.Notas10, X.NumeroR, 
                      X.NumeroD1, X.FechaD1, X.SaldoAct, X.MtoPagos, X.MtoNCredito, X.MtoNDebito, X.FechaI, X.ValorPtos, X.CancelP, X.NumeroT, X.MtoTotal, X.Contado, X.Credito, X.NumeroZ, X.FechaR, X.FechaT, 
                      X.NROUNICO, X.NumeroE, X.Municipio, X.CodConv, X.ZipCode, X.EsCorrel, X.AutSRI, X.NroEstable, X.PtoEmision, X.TipoTraE, X.NumeroNCF, X.TGravable0, Y.Placa, Y.Kilometraje, Y.Liquidacion, 
                      Y.Status, Y.Cierre_OR, Y.Apertura_OR, Z.Modelo, Z.Color, Z.Serial_M, Z.Serial, Z.Vendido, Z.Vendio_Concesionario, Z.Z_INTERNO, A.Nro_OR, A.Vale, A.Despacho, B.Descrip as Desclie
FROM                  SAFACT    AS X                                                    LEFT OUTER JOIN
                      SAFACT_01 AS Y ON X.NumeroD = Y.NumeroD AND X.TipoFac = Y.TipoFac LEFT OUTER JOIN
                      SAFACT_02 AS Z ON X.NumeroD = Z.NumeroD AND X.TipoFac = Z.TipoFac LEFT OUTER JOIN
                      SAFACT_03 AS A ON X.NumeroD = A.NumeroD AND X.TipoFac = A.TipoFac LEFT OUTER JOIN 
                      SACLIE    AS B ON X.CodClie=B.CodClie
 

 

GO
----------------

declare @TNAME CHAR(20)
declare @ALIAS CHAR(20)
SET @TNAME = 'VW_MASTER_TRANSAC_01'
SET @ALIAS = 'VW_MASTER_TRANSAC_01'
 
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




