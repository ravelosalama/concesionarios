 
if exists (select * from dbo.sysobjects where id = object_id(N'[TG_ADM_INSERTA_GESTION_ESPECIAL]'))
drop TRIGGER TG_ADM_INSERTA_GESTION_ESPECIAL  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TG_C_Z002_B]'))
drop TRIGGER TG_C_Z002_B  
GO
 


-- *********************************************************************************************
-- NUEVO TRIGGER PARA 902X CREADO POR: JOSE RAVELO JULIO-2016 REPROGRAMADO EN SEP-16
-- DETECTA TRANSACCIÓN EN SAOPER_02 Y TRANFIERE DATOS A SP_C_Z002_B (OPERACIONES ESPECIALES) 
-- ESTE MODULO ES DE USO EXCLUSIVO DE PERFILES DE USUARIOS DE NIVELES SUPER ADMINI(7) Y DIRECTIVOS(1)
-- ES EL SENSOR DE SOLICITUDES DE PROCESOS ESPECIALES DEL TIPO Z002, SOLO DISTRIBUYE AL SP 
-- *********************************************************************************************
GO
 

CREATE TRIGGER TG_C_Z002_B ON SAOPER_02
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
    
    
-- SAOPER_02 
DECLARE @CODOPER VARCHAR(10),
        @NROUNICO    INT,
        @FECHAT DATETIME,
        @CODUSUA VARCHAR (10),
        @TERCERO VARCHAR(15),
        @NumeroD VARCHAR(20),            
        @MOTIVO VARCHAR(60)       
       
                
-----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------

-- Recoge datos de la tabla: INSERTED
   SELECT @CODOPER=CODOPER,
          @NROUNICO=NROUNICO,
          @FECHAT=FECTRN,
          @CODUSUA=USUARIO,
          @TERCERO=TERCERO,
          @NUMEROD=DOCUMENTO,
          @MOTIVO=MOTIVO
          FROM INSERTED
   
   
-- VALIDACION DE TRANSACCION FACTIBLE
 

-- VERIFICA SI SE ACTIVO ALGUN SWICH DE VALIDACION, MUESTRA ADVERTENCIA Y REVERSA TRANSACCION
 
   IF @STATUSERROR=1
   BEGIN
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR  
   END
   ELSE
 
   -- Si usuarios es valido entonces procesa gestiones especiales sobre OPERACIONES.
      EXECUTE DBO.SP_C_Z002_B 
          @CODOPER=CODOPER,
          @NROUNICO=NROUNICO,
          @FECHAT=FECTRN,
          @CODUSUA=USUARIO,
          @TERCERO=TERCERO,
          @NUMEROD=DOCUMENTO,
          @MOTIVO=MOTIVO





