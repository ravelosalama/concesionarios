-- ********************************************************************************
-- TG ORIGINAL INSERT_FACTURA SOBRE SATAXVTA, SE SUSTITUYE POR:
-- TG_01_INSERT_PROCESADAS EN MAY 2016 POR: JOSE RAVELO PARA VERSIONES SUPERIORES A 9XXX
-- EL TG SE GENERA AQUI POR SER ULTIMA TABLA EN ACTUALIZARSE EN EL PROCESO DE GENERACION DE FACTURA.
-- Y REALIZA CRUCES DE REFERENCIAS PARA CIERRES DE TRANSACCIONES Y MEJORAR BUSQUEDAS. 
-- 
-- ********************************************************************************
-- *****************************************************************************************
-- NUEVO PROCEDIMIENTO ALMACENADO DESDE EL SENSOR NUEVO SAITEMFAC EN MAYO 2016
-- PROCESA TODAS LAS OPCIONES TIPODOC (A Y B) DE FACTURACION EN VENTAS DE LOS CONCESIONARIOS

-- <<<<<<<<<<<<<< 301 - SERVICIOS: FACTURA Y DEVOLUCION >>>>>>>>>>>>>>>>>>>>>
-- <<<<<<<<<<<<<< 201 - REPUESTOS: FACTURA Y DEVOLUCION >>>>>>>>>>>>>>>>>>>>>
-- <<<<<<<<<<<<<< 101 - VEHICULOS: FACTURA Y DEVOLUCION >>>>>>>>>>>>>>>>>>>>>
 
-- revisado ene-2013 JOSE RAVELO SOBRE LIBERTYLABORATORIO ANTES COMO INSERTA_ORDEN Y ANTES COMO:TG_GESTIONA_ESPERA
-- Regenerado en Marzo 2016 por: JOSE RAVELO COMO:SP_01_VENTAS_CONCESIONARIOS LUEGO SE SUBDIVIDE Y SE 
-- Regenera   en Mayo  2016 por: JOSE RAVELO COMO:SP_01_PROCESADAS
-- Mejorado en Abril 2017 por: JOSE RAVELO COMO:SP_01_PROCESADAS EN V310
-- Actualizado en 25 Septiembre 2017 inclusion decreto 3085 descuento en IVA por pagos electronicos.
-- Actualizado el 27 de Septiembre 2017, se agrega en validacion de medios electronicos, anticipos,  y credito. y se agregan contribuyentes especiales
-- ES LLAMADO POR: TG_C_MASTER

-- *****************************************************************************************
 
--ELIMINACION DE TRIGGERS VERSIONES ANTERIORES A 9XXX
if exists (select * from dbo.sysobjects where id = object_id(N'[INSERT_FACTURAS_VEHICULOS]'))
drop TRIGGER INSERT_FACTURAS_VEHICULOS  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TG_01_REFERENCIAS_CRUZADAS]'))
drop TRIGGER TG_01_REFERENCIAS_CRUZADAS  
GO


-- PARAMETROS DE AMBIENTE
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
  
 
 --ELIMINACION DE STORE PROCEDURE VERSIONES ANTERIORES A 9XXX
if exists (select * from dbo.sysobjects where id = object_id(N'[SP_01_ORDEN_SERVICIOS]'))
drop PROCEDURE SP_01_ORDEN_SERVICIOS  
GO

 if exists (select * from dbo.sysobjects where id = object_id(N'[SP_01_VENTA_DE_SERVICIOS]'))
drop PROCEDURE SP_01_VENTA_DE_SERVICIOS  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[SP_01_VENTAS_CONCESIONARIOS]'))
drop PROCEDURE SP_01_VENTAS_CONCESIONARIOS  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[SP_01_PROCESADAS]'))
drop PROCEDURE SP_01_PROCESADAS  
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[SP_C_01_PROCESADAS]'))
drop PROCEDURE SP_C_01_PROCESADAS  
GO


  
CREATE PROCEDURE  SP_C_01_PROCESADAS @TipoDoc varchar(1), @NumeroD Varchar(10), @CodTercero Varchar(10), @Codusua Varchar(10),@Codoper Varchar(10)
--WITH ENCRYPTION
AS


-----------------------------------
-- DECLARACION DE VARIABLES 
-----------------------------------

-- Contenido de campos de safact_01
DECLARE --@TipoDOC     varchar (1),
        -- @NumeroD     varchar (10),
        @Placa       varchar(10),
        @OR varchar(10)
 
-- Contenido de campos safact_02
DECLARE @Modelo varchar(15),
        @Color varchar(20),
        @Serial varchar(20),
        @concesionario Varchar(35)
   

-- Contenido de campos Safact
DECLARE -- @CODCLIE VARCHAR(10),
        -- @CODOPER VARCHAR(10),
        @DESCLIE VARCHAR(40),
        @CODVEND VARCHAR(10),
        @DOC_AFEC VARCHAR(10),
        @NUMEROO VARCHAR(10),
        -- @CODUSUA VARCHAR(60)
        @CODNVL VARCHAR(2),
        @CANCELT DECIMAL (28,3),  -- SECCION DECRETO 2602
        @TOTAL DECIMAL (28,3),    -- SECCION DECRETO 2602
        @ALICUOTA DECIMAL (28,3),  -- SECCION DECRETO 2602
        @ID3 VARCHAR(25),         -- SECCION DECRETO 2602
        @CREDITO DECIMAL (28,3),
        @CODSUCU VARCHAR(5),
        @CODESTA VARCHAR(10),
        @NROCTROL VARCHAR(20),
        @TEXENTO   DECIMAL (28,3),
        @MONTONETO DECIMAL (28,3),
        @MTOTAX    DECIMAL (28,3),
        @BASEIMPO  DECIMAL (28,3),
        @OTOTAL    DECIMAL (28,3),
        @TOTALDEV  DECIMAL (28,3),
        @TOTALFAC  DECIMAL (28,3),
        @SALDO     DECIMAL (28,3),
        @CANCELA     DECIMAL (28,3)
        
        
        
-- Contenido de saitemfac
DECLARE @CANTIDAD INT,
        @CODITEM  VARCHAR(20)   
        
-- Contenido de SAACXC
DECLARE @DOCUMENT VARCHAR(40),
        @NROREGI  INT,
        @NROUNICO INT,
        @FECHAO   DATETIME  
        
-- Contenido de SATAXVTA
DECLARE @APLICADA DECIMAL (28,3)                  
               

-- Contenido de variables locales
DECLARE @STATUSERROR INT, -- SWICHE QUE SE ACTIVA
        @DESCRIPERROR VARCHAR(256), -- DESCRIBE EL MENSAJE DE ERROR
        @FechaHoy Datetime
 
 
-- Contenido de SACLIE
 
 DECLARE @TIPOCLI INT                 

 
 

-------------------------------------------
-- VALORES INICIALES ASISGNADOS
-------------------------------------------

SET @FechaHoy = getdate()
SET @Modelo   = 'NO EXISTE'
SET @STATUSERROR=0 

 

-----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------


-- Recoge datos de la tabla: SAFACT
          
   SELECT 
        --@CODCLIE = CODCLIE,
        --@CODOPER = CODOPER,
          @DESCLIE = DESCRIP,
          @CODVEND = CODVEND,
          @DOC_AFEC=NUMEROR, -- REFERIDO A DEVOLUCION DE FACTURAS
          @CANCELT=CancelT, 
          @CANCELA=CANCELA,                           -- SECCION DECRETO 2602 3085 - TOTAL PAGADO MEDIOS ELECTRONICOS
          @ID3=ID3,                                    -- SECCION DECRETO 2602 3085- IDENTIFICADOR CI/RIF
          @ALICUOTA=Round(((MtoTax*100)/TGravable),0), -- SECCION DECRETO 2602 3085- ALICUOTA APLICADA
          @CREDITO=ISNULL(Credito,99),
          @CODSUCU=CodSucu,
          @CODESTA=CodEsta,
          @NROCTROL=NroCtrol,
          @MONTONETO=TGravable+TExento+Fletes,
          @MTOTAX=MtoTax,
          @BASEIMPO=TGravable,
          @TEXENTO=TExento,
          @FECHAO=FECHAE
        --@CODUSUA = CODUSUA  
          FROM SAFACT
          WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
          
 -- Recoge datos de la tabla: SAFACT_02
          
    SELECT @OR=Z_INTERNO FROM SAFACT_02
    WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TIPODOC  
    
-- Recoge tipo de cliente 0-Contribuyente, 4 - Constribuyente Especial.       
                  
    SELECT @tipocli=tipocli FROM SACLIE
    WHERE ID3=@ID3   
         
-- Recoge datos de la tabla: SSUSRS 
 SELECT @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WHERE CODUSUA=@CODUSUA  

           
       -- 1. Valida usuarios permitido 
   IF  (Substring(@CODNVL,1,2)<>'11')
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01098'
      RAISERROR (@DESCRIPERROR,16,1)
      ROLLBACK TRANSACTION
      RETURN
     END
     
     
-- Calculos preliminares      
     SET @TOTAL=@MONTONETO+@MTOTAX 
        

--**************************SECCION A: FACTURACION ****************************************************


      

IF @TipoDoc='A' 

BEGIN
   /* - SE INHABILITA POR FIN  DE LA VIGENCIA DEL DECRETO 2602
   -- SECCION DECRETO 2602: 10% IVA A CONSUMIDOR FINAL, MENOS 200.000 bS Y PAGO TOTAL MEDIOS ELECTRONICOS. 
   IF (SUBSTRING(@ID3,1,1)='V' OR SUBSTRING(@ID3,1,1)='E' OR SUBSTRING(@ID3,1,1)='P') AND
      (@TOTAL<200000) AND (@CANCELT=@TOTAL) AND (@ALICUOTA<>10)
     BEGIN
       SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01152'
       RAISERROR (@DESCRIPERROR,16,1)
       ROLLBACK TRANSACTION
       RETURN
     END  
     
  
   IF (SUBSTRING(@ID3,1,1)='J' OR SUBSTRING(@ID3,1,1)='G' OR @TOTAL>=200000 OR @CANCELT<>@TOTAL) AND (@ALICUOTA=10)
     BEGIN
       SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01155'
       RAISERROR (@DESCRIPERROR,16,1)
       ROLLBACK TRANSACTION
       RETURN
     END      
          
  -- FIN SECCION DECRETO 2602. */
  
  --SE HABILITA EL 25 DE SEPTIEMBRE DE 2017 / DECRETO 3085.
  /*
  IF @TIPOCLI=4 AND @ALICUOTA<>12 -- CONTRIBUYENTE ESPECIAL
     BEGIN
       SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01158'
       RAISERROR (@DESCRIPERROR,16,1)
       ROLLBACK TRANSACTION
       RETURN
     END  */
   /*  
   IF @CANCELT+@CANCELA<>@TOTAL AND @ALICUOTA<>12 and @ALICUOTA<>27 -- PAGO MIXTO CON EFECTIVO O CHEQUE NO PERMITIDO, SI ANTICIPO, CREDITO, INST DE PAGOS
     BEGIN
       SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01159'
       RAISERROR (@DESCRIPERROR,16,1)
       ROLLBACK TRANSACTION
       RETURN
     END  
 
  IF @MONTONETO<=2000000 AND @ALICUOTA<>9 AND @CANCELT+@CANCELA=@TOTAL -- APLICA 9%   AND @TIPOCLI<>4 
     BEGIN
       SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01160'
       RAISERROR (@DESCRIPERROR,16,1)
       ROLLBACK TRANSACTION
       RETURN
     END  
   -- TODA VENTA > 2mm PAGADA X MEDIOS ELECTRONICOS APLICA 7% O 22% CASO VEHICULOS, ES DECIR DESCUENTA 5% DE iva GENERAL
   IF @MONTONETO>2000000 AND @ALICUOTA<>7 AND @ALICUOTA<>22 AND @CANCELT+@CANCELA=@TOTAL -- APLICA 7%   AND @TIPOCLI<>4
     BEGIN
       SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01161'
       RAISERROR (@DESCRIPERROR,16,1)
       ROLLBACK TRANSACTION
       RETURN
     END  
     
   IF YEAR(@FECHAO)>2017 AND @ALICUOTA<>12 AND @ALICUOTA<>27
    BEGIN
       SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01162'
       RAISERROR (@DESCRIPERROR,16,1)
       ROLLBACK TRANSACTION
       RETURN
     END  
     */
     
  -- FIN DE VALIDACIONES DE EXTREMOS DEL DECRETO 3085.
  
  
  
   
--==============================================================================================================================
--                                        101 - INICIO FACTURACION VEHICULOS
--==============================================================================================================================

IF @CODOPER='01-101'  

  BEGIN
   
   SELECT @PLACA=CODPROD, @MODELO=Z.MODELO, @COLOR=Z.COLOR, @FECHAHOY=X.FECHAE, @CONCESIONARIO=Concesionario, @SERIAL=Y.NROSERIAL, @NUMEROO=W.ONUMERO
   FROM SAFACT X 
   INNER JOIN SASEPRFAC Y ON X.NUMEROD = Y.NUMEROD AND X.TIPOFAC=Y.TIPOFAC 
   INNER JOIN SAPROD_12_01 Z ON Y.NROSERIAL=Z.SERIAL  
   INNER JOIN SAITEMFAC W ON W.NUMEROD = X.NUMEROD AND W.TIPOFAC=X.TIPOFAC 
   WHERE X.NUMEROD=@NUMEROD AND X.TIPOFAC=@TIPODOC
 
   UPDATE SAFACT_01 SET PLACA=@PLACA, STATUS='VEHICULO' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc

   UPDATE SAPROD_12_01 SET FACTURA_VENTA = 'FA/'+@NUMEROD, FECHA_VENTA = @FECHAHOY         
   WHERE SERIAL=@SERIAL

   UPDATE SAFACT SET ORDENC='VEHICULO/' + @placa WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TIPODOC
   
   IF NOT EXISTS (SELECT PLACA FROM SACLIE_04 WHERE PLACA=@PLACA)
   INSERT SACLIE_04 (CODCLIE, FECTRN, PLACA, MODELO, SERIAL, COLOR, VENDIDO, CONCESIONARIO)
   VALUES (@CodTercero, @FECHAHOY, @PLACA, @MODELO, @SERIAL, @COLOR, @FECHAHOY, @CONCESIONARIO)

  IF NOT EXISTS (SELECT CODPROD FROM SAPROD_12_02 WHERE CODPROD=@PLACA) 
  INSERT SAPROD_12_02 (CODPROD, FECTRN, CODCLIE, DESCRIPCION, CONDICION)
  VALUES (@PLACA, @FECHAHOY, @CODTERCERO, @DESCLIE, 'TITULAR')

   -- ELIMINA DE DATOS COMPLEMENTARIOS DE DISPONIBILIDAD
   DELETE FROM SAPROD_11_03 WHERE SERIAL=@SERIAL

   
   
   -- LAS SIGUIENTE INSTRUCCIONES ES PARA CORREGIR FALLA DE LA APLICACION ORIGINAL QUE NO ELIMINA EL REGISTRO DE SASERI CUANDO FACTURA EN VERSION 873 Y 872 Y 9024
   
   DELETE FROM SASERI       WHERE NROSERIAL=@SERIAL
   DELETE FROM SAFACT       WHERE NumeroD=@NUMEROO AND TipoFac='G'
   DELETE FROM SAITEMFAC    WHERE NumeroD=@NUMEROO AND TipoFac='G'
   
 END

--================================================== 101 - FIN FACTURACION VEHICULOS ==============================================


 
  
--=================================================================================================================================
--                                        201 - INICIO DE FACTURACION DE REPUESTOS POR MOSTRADOR   
--=================================================================================================================================  
   -- Factura de repuesto por mostrador
IF @CODOPER='01-201'
  BEGIN
   UPDATE SAFACT_01 SET STATUS='REPUESTO' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TIPODOC
   UPDATE SAFACT SET ORDENC='REPUESTO' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TIPODOC
  END
 --============================ ========== 201 - FIN DE FACTURACION DE REPUESTOS POR MOSTRADOR  =================================== 
 





--=====================================================================================================
--                     301 - INICIO DE FACTURACION DE SERVICIOS    
--=====================================================================================================  

-- Factura de servicio.
IF  @CODOPER='01-301'  
 
  BEGIN
  -- 1. Valida codigo de mecanico/tecnico Valido
  IF  EXISTS (SELECT * FROM SAITEMFAC WHERE CODMECA='AAAAA'AND EsServ=1 and numerod=@numerod and tipoFAC=@TipoDoc)
     BEGIN
       SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01140'
       RAISERROR (@DESCRIPERROR,16,1)
       ROLLBACK TRANSACTION
       RETURN
     END  
  
    
   UPDATE SAFACT_01 SET STATUS=Y.Z_INTERNO 
   FROM SAFACT_01 X INNER JOIN SAFACT_02 Y 
   ON X.NUMEROD=Y.NUMEROD AND X.TIPOFAC=Y.TIPOFAC
   WHERE X.NUMEROD=@NUMEROD AND X.TIPOFAC=@TipoDoc  

   UPDATE SAFACT_01 SET STATUS=@NUMEROD, CIERRE_OR=@FECHAHOY 
   FROM SAFACT_01 X INNER JOIN SAFACT_02 Y 
   ON X.NUMEROD=Y.NUMEROD AND X.TIPOFAC=Y.TIPOFAC
   WHERE (X.NUMEROD=@OR) AND (X.TIPOFAC='G') 

   UPDATE SAFACT SET ORDENC=Y.Z_INTERNO 
   FROM SAFACT X INNER JOIN SAFACT_02 Y 
   ON X.NUMEROD=Y.NUMEROD AND X.TIPOFAC=Y.TIPOFAC
   WHERE X.NUMEROD=@NUMEROD AND X.TIPOFAC=@TIPODOC 

   UPDATE SAPROD_12_03 SET FECHA=GETDATE(), FACTURA=@NUMEROD, SERVICIO_REALIZADO='VER FACTURA'  
   FROM SAPROD_12_03 X 
   INNER JOIN SAFACT_02 Y ON X.ORDEN_DE_REPARACION=Y.Z_INTERNO AND Y.TIPOFAC='G'
   INNER JOIN SAFACT_01 Z ON Y.TIPOFAC=Z.TIPOFAC AND Y.NUMEROD=Z.NUMEROD
   WHERE X.ORDEN_DE_REPARACION=@OR AND CODPROD=Z.PLACA 
   
   ----  SE EJECUTA SIEMPRE Y CUANDO SE HAYAN FACTURADO TODOS LOS ITEMS DE LA OR ORIGINAL
   ----     PREMISAS: EN LA FACTURACION DEBE LLEGAR LA OR CON EL NUMERO EXACTO DE ITEM A FACTURAR. EL USUARIO DE CAJA NO DEBE
   ----     ELIMINAR REGISTROS QUE NO SEAN DE FACTURAS LARGAS, NO DEBE ELIMINAR NINGUN TIPO DE REGISTRO POR CUALQUIER OTRA RAZON.
  
-- SEGMENTO QUE ELIMINA TRAZAS DE OR TOTALMENTE FACTURADA Y REALIZA MARCAS CRUZADAS.  
DECLARE @CANTITFA INT
DECLARE @CANTITOR INT
 
SELECT @CANTITFA=COUNT(*) FROM SAITEMFAC WHERE ONumero=@OR AND TipoFac='A' 
SELECT @CANTITOR=COUNT(*) FROM SAITEMFAC WHERE NumeroD=@OR AND TipoFac='G'

IF @CANTITFA=@CANTITOR
  BEGIN 
   DELETE FROM SAFACT WHERE NumeroD=@OR AND TipoFac='G'     
   DELETE FROM SAITEMFAC WHERE NumeroD=@OR AND TipoFac='G'
 
 
   ---- SE MARCAN 'FACTURADAS' LOS CONTROLES INTERNOS CON REFERENCIA A LA OR ORIGINAL.
   -- VALES PROCESADOS
   -- 10022017
   IF NOT EXISTS (SELECT * FROM SAFACT X INNER JOIN SAFACT_03 Y ON X.NumeroD=Y.Vale AND X.TIPOFAC='F' WHERE Y.Nro_OR=@OR AND Y.DESPACHO IS NOT NULL AND X.Descrip LIKE '%FACTURADA%')
   UPDATE SAFACT SET DESCRIP=DESCRIP+'(FACTURADA)' FROM SAFACT X INNER JOIN SAFACT_03 Y ON X.NumeroD=Y.Vale AND X.TIPOFAC='F' WHERE Y.Nro_OR=@OR AND Y.DESPACHO IS NOT NULL
 
   -- VALES NO PROCESADOS
   -- 10022017
   IF NOT EXISTS (SELECT * FROM SAFACT X INNER JOIN SAFACT_03 Y ON X.NumeroD=Y.Vale AND X.TIPOFAC='F'    WHERE Y.Nro_OR=@OR AND Y.DESPACHO IS NULL AND X.Descrip LIKE '%FACTURADA%')
   UPDATE SAFACT SET DESCRIP='OR FACTURADA, VALE INUTILIZADO' FROM SAFACT X INNER JOIN SAFACT_03 Y ON X.NumeroD=Y.Vale AND X.TIPOFAC='F'    WHERE Y.Nro_OR=@OR AND Y.DESPACHO IS NULL
   
   -- DESPACHOS VIVOS
   -- 10022017
   IF NOT EXISTS (SELECT * FROM SAFACT X INNER JOIN SAFACT_03 Y ON X.NumeroD=Y.Despacho AND X.TIPOFAC='F'    WHERE Y.Nro_OR=@OR AND X.NumeroR IS NULL AND X.Descrip LIKE '%FACTURADA%')
   UPDATE SAFACT SET DESCRIP=DESCRIP+'(FACTURADA)' FROM SAFACT X INNER JOIN SAFACT_03 Y ON X.NumeroD=Y.Despacho AND X.TIPOFAC='F'    WHERE Y.Nro_OR=@OR AND X.NumeroR IS NULL 
   
  END  
   
 END
     
  
--==================================   301 - FIN DE FACTURACION DE SERVICIOS  ================================================  

 
  
--============================================================================================================================
--                               401 - 501 - 901  INICIO DE FACTURACION DE OTROS PROCESOS     
--============================================================================================================================  
-- Factura por otros servicios
IF @CODOPER='01-401'
  BEGIN
   UPDATE SAFACT_01 SET STATUS='OTROS' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
   UPDATE SAFACT SET ORDENC='OTROS' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
  END

-- Factura de ACCESORIOS DE VENTA POR VEHICULO NUEVO.
IF  @CODOPER='01-501'
  BEGIN
   UPDATE SAFACT_01 SET STATUS='ACCESORIOS' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
   UPDATE SAFACT SET ORDENC='ACCESORIOS' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
  END


-- Factura de GARANTIAS A CHRYSLER. AGREGADO EL 06/03/2009
IF  @CODOPER='01-901'
  BEGIN
   UPDATE SAFACT_01 SET STATUS='GARANTIA' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
   UPDATE SAFACT SET ORDENC='GARANTIA' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
  END
  --=========================== 401 - 501 - 901 - FIN  DE FACTURACION DE OTROS PROCESOS  ======================================  


END

 

-- ************************************* SECCION B:DEVOLUCIONES *************************************


-- SECCION DECRETO 2602: 10% IVA A CONSUMIDOR FINAL, MENOS 200.000 bS Y PAGO TOTAL MEDIOS ELECTRONICOS.
-- OJO AQUI APLICA COMPARAR ALICUOTA APLICADA EN DEVOLUCION = ALICUOTA APLICADA EN FACT ORIGEN SIN IMPORTAR SI ES PARCIAL O NO.       
 
 --SET @TOTAL=@MONTONETO+@MTOTAX 
IF @TipoDoc='B'

 BEGIN
   
   SELECT @APLICADA=ISNULL(MTOTAX,99) FROM SATAXVTA WHERE NumeroD=@DOC_AFEC AND TipoFac='A'
   SELECT @SALDO=ISNULL(SALDO,99) FROM SAACXC WHERE NumeroD=@DOC_AFEC AND TipoCxc='10' AND CodClie=@CodTercero
   
   
   /*
   SET @DESCRIPERROR='ESTOY AQUI CON:'+STR(@ALICUOTA)+'/'+STR(@APLICADA)+'//'+STR(@SALDO)+'/'+STR(@CREDITO)
   RAISERROR (@DESCRIPERROR,16,1)
   ROLLBACK TRANSACTION
   RETURN   
   */
   
   IF  @APLICADA<>@ALICUOTA
     BEGIN
       SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01153'
       RAISERROR (@DESCRIPERROR,16,1)
       ROLLBACK TRANSACTION
       RETURN
     END
     
   IF (@SALDO=0 and @CREDITO>0) or (@CREDITO>@SALDO) 
      BEGIN
       SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01154'
       RAISERROR (@DESCRIPERROR,16,1)
       ROLLBACK TRANSACTION
       RETURN
     END  
     
     
     
     
     -- ACTUALIZACION CRUZADA FACTURA/DEVOLUCION -- REVISAR SI ESTO HACE FALTA EN ESTA VERSION 9024
     -- UPDATE SAFACT SET NUMEROR=@Onumero WHERE numerod=@numerod and tipofac=@tipofac    -- actualiza registro de la DEVOLUCION    
     -- UPDATE SAFACT SET NUMEROR=@numerod WHERE numerod=@Onumero and tipofac=@Otipo       -- actualiza registro de factura afectada
 
 
     -- SEGMENTO QUE DESBLOQUEA FACTURA QUE NO HAYA SIDO DEVUELTA N SU TOTALIDAD PARA QUE SIGA QUEDANDO DISPONIBLE.
 
          SELECT @TOTALDEV=SUM(MONTO+MTOTAX) FROM SAFACT WHERE TIPOFAC='B' AND NUMEROR=@DOC_AFEC
          SELECT @TOTALFAC=CREDITO+CONTADO FROM SAFACT WHERE NUMEROD=@DOC_AFEC AND TIPOFAC='A'
         
          IF @TOTALDEV<@TOTALFAC
          
            UPDATE SAFACT SET NUMEROR='' WHERE NUMEROD=@DOC_AFEC AND TIPOFAC='A'
        


--=====================================================================================================
--                     101 - DEVOLUCION DE FACTURAS VEHICULOS 
--=====================================================================================================
IF @CODOPER='01-101'

  BEGIN

   SELECT @PLACA=CODPROD, @MODELO=Z.MODELO, @COLOR=Z.COLOR, @FECHAHOY=X.FECHAE, @CONCESIONARIO=CONCESIONARIO, @SERIAL=Y.NROSERIAL
   FROM SAFACT X 
   INNER JOIN SASEPRFAC Y ON X.NUMEROD = Y.NUMEROD AND X.TIPOFAC=Y.TIPOFAC 
   INNER JOIN SAPROD_12_01 Z ON Y.NROSERIAL=Z.SERIAL 
   WHERE X.NUMEROD=@NUMEROD AND X.TIPOFAC=@TipoDoc

   UPDATE SAFACT_01 SET PLACA=@PLACA, STATUS='VEHICULO' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc

   UPDATE SAPROD_12_01 SET FACTURA_VENTA = 'NC/'+@NUMEROD, FECHA_VENTA = @FECHAHOY         
   WHERE SERIAL=@SERIAL

   UPDATE SAFACT SET ORDENC='VEHICULO/DV' + @placa WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TIPODOC
    
    -- Crea o actualiza registro en datos adicionales de existencia para optimizar consulta.
            IF NOT EXISTS (SELECT * FROM SAPROD_11_03 WHERE serial=@serial)
              INSERT dbo.SAPROD_11_03 (CodProd, fectrn, Serial, Placa, Color, Status)     
              VALUES (@modelo, getDate(), @serial, @placa, @Color, 'DISPONIBLE')
            ELSE
              UPDATE SAPROD_11_03 
                 SET Codprod=@modelo,
                     fectrn=getdate(),
                     Serial=@serial,
                     Placa=@Placa,
                     Color=@Color,
                     Status='DISPONIBLE'
                 WHERE SERIAL=@SERIAL  

     -- INFORMA A REGISTRO DE VENTA EN SAFACT_01 QUE LA FACTURA ORIGEN FUE ANULADA
     UPDATE    SAFACT_01 SET   STATUS = 'ANULADA', LIQUIDACION=@NUMEROD
     WHERE     NUMEROD=@DOC_AFEC AND TIPOFAC = 'A'

   END
--========================================================================================================================================
--                                       101 - FIN DEVOLUCION DE FACTURAS DE VEHICULOS  
--======================================================================================================================================== 


--========================================================================================================================================
--                        INICIO  DEVOLUCION EN VENTA A CREDITO / GENERACION AUTOMATICA DE REGISTRO N/C EN CXC
--========================================================================================================================================

 
IF @CREDITO>0 AND NOT EXISTS (SELECT DOCUMENT FROM SAACXC WHERE TIPOCXC='31' AND NUMEROD=@NUMEROD AND CODCLIE=@CodTercero)

     BEGIN
          SET @DOCUMENT='DEV:'+@NumeroD+'/F.Afec:'+@DOC_AFEC
          -- SEGMENTO QUE GENERA LOS REGISTROS DE NOTAS DE CREDITO Y PAGOS CUANDO SE PRODUCE UNA DEVOLUCION A CREDITO
 
          INSERT INTO SAACXC  (CODCLIE, FECHAE, FECHAV, CODSUCU, CODESTA, CODUSUA, CODOPER, CODVEND, NUMEROD, NROCTROL, FROMTRAN,
                               TIPOCXC, DOCUMENT, MONTO, MONTONETO, MTOTAX, ESLIBROI, BASEIMPO, AFECTAVTA, AFECTACOMI, FECHAI,
                               NUMERON, TEXENTO, FECHAT )
 
          SELECT               @CodTercero,@FechaHoy,@FechaHoy, @CODSUCU, @CODESTA, @CODUSUA, @CODOPER, @CODVEND, @NUMEROD, @NROCTROL,0,                               '31', @DOCUMENT, @TOTAL, @MONTONETO, @MTOTAX, 1, @BASEIMPO, 1, 1, @FechaHoy, 
                               @DOC_AFEC, @TEXENTO, @FechaHoy
   
      
          SELECT @NROREGI=NROUNICO, @FECHAO=FECHAE, @OTOTAL=Monto FROM SAACXC WHERE NUMEROD=@DOC_AFEC AND TIPOCXC='10'AND CODCLIE=@CodTercero
          SELECT @NROUNICO=NROUNICO FROM SAACXC WHERE NUMEROD=@NUMEROD AND TIPOCXC='31' AND CODCLIE=@CodTercero

           
          INSERT INTO SAPAGCXC  (NROPPAL, NROREGI,TIPOCXC,MONTODOCA,MONTO,NUMEROD,DESCRIP,FECHAE,FECHAO,BASEIMPO,MTOTAX,TEXENTO)
          SELECT @NROUNICO, @NROREGI,'10', @OTOTAL, @TOTAL,@DOC_AFEC,@DOCUMENT, @FechaHoy,@FECHAO, @BASEIMPO, @MTOTAX, @TEXENTO
        
         -- SEGMENTO QUE ACTUALIZA EL SALDO DE FACTURAS EN CXC EN BASE A LA NOTA DE CREDITO PRODUCTO DE LA DEVOLUCION
        
          UPDATE SAACXC
          SET SALDO = SALDO - @TOTAL
          WHERE  NUMEROD=@DOC_AFEC AND TIPOCXC='10' AND CODCLIE=@CODTERCERO

      END
         
       
 -- =========================================== FIN DEVOLUCION A CREDITO ======================================================



END




 
 















 
 


























 
 










