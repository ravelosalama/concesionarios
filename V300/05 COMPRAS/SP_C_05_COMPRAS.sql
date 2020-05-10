-- *****************************************************************************************
-- PROCESA TODAS LAS COMPRAS DE LOS CONCESIONARIOS
-- 05 - COMPRA Y DEVOLUCION DE VEHICULOS 
-- 1. Corrige extension de compra del vehiculo.
-- 2. Crea vehiculo en inventario. Si existe lo actualiza.
-- 3. Crea registro de existencia en deposito de vehiculos.
-- 4. Crea registro de impuesto.
-- 5. Crea registro de extension del vehiculo. Si existe lo actualiza.
-- 05 - COMPRA Y DEVOLUCION DE REPUESTOS
-- 05 - COMPRA Y DEVOLUCION DE SERVICIOS
-- Segmentos de Codigos originales de Carlos Silva
-- Regenerado y Reprogramado para versiones superiores 901X 
-- Marzo 2016 por: JOSE RAVELO COMO:SP_05_COMPRAS_CONCESIONARIOS
-- **3** SEPTIEMBRE  2017:V310 SE MOFIFICA PERFIL 15 SE ELIMINA COMPRAS SE AGREGA NOTA DE ENTREGA Y PEDIDOS 
--                             SE MODIFICA PERFIL 2 Y SE AGREGA COMPRAS DE REPUESTOS CARGANDO DESDE NOTA DE ENTREGA.
-- *****************************************************************************************

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SESA_SP_COMPRA_VEHICULO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SESA_SP_COMPRA_VEHICULO]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_COMPRA_VEHICULO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE SP_05_COMPRA_VEHICULO
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_05_COMPRAS_CONCESIONARIOS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure SP_05_COMPRAS_CONCESIONARIOS
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_C_05_COMPRAS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure SP_C_05_COMPRAS
GO




SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
 

CREATE PROCEDURE  SP_C_05_COMPRAS @TipoDoc varchar(1), @NumeroD Varchar(10), @CodProv Varchar(10), @Codusua Varchar(10),@Codoper Varchar(10)
--WITH ENCRYPTION
AS


DECLARE @FechaHoy datetime
DECLARE @NumRec int

-- Datos del registro de IVA
DECLARE @CodTaxs varchar (5),
        @MontoIVA decimal (23,2),
        @EsPorct smallint

-- Datos del registro extendido de compra de vehiculo
DECLARE @CodProd varchar (15),
        @Serial varchar (35),
        @SerialMotor varchar (35),
        @Factura_compra varchar (10)

-- Datos del registro del modelo
DECLARE @Modelo varchar (25),
        @DescVehiculo varchar (35),
        @Marca varchar (20),
        @EsExento smallint

-- Datos del registro extendido del modelo
DECLARE @Ano int,
        @Cilindros int,
        @Kilometraje int,
        @Peso int,
        @Puestos int

-- Datos del registro extendido del vehiculo
DECLARE @Placa varchar (15),
        @Color varchar (25),
        @Status varchar (25),
        @CodInst int

-- Datos del registro de existencia
DECLARE @Deposito varchar (10),
        @Existencia decimal(28,3)

-- oTROS
DECLARE @CONCESIONARIO VARCHAR(35),
        @Atributos VARCHAR(60)


-- Datos del registro de item de la compra del vehiculo
DECLARE @CodItem varchar (15)

DECLARE @STATUSERROR INT,
        @DESCRIPERROR VARCHAR(300)
    SET @STATUSERROR=0
    
DECLARE @CODNVL VARCHAR(2) 
DECLARE @OR VARCHAR(20)   
    

SET @NumRec     = 0
SET @FechaHoy   = getdate()
SET @Status     = 'EN VENTA'
SET @CodInst    = '12'
SET @Deposito   = '020'
SET @Existencia = 0
SET @CodTaxs    = 'IVA'


-------------------------------------- <<<<< INICIO COMPRA DE VEHICULOS >>>>>>  --------------------------------------  

IF @Codoper = '05-101'

BEGIN
   -- RECOGE DATOS ADICIONALES COMPRA VEHICULO
   SELECT @Placa = UPPER(Placa),
          @Color = UPPER(Color),
          @SerialMotor = UPPER(Serial_Motor),
          @Kilometraje = ISNULL(Kilometraje,0),  
          @Atributos = UPPER(Atributos)
      FROM dbo.SACOMP_01 
      WHERE (TipoCom = @TipoDoc AND NumeroD = @NumeroD AND CodProv = @CodProv)



-- VALIDACIONES VIABILIDAD DE LA TRANSACCION 

   -- Valida si el usuario escribio bien el formato de la placa.   
   IF LEN(@PLACA) = 0 OR LEN(@PLACA)<6 OR LEN(@PLACA)>7 OR @PLACA=' ' or @Placa IS NULL
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01109'
     END
   
   -- Valida que no haya ningun campo vital vacio  
   IF  @PLACA='' OR @COLOR='' OR @SerialMotor='' or @PLACA is null OR @COLOR is null OR @SerialMotor is null 
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01096'
     END
    
   -- Valida que el usuario que este gestionando esta actividad sea valido. 
   SELECT @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WHERE CODUSUA=@CODUSUA  
   IF  Substring(@CODNVL,1,1)<>'4 ' 
     BEGIN
      SET @STATUSERROR=1
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01098'
     END 
     
 -- -- VERIFICA SI SE ACTIVO ALGUN SWICH DE VALIDACION, MUESTRA ADVERTENCIA Y REVERSA TRANSACCION

   IF @STATUSERROR=1
   
    BEGIN
       EXECUTE SP_00_VENTANA_ERROR @DESCRIPERROR
    END
     
-- OBJETO DEL PROCESO        
     
 
    -- REGOGE DATOS DE SERIALES DE COMPRA DE VEHICULO
   SELECT @CodItem = X.CodItem,
          @Serial  = X.NroSerial
      FROM SASEPRCOM AS X
      INNER JOIN dbo.SAITEMCOM AS Y
      ON (X.TipoCom = Y.TipoCom AND X.NumeroD = Y.NumeroD AND X.CodProv = Y.CodProv AND X.CodItem = Y.CodItem)
      WHERE (X.TipoCom = @TipoDoc AND X.NumeroD = @NumeroD AND X.CodProv = @CodProv)

   -- RECOGE DATOS 
   SELECT @Modelo       = x.CodProd,
          @DescVehiculo = X.Descrip,
          @Marca        = X.Marca,
          @EsExento     = X.EsExento,
          @Ano          = Y.Ano,
          @Cilindros    = Y.Cilindros,
          @Puestos      = Y.Puestos,
          @Peso         = Y.Peso
      FROM dbo.SAPROD AS X
      INNER JOIN dbo.SESA_VW_MODELOS AS Y
      ON (X.CodProd = Y.CodProd)
      WHERE (X.CodProd = @CodItem)

     -- recoge datos de concesionario
     SELECT @CONCESIONARIO = DESCRIP FROM SACONF 
    

   SET @NumRec = @@ROWCOUNT
   IF @NumRec > 0
   BEGIN
      -- Corrige extension de compra de vehiculo
      UPDATE dbo.SACOMP_01
         SET Placa       = @Placa,
             Kilometraje = @Kilometraje,
             Color       = @Color,
             Atributos   = @Atributos

         WHERE (TipoCom = @TipoDoc AND NumeroD = @NumeroD AND CodProv = @CodProv)
    
          
      IF LEN(@Placa)= 6 OR LEN(@Placa)=7
     
          BEGIN
     
            -- Crea o actualiza registro en datos adicionales de existencia para optimizar consulta.
            IF NOT EXISTS (SELECT * FROM SAPROD_11_03 WHERE serial=@serial)
              INSERT dbo.SAPROD_11_03 (CodProd, Serial, Placa, Color, Status)     
              VALUES (@modelo, @serial, @placa, @Color, 'DISPONIBLE')
            ELSE
              UPDATE SAPROD_11_03 
                 SET Codprod=@modelo,
                     Serial=@serial,
                     Color=@Color,
                     Status='DISPONIBLE'
                 WHERE SERIAL=@SERIAL
 
            -- Crea vehiculo en inventario.
            
            IF NOT EXISTS (SELECT * FROM SAPROD WHERE CodProd=@placa)
               INSERT dbo.SAPROD (CodProd, Descrip, CodInst,Refere, Marca, Descrip3, EsExento,Activo) 
               VALUES (@Placa, @DescVehiculo, @CodInst, @placa, @Marca, 'VEHICULO', @EsExento,0)
            ELSE
               UPDATE SAPROD 
                 SET  CODPROD=@Placa,
                      Descrip=@DescVehiculo,
                      CODINST=@CodInst,
                      Refere=@placa,
                      Marca=@Marca,
                      Descrip3='VEHICULO',
                      EsExento=@EsExento,
                      Activo=0
                 WHERE CODPROD=@Placa


            -- Crea registro de existencia en deposito de vehiculos.
            
             IF NOT EXISTS (SELECT * FROM SAEXIS WHERE CodProd=@placa AND CodUbic=@Deposito)
               INSERT dbo.SAEXIS (CodProd, CodUbic, Existen) 
               VALUES (@Placa, @Deposito, @Existencia)
             ELSE
               UPDATE SAEXIS 
                 SET CodProd=@Placa,
                     CodUbic=@Deposito,
                     Existen=@Existencia
                 where CodProd=@placa AND CodUbic=@Deposito
   

            -- Crea registro de impuesto.
            IF @EsExento = 0
            BEGIN
               SELECT @MontoIVA = MtoTax, @EsPorct = EsPorct FROM dbo.SATAXES WHERE (CodTaxs = @CodTaxs)
               INSERT SATAXPRD (CodProd, CodTaxs, Monto, EsPorct) 
                  VALUES (@Placa, @CodTaxs, @MontoIVA, @EsPorct)
            END
            

            -- Crea registro de extension del vehiculo.
            INSERT dbo.SAPROD_12_01 (CodProd, modelo, Serial, Serial_motor, Color, factura_compra, Kilometraje, Concesionario, Atributos) 
            VALUES (@Placa, @modelo, @Serial, @Serialmotor, @Color, @numerod, @Kilometraje, @Concesionario,@Atributos )
    
            -- Crea los registros en tabla de conversion SACSCODALTVEH Y SACODBAR
            -- Relaciona serial con la placa.
            IF NOT EXISTS (SELECT CODALT FROM SACSCODALTVEH WHERE CODALT=@placa)
              INSERT dbo.SACSCODALTVEH (CodProd, CodAlt, Tipo)     
              VALUES (@placa, @placa, '1')
            IF NOT EXISTS (SELECT CODALT FROM SACSCODALTVEH WHERE CODALT=@SERIAL)
              INSERT dbo.SACSCODALTVEH (CodProd, CodAlt, Tipo)     
              VALUES (@placa, @SERIAL, '2')
            IF NOT EXISTS (SELECT CODALT FROM SACSCODALTVEH WHERE CODALT=RIGHT(@SERIAL,9))
              INSERT dbo.SACSCODALTVEH (CodProd, CodAlt, Tipo)     
              VALUES (@placa, RIGHT(@SERIAL,9), '3')
            IF NOT EXISTS (SELECT CODALT FROM SACSCODALTVEH WHERE CODALT=RIGHT(@SERIAL,6))
              INSERT dbo.SACSCODALTVEH (CodProd, CodAlt, Tipo)     
              VALUES (@placa, RIGHT(@SERIAL,6), '4')


            IF NOT EXISTS (SELECT CODALTE FROM SACODBAR WHERE CODALTE=@placa)
              INSERT dbo.SACODBAR (CodProd, CodAlte)     
              VALUES (@placa, @placa)
            IF NOT EXISTS (SELECT CODALTE FROM SACODBAR WHERE CODALTE=@SERIAL)
              INSERT dbo.SACODBAR (CodProd, CodAlte)     
              VALUES (@placa, @SERIAL)
            IF NOT EXISTS (SELECT CODALTE FROM SACODBAR WHERE CODALTE=RIGHT(@SERIAL,9))
              INSERT dbo.SACODBAR (CodProd, CodAlte)     
              VALUES (@placa, RIGHT(@SERIAL,9))
            IF NOT EXISTS (SELECT CODALTE FROM SACODBAR WHERE CODALTE=RIGHT(@SERIAL,6))
              INSERT dbo.SACODBAR (CodProd, CodAlte)     
              VALUES (@placa, RIGHT(@SERIAL,6))
          END
   END
END
-------------------------------------<<<< fin compra de vehiculos >>>> ------------------------------------------





-------------------------------------- <<<<< INICIO COMPRA DE REPUESTOS >>>>>>  --------------------------------------  
IF @Codoper='05-201'    
    
BEGIN

-- VALIDACIONES VIABILIDAD DE LA TRANSACCION 
 
 
   
   SELECT @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WHERE CODUSUA=@CODUSUA  
   IF  Substring(@CODNVL,1,2)<>'15' AND Substring(@CODNVL,1,1)<>'2' -- observaciones en notas de inicio **3**
     BEGIN
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01098'
      EXECUTE SP_00_VENTANA_ERROR @DESCRIPERROR
     END 
     
 -- -- VERIFICA SI SE ACTIVO ALGUN SWICH DE VALIDACION, MUESTRA ADVERTENCIA Y REVERSA TRANSACCION


   

-- OBJETO DEL PROCESO        
     


END



-------------------------------------- <<<<< INICIO COMPRA DE SERVICIOS TOT >>>>>>  --------------------------------------  
-- ATENCION ESTE PROCESO DEBE REFINARSE DADO QUE ALGUNAS FACTURAS DE SERVICIOS TOT CONTIENEN SERVICIOS DE VARIAS OR.

IF @Codoper='05-301'    
    
BEGIN

-- VALIDACIONES VIABILIDAD DE LA TRANSACCION 
    SELECT @OR=Nro_OR FROM SACOMP_02 WHERE NumeroD=@NumeroD AND TipoCOM='H'  
    IF NOT EXISTS (SELECT * FROM SAFACT_01 WHERE (NUMEROD=@OR AND TIPOFAC='G')) 
    BEGIN
       
         SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01103'
         EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END  
 
   
   SELECT @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WHERE CODUSUA=@CODUSUA  
   IF  Substring(@CODNVL,1,2)<>'20' 
     BEGIN
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01098'
      EXECUTE SP_00_VENTANA_ERROR @DESCRIPERROR
     END 
     
     
     
     
 -- -- VERIFICA SI SE ACTIVO ALGUN SWICH DE VALIDACION, MUESTRA ADVERTENCIA Y REVERSA TRANSACCION

      
    
   

-- OBJETO DEL PROCESO        
     


END







SET QUOTED_IDENTIFIER OFF 
GO
