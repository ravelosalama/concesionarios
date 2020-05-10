if exists (select * from dbo.sysobjects where id = object_id(N'[TG_MASTER_CONCESIONARIO]'))
drop TRIGGER TG_MASTER_CONCESIONARIO  
GO


-- ********************************************************************************
-- NUEVO TRIGGER PARA 9020 CREADO POR: JOSE RAVELO MAR-2016 
-- DETECTA TRANSACCIÓN EN SA_CTRANSAC Y DISTRIBUYE A PROCEDIMIENTO 
-- MAESTRO DE DISTRIBUCION.
-- ********************************************************************************
 
if exists (select * from dbo.sysobjects where id = object_id(N'[TG_C_MASTER]'))
drop TRIGGER TG_C_MASTER  
GO
 

CREATE TRIGGER TG_C_MASTER ON SA_CTRANSAC
-- WITH ENCRYPTION
FOR INSERT 
AS
-----------------------------------
-- DECLARACION DE VARIABLES 
-----------------------------------
DECLARE @STATUSERROR INT,
        @DESCRIPERROR VARCHAR(300),
        @NROMAX INT,
        @NROLINEA INT,
        @NROREG INT,
        @total decimal(28,4),
        @totalg decimal(28,4)

   
-- Contenido de campos de saCOMP
DECLARE @TipoDOC     varchar (1),
        @NumeroD     varchar (20),
        @NROUNICO    INT
   
DECLARE @CODTERCERO VARCHAR(15),
        @CODOPER VARCHAR(10),
        @CODUSUA VARCHAR (10),
        @CODESTA VARCHAR (10),
        @FECHAT DATETIME
        
-----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------


SET @STATUSERROR=0



-- Recoge datos de la tabla: INSERTED
   SELECT @TIPODOC=TIPODOC,
          @NUMEROD=NUMEROD,
          @Nrounico=nrounico,
          @CodTERCERO=CodTERCERO,
          @Codoper=Codoper,
          @Codusua=Codusua,
          @Codesta=Codesta,
          @Fechat=Fechat 
   FROM INSERTED
 
   
     
   
    -- VERIFICA TRANSACCION Y DISTRIBUYE PROCEDIMIENTO
---------------------------------------------------------------------------------------------------------------- 
 
   -- 05 COMPRAS.
   
   -- <VEHICULOS>
   -- Procesa nueva compra de 101 - VEHICULO
   IF @TipoDoc = 'H' AND @CodOper = '05-101'
      EXECUTE dbo.SP_C_05_COMPRAS @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
  
   -- Procesa devolucion de compra de 101 - VEHICULO
   IF @TipoDoc = 'I' AND @CodOper = '05-101'
      EXECUTE dbo.SP_C_05_DEVOLUCION @TipoDoc, @NumeroD, @CodTERCERO, @Codusua, @Codoper
  
  
   -- <REPUESTOS>
   -- Procesa nueva compra de 201 - REPUESTOS
   
   IF @TipoDoc = 'H' AND @CodOper = '05-201'
       EXECUTE dbo.SP_C_05_COMPRAS @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
  
  
   -- Procesa devolucion de compra de 201 - REPUESTOS
   --IF @TipoDoc = 'I' AND @CodOper = '05-201'
   --   EXECUTE dbo.SP_05_DEVOLUCION_REPUESTOS @TipoDoc, @NumeroD, @CodTERCERO, @Codusua, @Codoper
  
  
   -- <SERVICIOS>
   -- Procesa nueva compra de 301 - SERVICIOS TOT 
   --IF @TipoDoc = 'H' AND @CodOper = '05-301'
   --   EXECUTE dbo.SP_05_COMPRA_SERVICIOS @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
  
   -- Procesa devolucion de compra de 301 - SERVICIOS TOT
   --IF @TipoDoc = 'I' AND @CodOper = '05-301'
   --   EXECUTE dbo.SP_05_DEVOLUCION_SERVICIOS @TipoDoc, @NumeroD, @CodTERCERO, @Codusua, @Codoper
  
  
  
  
--===========================================================================================================================  
     -- 01 <VENTAS>.
    
        -- 101 <VEHICULOS>    
        -- Procesa PREFACTURA de 101 - VEHICULO
  IF @TipoDoc = 'G' AND @CodOper = '01-101'
    begin
         EXECUTE dbo.SP_C_01_PRE_PROCESOS @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
    end
    
        -- Procesa FACTURACION de 101 - VEHICULO
  IF @TipoDoc = 'A' AND @CodOper = '01-101'
    begin
         EXECUTE dbo.SP_C_01_PROCESADAS @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
    end
         
        -- Procesa DEVOLUCION de 101 - VEHICULO
  IF @TipoDoc = 'B' AND @CodOper = '01-101'
         EXECUTE dbo.SP_C_01_PROCESADAS @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper



   
--============================================================================================================================   
        -- 201 <REPUESTOS>
        
       
    
  IF @TipoDoc = 'F' AND @CodOper = '01-201'  -- Procesa PRESUPUESTO DE REPUESTOS de 201 - REPUESTOS 
         EXECUTE dbo.SP_C_01_PRE_PROCESOS @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
         
  IF @TipoDoc = 'G' AND @CodOper = '01-201'  -- Procesa PREFACTURA de 201 - REPUESTOS
         EXECUTE dbo.SP_C_01_PRE_PROCESOS @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
    
       
  IF @TipoDoc = 'A' AND @CodOper = '01-201'  -- Procesa FACTURACION de 201 - REPUESTOS
         EXECUTE dbo.SP_C_01_PROCESADAS @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
       
        
  IF @TipoDoc = 'B' AND @CodOper = '01-201' -- Procesa DEVOLUCION de 201 - REPUESTOS
         EXECUTE dbo.SP_C_01_PROCESADAS @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
  
   

  --=========================================================================================================================== 
      
        -- 301 <SERVICIOS>
        IF @TipoDoc = 'G' AND @CodOper = '01-301'   -- Procesa ORDEN DE REPARACION de 301 - SERVICIOS (documento en espera)
      EXECUTE dbo.SP_C_01_301 @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
      
        IF @TipoDoc = 'F' AND @CodOper = '01-302'   -- Procesa VALES TALLER - ALMACEN 302 - TALLER (presupuesto)
      EXECUTE dbo.SP_C_01_302 @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
          
        IF @TipoDoc = 'F' AND @CodOper = '01-303'   -- Procesa DESPACHO ALMACEN A TALLER 303 - ALMACEN (presupuesto)
      EXECUTE dbo.SP_C_01_303 @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
      
        IF @TipoDoc = 'F' AND @CodOper = '01-304'   -- Procesa REVERSO DE DESPACHO ALMACEN A TALLER 304 - ALMACEN (presupuesto)
      EXECUTE dbo.SP_C_01_304 @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
            
        IF @TipoDoc = 'A' AND @CodOper = '01-301'   -- Procesa FACTURACION de 301 - SERVICIOS
      EXECUTE dbo.SP_C_01_PROCESADAS @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
  
        IF @TipoDoc = 'B' AND @CodOper = '01-301'   -- Procesa DEVOLUCION de 301 - SERVICIOS
      EXECUTE dbo.SP_C_01_PROCESADAS @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
     
        IF @TipoDoc = 'F' AND @CodOper = '01-305'   -- Procesa presupuestos a taller sobre OR 305 - (presupuesto)
      EXECUTE dbo.SP_C_01_305 @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
   
        IF @TipoDoc = 'F' AND @CodOper = '01-306'   -- Procesa anulacion de presupuestos a taller sobre OR 306 - (anulacion)
      EXECUTE dbo.SP_C_01_306 @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
      
        IF @TipoDoc = 'F' AND @CodOper = '01-307'   -- Efectua refrescamiento de despachos sobre OR 307 - (Refrescamiento)
      EXECUTE dbo.SP_C_01_307 @TipoDoc, @NumeroD, @CodTERCERO, @CodUsua, @Codoper
   
   
   
   
   
   
   
   
   