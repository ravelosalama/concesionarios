-- NOMBRE DEL OBJETO SEGUN PATRON PARA CONCESIONARIOS VW_C_LIBRODEVENTAIVA
-- QUE HACE
-- RESUELVE QUE NECESIDAD
-- QUE OBJETOS: REPORTES, SP, TG, LO REQUIERE
-- HECHO POR: JOSE RAVELO            FECHA: 03/2017
 
DROP VIEW dbo.VW_C_LIBRODEVENTAIVA

GO
CREATE VIEW dbo.VW_C_LIBRODEVENTAIVA
-- WITH ENCRYPTION

 
AS
 
SELECT SAFACT.CodClie, SAFACT.CodOper, 
       SAFACT.CodVend, SAFACT.Descrip, 
       SAFACT.FechaE, SAFACT.ID3, SAFACT.Monto, 
       SAFACT.MtoTax, SAFACT.Notas6, 
       SAFACT.NumeroD, SAFACT.RetenIVA, 
       SAFACT.Signo, SAFACT.TExento, 
       SAFACT.TGravable, SAFACT.TipoFac, 
       SATAXVTA.CodTaxs, SATAXVTA.Monto Monto_2, 
       SATAXVTA.MtoTax MtoTax_2, 
       SATAXVTA.NumeroD NumeroD_2, 
       SATAXVTA.TGravable TGravable_2, 
       SATAXVTA.TipoFac TipoFac_2, SAFACT.Notas9, 
       SAFACT.NumeroR, SACLIE.TipoCli, 
       VW_SAFACT.FechaT, 
       (safact.tgravable+safact.mtotax+SAFACT.TEXENTO)*safact.signo safact_tgravable_safact, 
       safact.texento*safact.signo safact_texento_safact_sig, 
       safact.tgravable*safact.signo safact_tgravable_safact_s, 
       safact.mtotax*safact.signo safact_mtotax_safact_sign, 
       (safact.mtotax-safact.retenIVA)*safact.signo safact_mtotax_safact_ret
FROM SAFACT SAFACT
      LEFT OUTER JOIN SATAXVTA SATAXVTA ON 
     (SATAXVTA.NumeroD = SAFACT.NumeroD)
      AND (SATAXVTA.TipoFac = SAFACT.TipoFac)
      LEFT OUTER JOIN SACLIE SACLIE ON 
     (SACLIE.CodClie = SAFACT.CodClie)
      LEFT OUTER JOIN VW_SAFACT VW_SAFACT ON 
     (VW_SAFACT.NumeroD = SAFACT.NumeroD)
      AND (VW_SAFACT.TipoFac = SAFACT.TipoFac)
WHERE ( SAFACT.TipoFac IN ('A','B') )
       
 
 union
 p{´ñ
 SELECT SAFACT.CodClie, SAFACT.CodOper, 
       SAFACT.CodVend, SAFACT.Descrip, 
       SAFACT.FechaE, SAFACT.ID3, SAFACT.Monto, 
       SAFACT.MtoTax, SAFACT.Notas6, 
       SAFACT.NumeroD, SAFACT.RetenIVA, 
       SAFACT.Signo, SAFACT.TExento, 
       SAFACT.TGravable, SAFACT.TipoFac, 
       0,0,0,0,0,0, SAFACT.Notas9, 
       SAFACT.NumeroR, SACLIE.TipoCli, 
       VW_SAFACT.FechaT, 
       (safact.tgravable+safact.mtotax+SAFACT.TEXENTO)*safact.signo safact_tgravable_safact, 
       safact.texento*safact.signo safact_texento_safact_sig, 
       safact.tgravable*safact.signo safact_tgravable_safact_s, 
       safact.mtotax*safact.signo safact_mtotax_safact_sign, 
       (safact.mtotax-safact.retenIVA)*safact.signo safact_mtotax_safact_ret
FROM SAFACT SAFACT
      LEFT OUTER JOIN SA_C_RETIVAVTA ON 
     (SA_C_RETIVAVTA.NUMEROD = SAFACT.NumeroD)
      AND (SAFACT.TipoFac='A')
      LEFT OUTER JOIN SACLIE SACLIE ON 
     (SACLIE.CodClie = SAFACT.CodClie)
      LEFT OUTER JOIN VW_SAFACT VW_SAFACT ON 
     (VW_SAFACT.NumeroD = SAFACT.NumeroD)
      AND (VW_SAFACT.TipoFac = SAFACT.TipoFac)
WHERE ( SAFACT.TipoFac IN ('A','B')

 
 
 
    

GO
----------------

declare @TNAME CHAR(20)
declare @ALIAS CHAR(20)
SET @TNAME = 'VW_C_LIBRODEVENTAIVA'
SET @ALIAS = 'VW_C_LIBRODEVENTAIVA'
 
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




