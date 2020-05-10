-- *****************************************************************************************
-- PROCESA TODAS LAS OPERACIONES ESPECIALES (B) SEGUN SENSOR EN SAOPER_02
--  

-- PROGRAMADO para versiones superiores 902X 
-- JULIO 2016 por: JOSE RAVELO COMO:SP_C_Z002_B OPERACIONES ESPECIALES 
-- SEP 2016 REPROGRAMADO COMO SP_C_Z002_B NOMBRE NEMOTECNICO POR VALOR DE DATA EN SAOPER
-- *****************************************************************************************
-- NOTA IMPORTANTE: SE DEHABILITO EL TG NOUPDATE PORQUE DEJABA DE FUNCIONAR ESTE SP
--                  SIGO EN ESTUDIO PARA SABER LA RAZON.


/*
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SESA_SP_COMPRA_VEHICULO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SESA_SP_COMPRA_VEHICULO]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_COMPRA_VEHICULO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE SP_05_COMPRA_VEHICULO
GO
*/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_ADM_OPERACIONES_GESTIONES_ESPECIALES]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure SP_ADM_OPERACIONES_GESTIONES_ESPECIALES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_C_Z002_B]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure SP_C_Z002_B




SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
 

CREATE PROCEDURE  SP_C_Z002_B 
        @CODOPER VARCHAR(10),
        @NROUNICO    INT,
        @FECHAT DATETIME,
        @CODUSUA VARCHAR (10),
        @TERCERO VARCHAR(15),
        @NumeroD VARCHAR(20),            
        @MOTIVO VARCHAR(60)  


--WITH ENCRYPTION
AS
 

BEGIN
 
 

DECLARE @STATUSERROR INT,
        @DESCRIPERROR VARCHAR(400)
    SET @STATUSERROR=0
    
DECLARE @CODNVL VARCHAR(2) ,
        @DESDE DATETIME,
        @HASTA DATETIME,
        @PROCESO DATETIME
     

 
   
 -------------------------------------- <<<<< OBJETO DEL PROCEDIMIENTO >>>>>>  -------------------------------------
 -- Validaciones generales
 IF SUBSTRING(@codoper,1,4)<>'Z002'
   BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01144'
      UPDATE SAOPER_02 SET RESULTADO=@DESCRIPERROR   WHERE   NroUnico=@NROUNICO  
   END
 
 -- Corrige error en valor de FecTrn que almacena la entrada a la sesion de SAINT y no fecha y hora de la transaccion.
UPDATE SAOPER_02 SET FecTrn = getdate()   WHERE   NroUnico=@NROUNICO  
 
 
   
 ------------<<<<< INICIO OPERACION ESPECIAL: 01-Eliminar Ret.I.V.A. (Cobranzas) >>>>>>>----
 ------------<<<<<                                        >>>>>>>>------------ 

IF @Codoper = 'Z002-B-001'  

BEGIN
    
    -- VALIDACIONES VIABILIDAD DE LA TRANSACCION 
  
 
   -- Valida que el dia del campo inicio sea valido
   IF CAST(DAY(@DESDE) as varchar(2))<>'1 ' and CAST(DAY(@DESDE) as varchar(2))<>'16'
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01141'
     END 
 
   -- Valida que el dia del campo hasta sea valido, tomando en cuenta tosos los dias de terminos de mes del ano
   IF CAST(DAY(@HASTA) as varchar(2))<>'15' and CAST(DAY(@HASTA) as varchar(2))<>'30' and CAST(DAY(@HASTA) as varchar(2))<>'31' and CAST(DAY(@HASTA) as varchar(2))<>'28' and CAST(DAY(@HASTA) as varchar(2))<>'29'
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01142'
     END
     
       -- Valida que no haya ningun campo vital vacio  
   IF  @CODUSUA='' OR @PROCESO='' OR @NUMEROD='' or @CODUSUA is null OR @PROCESO is null OR @NUMEROD is null OR @DESDE IS NULL OR @HASTA IS NULL
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01127'
     END


     

   -- Valida que el usuario que este gestionando esta actividad sea valido (1-Directiva o  7-SuperAdmin)
   SELECT @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WHERE CODUSUA=@CODUSUA  
   IF  Substring(@CODNVL,1,2)<>'7 ' AND Substring(@CODNVL,1,2)<>'1 '
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01098'
     END 
     
     -- Valida que el usuario indicado exista en SSUSRS
     IF NOT EXISTS (SELECT * FROM SSUSRS WHERE CodUsua=@CODUSUA)
   BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01145'
   END
     
    /*
-- -- VERIFICA SI SE ACTIVO ALGUN SWICH DE VALIDACION, MUESTRA ADVERTENCIA Y REVERSA TRANSACCION
      -- este bloque se inhabilito y sustituyo por el siguiente dado que en las tablas maestras de saint no funciona el raiserror, 
      -- por razones desconocidas, dando feedback al usuario de otra manera menos optima pero practica.
      -- se deja esta traza esperando solucion por parte de SAINT.
   IF @STATUSERROR=1
   BEGIN
      EXECUTE SP_00_VENTANA_ERROR @DESCRIPERROR
   END

   ELSE*/
 
 
    IF @STATUSERROR=0
   BEGIN
     -- se asigna valor de proceso satisfactorio a descripcion de mensaje al usuario. 
     SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01143'
     -- Verifica transaccion con documento repetido procesado satisfactoriamente. 
     IF EXISTS (SELECT * FROM SAOPER_02 WHERE DOCUMENTO=@NUMEROD AND RESULTADO LIKE '%satisfactor%')
     BEGIN
      --SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01146'
     END
     UPDATE SAACXP SET Notas10='ENTERADA EN DECLARACIÓN:'+@NUMEROD, Document=Document+' ENTERADA' WHERE TipoCxP='81' AND FechaE>=@DESDE AND FechaE<=@HASTA   
      
   END
   
   UPDATE SAOPER_02 SET RESULTADO=@DESCRIPERROR   WHERE   NroUnico=@NROUNICO    
   

END

------------------------------------------------
-------- FIN DEL PROCESO Z002-A-001
------------------------------------------------





--- INICIO OTRO PROCESO

---- FIN OTROPROCESO


END
 


 



 