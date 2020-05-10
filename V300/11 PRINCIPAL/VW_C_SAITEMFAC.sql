-- VISTA SAITEMFAC 
-- CREADO POR: JOSE RAVELO SEP 2016

 
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_C_SAITEMFAC]'))
DROP VIEW [dbo].[VW_C_SAITEMFAC]
GO


CREATE VIEW dbo.VW_C_SAITEMFAC
-- WITH ENCRYPTION

 
AS
SELECT   *
FROM    dbo.SAITEMFAC
 
    

GO
----------------

declare @TNAME CHAR(14)
declare @ALIAS CHAR(14)
SET @TNAME = 'VW_C_SAITEMFAC'
SET @ALIAS = 'VW_C_SAITEMFAC'
 
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




