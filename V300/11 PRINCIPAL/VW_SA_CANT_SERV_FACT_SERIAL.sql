-- VISTA QUE MUESTRA LAS VECES QUE SE HA FACTURADO UN VEHICULO EN SERVICIO SEGUN SU SERIAL 
-- CREADO POR: JOSE RAVELO AGO-2016

DROP VIEW [dbo].[VW_SA_CANT_SERV_FACT_SERIAL] 

GO
CREATE VIEW [dbo].[VW_SA_CANT_SERV_FACT_SERIAL]
-- WITH ENCRYPTION

 
AS
  SELECT DISTINCT SERIAL,     
    COUNT(SERIAL) OVER(PARTITION BY SERIAL) AS 'Count' 
     FROM SAFACT_02
     WHERE SERIAL IS NOT NULL AND SERIAL<>'' and tipofac='A'

     
    

GO
----------------

declare @TNAME CHAR(27)
declare @ALIAS CHAR(27)
SET @TNAME = 'VW_SA_CANT_SERV_FACT_SERIAL'
SET @ALIAS = 'VW_SA_CANT_SERV_FACT_SERIAL'
 
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




