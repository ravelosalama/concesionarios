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
-- Revisado y mejorado en Abril 2017 en V310. Por:JOSE RAVELO
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


if exists (select * from dbo.sysobjects where id = object_id(N'[SP_C_01_302]'))
drop PROCEDURE SP_C_01_302  
GO

 

-- PARAMETROS DE AMBIENTE
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
  


  
CREATE PROCEDURE  [dbo].[SP_C_01_302] @TipoDoc varchar(1), @NumeroD Varchar(10), @CodTercero Varchar(10), @Codusua Varchar(10),@Codoper Varchar(10)
--WITH ENCRYPTION
AS

 

-----------------------------------
-- DECLARACION DE VARIABLES 
-----------------------------------

-- Contenido de campos de safact_01
DECLARE --@TipoDOC varchar(1),
        --@NumeroD     varchar (10),
        @liquidacion Varchar(15),
        @status Varchar(15),
        @OR varchar(10)
 
-- Contenido de campos safact_02
DECLARE @Modelo varchar(15),
        @Serial varchar(20)
        
   
-- Contenido de campos safact_03
DECLARE @vale varchar(10), 
        @DESPACHO varchar(10),
        @PRESUPUESTO VARCHAR(10)

-- Contenido de campos Safact
DECLARE --@CODCLIE VARCHAR(10),SUSTITUIDO POR PARAMETRO @CODTERCERO.
        --@CODOPER VARCHAR(10),
        @DESCLIE VARCHAR(40),
        @CODVEND VARCHAR(10)   
      --@CODUSUA VARCHAR(60)
                

-- Contenido de variables locales
DECLARE @STATUSERROR INT, -- SWICHE QUE SE ACTIVA
        @DESCRIPERROR VARCHAR(300), -- DESCRIBE EL MENSAJE DE ERROR
        @CODNVL VARCHAR(2)
DECLARE @Deposito varchar(10)
  
BEGIN --TRY
     

-------------------------------------------
-- VALORES INICIALES ASISGNADOS
-------------------------------------------

SET @STATUSERROR=0 --INICIALIZACION EN APAGADO DE SWICHE QUE MUESTRA ERROR EN PANTALLA
 
 -----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------
 


-- Recoge datos de la tabla: SAFACT
   SELECT --@CODCLIE = CODCLIE, -- SUSTITUIDO POR PARAMETRO DE ENTRADA @CODTERCERO
          --@CODOPER = CODOPER,
            @CODVEND = CODVEND,
            @Deposito=CODUBIC
          --@CODUSUA = CODUSUA  
            FROM SAFACT WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
    
   SELECT @DESCLIE = DESCRIP 
          FROM SACLIE WHERE CodClie=@CODTERCERO      
          
          
       
-- Recoge datos de la tabla: SSUSRS 
   SELECT @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WHERE CODUSUA=@CODUSUA  



--===================================================
-- 302 - INICIO GESTIONA VALES DE TALLER AL ALMACEN
--===================================================

IF @TipoDoc='F' AND @Codoper='01-302' 

BEGIN

---------------------    
-- VALIDACIONES
--------------------- 
    
    SELECT TOP 1 @OR=isnull(Nro_OR,0),@vale=isnull(Vale,0),@DESPACHO=ISNULL(Despacho,0) FROM SAFACT_03 WITH (NOLOCK) WHERE NumeroD=@NumeroD AND TipoFac='F'

  -- 9. Valida si el Vale contiene un valor errado en el campo despacho de safact_03 (ESPACIO EN BLANCO).
     IF   @DESPACHO LIKE '% %'  
       BEGIN
          SET @STATUSERROR=1
          SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01157'
          EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
       END
 
   -- 5, 6 Y 7. Valida OR citada en el vale exista en BD, CodClie valido y Satatus pendiente. 
  
  
    IF EXISTS (SELECT * FROM SAFACT_01 WHERE (NUMEROD=@OR AND TIPOFAC='G')) 
    BEGIN
      SELECT @liquidacion=Liquidacion,@status=Status FROM SAFACT_01 WHERE (NUMEROD=@OR AND TIPOFAC='G')
      IF (@liquidacion='CONTADO' AND @CodTercero<>'99001') OR (@liquidacion='GARANTIA' AND @CodTercero<>'99002')OR (@liquidacion='INTERNA' AND @CodTercero<>'99003')OR (@liquidacion='ACCESORIO' AND @CodTercero<>'99004') -- VALIDA CLIENTE - TRANSACCION VALIDA.
       BEGIN
          SET @STATUSERROR=1
          SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01104'
          EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
       END
      IF (@status<>'PENDIENTE') -- PROCESA SOBRE OR PENDIENTE UNICAMENTE.
       BEGIN
          SET @STATUSERROR=1
          SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01107'
          EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
       END
     END
    ELSE      
     BEGIN
         SET @STATUSERROR=1
         SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01103'
         EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END  
   
     -- 3 Y 4 Valida DEPOSITO Y VENDEDOR validos solicitado  
  
    
   IF SUBSTRING(@CODVEND,1,3)<>'TAL' 
     BEGIN
        SET @STATUSERROR=1
        SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01106'
        EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END  
     
    IF  @DEPOSITO<>'001' 
     BEGIN
        SET @STATUSERROR=1
        SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01105'
        EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END               
     
    -- 2. Valida Cliente permitido segun las 4 tipos de Liquidacion.  
   IF @CodTercero<>'99001' AND @CodTercero<>'99002' AND @CodTercero<>'99003' AND  @CodTercero<>'99004' 
     BEGIN
       SET @STATUSERROR=1
       SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01102'
       EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END   
     
    
   -- 1. Valida usuario permitido 
  
   IF  Substring(@CODNVL,1,2)<>'13' 
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01101'
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END  
     
  --------------------------------------
  -- PROCESO DEL OBJETO
  --------------------------------------
  
IF @STATUSERROR=0
   BEGIN
  
 -- COLOCA NUEMRO DEL DOCUMENTO EMITIDO EN ESTE PROCESO (VALE) EN EL CAMPO ADICIONL PARA POSTERIOR RECUPERACION EN DESPACHO
 UPDATE SAFACT_03 SET VALE=@NUMEROD WHERE (TipoFac = 'F' and NumeroD = @NumeroD) 
 
 -- COLOCA EL CODIGO DEL MODELO Y EL SERIAL EN NOTAS 4 DEL VALE PARA QUE EL ALMACENISTA PUEDA EVALUAR REPUESTO ADECUADO.
 SELECT @Serial=SERIAL,@Modelo=Modelo FROM SAFACT_02 WHERE (NUMEROD=@OR AND TIPOFAC='G')
 UPDATE SAFACT SET DESCRIP=DESCRIP+':'+@OR, OrdenC='PENDIENTE', NOTAS4=@SERIAL+' '+@MODELO WHERE NUMEROD=@NumeroD AND TIPOFAC='F'

 -- COLOCA EN LA DESCRIPCION DE LA TORRE DE CONTROL DEL DOCUMENTO PRECURSOR
 SELECT @PRESUPUESTO=ONUMERO FROM SAITEMFAC WHERE NumeroD=@NumeroD AND TipoFac='F'
 UPDATE SAFACT SET Descrip=Descrip+' ACTIVADO/VALE:'+@NumeroD WHERE NumeroD=@PRESUPUESTO AND TipoFac='F'
 -- SE PUEDE MEJORAR ESTA MARCA BUSCANDO ALGUN BLOQUEO DEL DOCUMENTO PARA QUE NO PUEDA SER USADO MAS DE UNA VEZ.
 -- ESTE UPDATE SOLO MARCA EL DOCUMENTO COMO PROCESADO, PERO NO LO BLOQUEA.
  
  END


END
--=====================================================================================================
--                      302 - FIN GESTIONA VALES TALLER AL ALMACEN 
--=====================================================================================================
 

END /*TRY

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





   