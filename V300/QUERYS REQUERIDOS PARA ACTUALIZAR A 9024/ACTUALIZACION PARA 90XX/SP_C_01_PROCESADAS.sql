-- ********************************************************************************
-- TG ORIGINAL INSERT_FACTURA SOBRE SATAXVTA, SE SUSTITUYE POR:
-- TG_01_INSERT_PROCESADAS EN MAY 2016 POR: JOSE RAVELO PARA VERSIONES SUPERIORES A 9XXX
-- EL TG SE GENERA AQUI POR SER ULTIMA TABLA EN ACTUALIZARSE EN EL PROCESO DE GENERACION DE FACTURA.
-- Y REALIZA CRUCES DE REFERENCIAS PARA CIERRES DE TRANSACCIONES Y MEJORAR BUSQUEDAS. 
-- 
-- ********************************************************************************
-- *****************************************************************************************
-- NUEVO PROCEDIMIENTO ALMACENADO DESDE EL SENSOR NUEVO SAITEMFAC EN MAYO 2016
-- PROCESA TODAS LAS OPCIONES DE TRANSACCIONES PROCESADAS EN VENTAS DE LOS CONCESIONARIOS

-- <<<<<<<<<<<<<< 301 - SERVICIOS: FACTURA Y DEVOLUCION >>>>>>>>>>>>>>>>>>>>>
-- <<<<<<<<<<<<<< 201 - REPUESTOS: FACTURA Y DEVOLUCION >>>>>>>>>>>>>>>>>>>>>
-- <<<<<<<<<<<<<< 101 - VEHICULOS: FACTURA Y DEVOLUCION >>>>>>>>>>>>>>>>>>>>>
 
-- revisado ene-2013 JOSE RAVELO SOBRE LIBERTYLABORATORIO ANTES COMO INSERTA_ORDEN Y ANTES COMO:TG_GESTIONA_ESPERA
-- Regenerado en Marzo 2016 por: JOSE RAVELO COMO:SP_01_VENTAS_CONCESIONARIOS LUEGO SE SUBDIVIDE Y SE 
-- Regenera   en Mayo  2016 por: JOSE RAVELO COMO:SP_01_PROCESADAS
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
   

-- Contenido de campos Safact
DECLARE -- @CODCLIE VARCHAR(10),
        -- @CODOPER VARCHAR(10),
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
        @FACT_AFEC VARCHAR(10),
        @NUMEROO VARCHAR(10),
        -- @CODUSUA VARCHAR(60)
        @CODNVL VARCHAR(2)
        
-- Contenido de saitemfac
DECLARE @CANTIDAD INT,
        @CODITEM  VARCHAR(20)        
               

-- Contenido de variables locales
DECLARE @STATUSERROR INT, -- SWICHE QUE SE ACTIVA
        @DESCRIPERROR VARCHAR(256), -- DESCRIBE EL MENSAJE DE ERROR
        @VEHICULO INT, -- DEFINE ACCION A TOMAR PARA EL REGISTRO DE VEHICULO
        @DescriModelo Varchar(40),
        @EsExento int,
        @CodInst varchar(10)
        
DECLARE @CODVEH varchar(10)
DECLARE @Deposito varchar(10)
DECLARE @CodTaxs varchar(5)
DECLARE @Tmp_Codigo varchar (15)
DECLARE @Tmp_Serial varchar (35)
DECLARE @Tmp_Color varchar (25)
DECLARE @MontoIVA decimal (23,2)
DECLARE @EsPorct smallint
DECLARE @FechaHoy Datetime
 

-------------------------------------------
-- VALORES INICIALES ASISGNADOS
-------------------------------------------

SET @FechaHoy = getdate()
SET @Deposito = '020'
SET @CodTaxs  = 'IVA'
SET @Modelo   = 'NO EXISTE'
SET @CodInst  = 12
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
          @FACT_AFEC=NUMEROR, -- REFERIDO A DEVOLUCION DE FACTURAS
          @NOTAS1=NOTAS1,@NOTAS2=NOTAS2,@NOTAS3=NOTAS3,@NOTAS4=NOTAS4,@NOTAS5=NOTAS5,
          @NOTAS6=NOTAS6,@NOTAS7=NOTAS7,@NOTAS8=NOTAS8,@NOTAS9=NOTAS9,@NOTAS10=NOTAS10
          --@CODUSUA = CODUSUA  
          FROM SAFACT
          WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
          
 -- Recoge datos de la tabla: SAFACT_02
          
    SELECT @OR=Z_INTERNO FROM SAFACT_02
    WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TIPODOC        
                  
   
         
-- Recoge datos de la tabla: SSUSRS 
 SELECT @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WHERE CODUSUA=@CODUSUA  

           
       -- 1. Valida usuarios permitido 
   IF  (Substring(@CODNVL,1,2)<>'11')
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01098'
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END 
       
          
          
          

------------------------------------------------------------------------------------------------------
-- IDENTIFICADORES CRUZADOS, MARCAS Y ACCIONES ESPECIALES GENERALES  (CASOS DE FACTURACION) 
------------------------------------------------------------------------------------------------------

-- Factura de vehiculo
IF @TIPODOC='A' AND @CODOPER='01-101' AND @STATUSERROR=0

  BEGIN
   
   SELECT @PLACA=CODPROD, @MODELO=Z.MODELO, @COLOR=Z.COLOR, @FECHAHOY=X.FECHAE, @CONCESIONARIO=CONCESIONARIO, @SERIAL=Y.NROSERIAL, @NUMEROO=W.ONUMERO
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


--=====================================================================================================
--                     101 - DEVOLUCION DE FACTURAS VEHICULOS 
--=====================================================================================================
IF @TipoDoc='B' AND @CODOPER='01-101'

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
     WHERE     NUMEROD=@FACT_AFEC AND TIPOFAC = 'A'

   END
--=====================================================================================================
--                     101 - FIN DEVOLUCION DE FACTURAS DE VEHICULOS  
--===================================================================================================== 



 
  
--=====================================================================================================
--                     201 - INICIO DE FACTURACION DE REPUESTOS POR MOSTRADOR   
--=====================================================================================================  
   -- Factura de repuesto por mostrador
IF @TIPODOC='A' AND @CODOPER='01-201'
  BEGIN
   UPDATE SAFACT_01 SET STATUS='REPUESTO' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TIPODOC
   UPDATE SAFACT SET ORDENC='REPUESTO' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TIPODOC
  END
--=====================================================================================================
--                     201 - FIN DE FACTURACION DE REPUESTOS POR MOSTRADOR   
--=====================================================================================================  






--=====================================================================================================
--                     301 - INICIO DE FACTURACION DE SERVICIOS    
--=====================================================================================================  

-- Factura de servicio.
IF @TIPODOC='A' AND @CODOPER='01-301'  
 
  BEGIN
  -- 1. Valida codigo de mecanico/tecnico Valido
  IF  EXISTS (SELECT * FROM SAITEMFAC WHERE CODMECA='AAAAA'AND EsServ=1 and numerod=@numerod and tipoFAC=@TipoDoc)
     BEGIN
       SET @STATUSERROR=1
       SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01140'
       EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR 
     END  
    
   IF @STATUSERROR=0 
   BEGIN 
    
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
   
   ---- SE BORRAN REGISTROS EN SAFACT Y SAITEMFAC DE OR ORIGINAL EN VERSION 9024 SE DETECTA QUE QUEDA REGISTRO
  --- DELETE FROM SAFACT WHERE NumeroD=@OR AND TipoFac='G'     FALTA CONDICION DE CULMINACION DE OR PARA FACTURAS LARGAS.
  --- DELETE FROM SAITEMFAC WHERE NumeroD=@OR AND TipoFac='G'
   
 
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
--=====================================================================================================
--                     301 - FIN DE FACTURACION DE SERVICIOS    
--=====================================================================================================  


  
  
  
  
--=====================================================================================================
--                     401 - 501 - 901  INICIO DE FACTURACION DE OTROS PROCESOS     
--=====================================================================================================  
-- Factura por otros servicios
IF @TipoDoc='A' AND @CODOPER='01-401'
  BEGIN
   UPDATE SAFACT_01 SET STATUS='OTROS' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
   UPDATE SAFACT SET ORDENC='OTROS' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
  END

-- Factura de ACCESORIOS DE VENTA POR VEHICULO NUEVO.
IF @TIPODOC='A' AND @CODOPER='01-501'
  BEGIN
   UPDATE SAFACT_01 SET STATUS='ACCESORIOS' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
   UPDATE SAFACT SET ORDENC='ACCESORIOS' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
  END


-- Factura de GARANTIAS A CHRYSLER. AGREGADO EL 06/03/2009
IF @TIPODOC='A' AND @CODOPER='01-901'
  BEGIN
   UPDATE SAFACT_01 SET STATUS='GARANTIA' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
   UPDATE SAFACT SET ORDENC='GARANTIA' WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc
  END
  
--=====================================================================================================
--                     401 - 501 - 901 - FIN  DE FACTURACION DE OTROS PROCESOS     
--=====================================================================================================  

 
 

/* BLOQUE EN REPROGRAMACION VIENE DE TG CORRIGE_COMPROMETIDO EN SAITEMFAC
 
 
   -- Descuenta CANTIDAD A COMPROMETIDOS POR CADA repuestos facturado EN OR / CONTADO
   -- (ESTO ES UNA CORRECCION A FALLA DE SAINT)
 
-- Factura de servicios  
        
    IF @TIPOFAC='A' AND @CODOPER='01-301' AND @ESSERV=0
    
       UPDATE SAPROD SET COMPRO=COMPRO-@CANTIDAD where Codprod=@Coditem 
     
-- Devolucion Factura  

 
  IF @TIPOFAC='B'
     BEGIN
     -- ACTUALIZACION CRUZADA FACTURA/DEVOLUCION 
     UPDATE SAFACT SET NUMEROR=@Onumero WHERE numerod=@numerod and tipofac=@tipofac    -- actualiza registro de la DEVOLUCION    
     UPDATE SAFACT SET NUMEROR=@numerod WHERE numerod=@Onumero and tipofac=@Otipo       -- actualiza registro de factura afectada
 
 
     IF @CODOPER='01-301' -- devolucion factura servicio.
  
        UPDATE SAPROD SET COMPRO=COMPRO+@CANTIDAD where Codprod=@Coditem
     
   
     END
     
    



IF @TIPOFAC='B' AND @CREDITO>0 AND NOT EXISTS (SELECT DOCUMENT FROM SAACXC WHERE TIPOCXC='31' AND NUMEROD=@NUMEROD AND CODCLIE=@CODCLIE)

     BEGIN
 
          -- SEGMENTO QUE GENERA LOS REGISTROS DE NOTAS DE CREDITO Y PAGOS CUANDO SE PRODUCE UNA DEVOLUCION A CREDITO
 
          INSERT INTO SAACXC  (CODCLIE, FECHAE, FECHAV, CODSUCU, CODESTA, CODUSUA, CODOPER, CODVEND, NUMEROD, NROCTROL, FROMTRAN,
                               TIPOCXC, DOCUMENT, MONTO, MONTONETO, MTOTAX, ESLIBROI, BASEIMPO, AFECTAVTA, AFECTACOMI, FECHAI,
                               NUMERON, TEXENTO, FECHAT )
 
          SELECT               @CODCLIE, @FECHAE, @FECHAE, @CODSUCU, @CODESTA, @CODUSUA, @CODOPER, @CODVEND, @NUMEROD, @NUMEROD, 0,
                               '31', @DOCUMENT, @MONTO, @MONTONETO, @MTOTAX, 1, @BASEIMPO, 1, 1, @FECHAE, 
                               @ONUMERO, @TEXENTO, @FECHAE
   
      
          SELECT @NROREGI=NROUNICO, @FECHAO=FECHAE FROM SAACXC WHERE NUMEROD=@ONUMERO AND TIPOCXC='10'AND CODCLIE=@CODCLIE
          SELECT @NROUNICO=NROUNICO FROM SAACXC WHERE NUMEROD=@NUMEROD AND TIPOCXC='31' AND CODCLIE=@CODCLIE

    
          INSERT INTO SAPAGCXC  (NROPPAL, NROREGI,TIPOCXC,MONTODOCA,MONTO,NUMEROD,DESCRIP,FECHAE,FECHAO,BASEIMPO,MTOTAX,TEXENTO)
          SELECT @NROUNICO, @NROREGI,'10', @MONTO, @MONTO,@ONUMERO,@DOCUMENT, @FECHAE,@FECHAO, @BASEIMPO, @MTOTAX, @TEXENTO
        
         -- SEGMENTO QUE ACTUALIZA EL SALDO DE FACTURAS EN CXC EN BASE A LA NOTA DE CREDITO PRODUCTO DE LA DEVOLUCION
        
          UPDATE SAACXC
          SET SALDO = SALDO - @MONTO
          WHERE  NUMEROD=@ONUMERO AND TIPOCXC='10' AND CODCLIE=@CODCLIE


 
          -- SEGMENTO QUE DESBLOQUEA FACTURA QUE NO HAYA SIDO DEVUELTA N SU TOTALIDAD PARA QUE SIGA QUEDANDO DISPONIBLE.
 
          SELECT @TOTDEVOLS=SUM(MONTO+MTOTAX) FROM SAFACT WHERE TIPOFAC='B' AND NUMEROR=@ONUMERO
          SELECT @TOTFACAFE=CREDITO+CONTADO FROM SAFACT WHERE NUMEROD=@ONUMERO AND TIPOFAC='A'
         
          IF @TOTDEVOLS<@TOTFACAFE
          
            UPDATE SAFACT SET NUMEROR='' WHERE NUMEROD=@ONUMERO AND TIPOFAC='A'
            
     END
 

  FIN DE BLOQUE EN REPROGRAMACION VIENE DE TG CORRIGE_COMPROMETIDO EN SAITEMFAC */
 










