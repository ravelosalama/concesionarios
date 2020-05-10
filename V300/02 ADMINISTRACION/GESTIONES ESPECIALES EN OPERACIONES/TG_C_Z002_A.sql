 
if exists (select * from dbo.sysobjects where id = object_id(N'[TG_ADM_INSERTA_GESTION_ESPECIAL]'))
drop TRIGGER TG_ADM_INSERTA_GESTION_ESPECIAL  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TG_C_Z002_A]'))
drop TRIGGER TG_C_Z002_A  
GO
 


-- *********************************************************************************************
-- NUEVO TRIGGER PARA 902X CREADO POR: JOSE RAVELO JULIO-2016 REPROGRAMADO EN SEP-16
-- DETECTA TRANSACCIÓN EN SAOPER_01 Y TRANFIERE DATOS A SP_C_Z002_A (PROCESOS ESPECIALES) 
-- ESTE MODULO ES DE USO EXCLUSIVO DE PERFILES DE USUARIOS DE NIVELES SUPER ADMINI(7) Y DIRECTIVOS(1)
-- ES EL SENSOR DE SOLICITUDES DE PROCESOS EPECIALES DEL TIPO Z002, SOLO DISTRIBUYE AL SP 
-- *********************************************************************************************

GO
 

CREATE TRIGGER TG_C_Z002_A ON SAOPER_01
-- WITH ENCRYPTION
AFTER INSERT 

AS
-----------------------------------
-- DECLARACION DE VARIABLES 
-----------------------------------
DECLARE @STATUSERROR INT,
        @DESCRIPERROR VARCHAR(300),
        @CODNVL VARCHAR(2)
    SET @STATUSERROR=0
    
    
-- SAOPER_01 
DECLARE @PROCESO     varchar (35),
        @NumeroD     varchar (20),
        @NROUNICO    INT,
        @CODOPER VARCHAR(10),
        @CODUSUA VARCHAR (35),
        @FECHAT DATETIME,
        @DESDE DATETIME,
        @HASTA DATETIME,        
        @RESULTADO VARCHAR(10)
        
-----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------

-- Recoge datos de la tabla: INSERTED
   SELECT @CODOPER=CODOPER,
          @NROUNICO=NROUNICO,
          @FECHAT=FECTRN,
          @CODUSUA=USUARIO,
          @PROCESO=PROCESO,
          @NUMEROD=DOCUMENTO,
          @DESDE=PERIODO_DESDE,
          @HASTA=PERIODO_HASTA
          FROM INSERTED
   
   
-- VALIDACION DE TRANSACCION FACTIBLE
 

-- VERIFICA SI SE ACTIVO ALGUN SWICH DE VALIDACION, MUESTRA ADVERTENCIA Y REVERSA TRANSACCION
 
   IF @STATUSERROR=1
   BEGIN
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR  
   END
   ELSE
 
   -- Si usuarios es valido entonces procesa gestiones especiales sobre OPERACIONES.
      EXECUTE DBO.SP_C_Z002_A @CODOPER,@NROUNICO,@FECHAT,@CODUSUA,@PROCESO,@NUMEROD,@DESDE,@HASTA





