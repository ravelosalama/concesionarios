-- NUEVO TRIGGER DISE;ADO PARA VERSIONES SUPERIORES A 9XXX VIENE DE SOLUCION 8
-- ELABORADO EN: MAY 2016 POR: JOSE RAVELO
-- 
-- SUSTITUYE OBJETOS ELIMINADOS A CONTINUACION

-- ELIMINA OBJETOS DE VERSIONES ANTERIORES A 9XXX
if exists (select * from dbo.sysobjects where id = object_id(N'[ACTUALIZA RETENIVA CXC]'))
drop TRIGGER [ACTUALIZA RETENIVA CXC]  
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[ACTUALIZA RETENIVA]'))
drop TRIGGER [ACTUALIZA RETENIVA]  
GO
 
If exists (select * from dbo.sysobjects where id = object_id(N'[ACTUALIZA RETENIVA SAACXC]'))
drop TRIGGER [ACTUALIZA RETENIVA SAACXC] 
GO
  
 If exists (select * from dbo.sysobjects where id = object_id(N'[TG_ADM_CXC_SC]'))
drop TRIGGER [TG_ADM_CXC_SC] 
GO
 
---------------------------------------------------------------------------------------------- 
 
 If exists (select * from dbo.sysobjects where id = object_id(N'[TG_C_ADM_CXC]'))
drop TRIGGER [TG_C_ADM_CXC] 
GO
 

CREATE TRIGGER TG_C_ADM_CXC ON SAACXC
FOR INSERT  
AS

DECLARE @monto DECIMAL(23,2)
DECLARE @nroREGI  INT
DECLARE @NROUNICO INT
DECLARE @codOPER VARCHAR(10)
DECLARE @FACTURA VARCHAR(10)
DECLARE @tipoCXC VARCHAR(2)
DECLARE @fechapago DATETIME
DECLARE @fechaFACT DATETIME
DECLARE @FECHARETE DATETIME
DECLARE @FECHAHOY  DATETIME
DECLARE @comprobante VARCHAR(20)
DECLARE @CODESTA VARCHAR(10)
DECLARE @CODUSUA VARCHAR(10)
DECLARE @CODNVL VARCHAR(2)
DECLARE @TIPOCLI INT
DECLARE @DESCRIPERROR VARCHAR(300)
DECLARE @CODCLIE VARCHAR(15)
DECLARE @FECHAOF DATETIME
DECLARE @REGISTROS INT





-- RECOGE DATOS DEL INSERT
SELECT @monto = monto,
       @nroREGI=nroREGI,
       @NROUNICO=NROUNICO, 
       @CODOPER=CODOPER, 
       @TIPOCXC=TIPOCXC,
       @COMPROBANTE=NUMEROD, -- A PARTIR DE LA 9XXX  ANTES FUE NUMEROT
       @FACTURA=NUMERON,
       @FECHAPAGO=FECHAI,
       @FECHAFACT=FECHAR,
       @FECHARETE=FECHAE, -- ACTUALMENTE RECOGE LA FECHA DE LA TRANSACCION Y NO LA FECHA DE RETENCION FALLA DE LAS VERSIONES 9XXX NO PUEDE REPARARSE POR ESTA VIA HAY QUE ESPERAR CORRECCION DE SAINT.  
       @CODESTA=CODESTA,
       @CODUSUA=CODUSUA
       FROM INSERTED
       
       

-- Valida si es una ret iva contenga el valor en codoper de  04-002 
IF @TIPOCXC='81' AND @CODOPER<>'04-002'  
     BEGIN
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01130'
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END 
 
 
IF @codOPER='04-002' AND @TIPOCXC='81'

  BEGIN  
  
    /* 
     -- RECOGE FECHA REAL DEL COMPROBANTE, ESTO ESTABA EN SAACXC 81 FECHAE PERO EN VERSIONES 9XXX NO FUNCIONA 
     SELECT @FECHARETE=Y.FECHAE FROM SAACXC AS X INNER JOIN SAPAGCXC AS Y ON X.NroUnico = Y.NroPpal WHERE Y.NROPPAL=X.NROUNICO*/
     
     -- RECOGE FECHA DE EMISION DE LA FACTURA
     SELECT @FECHAOF=FECHAT FROM SAFACT WHERE NUMEROD=@FACTURA AND TIPOFAC='A'
     
     
     -- 1. Valida si codigo del USUARIO ES VALIDO
     -- Recoge datos de la tabla: SSUSRS 
     SELECT @CODNVL=SUBSTRING(DESCRIP,1,2) FROM SSUSRS WHERE CODUSUA=@CODUSUA    
     IF  (Substring(@CODNVL,1,2)<>'2 ' AND Substring(@CODNVL,1,2)<>'7 ' AND Substring(@CODNVL,1,2)<>'11')
     BEGIN
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01098'
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END 
     
     -- 2. Valida CONDICION de contribuyente especial del cliente. (NO SE EJECUTA POR VLIDACION ANTECESORA 81/04-002)
     -- Recoge datos de la tabla: SACLIE 
     SELECT @TIPOCLI=TIPOCLI FROM SACLIE WHERE CODCLIE=@CODCLIE    
     IF @TIPOCLI<>4  
     BEGIN
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01128'
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END 
    
     -- 3. Valida LONGITUD DE NUMERO DE RETENCION.
         IF LEN(@COMPROBANTE)<>14   
     BEGIN
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01129'
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END 
     
     -- 4. Valida FORMATO DE NUMERO DE RETENCION.
         IF SUBSTRING(@COMPROBANTE,1,4)<'2000' OR SUBSTRING(@COMPROBANTE,1,4)>'2050' OR SUBSTRING(@COMPROBANTE,5,2)>'12' OR SUBSTRING(@COMPROBANTE,5,2)<'01'  
     BEGIN
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01131'
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END 
     
     
     /* DESHABILITADO TEMPORAMENTE MIENTRAS SAINT REPARA SAACXC.FECHAE=FECHA DEL COMPROBANTE EN REG 81/04-002
     
     -- 5. Valida FORMATO DE NUMERO DE RETENCION SEA IGUAL A  LA FECHA DEL DOCUMENTO (NO SE EJCUTA POR NO PODER RECOGER @FECHARETE POR ESTAR SOLO EN SAPAGCXC Y NO GRABARSE ANTES DE ESTE PROCESO)
         IF SUBSTRING(@COMPROBANTE,1,4)<>YEAR(@FECHARETE) OR SUBSTRING(@COMPROBANTE,5,2)<> MONTH(@FECHARETE)  
     BEGIN
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01132'
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END */
     
     -- 6. Valida FECHA DE EMISION DEL COMPROBANTE SEA POSTERIOR A LA FECHA DE FACTURA QUE LE DIO ORIGEN.
          IF  @FECHAOF > @FECHARETE 
     BEGIN
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01134'
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END 
     
     
     -- 7. Valida REGISTRO DE RETENCION DUPLICADO 
     SELECT @REGISTROS=COUNT(*) FROM SAACXC WHERE NUMEROD=@COMPROBANTE AND NUMERON=@FACTURA
     IF @REGISTROS>1     
     BEGIN
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01133'
      EXECUTE dbo.SP_00_VENTANA_ERROR @DESCRIPERROR
     END 
     
     -- OBJETO DEL TRIGGER    

     IF (YEAR(@FECHAPAGO) = YEAR(@FECHAFACT)) AND (MONTH(@FECHAPAGO) = MONTH(@FECHAFACT))
         BEGIN
               -- CASO 1 (COBRANZA DE FACTURA MISMO MES)
               UPDATE SAFACT
               SET RETENIVA = @MONTO, NOTAS9=@COMPROBANTE
               WHERE  SAFACT.NUMEROD=@FACTURA AND SAFACT.TIPOFAC='A'
         END
      
                 
     -- CASO 2 (A PARTIR DE 9XXX ES COBRANZAS TODOS LOS CASOS, ANTES COBRANZAS MESES ANTERIORES, SE LIMITAN REGISTROS EN LOS REPORTES)
     INSERT INTO SA_C_RETIVAVTA (NROPPAL,FECHAPAGO,NUMEROD,MONTO,ENTERADA)
     SELECT @nroUNICO,@fechapago,@FACTURA,@monto,0   
     -- ADM/CXC/POA/ EN DETALLE DEL DOCUMENTO REGISTRAR NO. COMPROBANTE ---> ESTO YA NO ES NECESARIO.
                

 END



