
DROP TRIGGER SENSORSAFACTINSERT
GO

CREATE TRIGGER dbo.SENSORSAFACTINSERT ON saFACT FOR INSERT
AS

DECLARE @DESCRIPERROR VARCHAR(200)
DECLARE @AHORA VARCHAR(30)

 SET @AHORA = convert(varchar(8), getdate(), 112) + 
                     ' ' + 
                     convert(varchar(12), getdate(), 114)
SET @DESCRIPERROR='INSERT DETECTADO EN SAFACT A LAS:'+@AHORA --+'/'+STR(@Nrounico)+'/'+@Codoper+'/'+@Codusua+'/'+@Codesta--+'/'+STR(@Fechat)
RAISERROR (@DESCRIPERROR,10,1)






