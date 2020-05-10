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
DECLARE @ODEPOSITO Varchar(10)
 
BEGIN -- TRY
    

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

    
-- Recoge datos de la VISTA:VW_MASTER_TRANSAC_01
   SELECT TOP 1
          @MODELO=UPPER(MODELO), -- safact_02
          @COLOR=UPPER(COLOR),
          @SERIAL=UPPER(SERIAL),
          @SERIAL_M=UPPER(SERIAL_M),
          @VENDIDO=ISNULL(VENDIDO,'01/01/2000'),
          @CONCESIONARIO=UPPER(VENDIO_CONCESIONARIO),
          @OR=Z_INTERNO,
          @PLACA=UPPER(PLACA), -- safact_01
          @KILOMETRAJE=ISNULL(KILOMETRAJE,0),
          @LIQUIDACION=LIQUIDACION,
          @STATUS=STATUS,
          @CIERRE_OR=GETDATE(),
          @APERTURA_OR=APERTURA_OR,
          @ORDENC = ORDENC,
          @CODVEND = CODVEND,
          @Deposito=CODUBIC,
          @LIQANT=notas10,
          @FACT_AFEC=NUMEROR, -- REFERIDO A DEVOLUCION DE FACTURAS
          @NOTAS1=NOTAS1,@NOTAS2=NOTAS2,@NOTAS3=NOTAS3,@NOTAS4=NOTAS4,@NOTAS5=NOTAS5,
          @NOTAS6=NOTAS6,@NOTAS7=NOTAS7,@NOTAS8=NOTAS8,@NOTAS9=NOTAS9,@NOTAS10=NOTAS10,
          @DESCLIE =Desclie
          FROM VW_MASTER_TRANSAC_01 WITH (NOLOCK) WHERE TIPOFAC=@TipoDoc AND NUMEROD=@NUMEROD
    
    
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
  
        -- MARCAS CRUZADAS 
         
        UPDATE SAFACT_03 SET DESPACHO=@NUMEROD WHERE (TipoFac = 'F' and NumeroD = @NumeroD)
        UPDATE SAFACT_03 SET DESPACHO=@NUMEROD WHERE (TipoFac = 'F' and NumeroD = @vale)
        UPDATE SAFACT    SET ORDENC='VALE DESPACHADO:'+@NumeroD, Descrip='VALE DESPACHADO:'+@NumeroD WHERE (TipoFac = 'F' and NumeroD = @vale)
        UPDATE SAFACT    SET ORDENC='DESPACHO DEL VALE:'+@VALE, Descrip='DESPACHO DEL VALE:'+@VALE WHERE (TipoFac = 'F' and NumeroD = @NumeroD)  


      -- Reversa cantidades trasladadas en otros procesos (G) desde almacen principal al taller sobre la OR. y viceversa.
      
      -- DESCRIP10 ALMACENA EL CODIGO DE ALMACEN ORIGINAL DESDE DONDE SALIO EL PRODUCTO POR 1RA VEZ. 
      -- SOLUCION PARA CONTROLAR VARIOS ALMACENES. 
      UPDATE SAEXIS SET Existen=Existen+x.cantidad FROM SAITEMFAC X INNER JOIN SAEXIS Y ON X.CodItem=Y.CodProd 
      WHERE (X.TipoFac = 'G' AND X.NumeroD = @OR AND X.EsServ = 0 AND Y.CodUbic=X.Descrip10) 
            
      
      UPDATE SAEXIS SET Existen=Existen-x.cantidad FROM SAITEMFAC X INNER JOIN SAEXIS Y ON X.CodItem=Y.CodProd 
      WHERE (X.TipoFac = 'G' AND X.NumeroD = @OR AND X.EsServ = 0 AND Y.CodUbic='301')  
  
      
      -- Borra items de repuestos de la OR para recargarlos en base a despachos vivos
      DELETE dbo.SAITEMFAC
      WHERE (TipoFac = 'G' AND NumeroD = @OR AND EsServ = 0)

      -- Inserta en la OR los repuestos en despachos vivos relacionados con la OR 
      DECLARE MIREG SCROLL CURSOR FOR
      SELECT DISTINCT X.CodItem
         FROM dbo.SAITEMFAC AS X
         INNER JOIN dbo.SAFACT_03 AS Y
         ON (X.TipoFac = Y.TipoFac and X.NumeroD = Y.NumeroD) INNER JOIN SAFACT AS Z
         ON X.TIPOFAC=Z.TIPOFAC AND X.NUMEROD=Z.NUMEROD 
         WHERE X.TipoFac = 'F' AND Y.Nro_OR = @OR AND Z.Codoper='01-303' AND (Z.NUMEROR IS NULL OR Z.NUMEROR='')
      OPEN MIREG
      FETCH NEXT FROM MIREG INTO @CodItem
      WHILE (@@FETCH_STATUS = 0) 
      BEGIN
 
         -- Determina el proximo nro de linea
         SELECT @NroLinea = NroLinea + 1
            FROM  dbo.SAITEMFAC
            WHERE (TipoFac = 'G' and NumeroD = @OR)
 
         -- Determina la cantidad del repuesto entregado
         SELECT @Cantidad = SUM(X.Cantidad)
            FROM  dbo.SAITEMFAC AS X
            INNER JOIN dbo.SAFACT_03 AS Y
            ON (X.TipoFac = Y.TipoFac and X.NumeroD = Y.NumeroD) INNER JOIN SAFACT AS Z
            ON X.TIPOFAC=Z.TIPOFAC AND X.NUMEROD=Z.NUMEROD
            WHERE X.TipoFac = 'F' and Y.Nro_OR = @OR and X.CodItem = @CodItem AND (Z.NUMEROR IS NULL OR Z.NUMEROR='')AND Z.Codoper='01-303'
           
      
         -- Lee Costo y precio del item pedido.
         SELECT @Descrip1 = X.Descrip1,
                @Costo    = X.Costo,
                @Precio   = X.Precio,
                @FechaE   = X.FechaE,
                @FechaL   = X.FechaL,
                @ODEPOSITO= X.Codubic 
            FROM  dbo.SAITEMFAC AS X
            INNER JOIN dbo.SAFACT_03 AS Y
            ON (X.TipoFac = Y.TipoFac and X.NumeroD = Y.NumeroD) INNER JOIN SAFACT AS Z
            ON X.TIPOFAC=Z.TIPOFAC AND X.NUMEROD=Z.NUMEROD
            WHERE X.TipoFac = 'F' and Y.Nro_OR = @OR and X.CodItem = @CodItem AND (Z.NUMEROR IS NULL OR Z.NUMEROR='')AND Z.Codoper='01-303'
            
         
         
         -- ***OJO*** REVISAR EN FRIO ESTAS VALIDACIONES Y Y BREAK QUE INCURRE QUE REALMENTE HAGA EL ROLLBACK
         
         -- Valida si se intenta sacar productos del almacen 301 - TALLER 
         IF @ODEPOSITO='301'
            BEGIN
              CLOSE MIREG
              DEALLOCATE MIREG
              SELECT @DESCRIPERROR=DESCRIPCION+' '+@CODITEM FROM SA_CERROR WHERE CODERR='01148'
              EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR 
            END 
         
         -- Valida si la cantidad de articulos a despachar es mayor a la existente en almacen.     
         SELECT @EXISTEN=Existen FROM SAEXIS WHERE CodProd=@CODITEM AND (CodUbic=@ODEPOSITO)
         IF @CANTIDAD>@EXISTEN
            BEGIN
              CLOSE MIREG
              DEALLOCATE MIREG
              SELECT @DESCRIPERROR=DESCRIPCION+' '+@CODITEM FROM SA_CERROR WHERE CODERR='01125'
              EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR 
            END 
         
         -- Valida si se intenta despachar el comodin generico R9999  
           IF @CODITEM='R9999' 
            BEGIN
              CLOSE MIREG
              DEALLOCATE MIREG
              SELECT @DESCRIPERROR=DESCRIPCION+' '+@CODITEM FROM SA_CERROR WHERE CODERR='01138'
              EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR 
            END 
            
         -- Inserta item de repuesto en la OR.
         INSERT dbo.SAITEMFAC (TipoFac, NumeroD, CodItem, NroLinea, CodUbic, Descrip1, Costo, Cantidad, Precio, Signo, FechaE, FechaL, Descrip10)
         VALUES ('G', @OR, @CodItem, @NroLinea, '301', @Descrip1, @Costo, @Cantidad, @Precio, 1, @FechaE, @FechaL,@ODEPOSITO)
         
         IF NOT EXISTS (SELECT * FROM SAEXIS WHERE (CODPROD=@CODITEM and CodUbic='301'))
         INSERT SAEXIS (Codprod,CodUbic, Existen,ExUnidad,CantPed,UnidPed,CantCom,UnidCom)
         VALUES (@Coditem,'301',0,0,0,0,0,0)
         
         -- Traslada stock reconstruido del Almacen principal al taller del repuesto procesado
         UPDATE SAEXIS SET Existen=Existen-@CANTIDAD where CodProd=@CODITEM and CodUbic=@ODEPOSITO
         UPDATE SAEXIS SET Existen=Existen+@CANTIDAD where CodProd=@CODITEM and CodUbic='301'
         

         FETCH NEXT FROM MIREG INTO @CodItem
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





   