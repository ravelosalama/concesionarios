--AUDITORIA DE DESPACHOS Y REVERSOS DE DESPACHOS
                        
-- EXISTENCIA 
SELECT * FROM SAEXIS WHERE     (CodProd = 'PRODUCTOX') OR
                      (CodProd = 'PRODUCTOY') OR
                      (CodProd = 'PRODUCTOZ') OR
                      (CodProd = '000ATM10') OR
                      (CodProd = '000ATM30')

-- DESPACHOS VIVOS
 SELECT     TOP (200) CodItem, Cantidad, CodUbic, NumeroD, TipoFac, Nro_OR, NumeroR, CodOper, Costo, Precio, Descrip1, FechaE, FechaL
FROM         VW_C_DESPACHOS_VIVOS
WHERE     (Nro_OR = '080315') OR
                      (Nro_OR = '080318')
                      ORDER BY  CodItem,NRO_OR
                      
-- CARGADOS EN OR                                       
   SELECT     TOP (200) TipoFac, NumeroD, OTipo, ONumero, Status, NroLinea, CodItem,Cantidad, CodUbic, CodMeca, CodVend, Descrip1, Descrip2, Descrip3, Descrip4, Descrip5, Descrip6, Descrip7, 
                      Descrip8, Descrip9, Descrip10, Refere, Signo, CantMayor, Cantidad, CantidadO, ExistAntU, ExistAnt, CantidadU, CantidadC, CantidadA, CantidadUA, Costo, Precio, Descto, NroLote, FechaE, FechaL, 
                      FechaV, EsServ, EsUnid, EsFreeP, EsPesa, EsExento, UsaServ, DEsLote, DEsSeri, DEsComp, NroUnicoL, Tara, TotalItem, NumeroE, CodSucu, MtoTax, PriceO
FROM         SAITEMFAC
WHERE     (NumeroD = '080315') or numerod='080318'                   
                                                                
-- FIN AUDITORIA DE DESPACHOS Y REVERSOS DE DESPACHOS

