SELECT * FROM      SAITEMFAC AS X INNER JOIN SAEXIS Y ON X.CodItem = Y.CodProd INNER JOIN SAFACT Z ON Z.TipoFac=X.TIPOFAC AND X.NumeroD=Z.NUMEROD WHERE     (X.TipoFac = 'f') AND (X.NumeroD = '003498') AND (Y.CodUbic = '001') AND Z.CodOper='01-303'
GO

 SELECT   DISTINCT X.CodItem,SUM(X.CANTIDAD) 
         FROM dbo.SAITEMFAC AS X
         INNER JOIN dbo.SAFACT_03 AS Y
         ON (X.TipoFac = Y.TipoFac and X.NumeroD = Y.NumeroD) INNER JOIN SAFACT AS Z
         ON X.TIPOFAC=Z.TIPOFAC AND X.NUMEROD=Z.NUMEROD 
         WHERE X.TipoFac = 'F' AND Y.Nro_OR = '075772' AND Z.Codoper='01-303' AND Z.NUMEROR IS NULL GROUP BY X.CodItem
GO         

  SELECT * FROM SAITEMFAC X INNER JOIN SAEXIS Y ON X.CodItem=Y.CodProd WHERE (X.TipoFac = 'G' AND X.NumeroD = '075772' AND X.EsServ = 0 AND Y.CodUbic='001') ORDER BY CodItem
GO
  
   SELECT * FROM SAITEMFAC X INNER JOIN SAEXIS Y ON X.CodItem=Y.CodProd WHERE (X.TipoFac = 'G' AND X.NumeroD = '075772' AND X.EsServ = 0 AND Y.CodUbic='301') ORDER BY CodItem
GO  
  


  
  
  
          