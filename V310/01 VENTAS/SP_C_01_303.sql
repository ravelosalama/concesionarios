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
-- Revisado, corregido y mejorado en Abril 2017 por: JOSE RAVELO: COMO:SP_C_01_303 PARA VERSION 9024+ V310
-- 23/04/2018: Ampliado el campo @costo y @precio para que entren valores altos por inflasión.
-- *****************************************************************************************

 
 

if exists (select * from dbo.sysobjects where id = object_id(N'[SP_C_01_303]'))
drop PROCEDURE SP_C_01_303  
GO


-- PARAMETROS DE AMBIENTE
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
  
  
CREATE PROCEDURE  [dbo].[SP_C_01_303] @TipoDoc varchar(1), @NumeroD Varchar(20), @CodTercero Varchar(10), @Codusua Varchar(10),@Codoper Varchar(10)
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
 

-- Contenido de campos safact_03
DECLARE @vale varchar(10), 
        @DESPACHO varchar(10)


-- Contenido de campos Safact
DECLARE --@CODCLIE VARCHAR(10),SUSTITUIDO POR PARAMETRO @CODTERCERO.
        --@CODOPER VARCHAR(10),
          @CODVEND VARCHAR(10),
          @Descrip1 VARCHAR(60),
          @Costo   DECIMAL(28,3),
          @Precio  DECIMAL(28,3),
          @FechaE  DATETIME,
          @FechaL  DATETIME
        --@CODUSUA VARCHAR(60)
        
-- Contenido de saitemfac
DECLARE @CANTIDAD INT,
        @CODITEM  VARCHAR(20),
        @EXISTEN  INT
         
               

-- Contenido de variables locales
DECLARE @STATUSERROR INT, -- SWICHE QUE SE ACTIVA
        @DESCRIPERROR VARCHAR(300), -- DESCRIBE EL MENSAJE DE ERROR
        @CODNVL VARCHAR(2),
        @NroLinea INT,
        @CANTPROD INT, -- CANTIDAD TOTAL DE UN PRODUCTO DESPACHADOS EN DESPACHOS VIVOS SOBRE OR VIVAS     
        @STOCK INT    --  STOCK DE UN PRODUCTO EN SAPROD  
                
 
DECLARE @Deposito varchar(10)  
DECLARE @ODEPOSITO Varchar(10)
 
BEGIN -- TRY
    

-------------------------------------------
-- VALORES INICIALES ASISGNADOS
-------------------------------------------

 
SET @STATUSERROR=0 --INICIALIZACION EN APAGADO DE SWICHE QUE MUESTRA ERROR EN PANTALLA
SET @NroLinea = 0
 



-----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------

    
-- Recoge datos de la VISTA:VW_MASTER_TRANSAC_01
   SELECT TOP 1
          @CODVEND = CODVEND,
          @Deposito=CODUBIC
          FROM VW_MASTER_TRANSAC_01 WITH (NOLOCK) WHERE TIPOFAC=@TipoDoc AND NUMEROD=@NUMEROD
        
-- Recoge datos de la tabla: SSUSRS 
 SELECT TOP 1 @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WITH (NOLOCK) WHERE CODUSUA=@CODUSUA  

 


--===================================================
-- 303 - INICIO GESTIONA DESPACHOS A TALLER 
--===================================================

IF @TipoDoc='F' AND @Codoper='01-303' 

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
    
    -- 8. Valida si se ha cargado un vale valido en esta transaccion.   
    IF NOT EXISTS (SELECT TOP 1 * FROM SAFACT WITH (NOLOCK) WHERE (NUMEROD=@vale AND TIPOFAC='F' AND CodOper='01-302'))
       BEGIN
          SET @STATUSERROR=1
          SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01124'
          EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
       END
  
    -- 7. Valida si el Vale ya fue procesado. -- OJO ESTA VALIDACION PUDIERA CAMBIAR SI SE PERMITE VARIOS DESPACHOS DE UN SOLO VALE.
     IF   @DESPACHO<>'0'  
       BEGIN
          SET @STATUSERROR=1
          SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01139'
          EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
       END
    
   -- 5 y 6. Valida OR citada en el vale exista en BD y este correcta.
   
   IF EXISTS (SELECT TOP 1 * FROM SAFACT_01 WITH (NOLOCK) WHERE (NUMEROD=@OR AND TIPOFAC='G'))
    BEGIN
     SELECT TOP 1 @liquidacion=Liquidacion,@status=Status FROM SAFACT_01 WITH (NOLOCK) WHERE (NUMEROD=@OR AND TIPOFAC='G')
      -- valida codigo de cliente segun tipo de orden segun los clientes validos en despacho.
      IF (@liquidacion='CONTADO' AND @CodTercero<>'990011') OR (@liquidacion='GARANTIA' AND @CodTercero<>'990022')OR (@liquidacion='INTERNA' AND @CodTercero<>'990033')OR (@liquidacion='ACCESORIO' AND @CodTercero<>'990044')
      BEGIN
        SET @STATUSERROR=1
        SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01104'
        EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
       END
      IF (@status<>'PENDIENTE')
       BEGIN
        SET @STATUSERROR=1
        SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01107'
        EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
       END
     END
    ELSE      
     BEGIN
       SET @STATUSERROR=1
       SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01103'
       EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END  
   
     -- 3 Y 4 Valida DEPOSITO Y VENDEDOR validos solicitado  
     
   SELECT TOP 1 @DEPOSITO=CODUBIC, @CODVEND=CodVend FROM SAFACT WITH (NOLOCK) WHERE NumeroD=@NumeroD AND TipoFac=@TIPODOC  
   IF SUBSTRING(@CODVEND,1,3)<>'ALM' 
     BEGIN
       SET @STATUSERROR=1
       SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01106'
       EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR 
     END  
     
    IF  @DEPOSITO<>'001' -- OJO ESTE DEPOSITO ES EL PREDETERMINADO DEL DOCUMENTO, NO EL DEL CADA ITEM 
     BEGIN
       SET @STATUSERROR=1
       SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01105'
       EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END     
     
    
    -- 2. Valida Cliente permitido segun las 4 tipos de Liquidacion Y ROL DE usuario.  
   IF @CodTercero<>'990011' AND @CodTercero<>'990022' AND @CodTercero<>'990033' AND  @CodTercero<>'990044' 
     BEGIN
        SET @STATUSERROR=1
        SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01108'
        EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END   
     
    
   -- 1. Valida usuario permitido 
    
   IF  Substring(@CODNVL,1,2)<>'19' 
     BEGIN
       SET @STATUSERROR=1
       SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01101'
       EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END  
  
  
 -------------------------------------
-- PROCESO DE LA SECCIÓN
--------------------------------------
 
 IF @STATUSERROR=0
    
    BEGIN
     
     
      -- CURSOR 1: Reversa cantidades trasladadas en otros procesos desde almacenes hasta el taller sobre la OR. y viceversa, en funcion a todos los despachos vivos, menos el despacho de este proceso, manejado desde una vista.
     
      DECLARE MIREG SCROLL CURSOR FOR
      SELECT  CODITEM,CODUBIC,CANTIDAD
         FROM VW_C_DESPACHOS_VIVOS  
         WHERE Nro_OR = @OR AND NUMEROD<>@NUMEROD
        
          
      OPEN MIREG
      FETCH NEXT FROM MIREG INTO @CODITEM,@ODEPOSITO,@CANTIDAD
      WHILE (@@FETCH_STATUS = 0) 
      BEGIN
         
                
       UPDATE SAEXIS SET EXISTEN=EXISTEN+@CANTIDAD WHERE CODPROD=@CODITEM AND CODUBIC=@ODEPOSITO
       UPDATE SAEXIS SET EXISTEN=EXISTEN-@CANTIDAD WHERE CODPROD=@CODITEM AND CODUBIC='301'
       
       FETCH NEXT FROM MIREG INTO @CODITEM,@ODEPOSITO,@CANTIDAD
      END
      CLOSE MIREG
      DEALLOCATE MIREG
          
      -- MARCAS CRUZADAS 
         
        UPDATE SAFACT_03 SET DESPACHO=@NUMEROD WHERE (TipoFac = 'F' and NumeroD = @NumeroD)
        UPDATE SAFACT_03 SET DESPACHO=@NUMEROD WHERE (TipoFac = 'F' and NumeroD = @vale)
        UPDATE SAFACT    SET ORDENC='VALE DESPACHADO:'+@NumeroD, Descrip='VALE DESPACHADO:'+@NumeroD WHERE (TipoFac = 'F' and NumeroD = @vale)
        UPDATE SAFACT    SET ORDENC='DESPACHO DEL VALE:'+@VALE, Descrip='DESPACHO DEL VALE:'+@VALE WHERE (TipoFac = 'F' and NumeroD = @NumeroD) 
     
 
      -- Borra items de repuestos de la OR para recargarlos en base a despachos vivos
      DELETE dbo.SAITEMFAC
      WHERE (TipoFac = 'G' AND NumeroD = @OR AND EsServ = 0)
      
      
      
      -- CURSOR 2: Inserta en la OR los repuestos en despachos vivos relacionados con la OR 
      DECLARE MIREG SCROLL CURSOR FOR
      SELECT DISTINCT CodItem,Descrip1,Costo,Precio,FechaE,FechaL,Codubic
         FROM VW_C_DESPACHOS_VIVOS
         WHERE NRO_OR=@OR
      OPEN MIREG
      FETCH NEXT FROM MIREG INTO @CodItem,@Descrip1,@Costo,@Precio,@FechaE,@FechaL,@ODEPOSITO
      WHILE (@@FETCH_STATUS = 0) 
      BEGIN
             
            -- Valida si se intenta despachar el comodin generico R99999  
           IF @CODITEM='R99999' 
            BEGIN
              CLOSE MIREG
              DEALLOCATE MIREG
              SELECT @DESCRIPERROR=DESCRIPCION+' '+@CODITEM FROM SA_CERROR WHERE CODERR='01138'
              RAISERROR (@DESCRIPERROR,16,1)
              ROLLBACK TRANSACTION
              RETURN
            END        
     
             -- Valida si se intenta sacar productos del almacen 301 - TALLER 
         IF @ODEPOSITO='301'
            BEGIN
              CLOSE MIREG
              DEALLOCATE MIREG
              SELECT @DESCRIPERROR=DESCRIPCION+' '+@CODITEM FROM SA_CERROR WHERE CODERR='01148'
              RAISERROR (@DESCRIPERROR,16,1)
              ROLLBACK TRANSACTION
              RETURN
            END   
         
         -- Agrega el registro del producto sobre la OR si este no existe en la misma.
         IF NOT EXISTS (SELECT * FROM SAITEMFAC WHERE (NUMEROD=@OR AND TIPOFAC='G' AND CodItem=@CODITEM ))
         BEGIN     
         -- Determina la cantidad de repuestos despachados entre todos los almacenes y todos los despachos vivos asociados a esa OR 
         SELECT @CANTPROD = SUM(Cantidad)
            FROM VW_C_DESPACHOS_VIVOS  
            WHERE Nro_OR = @OR AND CodItem = @CodItem 
           
         -- Determina el proximo nro de linea   -- V310 SE AGREGA FUNCION MAX() PARA MEJORAR CALCULO Y EVITA ERROR DE PRIMARY KEY.
         SELECT @NroLinea = MAX(NroLinea) + 1
            FROM  dbo.SAITEMFAC
            WHERE (TipoFac = 'G' and NumeroD = @OR)
                  
         -- Inserta item de repuesto en la OR.
         INSERT dbo.SAITEMFAC (TipoFac, NumeroD, CodItem, NroLinea, CodUbic, Descrip1, Costo, Cantidad, Precio, Signo, FechaE, FechaL, Descrip10)
         VALUES ('G', @OR, @CodItem, @NroLinea, '301', @Descrip1, @Costo, @CANTPROD, @Precio, 1, @FechaE, @FechaL,@ODEPOSITO)
         
         -- Crea el regitro del producto en almacen taller sino existe.
         IF NOT EXISTS (SELECT * FROM SAEXIS WHERE (CODPROD=@CODITEM and CodUbic='301'))
         INSERT SAEXIS (Codprod,CodUbic, Existen,ExUnidad,CantPed,UnidPed,CantCom,UnidCom)
         VALUES (@Coditem,'301',0,0,0,0,0,0)
         END
         
         
               
         FETCH NEXT FROM MIREG INTO @CodItem,@Descrip1,@Costo,@Precio,@FechaE,@FechaL,@ODEPOSITO
      END
      CLOSE MIREG
      DEALLOCATE MIREG
   
   
   
   -- CURSOR 3: Reconstruye cantidades trasladadas en todos los despachos desde almacenes hasta el taller y viceversa relacionados con la OR., manejado desde una vista INCLUYENDO EL DESPACHO OJETO DE ESTA TRANSACCION.
      DECLARE @DESBORDE DECIMAL (28,3)
      DECLARE MIREG SCROLL CURSOR FOR
      SELECT  CODITEM,CODUBIC,CANTIDAD
         FROM VW_C_DESPACHOS_VIVOS  
         WHERE Nro_OR = @OR  
          
      OPEN MIREG
      FETCH NEXT FROM MIREG INTO @CODITEM,@ODEPOSITO,@CANTIDAD
      WHILE (@@FETCH_STATUS = 0) 
      BEGIN
      
      
      -- Valida stock del Item procesado en el almacen desde donde se intenta extraer.
       SELECT @EXISTEN=EXISTEN FROM SAEXIS WHERE CodProd=@CODITEM AND CodUbic=@ODEPOSITO
       IF @EXISTEN>=@CANTIDAD
           BEGIN    
              UPDATE SAEXIS SET EXISTEN=EXISTEN-@CANTIDAD WHERE CODPROD=@CODITEM AND CODUBIC=@ODEPOSITO
              UPDATE SAEXIS SET EXISTEN=EXISTEN+@CANTIDAD WHERE CODPROD=@CODITEM AND CODUBIC='301'
           END
       ELSE 
       
           BEGIN
               SELECT @DESCRIPERROR=DESCRIPCION
                                   +@CODITEM
                                   +' Cantidad:'
                                   +STR(@CANTIDAD)
                                   +', Existencia:'
                                   +STR(@EXISTEN)
                                   +' EN:'
                                   +@ODEPOSITO 
                                   FROM SA_CERROR WHERE CODERR='01125'
              RAISERROR (@DESCRIPERROR,16,1)
              ROLLBACK TRANSACTION
              RETURN
             END
       
       
       FETCH NEXT FROM MIREG INTO @CODITEM,@ODEPOSITO,@CANTIDAD
      END
      CLOSE MIREG
      DEALLOCATE MIREG
   
     
   END  
     
END

--=====================================================================================================
--                     303 - FIN GESTIONA DESPACHOS A TALLER 
--=====================================================================================================

  
END --TRY
 /*
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
           
      SET @DESCRIPERROR=' Error No.:'+STR(@ERRORNUMBER)+' Sev:'+STR(@ERRORSEVERITY)+' Estado:'+STR(@ERRORSTATE)+' Objeto:'+@ERRORPROCEDURE+' Lin:'+STR(@ERRORLINE)+' Mene:'+@ERRORMESSAGE +'Cd:'+@CODITEM
      
      
      
      RAISERROR (@DESCRIPERROR,16,1)
      ROLLBACK TRANSACTION
      RETURN
  
 
        
        
        
END CATCH; */


GO




 