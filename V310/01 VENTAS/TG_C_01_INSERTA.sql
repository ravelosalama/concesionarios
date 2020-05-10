
if exists (select * from dbo.sysobjects where id = object_id(N'[SESA_TG_VALE_ENTREGA]'))
drop TRIGGER SESA_TG_VALE_ENTREGA  
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[INSERT_FACTURAS]'))
drop TRIGGER INSERT_FACTURAS  
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[INSERT_FACTURAS]'))
drop TRIGGER INSERT_FACTURAS  
GO





if exists (select * from dbo.sysobjects where id = object_id(N'[CORRIGE_COMPROMETIDOS]'))
drop TRIGGER CORRIGE_COMPROMETIDOS  
GO



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


if exists (select * from dbo.sysobjects where id = object_id(N'[TG_01_DETECTA_INSERT]'))
drop TRIGGER TG_01_DETECTA_INSERT
GO






-- ********************************************************************************
-- NUEVO TRIGGER PARA 9XXX CREADO POR: JOSE RAVELO MAR-2016 
-- DETECTA TRANSACCIÓN EN SAITEMFAC RECOGE DATOS DEL MISMO E INSERTA EN:
-- TRANSACCIONES VENTAS CONCESIONARIOS SA_CTRANSAC.
-- 21/04/2017 SE INCORPORA LA OPCION EN CODOPER<>'01-307' REFRESCAMIENTO DE DESPACHO
-- ********************************************************************************
 

if exists (select * from dbo.sysobjects where id = object_id(N'[TG_C_01_INSERTA]'))
drop TRIGGER TG_C_01_INSERTA
GO





CREATE TRIGGER TG_C_01_INSERTA ON SAITEMFAC
-- WITH ENCRYPTION
FOR INSERT 
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
        @totalg decimal(28,4)
       
      
 BEGIN --TRY            
        
-----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------

-- Recoge datos de la tabla: INSERTED
   SELECT @TIPODOC=TIPOFAC,
          @NUMEROD=NUMEROD
          FROM INSERTED
              

   SELECT @total=sum(totalItem) 
         from saitemfac where numerod=@numeroD and tipofac=@TIPODOC
  
   SELECT @Nrounico=nrounico,
          @Codoper=Codoper,
          @Codusua=Codusua,
          @Codesta=Codesta,
          @Fechat=Fechat,
          @CodTERCERO=Codclie,
          @totalg=totalprd+TOTALSRV
          from safact where numerod=@numerod and tipofac=@tipodoc   

   
   -- Verifica que sea el ultimo registro insertado
   IF  ROUND(@total,0)>=ROUND(@totalg,0)
      
    BEGIN
    
     
       -- VALIDACION DE TRANSACCION FACTIBLE.. YA ESTA SIENDO VALIDADO POR LA PROPIA APLICACION EN EL CUADRO DE TOTALIZAR
       -- VEHICULOS,REPUESTOS,SERVICIOS,TALLER,ALMACEN,OTROS SERVICIOS, COMPLEMENTO DE VEHICULO,GARANTIAS
       IF (@CODOPER <> '01-101' AND @CODOPER <> '01-201' AND @CODOPER<> '01-301' AND @CODOPER<>'01-302' AND @CODOPER<>'01-303' AND @CODOPER <> '01-401' AND @CODOPER<> '01-501' AND @CODOPER <> '01-901' and @CODOPER<>'01-304' AND @CODOPER<>'01-305' and @CODOPER<>'01-306' AND @CODOPER <> '01-307') OR (@CODOPER IS NULL)
          BEGIN
           SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01100'
           EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR            
          END 
        ELSE
       -- SI LA TRANSAACIÓN ES VALIDA GRABA DATOS EN:SA_CTRANSAC, TABLA TRANSACCIONAL MODULO CONCESIONARIO. 
       INSERT SA_CTRANSAC (TipoDOC,NumeroD,NROPPAL,CODTERCERO,CODOPER,CODUSUA,CODESTA,FECHAT)
       VALUES  (@TipoDOC,@NumeroD,@NROUNICO,@CODTERCERO,@CODOPER,@CODUSUA,@CODESTA,GETDATE())
       
       
       
     END 
   
 
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
  
END CATCH */

GO

 




  
 
