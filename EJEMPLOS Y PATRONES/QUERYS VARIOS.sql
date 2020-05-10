--OCT 2016
SELECT * FROM SASERV X RIGHT OUTER JOIN SAINSTA Y ON X.CodInst=Y.CodInst
WHERE Y.Descrip IS NOT  NULL




  SELECT CODPROD,REFERE FROM SAPROD WHERE CodInst='12' AND (Refere <> CodProd)


--UPDATE SAPROD SET Refere=CodProd WHERE CodInst='12' AND (Refere IS NULL OR Refere='')


 SELECT TOP 1
             Modelo,
             Serial,
             Color,
             fecha_venta,
             Serial_motor,SERIAL,
             Concesionario
            FROM dbo.SAPROD_12_01 WITH (NOLOCK) 
            WHERE (CODPROD=@CODVEH)











--QUERYS UTILITARIOS VARIOS

-- QUERY PARA REVISAR CONSISTENCIA DE STOCK ENTRE SAEPRD-SAPROD Y SAEXIS PARA RECONSTRUIR EXISTEN 

SELECT     x.CodProd, y.Descrip, x.Periodo, x.CntCompra, x.CntVentas, x.CntInicial, x.ExFinal, y.Existen AS SAPROD, z.Existen AS SAEXIS, z.CodUbic
FROM         SAEPRD AS x INNER JOIN
                      SAPROD AS y ON x.CodProd = y.CodProd INNER JOIN
                      SAEXIS AS z ON x.CodProd = z.CodProd 
WHERE     (x.Periodo = '201604') AND y.Existen <> x.CntInicial + x.CntCompra - x.CntVentas AND Y.Existen<>0 AND CntVentas<>0




--QUERY PARA EVALUAR ULTIMO REGISTRO INSERTADO EN SAITEMFAC COMPARANDO TOTAL DOC DE SAFACT CON SUM DE TOTALITEM EN SAFACT
-- Calcula numero de registros (filas) en saitemfac del documento cargado (documento en espera) faltantes por procesar
-- Siendo @nummax=0 el indicador del ultimo registro insertado en saitemfac, condicion de grabacion en sa_ctransac  

 
   select @nromax=isnull(count(*),0) from saitemfac where numerod=@numeroD and tipofac=@TIPODOC
   SELECT @NROLINEA=isnull(NROLINEA,0) FROM SAITEMFAC where numerod=@numeroD and tipofac=@TIPODOC
   SELECT @NROREG=isnull(COUNT(*),0) FROM INSERTED
 
  select @total=sum(totalItem) from saitemfac where numerod=@numeroD and tipofac=@TIPODOC
   select @totalg=totalprd+TOTALSRV from safact where numerod=@numeroD and tipofac=@TIPODOC
   
-- PROCESA SI ES FACTURA O DEVOLUCION Y SI ES ULTIMO REGITRO O FILA PROCESADA DE LA TRANSACCION  
if @total>=@totalg
begin
SET @DESCRIPERROR='ESTOY EN DETECTA PRE PROCESO CON:'+@TIPODOC+@NUMEROD+STR(@NROMAX)+' REG INSERTED:'+STR(@NROREG)+' total:'+str(@total)+' tot safact:'+str(@totalg) --+' LINEA:'+str(@NROLINEA) --+@COLOR  --+'/'+STR(@Nrounico)+'/'+@Codoper+'/'+@Codusua+'/'+@Codesta--+'/'+STR(@Fechat)
RAISERROR (@DESCRIPERROR,16,1)
ROLLBACK TRANSACTION
RETURN
end
