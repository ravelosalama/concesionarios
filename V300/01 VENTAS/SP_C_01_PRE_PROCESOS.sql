-- *****************************************************************************************
-- NUEVO PROCEDIMIENTO ALMACENADO DESDE EL SENSOR NUEVO SAFACT_04 EN MARZO 2016
-- PROCESA TODAS LAS OPCIONES DE VENTAS DE LOS CONCESIONARIOS
-- <<<<<<<<<<<<<< 303 - DESPACHO - ALMACEN >>>>>>>>>>>>>>>>>>
-- <<<<<<<<<<<<<< 302 - TALLER - VALE   >>>>>>>>>>>>>>>>>>>>>
-- <<<<<<<<<<<<<< 301 - SERVICIOS: ORDEN DE SERVICIO - PREFACTURA - FACTURA >>>>>>>>>>>>>>>>>>
-- <<<<<<<<<<<<<< 201 - REPUESTOS: PREFACTURA - FACTURA >>>>>>>>>>>>>>>>>>>>>
-- <<<<<<<<<<<<<< 101 - VEHICULOS: PREFACTURA - FACTURA >>>>>>>>>>>>>>>>>>>>>
-- ********** INICIADO POR CARLOS SILVA. MODIFICADO POR JOSE RAVELO ***********************
-- revisado ene-2013 JOSE RAVELO SOBRE LIBERTYLABORATORIO ANTES COMO INSERTA_ORDEN Y ANTES COMO:TG_GESTIONA_ESPERA
-- Regenerado en Marzo 2016 por: JOSE RAVELO COMO:SP_01_PRE_PROCESOS para versiones 9xxx
-- *****************************************************************************************

 
-- ELIMINACION DE TRIGGERS VERSIONES ANTERIORES A 9XXX 
if exists (select * from dbo.sysobjects where id = object_id(N'[CONCESIONARIOS_TG_ESPERA_OR]'))
drop TRIGGER CONCESIONARIOS_TG_ESPERA_OR  
GO

-- SOBRE SAFACT_02
if exists (select * from dbo.sysobjects where id = object_id(N'[INSERT_ORDEN]'))
drop TRIGGER INSERT_ORDEN  
GO

-- SOBRE SAFACT 
if exists (select * from dbo.sysobjects where id = object_id(N'[STATUS FACTURA ANULADA]'))
drop TRIGGER [dbo].[STATUS FACTURA ANULADA] 
GO

-- SAITEMFAC
if exists (select * from dbo.sysobjects where id = object_id(N'[CORRIGE_COMPROMETIDO]'))
drop TRIGGER [dbo].[CORRIGE_COMPROMETIDO] 
GO
 
-- SOBRE SAFACT_01
if exists (select * from dbo.sysobjects where id = object_id(N'[SESA_TG_MODIFICA_LIQUIDACION]'))
drop TRIGGER [dbo].[SESA_TG_MODIFICA_LIQUIDACION] 
GO

 -- SOBRE SAITEMFAC
if exists (select * from dbo.sysobjects where id = object_id(N'[VALIDA_CERRAR_ORDEN]'))
drop TRIGGER [dbo].[VALIDA_CERRAR_ORDEN] 
GO

 
 
 --ELIMINACION DE STORE PROCEDURE VERSIONES ANTERIORES A 9XXX

if exists (select * from dbo.sysobjects where id = object_id(N'[SESA_SP_CORRIGE_COMPROMETIDOS]'))
drop PROCEDURE SESA_SP_CORRIGE_COMPROMETIDOS  
GO 
 
 
if exists (select * from dbo.sysobjects where id = object_id(N'[SP_01_ORDEN_SERVICIOS]'))
drop PROCEDURE SP_01_ORDEN_SERVICIOS  
GO

 if exists (select * from dbo.sysobjects where id = object_id(N'[SP_01_VENTA_DE_SERVICIOS]'))
drop PROCEDURE SP_01_VENTA_DE_SERVICIOS  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[SP_01_VENTAS_CONCESIONARIOS]'))
drop PROCEDURE SP_01_VENTAS_CONCESIONARIOS  
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[SP_01_PRE_PROCESOS]'))
drop PROCEDURE SP_01_PRE_PROCESOS  
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[SP_C_01_PRE_PROCESOS]'))
drop PROCEDURE SP_C_01_PRE_PROCESOS  
GO








-- PARAMETROS DE AMBIENTE
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
  


  
CREATE PROCEDURE  [dbo].[SP_C_01_PRE_PROCESOS] @TipoDoc varchar(1), @NumeroD Varchar(10), @CodTercero Varchar(10), @Codusua Varchar(10),@Codoper Varchar(10)
--WITH ENCRYPTION
AS

 

-----------------------------------
-- DECLARACION DE VARIABLES 
-----------------------------------

-- Contenido de campos de safact_01
DECLARE --@TipoDOC varchar(1),
        --@NumeroD     varchar (10),
        @Placa       varchar(10),
        @Kilometraje int,
        @liquidacion Varchar(15),
        @status Varchar(15),
        @cierre_Or datetime,
        @apertura_or datetime,
        @OR varchar(10)
 
-- Contenido de campos safact_02
DECLARE @Modelo varchar(15),
        @Color varchar(20),
        @Serial_M varchar(20),
        @Serial varchar(20),
        @Vendido datetime,
        @concesionario Varchar(35)
       

-- Contenido de campos safact_03
DECLARE @vale varchar(10), 
        @DESPACHO varchar(10)


-- Contenido de campos Safact
DECLARE --@CODCLIE VARCHAR(10),SUSTITUIDO POR PARAMETRO @CODTERCERO.
        --@CODOPER VARCHAR(10),
        @DESCLIE VARCHAR(40),
        @CODVEND VARCHAR(10),
        @NOTAS1  VARCHAR(60),
        @NOTAS2  VARCHAR(60),
        @NOTAS3  VARCHAR(60),
        @NOTAS4  VARCHAR(60),
        @NOTAS5  VARCHAR(60),
        @NOTAS6  VARCHAR(60),
        @NOTAS7  VARCHAR(60),
        @NOTAS8  VARCHAR(60),
        @NOTAS9  VARCHAR(60),
        @NOTAS10 VARCHAR(60),
        @CodUbic VARCHAR(10),
        @Descrip1 VARCHAR(60),
        @Costo   DECIMAL(10,2),
        @Precio  DECIMAL(10,2),
        @FechaE  DATETIME,
        @FechaL  DATETIME,
        @LIQANT varchar(30),
        @FACT_AFEC VARCHAR(20),
        @MARCA VARCHAR(20),
        @ORDENC VARCHAR(30)       
      --@CODUSUA VARCHAR(60)
        
-- Contenido de saitemfac
DECLARE @CANTIDAD INT,
        @CODITEM  VARCHAR(20),
        @EXISTEN  INT       
               

-- Contenido de variables locales
DECLARE @STATUSERROR INT, -- SWICHE QUE SE ACTIVA
        @DESCRIPERROR VARCHAR(300), -- DESCRIBE EL MENSAJE DE ERROR
        @VEHICULO INT, -- DEFINE ACCION A TOMAR PARA EL REGISTRO DE VEHICULO
        @DescriModelo Varchar(40),
        @EsExento int,
        @CodInst varchar(10),
        @CODNVL VARCHAR(2),
        @NroLinea INT,
        @Coderr VARCHAR(10),
        @NROMAX INT,
        @NROREG INT,
        @total decimal(28,4),
        @totalg decimal(28,4)
        
        
        
DECLARE @CODVEH varchar(10)
DECLARE @Deposito varchar(10)
DECLARE @CodTaxs varchar(5)
DECLARE @Tmp_Codigo varchar (15)
DECLARE @Tmp_Serial varchar (35)
DECLARE @Tmp_Color varchar (25)
DECLARE @MontoIVA decimal (23,2)
DECLARE @EsPorct smallint
DECLARE @FechaHoy Datetime

 
BEGIN --TRY
    

-------------------------------------------
-- VALORES INICIALES ASISGNADOS
-------------------------------------------


SET @FechaHoy = getdate()
SET @STATUSERROR=0 --INICIALIZACION EN APAGADO DE SWICHE QUE MUESTRA ERROR EN PANTALLA
SET @NroLinea = 0
SET @CodInst='12'



-----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------

-- Recoge datos de la tabla: SAFACT_02
   SELECT --@TIPOFAC=TIPOFAC,
          --@NUMEROD=NUMEROD,
          @MODELO=UPPER(MODELO),
          @COLOR=UPPER(COLOR),
          @SERIAL=UPPER(SERIAL),
          @SERIAL_M=UPPER(SERIAL_M),
          @VENDIDO=ISNULL(VENDIDO,'01/01/2000'),
          @CONCESIONARIO=UPPER(VENDIO_CONCESIONARIO),
          @OR=Z_INTERNO
   FROM SAFACT_02 WHERE TIPOFAC=@TipoDoc AND NUMEROD=@NUMEROD

-- Recoge datos de la tabla: SAFACT_01
   SELECT @PLACA=UPPER(PLACA),
          @KILOMETRAJE=ISNULL(KILOMETRAJE,0),
          @LIQUIDACION=LIQUIDACION,
          @STATUS=STATUS,
          @CIERRE_OR=GETDATE(),
          @APERTURA_OR=APERTURA_OR
   FROM SAFACT_01 WHERE TIPOFAC=@TIPODOC AND NUMEROD=@NUMEROD
   
    
   -- Determina la liquidacion de la orden segun la primera letras
   BEGIN
     IF (UPPER(SUBSTRING(@Liquidacion,1,1)) = 'I') SET @Liquidacion = 'INTERNA'
     ELSE
     IF (UPPER(SUBSTRING(@Liquidacion,1,1)) = 'G') SET @Liquidacion = 'GARANTIA'
     ELSE
     IF (UPPER(SUBSTRING(@Liquidacion,1,1)) = 'C') SET @Liquidacion = 'CONTADO'
     ELSE
     IF (UPPER(SUBSTRING(@Liquidacion,1,1)) = 'A') SET @Liquidacion = 'ACCESORIO'
     ELSE 
     SET @Liquidacion = '???'
   END


   -- Determina el status de la orden de reparacion segun a la primera letra
   BEGIN
     IF (UPPER(SUBSTRING(@Status,1,1)) = 'P') or LEN(@Status) = 0 -- PENDIENTE O PROCESO
        SET @Status = 'PENDIENTE'
     ELSE
     IF (UPPER(SUBSTRING(@Status,1,1)) = 'C') -- CERRADA
        SET @Status = 'CERRADA'
     ELSE
     IF (UPPER(SUBSTRING(@Status,1,1)) = 'S') -- SUSPENSO EN ESPERA DE REPUESTOS.
        SET @Status = 'SUSPENSO'
   END


-- Recoge datos de la tabla: SAFACT
   SELECT --@CODCLIE = CODCLIE, -- SUSTITUIDO POR PARAMETRO DE ENTRADA @CODTERCERO
          --@CODOPER = CODOPER,
          @ORDENC = ORDENC,
          @CODVEND = CODVEND,
          @Deposito=CODUBIC,
          @LIQANT=notas10,
          @FACT_AFEC=NUMEROR, -- REFERIDO A DEVOLUCION DE FACTURAS
          @NOTAS1=NOTAS1,@NOTAS2=NOTAS2,@NOTAS3=NOTAS3,@NOTAS4=NOTAS4,@NOTAS5=NOTAS5,
          @NOTAS6=NOTAS6,@NOTAS7=NOTAS7,@NOTAS8=NOTAS8,@NOTAS9=NOTAS9,@NOTAS10=NOTAS10
          --@CODUSUA = CODUSUA  
          FROM SAFACT
          WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
    
   SELECT @DESCLIE = DESCRIP 
          FROM SACLIE WHERE CodClie=@CODTERCERO      
          
          
       
-- Recoge datos de la tabla: SSUSRS 
 SELECT @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WHERE CODUSUA=@CODUSUA  



 



--================================================
-- 101 - INICIO GESTIONA PREFACTURA DE VEHICULOS
--================================================
 IF @TipoDoc='G' AND @CODOPER='01-101'
 
  BEGIN
  
  -- 5 Valida que no se haya cargado la transaccion de una OR. 
  IF @OR IS NOT NULL OR @OR=@NumeroD
   BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01137'
     END  
  
    -- 3 Y 4 Valida DEPOSITO Y VENDEDOR validos solicitado  
      
   IF SUBSTRING(@CODVEND,1,2)<>'VE' 
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01106'
     END  
     
    IF  @DEPOSITO<>'010' 
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01105'
     END 
         
    -- 1. Valida usuario permitido 
   
   IF  Substring(@CODNVL,1,2)<>'4 ' 
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01098'
     END 
    
   -- MUESTRA PANTALLA CON RESULTADO DE VALIDACIONES SI LAS HAY.

   IF @STATUSERROR=1
   BEGIN
    EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR 
   END
   
   UPDATE SAFACT SET ORDENC='VEHICULO' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
    
END
--================================================
-- 101 - FIN GESTIONA PREFACTURA DE VEHICULO
--================================================

 

--================================================
-- 201 - INICIO GESTIONA PREFACTURA DE REPUESTOS MOSTRADOR
--================================================
IF @TIPODOC='G' AND @CODOPER='01-201'
 
 BEGIN
 -- 5 Valida que no se haya cargado la transaccion de una OR. 
  If @OR IS NOT NULL OR @OR=@NumeroD
   BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01137'
     END  
  
  -- 3 Y 4 Valida DEPOSITO Y VENDEDOR validos solicitado  
      
   IF SUBSTRING(@CODVEND,1,2)<>'RP' 
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01106'
     END  
     
    IF  @DEPOSITO<>'001' AND @Deposito<>'002'
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01105'
     END 
         
   -- 1. Valida usuario permitido 
   
   IF  Substring(@CODNVL,1,2)<>'9 ' 
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01098'
     END 
    
   -- MUESTRA PANTALLA CON RESULTADO DE VALIDACIONES SI LAS HAY.

   IF @STATUSERROR=1
   BEGIN
    EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR 
   END
   
   UPDATE SAFACT SET ORDENC='REPUESTO' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
 END 
--================================================
-- 201 - FIN GESTIONA PREFACTURA DE REPUESTOS - MOSTRADOR
--================================================





--================================================
-- 901 - INICIO GESTIONA PREFACTURA ANTIGUA DE GARANTIA 
--================================================
IF @TIPODOC='G' AND @CODOPER='01-901'
   UPDATE SAFACT SET ORDENC='GARANTIA' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
--================================================
-- 301 - FIN GESTIONA PREFACTURA ANTIGUA DE GARANTIA 
--================================================


 
 








END /* TRY

BEGIN CATCH

    DECLARE @ERRORNUMBER INT,
            @ERRORSEVERITY INT,
            @ERRORSTATE INT,
            @ERRORPROCEDURE NVARCHAR(128),
            @ERRORLINE INT,
            @ERRORMESSAGE NVARCHAR(200)



    SELECT
        @ERRORNUMBER=ERROR_NUMBER() 
        ,@ERRORSEVERITY=ERROR_SEVERITY() 
        ,@ERRORSTATE=ERROR_STATE() 
        ,@ERRORPROCEDURE=ERROR_PROCEDURE() 
        ,@ERRORLINE=ERROR_LINE() 
        ,@ERRORMESSAGE=ERROR_MESSAGE() 
           
      SET @DESCRIPERROR=' Error No.:'+STR(@ERRORNUMBER)+' Severidad:'+STR(@ERRORSEVERITY)+' Estado:'+STR(@ERRORSTATE)+' Objeto:'+@ERRORPROCEDURE+' Linea:'+STR(@ERRORLINE)+' Mensaje:'+@ERRORMESSAGE 
      
      
      
      RAISERROR (@DESCRIPERROR,16,1)
      ROLLBACK TRANSACTION
      RETURN
  
 
        
        
        
END CATCH;*/

GO





   