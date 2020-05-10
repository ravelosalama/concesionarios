SET FORMAT ddmmyy
SELECT  X.CODITEM
    ,Existen
    ,SUM(Cantidad)   OVER(PARTITION BY x.coditem) AS 'Total'
    ,AVG(Cantidad)   OVER(PARTITION BY x.coditem) AS 'Promedio'
    ,COUNT(Cantidad) OVER(PARTITION BY x.coditem) AS 'Count'
    ,MIN(Cantidad)   OVER(PARTITION BY x.coditem) AS 'Min'
    ,MAX(Cantidad)   OVER(PARTITION BY x.coditem) AS 'Max'
    ,DATEDIFF (mm ,x.fechae ,getdate())           AS 'Meses'
    ,MIN(DATEDIFF (mm ,x.fechae ,getdate())  )OVER(PARTITION BY x.coditem) AS 'minmes'
    ,MAX(DATEDIFF (mm ,x.fechae ,getdate())  )OVER(PARTITION BY x.coditem) AS 'mAXmes'
    
FROM   SAITEMFAC AS x INNER JOIN
                      SAFACT AS y ON x.NumeroD = y.NumeroD AND x.TipoFac = y.TipoFac INNER JOIN
                      SAPROD AS Z ON x.CodItem = Z.CodProd
WHERE   (x.EsServ = '0') AND (y.CodOper = '01-201' OR
                      y.CodOper = '01-301') AND (y.TipoFac = 'A') AND (y.NumeroR IS NULL OR
                      y.NumeroR = '') AND (Z.FechaUV >= CONVERT(DATETIME, '02/28/2011', 120)) OR
                      (x.EsServ = '0') AND (y.CodOper = '01-201' OR
                      y.CodOper = '01-301') AND (y.TipoFac = 'C') AND (y.NumeroR IS NULL OR
                      y.NumeroR = '') AND (Z.FechaUV >= CONVERT(DATETIME, '02/28/2011', 120)) order by x.TOTAL DESC
 

 GO
 
 SELECT CODCLIE, DESCRIP  FROM SAFACT 