DECLARE @OR       VARCHAR(20),
        @NROLINEA INT,
        @CANTIDAD INT,
        @CODITEM  VARCHAR(15),
        @DESCRIP1 VARCHAR(60),
        @COSTO    DECIMAL (28,5),
        @PRECIO   DECIMAL (28,5),
        @FECHAE   DATETIME,
        @FECHAL   DATETIME,
        @ODEPOSITO VARCHAR(10),
        @DESCRIPERROR VARCHAR(300),
        @EXISTEN DECIMAL(28,5)
        
        -- COLOCAR AQUI LA OR A LA QUE SE LE DESEA RECONSTRUIR LOS REPUESTOS DESPACHADOS

        SET @OR='075337'


      -- Reversa cantidades trasladadas en otros procesos (G) desde almacen principal al taller sobre la OR. y viceversa.
      
      -- DESCRIP10 ALMACENA EL CODIGO DE ALMACEN ORIGINAL DESDE DONDE SALIO EL PRODUCTO POR 1RA VEZ. 
      -- SOLUCION PARA CONTROLAR VARIOS ALMACENES. 
      UPDATE SAEXIS SET Existen=Existen+x.cantidad FROM SAITEMFAC X INNER JOIN SAEXIS Y ON X.CodItem=Y.CodProd 
      WHERE (X.TipoFac = 'G' AND X.NumeroD = @OR AND X.EsServ = 0 AND Y.CodUbic=X.Descrip10) 
            
      
      UPDATE SAEXIS SET Existen=Existen-x.cantidad FROM SAITEMFAC X INNER JOIN SAEXIS Y ON X.CodItem=Y.CodProd 
      WHERE (X.TipoFac = 'G' AND X.NumeroD = @OR AND X.EsServ = 0 AND Y.CodUbic='301')  
  
      
      -- Borra items de repuestos de la OR para recargarlos en base a despachos vivos
      DELETE dbo.SAITEMFAC
      WHERE (TipoFac = 'G' AND NumeroD = @OR AND EsServ = 0)

      -- Inserta en la OR los repuestos en despachos vivos relacionados con la OR 
      DECLARE MIREG SCROLL CURSOR FOR
      SELECT DISTINCT X.CodItem
         FROM dbo.SAITEMFAC AS X
         INNER JOIN dbo.SAFACT_03 AS Y
         ON (X.TipoFac = Y.TipoFac and X.NumeroD = Y.NumeroD) INNER JOIN SAFACT AS Z
         ON X.TIPOFAC=Z.TIPOFAC AND X.NUMEROD=Z.NUMEROD 
         WHERE X.TipoFac = 'F' AND Y.Nro_OR = @OR AND Z.Codoper='01-303' AND (Z.NUMEROR IS NULL OR Z.NUMEROR='')
      OPEN MIREG
      FETCH NEXT FROM MIREG INTO @CodItem
      WHILE (@@FETCH_STATUS = 0) 
      BEGIN
 
         -- Determina el proximo nro de linea
         SELECT @NroLinea = NroLinea + 1
            FROM  dbo.SAITEMFAC
            WHERE (TipoFac = 'G' and NumeroD = @OR)
 
         -- Determina la cantidad del repuesto entregado
         SELECT @Cantidad = SUM(X.Cantidad)
            FROM  dbo.SAITEMFAC AS X
            INNER JOIN dbo.SAFACT_03 AS Y
            ON (X.TipoFac = Y.TipoFac and X.NumeroD = Y.NumeroD) INNER JOIN SAFACT AS Z
            ON X.TIPOFAC=Z.TIPOFAC AND X.NUMEROD=Z.NUMEROD
            WHERE X.TipoFac = 'F' and Y.Nro_OR = @OR and X.CodItem = @CodItem AND (Z.NUMEROR IS NULL OR Z.NUMEROR='')AND Z.Codoper='01-303'
           
      
         -- Lee Costo y precio del item pedido.
         SELECT @Descrip1 = X.Descrip1,
                @Costo    = X.Costo,
                @Precio   = X.Precio,
                @FechaE   = X.FechaE,
                @FechaL   = X.FechaL,
                @ODEPOSITO= X.Codubic 
            FROM  dbo.SAITEMFAC AS X
            INNER JOIN dbo.SAFACT_03 AS Y
            ON (X.TipoFac = Y.TipoFac and X.NumeroD = Y.NumeroD) INNER JOIN SAFACT AS Z
            ON X.TIPOFAC=Z.TIPOFAC AND X.NUMEROD=Z.NUMEROD
            WHERE X.TipoFac = 'F' and Y.Nro_OR = @OR and X.CodItem = @CodItem AND (Z.NUMEROR IS NULL OR Z.NUMEROR='')AND Z.Codoper='01-303'
            
         
         
         -- ***OJO*** REVISAR EN FRIO ESTAS VALIDACIONES Y Y BREAK QUE INCURRE QUE REALMENTE HAGA EL ROLLBACK
         
         -- Valida si se intenta sacar productos del almacen 301 - TALLER 
         IF @ODEPOSITO='301'
            BEGIN
              CLOSE MIREG
              DEALLOCATE MIREG
              SELECT @DESCRIPERROR=DESCRIPCION+' '+@CODITEM FROM SA_CERROR WHERE CODERR='01148'
              EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR 
            END 
         
         -- Valida si la cantidad de articulos a despachar es mayor a la existente en almacen.     
         SELECT @EXISTEN=Existen FROM SAEXIS WHERE CodProd=@CODITEM AND (CodUbic=@ODEPOSITO)
         IF @CANTIDAD>@EXISTEN
            BEGIN
              CLOSE MIREG
              DEALLOCATE MIREG
              SELECT @DESCRIPERROR=DESCRIPCION+' '+@CODITEM FROM SA_CERROR WHERE CODERR='01125'
              EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR 
            END 
         
         -- Valida si se intenta despachar el comodin generico R9999  
           IF @CODITEM='R9999' 
            BEGIN
              CLOSE MIREG
              DEALLOCATE MIREG
              SELECT @DESCRIPERROR=DESCRIPCION+' '+@CODITEM FROM SA_CERROR WHERE CODERR='01138'
              EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR 
            END 
            
         -- Inserta item de repuesto en la OR.
         INSERT dbo.SAITEMFAC (TipoFac, NumeroD, CodItem, NroLinea, CodUbic, Descrip1, Costo, Cantidad, Precio, Signo, FechaE, FechaL, Descrip10)
         VALUES ('G', @OR, @CodItem, @NroLinea, '301', @Descrip1, @Costo, @Cantidad, @Precio, 1, @FechaE, @FechaL,@ODEPOSITO)
         
         IF NOT EXISTS (SELECT * FROM SAEXIS WHERE (CODPROD=@CODITEM and CodUbic='301'))
         INSERT SAEXIS (Codprod,CodUbic, Existen,ExUnidad,CantPed,UnidPed,CantCom,UnidCom)
         VALUES (@Coditem,'301',0,0,0,0,0,0)
         
         -- Traslada stock reconstruido del Almacen principal al taller del repuesto procesado
         UPDATE SAEXIS SET Existen=Existen-@CANTIDAD where CodProd=@CODITEM and CodUbic=@ODEPOSITO
         UPDATE SAEXIS SET Existen=Existen+@CANTIDAD where CodProd=@CODITEM and CodUbic='301'
         

         FETCH NEXT FROM MIREG INTO @CodItem
      END
      CLOSE MIREG
      DEALLOCATE MIREG
      
      
      
  