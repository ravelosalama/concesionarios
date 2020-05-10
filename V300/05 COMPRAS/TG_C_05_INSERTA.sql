
if exists (select * from dbo.sysobjects where id = object_id(N'[CONCESIONARIOS_TG_ESPERA_OR]'))
drop TRIGGER CONCESIONARIOS_TG_ESPERA_OR  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[SESA_TG_COMPRA_VEHICULO_INSERT]'))
drop TRIGGER SESA_TG_COMPRA_VEHICULO_INSERT  
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[INSERT_ORDEN]'))
drop TRIGGER INSERT_ORDEN  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TG_05_INSERTA_TRANSACCION]'))
drop TRIGGER TG_05_INSERTA_TRANSACCION  




-- ********************************************************************************
-- NUEVO TRIGGER PARA 902X CREADO POR: JOSE RAVELO MAR-2016 
-- DETECTA TRANSACCIÓN EN SACOMP_03, RECOGE DATOS DEL MISMO E INSERTA EN:
-- TRANSACCIONES CONCESIONARIOS.
-- ********************************************************************************
 
if exists (select * from dbo.sysobjects where id = object_id(N'[TG_C_05_INSERTA]'))
drop TRIGGER TG_C_05_INSERTA  

GO


CREATE TRIGGER TG_C_05_INSERTA ON SACOMP_03
-- WITH ENCRYPTION
AFTER INSERT 
AS
-----------------------------------
-- DECLARACION DE VARIABLES 
-----------------------------------
DECLARE @STATUSERROR INT,
        @DESCRIPERROR VARCHAR(300)
    SET @STATUSERROR=0
    
-- Contenido de campos de saCOMP
DECLARE @TipoDOC     varchar (1),
        @NumeroD     varchar (20),
        @NROUNICO    INT
   
DECLARE @CODTERCERO VARCHAR(15),
        @CODOPER VARCHAR(10),
        @CODUSUA VARCHAR (10),
        @CODESTA VARCHAR (10),
        @FECHAT DATETIME
        
DECLARE @COLOR VARCHAR(50)        
        
-----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------

-- Recoge datos de la tabla: INSERTED
   SELECT @TIPODOC=TIPOcom,
          @NUMEROD=NUMEROD,
          @CodTERCERO=Codprov
     
   FROM INSERTED
   
   
   select @Nrounico=nrounico,
          @Codoper=Codoper,
          @Codusua=Codusua,
          @Codesta=Codesta,
          @Fechat=Fechat
   from sacomp where numerod=@numerod and tipocom=@tipodoc and codprov=@codtercero     


-- VALIDACION DE TRANSACCION FACTIBLE

IF   (@CODOPER <> '05-101' AND @CODOPER <> '05-201' AND @CODOPER<> '05-301' AND @CODOPER <> '05-401' AND @CODOPER<> '05-501' AND @CODOPER <> '05-601' AND @CODOPER<> '05-310' AND @CODOPER<>'05-701' AND @CODOPER<>'05-500' AND @CODOPER<>'05-801') OR (@CODOPER IS NULL)
        BEGIN
         SET @STATUSERROR=1
         SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01095'            
        END 
 
        
-- VERIFICA SI SE ACTIVO ALGUN SWICH DE VALIDACION, MUESTRA ADVERTENCIA Y REVERSA TRANSACCION

   IF @STATUSERROR=1
   BEGIN
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR  
   END

-- SI LA TRANSAACIÓN ES VALIDA GRABA DATOS EN:SA_CTRANSAC, TABLA TRANSACCIONAL MODULO CONCESIONARIO. 
    
   INSERT SA_CTRANSAC (TipoDOC,NumeroD,NROPPAL,CODTERCERO,CODOPER,CODUSUA,CODESTA,FECHAT)
   VALUES  (@TipoDOC,@NumeroD,@NROUNICO,@CODTERCERO,@CODOPER,@CODUSUA,@CODESTA,GETDATE())






