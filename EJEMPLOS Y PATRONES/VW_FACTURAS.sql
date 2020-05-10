-- OJO VERIFICAR ESTA VISTA QUEDO ERRANTE NO SE DE DONDE SALIO NI QUE PROCESO LA REQUIERE, PRESUMO ES UNA ESCRITURA INSIPIENTE
-- DE ALGUN OBJETO QUE NO SE TERMINO.



USE [LibertyCarsAnualDB]
GO

/****** Object:  View [dbo].[VW_FACTURAS]    Script Date: 09/04/2016 01:34:15 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_FACTURAS]'))
DROP VIEW [dbo].[VW_FACTURAS]
GO

USE [LibertyCarsAnualDB]
GO

/****** Object:  View [dbo].[VW_FACTURAS]    Script Date: 09/04/2016 01:34:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_FACTURAS]
 

AS
SELECT     dbo.SAFACT.TipoFac      AS TIPOFAC,
           dbo.SAFACT.NumeroD      AS NUMEROD,
           dbo.SAFACT.NroCtrol     AS CONTROL,
           dbo.SAFACT.Signo        AS SIGNO, 
           dbo.SAFACT.CodClie      AS CODCLIE,
           dbo.SAFACT.CodVend      AS CODVEND,
           dbo.SAFACT.CodUbic      AS CODUBIC,
           dbo.SAFACT.Descrip      AS CLIENTE,
           dbo.SAFACT.ID3          AS RIF,
           dbo.SAFACT.Monto        AS MONTO,
           dbo.SAFACT.MtoTax       AS IVA,
           dbo.SAFACT.TGravable    AS GRAVABLE,
           dbo.SAFACT.TExento      AS Exento,
           dbo.SAFACT.CostoPrd     AS Costoprd,
           dbo.SAFACT.CostoSrv     AS CostoSrv,
           dbo.SAFACT.FechaE       AS Emision,
           dbo.SAFACT.TotalPrd     AS TOTALPRD,
           dbo.SAFACT.TotalSrv     AS TOTALSRV,
           dbo.SAFACT.CodOper      AS CODOPER,
           dbo.SAFACT_01.Orden_de_reparacion AS ORDEN_DE_REPARACION,
           dbo.SAFACT_01.Orden_de_Compra AS Orden_de_Compra,
           dbo.SAFACT_01.Liquidacion AS LIQUIDACION,
           dbo.SAFACT_01.Status AS STATUS
FROM       dbo.SAFACT INNER JOIN
                      dbo.SAFACT_01 ON dbo.SAFACT.NumeroD = dbo.SAFACT_01.NumeroD AND dbo.SAFACT.TipoFac = dbo.SAFACT_01.TipoFac


GO


