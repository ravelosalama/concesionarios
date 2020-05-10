 
if exists (select * from dbo.sysobjects where id = object_id(N'[TG_ADM_INSERTA_GESTIONES_ESPECIALES]'))
drop TRIGGER TG_ADM_INSERTA_GESTIONES_ESPECIALES  
GO



-- *********************************************************************************************
-- NUEVO TRIGGER PARA 902X CREADO POR: JOSE RAVELO JULIO-2016 REPROGRAMADO EN SEP-16
-- DETECTA TRANSACCIÓN EN SAOPER_03 Y TRANFIERE DATOS A SP_C_Z002_C (OPERACIONES ESPECIALES AVANZADAS) 
-- ESTE MODULO ES DE USO EXCLUSIVO DE PERFILES DE USUARIOS DE NIVELES SUPER ADMINI(7) Y DIRECTIVOS(1)
--
-- *********************************************************************************************

if exists (select * from dbo.sysobjects where id = object_id(N'[TG_C_Z002_C]'))
drop TRIGGER TG_C_Z002_C  
GO
  

CREATE TRIGGER TG_C_Z002_C ON SAOPER_03
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
DECLARE @EVENTO      varchar (35),
        @NumeroD     varchar (20),
        @NROUNICO    INT,
        @CODOPER VARCHAR(10),
        @CODUSUA VARCHAR (35),
        @FECHAD DATETIME,
        @DESDE DATETIME,
        @HASTA DATETIME,        
        @RESULTADO VARCHAR(10)
        
-----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------
/*
-- Recoge datos de la tabla: INSERTED
   SELECT @CODOPER=CODOPER,
          @CODUSUA=USUARIO,
          @EVENTO=EVENTO,
          @NUMEROD=DOCUMENTO,
          @FECHAD=FECHA,
          @DESDE=PERIODO_DESDE,
          @HASTA=PERIODO_HASTA
     
   FROM INSERTED*/
   
   
-- VALIDACION DE TRANSACCION FACTIBLE
 -- Valida que el usuario que este gestionando esta actividad sea valido (1-Directiva o  7-SuperAdmin)
   SELECT @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WHERE CODUSUA=@CODUSUA  
   IF  Substring(@CODNVL,1,1)<>'7 ' AND Substring(@CODNVL,1,1)<>'1 '
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01098'
     END 

-- VERIFICA SI SE ACTIVO ALGUN SWICH DE VALIDACION, MUESTRA ADVERTENCIA Y REVERSA TRANSACCION

   IF @STATUSERROR=1
   BEGIN
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR  
   END
   ELSE
  
   -- Si usuarios es valido entonces procesa gestiones especiales sobre OPERACIONES.
      EXECUTE DBO.SP_C_Z002_C @CODOPER, @CODUSUA,@EVENTO,@NUMEROD,@FECHAD,@DESDE,@HASTA





