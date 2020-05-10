
DROP TRIGGER SENSORSAFACTUPDATE
GO

CREATE TRIGGER dbo.SENSORSAFACTUPDATE ON saFACT FOR UPDATE
AS

DECLARE @DESCRIPERROR VARCHAR(200)
DECLARE @AHORA VARCHAR(30)

 SET @AHORA = convert(varchar(8), getdate(), 112) + 
                     ' ' + 
                     convert(varchar(12), getdate(), 114)
SET @DESCRIPERROR='UPDATE DETECTADO EN SAFACT A LAS:'+@AHORA --+'/'+STR(@Nrounico)+'/'+@Codoper+'/'+@Codusua+'/'+@Codesta--+'/'+STR(@Fechat)
RAISERROR (@DESCRIPERROR,10,1)






