-- VISTA QUE MUESTRA LAS VECES QUE SE HA FACTURADO UN VEHICULO EN SERVICIO SEGUN SU PLACA 
-- CREADO POR: JOSE RAVELO AGO-2016

DROP VIEW [dbo].[VW_SA_CANT_SERV_FACT_PLACA] 

GO
CREATE VIEW [dbo].[VW_SA_CANT_SERV_FACT_PLACA]
-- WITH ENCRYPTION

 
AS
  SELECT DISTINCT PLACA,     
    COUNT(PLACA) OVER(PARTITION BY PLACA) AS 'Count' 
     FROM SAFACT_01
     WHERE PLACA IS NOT NULL AND PLACA<>'' and tipofac='A'

     
    

GO
----------------

declare @TNAME CHAR(26)
declare @ALIAS CHAR(26)
SET @TNAME = 'VW_SA_CANT_SERV_FACT_PLACA'
SET @ALIAS = 'VW_SA_CANT_SERV_FACT_PLACA'
 
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




