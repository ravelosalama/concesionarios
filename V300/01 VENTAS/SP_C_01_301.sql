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


if exists (select * from dbo.sysobjects where id = object_id(N'[SP_C_301]'))
drop PROCEDURE SP_C_301  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[SP_C_01_301]'))
drop PROCEDURE SP_C_01_301  
GO








-- PARAMETROS DE AMBIENTE
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
  


  
CREATE PROCEDURE  [dbo].[SP_C_01_301] @TipoDoc varchar(1), @NumeroD Varchar(10), @CodTercero Varchar(10), @Codusua Varchar(10),@Codoper Varchar(10)
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
          @DESCLIE = Desclie
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

    
   
          
          
       
-- Recoge datos del usuario de la tabla: SSUSRS 
 SELECT TOP 1 @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WITH (NOLOCK) WHERE CODUSUA=@CODUSUA  






--=========================================================================================================
--  A)- 301 - INICIO DE GESTIONA ORDEN DE REPARACION
--=========================================================================================================
IF @TIPODOC='G' AND @CODOPER='01-301'

BEGIN

---------------------    
-- VALIDACIONES
--------------------- 

   -- Valida si el usuario escribio bien el formato de la placa.   
   IF LEN(@PLACA) = 0 OR LEN(@PLACA)<6 OR LEN(@PLACA)>7 OR @PLACA=' ' or @Placa IS NULL
     BEGIN
         SET @STATUSERROR=1
         SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01109' -- 14. Valida formato valido de escritura de placa
         EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END
   ELSE
     
      -- Respecto a existencia y consistencia de datos del vehiculo en base de datos
      IF NOT EXISTS (SELECT * FROM SAPROD WITH (NOLOCK) WHERE CodProd = @Placa or refere=@placa) 
      BEGIN
         IF LEN(@MODELO)=0 OR LEN(@COLOR)=0 OR LEN(@SERIAL)=0 OR LEN(@SERIAL_M)=0 OR LEN(@VENDIDO)=0 OR LEN(@CONCESIONARIO)=0 OR 
            @MODELO IS NULL OR @COLOR IS NULL OR @SERIAL IS NULL OR @SERIAL_M IS NULL OR @VENDIDO IS NULL OR @CONCESIONARIO IS NULL 
           BEGIN
              SET @STATUSERROR=1
              SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01110' -- 13. Valida datos para creacion de vehiculos.
              EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
           END
         ELSE
           IF NOT EXISTS (SELECT TOP 1 * FROM SAPROD_12_01 WITH (NOLOCK) WHERE (SERIAL = @SERIAL))
              SET @VEHICULO = 1 -- CREAR VEHICULO EN BASE DE DATOS SEGUN DATOS ADICIONALES: REGISTRO DE VEHICULO
           ELSE
           BEGIN
              SET @STATUSERROR=1
              SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01111' -- 12. Valida otra placa con mismo serial.
              EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
           END
      END
      ELSE
          BEGIN
            SET @VEHICULO = 2 -- TOMAR DATOS DE VEHICULO EN BD Y CARGARLO A REGISTRO DE VEHICULO

            SELECT TOP 1 @CODVEH=CODPROD FROM SAPROD WITH (NOLOCK) WHERE REFERE=@PLACA 

            SELECT TOP 1
             @Modelo = Modelo,
             @Serial = Serial,
             @Color  = Color,
             @VENDIDO=ISNULL(fecha_venta,'01/01/2000'),
             @Serial_M= ISNULL(Serial_motor,SERIAL),
             @concesionario=Concesionario
            FROM dbo.SAPROD_12_01 WITH (NOLOCK) 
            WHERE (CODPROD=@CODVEH)
         END
     
  
     
         
      -- 11. Valida si el codigo escrito en Modelo existe correctamente en SAPROD  
         SELECT TOP 1 @DescriModelo=DESCRIP FROM SAPROD WITH (NOLOCK) WHERE CODPROD=@MODELO AND CodInst=11
         IF @DescriModelo IS NULL
         BEGIN
            SET @STATUSERROR=1
            SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01112'
            EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR 
         END 


         
      -- 10. Valida si el codigo escrito DEL Modelo TIENE registro valido en saprod_11_01 DATOS COMPLETOS.   
         IF EXISTS (SELECT TOP 1 * FROM SAPROD_11_01 WITH (NOLOCK) WHERE (CODPROD=@MODELO) AND (Ano IS NULL OR Peso IS NULL OR Clase IS NULL OR  Ano=' ' OR Peso=' ' OR Clase =' '))
         BEGIN
            SET @STATUSERROR=1
            SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01123'
            EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR  
         END 
   
   
 
   
        
     -- 9. Respecto a numeros de OR ABIERTAS  del mismo vehiculo SEGUN SERIAL 
     IF EXISTS (SELECT * FROM VW_MASTER_TRANSAC_01 
     WHERE (@serial<>'' and SERIAL=@SERIAL AND TIPOFAC='G' AND NUMEROD <>@NUMEROD AND LIQUIDACION = @LIQUIDACION AND STATUS = 'PENDIENTE'))  
     
     
        BEGIN
            SET @STATUSERROR=1
            SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01113'
            EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR  
        END


    
     /* ESTE BLOQUE FUE REESCRITO el 25/09/2016 POR CUANTO ERA LA CONSULTA DE MAYOR COSTO DE LA TRANSACCION EL 95% DEL CONSUMO TOTAL DEL TIEMPO. 
     -- 9. Respecto a numeros de OR ABIERTAS  del mismo vehiculo SEGUN SERIAL 
     IF EXISTS (SELECT * FROM SAFACT_01 X WITH (NOLOCK)  inner join safact_02 y WITH (NOLOCK) on x.tipofac=y.tipofac and x.numerod=y.numerod WHERE (@serial<>'' and Y.SERIAL=@SERIAL AND x.TIPOFAC='G' AND x.NUMEROD <>@NUMEROD AND LIQUIDACION = @LIQUIDACION AND STATUS = 'PENDIENTE'))  
     
     
        BEGIN
            SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01113'
            EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR  
        END */


     -- 8. Valida si codigo del asesor es valido
     IF SUBSTRING(@CODVEND,1,2)<>'AS'
        BEGIN
              SET @STATUSERROR=1
              SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01114'
              EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
        END

     -- 7. Valida si se registraron requerimientos en Comentarios
     IF @NOTAS1 IS NULL AND @NOTAS2 IS NULL AND @NOTAS3 IS NULL AND @NOTAS4 IS NULL AND @NOTAS5 IS NULL  
        BEGIN
           SET @STATUSERROR=1
           SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01115' 
           EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
        END  
  
     -- 6. Valida consistenacia en campo de liquidacion
     IF @Liquidacion<>'CONTADO' AND @Liquidacion<>'GARANTIA' AND @LIQUIDACION<>'INTERNA' AND @LIQUIDACION<>'ACCESORIO'
        BEGIN
            SET @STATUSERROR=1
            SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01116'
            EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR 
        END
        
     -- 5. Valida consistencia en campo de status
     IF @STATUS<>'PENDIENTE' AND @STATUS<>'CERRADA' AND @STATUS<>'SUSPENSO'
        BEGIN
           SET @STATUSERROR=1
           SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01117'
           EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
        END  
      
     -- 4. Valida si al cerrar orden con rubros de servicios posee tecnicos validos
     IF SUBSTRING(@STATUS,1,1)='C'  AND EXISTS (SELECT TOP 1 * FROM SAITEMFAC WITH (NOLOCK) WHERE CODMECA='AAAAA' and EsServ=1 and tipofac=@TipoDoc and NumeroD=@numerod)
        BEGIN
           SET @STATUSERROR=1
           SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01122'
           EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
        END   
   
     -- 3. Valida intento de cierre de OR contado O GARANTIA
     IF (@LIQUIDACION='CONTADO' OR @LIQUIDACION='GARANTIA') AND @STATUS='CERRADA' -- ORsGARANTIAS A PERTIR DE LA 9XXX SE FACTURA POR CAJA
        BEGIN
         SET @STATUSERROR=1
         SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01118'
         EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
        END 
        
     -- 2. Valida intento de cierre POR USUARIO NO AUTORIZADO
     IF @STATUS='CERRADA' AND Substring(@CODNVL,1,2)<>'8 '
        BEGIN
          SET @STATUSERROR=1
          SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01121'
          EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
        END     
        
/*
     -- 1. Valida cambio de liquidacion con usuario no autorizado  
       -- SEGMENTO INHABILITADO TEMPORALMENTE EN ESTUDIO DE NECESIDAD PARA VERSION 9XXX
       -- SEGMENTO REHABILITADO EL 27/09/2016 Y CORREGIDO SEGUN NUEVO CRITERIO.
       -- SE VOLVIO A DEHABILITAR POR CUANTO HAY QUE MEJORAR CRITERIO PORQUE NO PERMITE ABRIER NUEVA OR
     SET @LIQUIDACION='%'+SUBSTRING(@LIQUIDACION,1,4)+'%' --PREPARA LA CADENA A SER BUSCADA EN LA SIGUIENTE INSTRUCCION       
     IF NOT EXISTS (SELECT * FROM SAFACT WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TIPODOC AND NOTAS10 LIKE @LIQUIDACION)
      BEGIN
       IF  Substring(@CODNVL,1,2)<>'8 '
       BEGIN
         SET @STATUSERROR=1
         SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01119' 
         EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
       END
      END
 */   
      -- 0. Valida usuarios permitido 
   IF  (Substring(@CODNVL,1,2)<>'10' AND Substring(@CODNVL,1,2)<>'8 ' AND Substring(@CODNVL,1,2)<>'16')
     BEGIN
      SET @STATUSERROR=1
      SELECT TOP 1 @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WITH (NOLOCK) WHERE CODERR='01098'
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END 

-----------------------------------------------------------------------------------------
----------------------------- PROCESO DEL OBJETO ----------------------------------------
-----------------------------------------------------------------------------------------

IF @STATUSERROR=0
 
 BEGIN

  

-----------------------------------------------------------------------------------------   
-- SI PLACA NO EXISTE EN BD Y REGISTRO DE VEHICULO ESTA COMPLETO CREA VEHICULO EN BD
----------------------------------------------------------------------------------------- 
 
IF @VEHICULO = 1

BEGIN

   
      
   -- B -- Crea vehiculo en productos
         INSERT SAPROD (CodProd, Refere, Descrip,       Descrip3,   CodInst,  EsExento, Activo,MARCA) 
                VALUES (@Placa,  @Placa, @DescriModelo, 'VEHICULO', @CodInst, 1,0,@MARCA)

      -- Crea registro de existencia
      INSERT SAEXIS (CodProd, CodUbic, Existen) 
                VALUES (@Placa, '020', 0)

      
   -- C -- Crea datos adicionales del vehiculo
 
      INSERT dbo.SAPROD_12_01 (CodProd, Modelo, Serial, Color, Fecha_venta, Kilometraje,Serial_motor, Concesionario ) 
         VALUES (@Placa, @Modelo, @Serial, @Color, @Vendido, @Kilometraje, @Serial_M, @concesionario)

END
------------------------------------------------------------------------------------------------------
-- SI EXISTE PLACA EN BASE DE DATOS REGOGE DATOS ADICIONALES Y LOS CARGA EN REGISTRO DE VEHICULO
------------------------------------------------------------------------------------------------------
--IF @VEHICULO = 2

-- TOMA EL VALOR EN @CODPROD DEL CAMPO CODPROD DEL REGISTRO DE VEHICULO CONSULTADO POR REFERENCIA O NUEVA PLACA. OJO MUY IMPORTANTE.

-- ACTUALIZA DATOS CORREGIDOS Y PREPARADOS EN SAFACT_01 Y SAFACT_02, coloca placa en orden de compra en SAFACT, 

   UPDATE SAFACT_01 SET            
          PLACA=@PLACA,
          KILOMETRAJE=@KILOMETRAJE,
          LIQUIDACION=@LIQUIDACION,
          STATUS=@STATUS,
          CIERRE_OR=@CIERRE_OR,
          APERTURA_OR=@APERTURA_OR
          WHERE TIPOFAC=@TipoDoc AND NUMEROD=@NUMEROD


   UPDATE SAFACT_02 SET
          MODELO=@MODELO,
          COLOR=@COLOR,
          SERIAL=@SERIAL,
          SERIAL_M=@SERIAL_M,
          VENDIDO=@VENDIDO,
          VENDIO_CONCESIONARIO=@CONCESIONARIO,
          Z_INTERNO = @NUMEROD
          WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc


   UPDATE SAFACT SET
          ORDENC=@PLACA+' '+@LIQUIDACION, NOTAS10=@PLACA+' '+@LIQUIDACION, Descrip=@PLACA+' '+@LIQUIDACION+' '+@DESCLIE
          WHERE NUMEROD=@NUMEROD AND TIPOFAC=@TipoDoc


--------------------------------------------------------------------------------------------------------
-- CREA VINCULOS CON TABLAS MAESTRAS PARA MEJORAR INFORMACION DE CONSULTA RAPIDA
--------------------------------------------------------------------------------------------------------


   -- Crea datos del vinculo con el cliente y viceversa.  
   IF NOT EXISTS (SELECT TOP 1 * FROM SACLIE_04 WITH (NOLOCK) WHERE (CODCLIE=@CODTERCERO AND PLACA=@PLACA))
      INSERT dbo.SACLIE_04 (FecTrn, Codclie, Placa, Modelo, Serial, Color, Vendido, Concesionario ) 
      VALUES (@Fechahoy, @CodTercero, @Placa, @Modelo, @Serial, @Color, @Vendido, @concesionario)
   ELSE
      UPDATE SACLIE_04 SET
          FecTrn=@Fechahoy,
          CODCLIE=@CodTercero,
          PLACA=@PLACA,
          MODELO=@MODELO,
          COLOR=@COLOR,
          SERIAL=@SERIAL,
          VENDIDO=@VENDIDO,
          CONCESIONARIO=@CONCESIONARIO
          WHERE CODCLIE=@CodTercero AND PLACA=@PLACA

    -- Crea o actualiza ficha de Clientes Vinculados en Productos/vehiculo.
    IF NOT EXISTS (SELECT TOP 1 * FROM SAPROD_12_02 WITH (NOLOCK) WHERE (CODPROD=@PLACA AND CODCLIE=@CodTercero))
      INSERT dbo.SAPROD_12_02 (FecTrn, Codprod, CodClie, Descripcion, Condicion) 
      VALUES (@fechahoy, @Placa, @CodTERCERO, @Desclie, 'X DEFINIR' )
    ELSE
      UPDATE SAPROD_12_02 SET
          FecTrn=@Fechahoy,
          CODCLIE=@CODTERCERO,
          CODPROD=@PLACA,
          DESCRIPCION=@DESCLIE
          -- CONDICION=''                    
      WHERE CODCLIE=@CODTERCERO AND CODPROD=@PLACA

    -- Crea o actualiza ficha de consulta de servicios en Productos.
    IF NOT EXISTS (SELECT TOP 1 * FROM SAPROD_12_03 WITH (NOLOCK) WHERE (CODPROD=@PLACA AND Orden_de_reparacion=@numerod))
      INSERT dbo.SAPROD_12_03 (Codprod, FecTrn, fecha, factura, Orden_de_reparacion, servicio_realizado) 
      VALUES (@placa, @fechahoy, @fechahoy, 'PENDIENTE', @numerod, @status )
    ELSE
      UPDATE SAPROD_12_03 SET
          FecTrn=@Fechahoy,
          Fecha=@Fechahoy,
          CODprod=@Placa,
          Orden_de_reparacion=@numerod
      WHERE (CODPROD=@PLACA AND Orden_de_reparacion=@numerod) 


---------------------------------------------------------------------------------------------------
-- PROCESA CIERRE DE ORDENES DISTINTAS A CONTADO PARA QUE NO SEAN EDITABLES Y TENGAN FECHA DE CORTE
---------------------------------------------------------------------------------------------------
--AND (@CODUSUA='JACK' OR @CODUSUA='DORIS') -- OJO ADAPTACION TEMPORAL PRESTIGE CARS  ADAPTACION RORAIMA MOTORS {AND @LIQUIDACION<>'GARANTIA'.
-- VALIDACION DE USUARIO SE RESOLVIO EN VERSION EN REINGENIERIA REALIZADA PARA CAMBIO DE VERSION 9XXX  EN SECCION DE VALIDACION  
   IF @LIQUIDACION<>'CONTADO' AND  @LIQUIDACION<>'GARANTIA' AND @STATUS='CERRADA'  
       BEGIN
        UPDATE SAFACT    SET TIPOFAC='Z' WHERE (TipoFac = @TipoDoc and NumeroD = @NumeroD) 
        UPDATE SAFACT_01 SET TIPOFAC='Z' WHERE (TipoFac = @TipoDoc and NumeroD = @NumeroD)
        UPDATE SAFACT_02 SET TIPOFAC='Z' WHERE (TipoFac = @TipoDOC and NumeroD = @NumeroD)
        -- UPDATE SAITEMFAC SET TIPOFAC='Z' WHERE (TipoFac = @TipoDoc and NumeroD = @NumeroD)
        -- LA SIGUENTE INSTRUCCION ES PARA ELIMINAR LOS REGISTROS EN SAITEMFAC QUE SE CREAN 
        -- Y DUPLICAN LA DATA SOLO QUE LO CREA CON TIPOFAC='G' OJO AVERIGUAR POR QUE PASA ESTO
        --DELETE FROM SAITEMFAC WHERE (TipoFac = @TipoDoc and NumeroD = @NumeroD) 
       END   
END

END
--==============================================================================================================
-- 301 - FIN GESTIONA ORDEN DE REPARACION
--==============================================================================================================

 
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





   