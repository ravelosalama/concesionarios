-- INICIO DEL PROCESO DE DISEÑO EN MAEZO 2018
-- CONTINUACIÓN 19/07/2018 SOBRE RESPALDO DEL MISMO DIA EFECTUADO SOBRE LIBERTYLABORATORIO_9024_V31
-- CONTINUACIÓN 13/08/2018 SE REALIZAN: 
-- CONTINUACION 16/08/2018
-- CULMINACION DEL QUERY 17/08/2018
-- REVISIÓN GENERAL DEL QUERY 18/08/2018
-- EJECUCIÓN DE PRUEBA 18/08/2018 SOBRE LIBERTYLABORATORIO_9024_V31

-- DESARROLLO DE LA RECONVERSIÓN:
-- LIBERTY CARS RESPADO SATISFACTORIO, RECONVERSION SATISFACTORIA, FALTA MONTAR CLON NO CONVERTIDO PARA CONSULTA.
-- PRESTIGE CARS RESPALDO FALLIDO, RECONVERSION SATISFACTORIA, PENDIENTE RECONSTRUIR BD ORIGEN Y CLONAR.
-- METROPOLIS CARS: RESPLADO SATISFACTORIO, RECONVESRION SATISFACTORIA, FALTA MONTAR CLON NO CONVERTIDO PARA CONSULTA.
-- PLANET CARS:     RESPLADO SATISFACTORIO, RECONVESRION SATISFACTORIA, FALTA MONTAR CLON NO CONVERTIDO PARA CONSULTA.
-- RORAIMA MOTORS:  RESPLADO SATISFACTORIO, RECONVESRION SATISFACTORIA, FALTA MONTAR CLON NO CONVERTIDO PARA CONSULTA.
-- GUAYANAUTO    :  RESPLADO SATISFACTORIO, RECONVESRION SATISFACTORIA, FALTA MONTAR CLON NO CONVERTIDO PARA CONSULTA.
-- REPUESTOS MODELO:RESPLADO SATISFACTORIO, RECONVESRION SATISFACTORIA, FALTA MONTAR CLON NO CONVERTIDO PARA CONSULTA.
-- SURAUTO         :RESPLADO SATISFACTORIO, RECONVESRION SATISFACTORIA, FALTA MONTAR CLON NO CONVERTIDO PARA CONSULTA.
--










-- EN SERVIDOR LCARS001.
-- LA LISTA DE TABLAS ESTA EN ORDEN DE LECTURA EN LA BASE DE DATOS Y QUE TENGAN CAMPOS DE VALORES NUMERICOS
-- Se observan campos decimales 28,3 que no son suceptibles a la reconversion generalmente como campos cantidades.
-- Estos ultimos no han sido tomado en cuenta en el query.







--/*



-- 1
UPDATE  [SA_C_RETIVAVTA]
   SET  
      [MONTO] = MONTO/100000 
      
GO

-- 2
UPDATE [SAACXC]
   SET 
      [MontoMEx]  = MontoMEx/100000,
      [SaldoMEx]  = SaldoMEx/100000,
      [Monto]     = Monto/100000,
      [MontoNeto] = MontoNeto/100000,
      [MtoTax]    = MtoTax/100000,
      [RetenIVA]  = RetenIVA/100000,
      [OrgTax]    = OrgTax/100000,
      [Saldo]     = Saldo/100000,
      [SaldoAct]  = SaldoAct/100000,      
      [BaseImpo]  = BaseImpo/100000,
      [CancelI]   = CancelI/100000,
      [CancelA]   = CancelA/100000,
      [CancelE]   = CancelE/100000,
      [CancelC]   = CancelC/100000,      
      [CancelT]   = CancelT/100000,
      [CancelG]   = CancelG/100000,
      [Comision]  = Comision/100000,
      [SaldoOrg]  = SaldoOrg/100000,
      [CancelP]   = CancelP/100000,
      [TExento]   = TExento/100000,
      [CancelD]   = CancelD/100000,
      [Debitos]   =Debitos/100000,
      [Creditos]  =Creditos/100000
    
    
 GO
 
-- 3 
UPDATE [SAACXP]
   SET 
      [MontoMEx]  = MontoMEx /100000,
      [SaldoMEx]  = SaldoMEx /100000,
      [Monto]     = Monto    /100000, 
      [MontoNeto] = MontoNeto/100000, 
      [MtoTax]    = MtoTax   /100000,
      [RetenIVA]  = RetenIVA /100000,
      [OrgTax]    = OrgTax   /100000,
      [Saldo]     = Saldo    /100000,
      [SaldoAct]  = SaldoAct /100000,
      [BaseImpo]  = BaseImpo /100000,
      [CancelI]   = CancelI  /100000, 
      [CancelA]   = CancelA  /100000, 
      [CancelE]   = CancelE  /100000, 
      [CancelC]   = CancelC  /100000, 
      [CancelT]   = CancelT  /100000, 
      [CancelG]   = CancelG  /100000, 
      [SaldoOrg]  = SaldoOrg /100000, 
      [TExento]   = TExento  /100000, 
      [CancelD]   = CancelD  /100000, 
      [Debitos]   = Debitos  /100000, 
      [Creditos]  = Creditos /100000
     
GO

--4
UPDATE [SACLIE] 
   SET  
      LimiteCred = LimiteCred/100000, 
      [Saldo] = Saldo/100000, 
      [MontoMax] = MontoMax/100000, 
      [MtoMaxCred] = MtoMaxCred/100000, 
      [PagosA] = PagosA/100000, 
      [PromPago] = PromPago/100000, 
      [RetenIVA] = RetenIVA/100000, 
      [Descto] = Descto/100000, 
      [MontoUV] = MontoUV/100000, 
      [MontoUP] = MontoUP/100000, 
      [SaldoPtos] = SaldoPtos/100000 
   
GO

--5
UPDATE  [SACLIE_05]
   SET  
      [Efectivo]            = Efectivo/100000, 
      [Cheque]              = Cheque/100000, 
      [Instrumento_de_Pago] = Instrumento_de_Pago/100000
      
GO

/*
--6
UPDATE [SACLIE_06]
   SET Exento = Exento /100000
       ,Base_Imponible = Base_Imponible/100000 
       ,Alicuota = Alicuota/100000
       ,Saldo = Saldo/100000
       
GO
*/



--7
UPDATE SACLPR 
 
    SET [precio]=precio/100000
GO


--8
UPDATE [SACMEC]
   SET [Desde] = Desde/100000,
       [Hasta] = Hasta/100000,
       [Monto] = Monto/100000 

GO

--9
UPDATE [SACOMP]
   SET 
       [MontoMEx] = MontoMEx/100000
      ,[Monto] = Monto/100000
      ,[OtrosC] = OtrosC/100000 
      ,[MtoTax] = MtoTax/100000
      ,[Fletes] = Fletes/100000
      ,[TGravable] = TGravable/100000
      ,[TExento] = TExento/100000
      ,[DesctoP] = DesctoP/100000
      ,[RetenIVA] = RetenIVA/100000
      ,[CancelI] = CancelI/100000
      ,[CancelE] = CancelE/100000
      ,[CancelT] = CancelT/100000 
      ,[CancelC] = CancelC/100000 
      ,[CancelA] = CancelA/100000 
      ,[CancelG] = CancelG/100000 
      ,[Descto1] = Descto1/100000  
      ,[MtoInt1] = MtoInt1/100000 
      ,[Descto2] = Descto2/100000 
      ,[MtoInt2] = MtoInt2/100000 
      ,[MtoFinanc] = MtoFinanc/100000 
      ,[TotalPrd] = TotalPrd/100000 
      ,[TotalSrv] = TotalSrv/100000 
      ,[SaldoAct] = SaldoAct/100000 
      ,[MtoPagos] = MtoPagos/100000 
      ,[MtoNCredito] = MtoNCredito/100000 
      ,[MtoNDebito] = MtoNDebito/100000 
      ,[MtoTotal] = MtoTotal/100000 
      ,[Contado] = Contado/100000 
      ,[Credito] = Credito/100000 
      ,[TGravable0] = TGravable0/100000 
      
GO

-- 10
UPDATE SACVEN 
     SET  
       [Desde]=Desde/100000
      ,[Hasta]=Hasta/100000
      ,[Monto]=Monto/100000
GO

-- 11
UPDATE [dbo].[SAECLI]
   SET [Credito] = Credito/100000 
      ,[Contado] = Contado/100000 
      ,[Descto] =  Descto/100000 
      ,[Costo] = Costo/100000 
      ,[MtoDevol] = MtoDevol/100000 
      ,[MtoPagos] = MtoPagos/100000 
      ,[MtoNDebito] = MtoNDebito/100000 
      ,[MtoNCredito] = MtoNCredito/100000 
      ,[MtoRetenImp] = MtoRetenImp/100000
 
GO

--12
UPDATE [dbo].[SAECOM]
   SET [MtoCompra] = MtoCompra/100000 
      ,[MtoTax] =  MtoTax/100000 
      ,[Descto] =  Descto/100000 
      ,[Fletes] =  Fletes/100000 
      ,[Contado] = Contado/100000 
      ,[Credito] = Credito/100000 
      
      
      GO

--13

UPDATE [dbo].[SAEMEC]
   SET [MtoVentas] = MtoVentas/100000
      ,[CntVentas] = CntVentas/100000 
      ,[Comision] = Comision/100000 
GO


--14

UPDATE [dbo].[SAEOPI]
   SET [MtoCargos] = MtoCargos/100000 
      ,[MtoDescarg] = MtoDescarg/100000 
      ,[MtoTraslad] = MtoTraslad/100000 
      
GO

--15

UPDATE [dbo].[SAEPRD]
   SET [MtoCompra] = MtoCompra/100000 
      ,[MtoVentas] = MtoVentas/100000 
      ,[Costo] = Costo/100000 
      ,[MtoCargos] = mtoCargos/100000 
      ,[MtoDescarg] = MtoDescarg/100000 
      ,[CostoFinal] = CostoFinal/100000 
GO

--16 

UPDATE [dbo].[SAEPRV]
   SET [Credito] = Credito/100000 
      ,[Contado] = Contado/100000 
      ,[MtoDevol] = MtoDevol/100000 
      ,[MtoPagos] = MtoPagos/100000 
      ,[MtoNDebito] = MtoNDebito/100000 
      ,[MtoNCredito] = MtoNCredito/100000 
      ,[MtoRetenImp] = MtoRetenImp/100000 
 
 GO
 

--17

UPDATE [dbo].[SAESRV]
   SET 
       [MtoVentas] = MtoVentas/100000 
      ,[Costo] = Costo/100000 
      ,[MtoCompra] = MtoCompra/100000 
      
GO

--18

UPDATE [dbo].[SAETAR]
   SET [MtoVentas] = MtoVentas/100000
      ,[MtoRetenImp] = MtoRetenImp/100000
      ,[Impuesto] = Impuesto/100000
      ,[MtoTotReten] = MtoTotReten/100000
      ,[MtoTips] = MtoTips/100000 
      ,[MtoIngreso] = MtoIngreso/100000
      ,[MtoCompra] = MtoCompra/100000 
 
GO

--19

UPDATE [dbo].[SAEVEN]
   SET [MtoVentas] = MtoVentas/100000 
      ,[Costo] = Costo/100000 
      ,[MtoIngreso] = MtoIngreso/100000 
      ,[MtoComiVta] = MtoComiVta/100000 
      ,[MtoComiCob] = MtoComiCob/100000 
 
GO

--20

UPDATE [dbo].[SAEVTA]
   SET [MtoVentas] = MtoVentas/100000 
      ,[Descto] = Descto/100000 
      ,[Fletes] = Fletes/100000
      ,[MtoTax] = MtoTax/100000
      ,[Contado] = Contado/100000
      ,[Credito] = Credito/100000
      ,[Costo] = Costo/100000
 GO


--21

UPDATE [SAEXISCON]
   SET  
      [Monto] = Monto/100000 
      
GO

--22

UPDATE [dbo].[SAFACT]
   SET [MontoMEx] = montoMEx/100000
      ,[Monto] = Monto/100000
      ,[MtoTax] = MtoTax/100000
      ,[Fletes] = Fletes/100000
      ,[TGravable] = TGravable/100000
      ,[TExento] = TExento/100000
      ,[CostoPrd] = CostoPrd/100000
      ,[CostoSrv] = CostoSrv/100000
      ,[DesctoP] = DesctoP/100000
      ,[RetenIVA] = RetenIVA/100000
      ,[CancelI] = CancelI/100000
      ,[CancelA] = CancelA/100000
      ,[CancelE] = CancelE/100000
      ,[CancelC] = CancelC/100000 
      ,[CancelT] = CancelT/100000 
      ,[CancelG] = CancelG/100000 
      ,[Cambio] = Cambio/100000 
      ,[MtoExtra] = MtoExtra/100000 
      ,[Descto1] = Descto1/100000 
      ,[PctAnual] = PctAnual/100000 
      ,[MtoInt1] = MtoInt1/100000 
      ,[Descto2] = Descto2/100000 
      ,[PctManejo] = PctManejo/100000 
      ,[MtoInt2] = MtoInt2/100000 
      ,[MtoFinanc] = MtoFinanc/100000 
      ,[TotalPrd] = TotalPrd/100000 
      ,[TotalSrv] = TotalSrv/100000 
      ,[MtoComiVta] = MtoComiVta/100000 
      ,[MtoComiCob] = MtoComiCob/100000 
      ,[MtoComiVtaD] = MtoComiVtaD/100000
      ,[MtoComiCobD] = MtoComiCobD/100000
      ,[SaldoAct] = SaldoAct/100000 
      ,[MtoPagos] = MtoPagos/100000 
      ,[MtoNCredito] = MtoNCredito/100000 
      ,[MtoNDebito] = MtoNDebito/100000 
      ,[ValorPtos] = ValorPtos/100000 
      ,[CancelP] = CancelP/100000 
      ,[MtoTotal] = MtoTotal/100000 
      ,[Contado] = Contado/100000 
      ,[Credito] = Credito/100000 
      ,[TGravable0] = TGravable0/100000 
 GO


--Voy por SAINITI la cual es una tabla muy grande que habria que valorar su conversión o limpieza dado que gran parte se va ir a 0
--23
UPDATE [dbo].[SAINITI]
   SET 
         
         [Costo] = Costo/100000 
        ,[CostoFinal] = CostoFinal/100000 
        
   WHERE Costo<>0     
        
        
GO

--24

UPDATE [dbo].[SAINSTA]
   SET [Descto] = Descto/100000
   
   go


--25

UPDATE [dbo].[SAIPACXC]
   SET 
       [Monto] = Monto/100000
      ,[Impuesto] = Impuesto/100000
      ,[RetencT] = RetencT/100000 
      
GO


--26

UPDATE [dbo].[SAIPAVTA]
   SET [Monto] = Monto/100000 
      ,[Propina] = Propina/100000 
      ,[Impuesto] = Impuesto/100000 
      ,[RetencT] = RetencT/100000 
     
GO

--27

UPDATE [dbo].[SAITEMCOM]
   SET 
       [Costo] = Costo/100000
      ,[Precio1] = Precio1/100000
      ,[Precio2] = Precio2/100000
      ,[Precio3] = Precio3/100000
      ,[PrecioU] = PrecioU/100000
      ,[Precio] = Precio/100000
      ,[Descto] = Descto/100000
      ,[TotalItem] = TotalItem/100000
      ,[PrecioU2] = PrecioU2/100000 
      ,[PrecioU3] = PrecioU3/100000  
      ,[MtoTax] = MtoTax/100000
      ,[CostOrg] = CostOrg/100000  
 GO
 
 --28
 
 UPDATE [dbo].[SAITEMFAC]
   SET [Costo] = Costo/100000 
      ,[Precio] = Precio/100000     
      ,[Descto] = Descto/100000 
      ,[TotalItem] = TotalItem/100000
      ,[MtoTax] = MtoTax/100000 
      ,[PriceO] = PriceO/100000 
 
GO

--29

UPDATE [dbo].[SAITEMOPI]
   SET 
       [Costo] = Costo/100000 
      ,[Precio] = Precio/100000 
      ,[Descto] = Descto/100000 
      ,[TotalItem] = TotalItem/100000 
      ,[PrecioU] = PrecioU/100000 
      
      
      GO
      
      
--30

UPDATE [dbo].[SAITEMPLANI]
   SET 
       [Monto] = Monto/100000 
      ,[Saldo] = Saldo/100000 
      ,[CancelI] = CancelI/100000 
      ,[CancelA] = CancelA/100000 
      ,[CancelE] = CancelE/100000 
      ,[CancelC] = CancelC/100000 
      ,[CancelT] = CancelT/100000
      ,[CancelG] = CancelG/100000 
      ,[Comision] = Comision/100000 
      
      
GO

--31

UPDATE [dbo].[SAITEO]
   SET 
       [Monto] = Monto/100000 
      ,[Comision] = Comision/100000
      ,[Desde] = Desde/100000
      ,[Hasta] = Hasta/100000
 
 
GO

--32

UPDATE [dbo].[SAITFL]
   SET 
       [Precio] = Precio/100000
  
GO



--33

UPDATE  [dbo].[SAITOR]
   SET  
       [Precio] = Precio/100000 
      ,[Descto] = Descto/100000  
      ,[MtoTax1] = MtoTax1/100000  
      ,[MtoTax2] = MtoTax2/100000  
      ,[MtoTax3] = MtoTax3/100000  
      ,[MtoTax4] = MtoTax4/100000  
      ,[MtoTax5] = MtoTax5/100000  
 
GO


--34

UPDATE [dbo].[SALOTE]
   SET 
       [Costo] = Costo/100000 
      ,[Precio] = Precio/100000
      ,[PrecioU] = PrecioU/100000 
      ,[Precio1] = Precio1/100000 
      ,[PrecioU1] = PrecioU1/100000 
      ,[Precio2] = Precio2/100000 
      ,[PrecioU2] = PrecioU2/100000 
      ,[Precio3] = Precio3/100000 
      ,[PrecioU3] = PrecioU3/100000 
      ,[PuestoI] = PuestoI/100000 
 
GO



--35


UPDATE [dbo].[SAOPEI]
   SET 
   [Monto] = Monto/100000
   
      
GO


--36



UPDATE [dbo].[SAORDT]
   SET 
       [Descto] = Descto/100000
      ,[MtoTax1] = MtoTax1/100000
      ,[MtoTax2] = MtoTax2/100000
      ,[MtoTax3] = MtoTax3/100000
      ,[MtoTax4] = MtoTax4/100000
      ,[MtoTax5] = MtoTax5/100000
   
GO



-- 37

UPDATE [dbo].[SAPAGCXC]
   SET 
       [MontoDocA] = MontoDocA/100000
      ,[Monto] = Monto/100000
      ,[Comision] = Comision/100000
      ,[BaseReten] = BaseReten/100000 
      ,[BaseImpo] = BaseImpo/100000 
      ,[MtoTax] = MtoTax/100000 
      ,[RetenIVA] = RetenIVA/100000 
      ,[TExento] = TExento/100000 
      
GO


--38

UPDATE [dbo].[SAPAGCXP]
   SET [MontoDocA] = MontoDocA/100000 
      ,[Monto] = Monto/100000 
      ,[BaseReten] = BaseReten/100000 
      ,[BaseImpo] = BaseImpo/100000 
      ,[MtoTax] = MtoTax/100000 
      ,[RetenIVA] = RetenIVA/100000 
      ,[TExento] = TExento/100000 
      
GO


--39

UPDATE [dbo].[SAPLANI]
   SET 
   [Monto] = Monto/100000 
 
GO

--40

UPDATE  [dbo].[SAPRIM]
   SET [CostAct] = CostAct/100000
      ,[CostPro] = CostPro/100000
      ,[CostAnt] = CostAnt/100000
      ,[Precio1] = Precio1/100000
      ,[Precio2] = Precio2/100000 
      ,[Precio3] = Precio3/100000
      ,[Costo1] = Costo1/100000 
      ,[Costo2] = Costo2/100000 
      ,[Costo3] = Costo3/100000 
      ,[Costo4] = Costo4/100000 
      ,[Costo5] = Costo5/100000 
      ,[Costo6] = Costo6/100000 
      ,[Costo7] = Costo7/100000 
      ,[Costo8] = Costo8/100000 
      ,[Costo9] = Costo9/100000 
      ,[Costo10] = Costo10/100000 
 
GO

--41

UPDATE [dbo].[SAPRIMCOM]
   SET 
       [PrecioU] = PrecioU/100000 
      ,[Precio1] = Precio1/100000 
      ,[Precio2] = Precio2/100000 
      ,[Precio3] = Precio3/100000 
      ,[PrecioI1] = PrecioI1/100000
      ,[PrecioI2] = PrecioI2/100000 
      ,[PrecioI3] = PrecioI3/100000 
      ,[Costo1] = Costo1/100000 
      ,[Costo2] = Costo2/100000 
      ,[Costo3] = Costo3/100000 
      ,[Costo4] = Costo4/100000 
      ,[Costo5] = Costo5/100000 
      ,[Costo6] = Costo6/100000 
      ,[Costo7] = Costo7/100000 
      ,[Costo8] = Costo8/100000 
      ,[Costo9] = Costo9/100000 
      ,[Costo10] = Costo10/100000 
      ,[PrecioU2] = PrecioU2/100000 
      ,[PrecioU3] = PrecioU3/100000 
      
      
GO


--42

UPDATE [dbo].[SAPROD]
   SET [Precio1] = Precio1/100000 
      ,[Precio2] = Precio2/100000
      ,[Precio3] = Precio3/100000
      ,[PrecioU] = PrecioU/100000 
      ,[CostAct] = CostAct/100000
      ,[CostPro] = CostPro/100000
      ,[CostAnt] = CostAnt/100000
      ,[PrecioU2] = PrecioU2/100000
      ,[PrecioU3] = PrecioU3/100000
      
GO


--43

UPDATE [dbo].[SAPROV]
   SET 
       [Saldo] = Saldo/100000 
      ,[MontoMax] = MontoMax/100000 
      ,[PagosA] = PagosA/100000 
      ,[PromPago] = PromPago/100000 
      ,[RetenIVA] = RetenIVA/100000 
      ,[MontoUC] = MontoUC/100000 
      ,[MontoUP] = MontoUP/100000 
      
GO


--44

UPDATE [dbo].[SAPVPR]
   SET [Costo] = Costo/100000 
     
GO


--45

UPDATE [dbo].[SARGOCAT]
   SET 
       [Desde] = Desde/100000 
      ,[Hasta] = Hasta/100000 
      ,[Monto] = Monto/100000 
 
GO


--46


UPDATE [dbo].[SARGORET]
   SET [Desde] = Desde/100000 
      ,[Hasta] = Hasta/100000 
      ,[Monto] = Monto/100000 
 
 GO
 
 
 
 
 --47    -------CONCESIONARIOS
 
 
 UPDATE [dbo].[SASE_RETIVACXC]
   SET [MONTO] = MONTO/100000 
 
GO



/*
--48

UPDATE [dbo].[SASERGUA]
   SET [Precio1] = Precio1/100000 
      ,[PrecioI1] = PrecioI1/100000
      ,[Precio2] = Precio2/100000
      ,[PrecioI2] = PrecioI2/100000
      ,[Precio3] = Precio3/100000
      ,[PrecioI3] = PrecioI3/100000
      ,[Costo] = Costo/100000
      ,[Comision] = Comision/100000 
      
GO

--49

UPDATE [dbo].[SASERPLA]
   SET [Precio1] = Precio1/100000 
      ,[PrecioI1] = PrecioI1/100000 
      ,[Precio2] = Precio2/100000 
      ,[PrecioI2] = PrecioI2/100000 
      ,[Precio3] = Precio3/100000 
      ,[PrecioI3] = PrecioI3/100000 
      ,[Costo] = Costo/100000 
      ,[Comision] = Comision/100000 
      
GO
*/

--50

UPDATE [dbo].[SASERV]
   SET [Precio1] = Precio1/100000 
      ,[PrecioI1] = PrecioI1/100000 
      ,[Precio2] = Precio2/100000 
      ,[PrecioI2] = PrecioI2/100000 
      ,[Precio3] = Precio3/100000 
      ,[PrecioI3] = PrecioI3/100000 
      ,[Costo] = Costo/100000 
      ,[Comision] = Comision/100000 
      
      
      GO
      
      
--51

UPDATE [dbo].[SATAXCOM]
   SET [Monto] = Monto/100000 
      ,[TGravable] = TGravable/100000 
      
GO



--52


UPDATE [dbo].[SATAXCXC]
   SET [Monto] = Monto/100000 
      ,[TGravable] = TGravable/100000 
    
GO



--53


UPDATE [dbo].[SATAXCXP]
   SET [Monto] = Monto/100000 
      ,[TGravable] = TGravable/100000 
      
      GO
      
      
      
--54

UPDATE [dbo].[SATAXITC]
   SET [Monto] = Monto/100000 
      ,[TGravable] = TGravable/100000 
      
GO

--55

UPDATE [dbo].[SATAXITF]
   SET [Monto] = Monto/100000 
      ,[TGravable] = TGravable/100000 
      GO
      
      

--56


UPDATE [dbo].[SATAXVTA]
   SET [Monto] = Monto/100000 
      ,[TGravable] = TGravable/100000 
      GO


--57 -- 17/08/2018

UPDATE [dbo].[SBACUM]
   SET 
       [Debitos] = Debitos/100000 
      ,[Creditos] = Creditos/100000 
 GO


--58

UPDATE [dbo].[SBAPPD]
   SET [Monto] = Monto/100000 
      
GO

--59

UPDATE [dbo].[SBAPPM]
   SET 
      [MtoPagos] = MtoPagos/100000 
      
GO

--60

UPDATE [dbo].[SBBANC]
   SET [SaldoAct] = SaldoAct/100000
      ,[SaldoC1] = SaldoC1/100000 
      ,[SaldoC2] = SaldoC2/100000 
      
      
GO

--61

UPDATE [dbo].[SBBENE]
   SET [Monto] = Monto/100000
      ,[UMonto] = UMonto/100000 
      GO



--62

UPDATE [dbo].[SBBENEb]
   SET [Monto] = Monto/100000
      ,[UMonto] = UMonto/100000 

GO



--63

UPDATE [dbo].[SBConc]
   SET [SaldoI] = SaldoI/100000 
      ,[MtDepoC] = MtDepoC/100000
      ,[MtCredC] = MtCredC/100000
      ,[MtCheqC] = MtCheqC/100000
      ,[MtNDebC] = MtNDebC/100000
      ,[MtDepoT] = MtDepoT/100000
      ,[MtCredT] = MtCredT/100000
      ,[MtCheqT] = MtCheqT/100000
      ,[MtNDebT] = MtNDebT/100000
      ,[SaldoF] =  SaldoF/100000 
      ,[SaldoLib] = SaldoLib/100000 
 
GO


--64


UPDATE [dbo].[SBCTAS]
   SET [UMonto] = UMonto/100000
      ,[SaldoAct] = SaldoAct/100000 
      GO
      
      
      
 --65
 
 
UPDATE [dbo].[SBDIFE]
   SET [Monto] = Monto/100000 
      ,[MontoE] = MontoE/100000
      ,[MontoC] = MontoC/100000
      ,[MontoBT] = MontoBT/100000
      ,[BaseIT] = BaseIT/100000
      ,[ComiT] = ComiT/100000
      ,[ImpT] = ImpT/100000
      ,[NetoT] = NetoT/100000
      
GO


--66

UPDATE [dbo].[SBDOpF]
   SET [Monto] = Monto/100000 
      ,[Monto2] = Monto2/100000 
      
GO


--67

UPDATE [dbo].[SBDTRN]
   SET 
       [BaseTr] = BaseTr/100000
      ,[Monto] = Monto/100000 
      ,[MtoDb] = MtoDb/100000 
      ,[MtoCr] = MtoCr/100000 
      ,[FlujoE] = FlujoE/100000
 
GO

--68


UPDATE [dbo].[SBEsti]
   SET [Debitos] = Debitos/100000 
      ,[Creditos] = Creditos/100000 
 
GO


--69

UPDATE [dbo].[SBFDCCONS]
   SET [Monto] = Monto/100000 
 
GO


--70

UPDATE [dbo].[SBFDCPER]
   SET 
      [SaldoA] = SaldoA/100000 
 
GO


--71

UPDATE [dbo].[SBOPCXPP]
   SET [Monto] = Monto/100000 
      ,[MtoPagos] = MtoPagos/100000 
      ,[MtoReten] = MtoReten/100000 
      ,[MtoIDB] = MtoIDB/100000 
      
GO


--72

UPDATE [dbo].[SBOpFr]
   SET [Monto] = Monto/100000 
GO


--73

UPDATE [dbo].[SBTRAN]
   SET [Monto] = Monto/100000
      ,[MtoDb] = MtoDb/100000
      ,[MtoCr] = MtoCr/100000
      ,[MtoIDB] = MtoIDB/100000
      ,[MtoDebito] = MtoDebito/100000
      ,[MtoOrigen] = MtoOrigen/100000
      ,[Monto1] = Monto1/100000
      ,[Monto2] = Monto2/100000
      ,[MtoDeb] = MtoDeb/100000
      ,[MtoOri] = MtoOri/100000
      ,[Saldo] = Saldo/100000
      
GO



--74


UPDATE [dbo].[SBTrTr]
   SET [Monto] = Monto/100000 
      ,[MtoDb] = MtoDb/100000 
      ,[MtoCr] = MtoCr/100000 
      ,[Monto1] = Monto1/100000 
      ,[Monto2] = Monto2/100000 
      ,[Saldo] = Saldo/100000 
 
GO





















































      
      
      
      
      
      
      
            
      
      
      
      
      
            


 
 
 
 
 




















      







