
if exists (select * from dbo.sysobjects where id = object_id(N'[CONCESIONARIOS_TG_ESPERA_OR]'))
drop TRIGGER CONCESIONARIOS_TG_ESPERA_OR  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[INSERT_ORDEN]'))
drop TRIGGER INSERT_ORDEN  
GO
 
if exists (select * from dbo.sysobjects where id = object_id(N'[SESA_TG_DEVUELVE_ENTREGA]'))
drop TRIGGER SESA_TG_DEVUELVE_ENTREGA  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[SESA_TG_BORRAR_PEDIDOS]'))
drop TRIGGER SESA_TG_BORRAR_PEDIDOS  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[SESA_TG_VALES_CARGADOS]'))
drop TRIGGER SESA_TG_VALES_CARGADOS  
GO
 
if exists (select * from dbo.sysobjects where id = object_id(N'[TG_01_INSERTA_TRANSACCION]'))
drop TRIGGER TG_01_INSERTA_TRANSACCION  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TG_01_INSERTA_PROCESADAS]'))
drop TRIGGER TG_01_INSERTA_PROCESADAS  
GO
 
if exists (select * from dbo.sysobjects where id = object_id(N'[TG_01_INSERTA_PREPROCESOS]'))
drop TRIGGER TG_01_INSERTA_PREPROCESOS  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TG_01_INSERTA_PRE_PROCESOS]'))
drop TRIGGER TG_01_INSERTA_PRE_PROCESOS  
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[TG_01_DETECTA_PROCESADAS]'))
drop TRIGGER TG_01_DETECTA_PROCESADAS  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TG_01_DETECTA_PRE_PROCESO]'))
drop TRIGGER TG_01_DETECTA_PRE_PROCESO  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TG_01_DETECTA_UPDATE]'))
drop TRIGGER TG_01_DETECTA_UPDATE
GO








-- ********************************************************************************
-- NUEVO TRIGGER PARA 9XXX CREADO POR: JOSE RAVELO SEP-2016 
-- DETECTA ELIMINACION EN SAFACT Y VALIDA USUARIO Y PERTINENCIA DE LA TRANSACCION
-- EVITA QUE ALGUN USUARIO NO AUTORIZADO ELIMINE PREFACTURAS SIN AUTORIZACION O POR ERROR
-- TRANSACCIONES VENTAS CONCESIONARIOS SA_CTRANSAC.
-- ********************************************************************************
DROP TRIGGER TG_01_DELETE
GO

CREATE TRIGGER TG_01_DELETE ON SAPROD
-- WITH ENCRYPTION
AFTER DELETE
AS

-----------------------------------
-- DECLARACION DE VARIABLES 
-----------------------------------
DECLARE @STATUSERROR INT,
        @DESCRIPERROR VARCHAR(300)
    SET @STATUSERROR=0
    
 
DECLARE @TipoDOC     varchar (1),
        @NumeroD     varchar (20),
        @NROUNICO    INT,
        @NumeroO     varchar(20),
        @CODTERCERO VARCHAR(15),
        @CODOPER VARCHAR(10),
        @CODUSUA VARCHAR (10),
        @CODESTA VARCHAR (10),
        @FECHAT DATETIME,
        @NROMAX INT,
        @NROLINEA INT,
        @NROREG INT,
        @total decimal(28,4),
        @totalg decimal(28,4),
        @CODNVL VARCHAR (2)
        
       
      
      
    BEGIN  
      
     
     SET @DESCRIPERROR= 'AQUI TOY '
     RAISERROR (@DESCRIPERROR,16,1)
     ROLLBACK TRANSACTION
     RETURN
     
END
 
   /*           
        
-----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------

-- Recoge datos de la tabla: DELETE
   SELECT @TIPODOC=TIPOFAC,
          @NUMEROD=NUMEROD,
          @Nrounico=nrounico,
          @Codoper=Codoper,
          @Codusua=ISNULL(Codusua,'VACIO'),
          @Codesta=Codesta,
          @Fechat=Fechat,
          @CodTERCERO=Codclie
          from DELETED     


    
/*     






















       
-- 0 Recoge datos de la tabla: SSUSRS 
 SELECT @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WHERE CODUSUA=@CODUSUA  

           


     -- 1. Valida usuarios permitido para eliminar en safact 
   IF  (Substring(@CODNVL,1,2)<>'1 ')
     BEGIN
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01098'
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END 






  
    /* BLOQUE INHABILITADO Y PUESTO A INVERNAR
     BEGIN
           -- VALIDACION DE TRANSACCION FACTIBLE.. YA ESTA SIENDO VALIDADO POR LA PROPIA APLICACION EN EL CUADRO DE TOTALIZAR
       -- VEHICULOS,REPUESTOS,SERVICIOS,TALLER,ALMACEN,OTROS SERVICIOS, COMPLEMENTO DE VEHICULO,GARANTIAS
       IF   (@CODOPER <> '01-101' AND @CODOPER <> '01-201' AND @CODOPER<> '01-301' AND @CODOPER<>'01-302' AND @CODOPER<>'01-303' AND @CODOPER <> '01-401' AND @CODOPER<> '01-501' AND @CODOPER <> '01-901' AND @CODOPER <> '01-304') OR (@CODOPER IS NULL)   
          BEGIN
           SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01001'
           EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR            
          END 
        ELSE
       -- SI LA TRANSAACIÓN ES VALIDA GRABA DATOS EN:SA_CTRANSAC, TABLA TRANSACCIONAL MODULO CONCESIONARIO. 
       INSERT SA_CTRANSAC (TipoDOC,NumeroD,NROPPAL,CODTERCERO,CODOPER,CODUSUA,CODESTA,FECHAT)
       VALUES  (@TipoDOC,@NumeroD,@NROUNICO,@CODTERCERO,@CODOPER,@CODUSUA,@CODESTA,GETDATE())
     END */ 
*/   
 
 END TRY

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
  
END CATCH 

 
*/



  
 
