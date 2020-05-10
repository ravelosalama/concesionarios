SELECT * FROM saitemfac x 
inner join SAFACT    y on x.NumeroD=y.NumeroD and x.TipoFac=y.tipofac  
inner join SAFACT_03 z on x.NumeroD=z.NumeroD and x.TipoFac=z.tipofac
inner join SAFACT_01 w on z.Nro_OR=w.NumeroD and w.TipoFac='G'
WHERE EsServ=0 and x.TipoFac='f' and y.CodOper='01-303' and y.NumeroR is null and w.Status='PENDIENTE'