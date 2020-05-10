-- *****************************************************************************************
-- PROCESA DEVOLUCION DE VEHICULO
-- ELIMINA REGISTROS CON TRAZAS DE PLACA 
-- ********** REALIZADO POR CARLOS SILVA. MODIFICADO POR JOSE RAVELO ***********************
-- revisado ene-2013 JOSE RAVELO SOBRE LIBERTYLABORATORIO
-- Regenerado en Marzo 2016 por: JOSE RAVELO
-- *****************************************************************************************


SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SESA_SP_COMPRA_VEHICULO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SESA_SP_COMPRA_VEHICULO]
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SESA_SP_DEVCOMPRA_VEHICULO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SESA_SP_DEVCOMPRA_VEHICULO]
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_05_DEVOLUCION_VEHICULO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_05_DEVOLUCION_VEHICULO]
GO




SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
 
 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_C_05_DEVOLUCION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_C_05_DEVOLUCION]
GO



CREATE PROCEDURE  SP_C_05_DEVOLUCION @TipoDoc varchar(1), @NumeroD Varchar(10), @CodProv Varchar(10), @Codusua Varchar(10),@Codoper Varchar(10)
--WITH ENCRYPTION
AS

 

DECLARE @Placa varchar (10)

BEGIN
   SELECT @Placa = UPPER(ISNULL(X.Placa, ''))
      FROM SESA_VW_COMPRA_VEHICULO AS X
      WHERE (X.TipoCom = @TipoDoc AND X.NumeroD = @NumeroD AND X.CodProv = @CodProv)

   IF EXISTS (SELECT CodProd FROM dbo.SAPROD WHERE (CodProd = @Placa))
   BEGIN
      -- Actualiza vehiculo en inventario.
      DELETE FROM dbo.SAPROD   WHERE  (CodProd = @Placa)
         
      DELETE FROM SAPROD_12_01 WHERE  (CodProd = @Placa)
        
       DELETE FROM SAPROD_12_02 WHERE  (CodProd = @Placa)
       
        DELETE FROM SAPROD_12_03 WHERE  (CodProd = @Placa)
        
         DELETE FROM SAPROD_12_01 WHERE  (CodProd = @Placa)
         
          DELETE FROM SAPROD_11_03 WHERE  (Placa = @Placa)

      -- Actualiza registro de extension del vehiculo.
      DELETE FROM dbo.SESA_VW_VEHICULOS 
         WHERE (CodProd = @Placa)
   END
END

SET QUOTED_IDENTIFIER OFF 
GO
