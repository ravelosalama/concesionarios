-- *****************************************************************************************
-- PROCESA TODOS LOS PROCESOS ESPECIALES SOBRE OPERACIONES SAOPER_03
--  

-- PROGRAMADO para versiones superiores 902X 
-- JULIO 2016 por: JOSE RAVELO COMO:SP_ADM_OPERACIONES_GESTIONES_ESPECIALES
-- SEP 2016 REPROGRAMADO COMO SP_C_Z002_C NOMBRE NEMOTECNICO POR VALOR DE DATA EN SAOPER
-- *****************************************************************************************


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_ADM_OPERACIONES_GESTIONES_ESPECIALES]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure SP_ADM_OPERACIONES_GESTIONES_ESPECIALES
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_C_Z002_C]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure SP_C_Z002_C
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
 

CREATE PROCEDURE  SP_C_Z002_C @CODOPER VARCHAR(10), @CODUSUA VARCHAR(35),@EVENTO VARCHAR(35),@NUMEROD VARCHAR(20),@FECHAD DATETIME,@DESDE DATETIME,@HASTA DATETIME

--WITH ENCRYPTION
AS


DECLARE @FechaHoy datetime
DECLARE @NumRec int

-- Datos del registro de IVA
DECLARE @CodTaxs varchar (5),
        @MontoIVA decimal (23,2),
        @EsPorct smallint

-- Datos del registro extendido de compra de vehiculo
DECLARE @CodProd varchar (15),
        @Serial varchar (35),
        @SerialMotor varchar (35),
        @Factura_compra varchar (10)

-- Datos del registro del modelo
DECLARE @Modelo varchar (25),
        @DescVehiculo varchar (35),
        @Marca varchar (20),
        @EsExento smallint

-- Datos del registro extendido del modelo
DECLARE @Ano int,
        @Cilindros int,
        @Kilometraje int,
        @Peso int,
        @Puestos int

-- Datos del registro extendido del vehiculo
DECLARE @Placa varchar (15),
        @Color varchar (25),
        @Status varchar (25),
        @CodInst int

-- Datos del registro de existencia
DECLARE @Deposito varchar (10),
        @Existencia decimal(28,3)

-- oTROS
DECLARE @CONCESIONARIO VARCHAR(35),
        @Atributos VARCHAR(60)


-- Datos del registro de item de la compra del vehiculo
DECLARE @CodItem varchar (15)

DECLARE @STATUSERROR INT,
        @DESCRIPERROR VARCHAR(300)
    SET @STATUSERROR=0
    
DECLARE @CODNVL VARCHAR(2)    
    
 -------------------------------------- <<<<< OBJETO DEL PROCEDIMIENTO >>>>>>  ------------------------------

IF @Codoper = '06-002' -- CIERRE DE PERIODO IMPOSITIVO QUINCENAL PARA CONTRIBUYENTES ESPECIALES.

BEGIN
    -- VALIDACIONES VIABILIDAD DE LA TRANSACCION 

   
   -- Valida que no haya ningun campo vital vacio  
   IF  @CODUSUA='' OR @EVENTO='' OR @NUMEROD='' or @CODUSUA is null OR @EVENTO is null OR @NUMEROD is null 
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01127'
     END

     
 -- -- VERIFICA SI SE ACTIVO ALGUN SWICH DE VALIDACION, MUESTRA ADVERTENCIA Y REVERSA TRANSACCION

   IF @STATUSERROR=1
   
    BEGIN
       EXECUTE SP_00_VENTANA_ERROR @DESCRIPERROR
    END
     
-- INICIO DEL PROCEDIMIENTO 

   UPDATE SAACXP SET Notas10='ENTERADA EN DECLARACIÓN:'+@NUMEROD, Document=Document+' ENTERADA' WHERE TipoCxP='81' AND FechaE>=@DESDE AND FechaE<=@HASTA    
   UPDATE SAOPER_01 SET RESULTADO='CIERRE EJECUTADO SATISFACTORIAMENTE'  
  

-- FIN DEL PROCEDIMIENTO  
     


END







SET QUOTED_IDENTIFIER OFF 
GO
