-- ******************* SAINT ANNUAL ENTERPRISE AUTOMOTRIZ **********************-- ******************* PROCEDURE PARA VERSION 9039  ****************************-- SCRIPTS REALIZADO POR: JOSE RAVELO / DICIEMBRE 2018 --         REVISADO  POR: JOSE RAVELO / ENERO 2019--         TESTEADO: POR: JOSE RAVELO / ENERO 2019--         EJECUTADO: -- Corrige y genera TG para subsanar error en actualización 9037 y 9038-- Corrige saldos y agrega funcionalidad -- *****************************************************************************IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='TR_ADM_INSERTARCXC' AND TYPE='TR')     DROP TRIGGER [DBO].TR_ADM_INSERTARCXC;
GO
CREATE TRIGGER TR_ADM_INSERTARCXC ON SAACXC
 WITH ENCRYPTION FOR INSERT AS
IF @@ROWCOUNT = 0 RETURN
BEGIN
 DECLARE
   @CodClie    varchar(15),
   @Monto      decimal(28,4),
   @saldo      decimal(28,4),
   @SaldoAnt   DECIMAL(28,4),
   @FECHAE     datetime,
   @FACTOR     SMALLINT,
   @fromtran   INT,
   @ESRETEN    INT,
   @NroUnico   INT,
   @NumeroD    varchar(20),
   @TipoCxC    varchar(2),
   @CancelA    DECIMAL(28,4),
   @FactorM    DECIMAL(28,4),
   @CodEsta    VARCHAR(10),
   @CodUsua    VARCHAR(10);
 SELECT @CODCLIE=CODCLIE, @TipoCxc=TipoCxC, @CancelA=CancelA,
        @NumeroD=NumeroD, @FechaE=FechaE,   @FactorM=Factor,
        @CodEsta=CODESTA, @CodUsua=CODUSUA, @fromtran=fromTran,
        @ESRETEN=ESRETEN, @NROUNICO=NROUNICO 
   FROM INSERTED;
 SET @SALDOANT=0;
 update saacxc
    set @saldoant=saldoact=@saldoant+
                 (case when SUBSTRING(v.tipocxc,1,1) in ('1','6','7') then v.monto
                       when SUBSTRING(v.tipocxc,1,1) in ('5') then 0 
                       when SUBSTRING(v.tipocxc,1,1) in ('2') then  
                            (CASE when SUBSTRING(v.tipocxc,2,1) in ('5') then 0  ELSE v.monto end)
                       else -v.monto end)
   from (select NroUnico, tipocxc, monto,
                ROW_NUMBER() OVER (ORDER BY codclie, NroUnico) AS RowNum
           from saacxc) v
  where v.NROUNICO=SAACXC.NroUnico and saacxc.codclie=@codclie
 IF (@CancelA >0) BEGIN
    DECLARE MCursorCA CURSOR FOR
        SELECT NroUnico, Saldo
          FROM SAACXC WITH (NOLOCK)
         WHERE (TipoCxc='50') And (Saldo>0) And (CodClie=@CODCLIE)
      ORDER BY NroUnico;
    OPEN McursorCA;
    FETCH NEXT FROM McursorCA INTO @NroUnico, @Saldo;
    WHILE @@FETCH_STATUS = 0 BEGIN
        IF @Saldo <= @CancelA BEGIN
           UPDATE SAACXC Set Saldo=0, SaldoMEx=0
            WHERE NroUnico=@NroUnico;
           SET @CancelA=@CancelA-@Saldo;
        END
        ELSE BEGIN
           UPDATE SAACXC Set Saldo=Saldo-@CancelA, 
                             SaldoMEx=case when @FACTORM>0 Then 
                                                saldo/@FactorM 
                                           Else 0 END 
            WHERE CodClie=@CodClie And NroUnico=@NroUnico;
           SET @CancelA=0;
        END;
        FETCH NEXT FROM McursorCA INTO @NroUnico, @Saldo;
    END;
    CLOSE McursorCA;
    DEALLOCATE McursorCA;
 END;
END
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='TR_ADM_INSERTARCXP' AND TYPE='TR')     DROP TRIGGER [DBO].TR_ADM_INSERTARCXP;
GO
CREATE TRIGGER TR_ADM_INSERTARCXP ON SAACXP
WITH ENCRYPTION FOR INSERT AS
IF @@ROWCOUNT = 0 RETURN
BEGIN
 DECLARE
   @CODPROV    varchar(15),
   @Monto      decimal(28,4),
   @saldo      decimal(28,4),
   @SaldoAnt   DECIMAL(28,4),
   @FECHAE     datetime,
   @FACTOR     SMALLINT,
   @NroUnico   INT,
   @NumeroD    varchar(20),
   @TIPOCXP    varchar(2),
   @CancelA    DECIMAL(28,4),
   @FactorM    DECIMAL(28,4),
   @CodEsta    VARCHAR(10),
   @CodUsua    VARCHAR(10);
 SELECT @CODPROV=CODPROV, @TIPOCXP=TIPOCXP, @CancelA=CancelA,
        @NumeroD=NumeroD, @FechaE=FechaE,   @FactorM=Factor,
        @CodEsta=CODESTA, @CodUsua=CODUSUA, 
        @NROUNICO=NROUNICO 
   FROM INSERTED;
 SET @SALDOANT=0;
 update saacxp
    set @saldoant=saldoact=@saldoant+
                (case when SUBSTRING(v.tipocxp,1,1) in ('1','3','6','7') then v.monto
                      when SUBSTRING(v.tipocxp,1,1) in ('5') then 0 
                      when SUBSTRING(v.tipocxp,1,1) in ('3') then  
                           (CASE when SUBSTRING(v.tipocxp,2,1) in ('5') then 0  ELSE v.monto end)
                      when v.tipocxp='8' THEN (CASE SUBSTRING(v.TIPOCXP,2,1) WHEN '2' THEN v.monto ELSE -v.monto END) 
                      ELSE -v.monto END) 
   from (select NroUnico, tipocxp, monto,
                ROW_NUMBER() OVER (ORDER BY codprov, NroUnico) AS RowNum
           from saacxp) v
  where v.NROUNICO=SAACXP.NroUnico and saacxp.codprov=@codprov
 IF (@CancelA>0) BEGIN
      DECLARE MCursorCA CURSOR FOR
       SELECT NroUnico, Saldo
         FROM SAACXP WITH (NOLOCK)
        WHERE TipoCxp='50' And Saldo>0 And CodProv=@CODPROV
     ORDER BY NroUnico;
    OPEN McursorCA;
    FETCH NEXT FROM McursorCA INTO @NroUnico, @Saldo;
    WHILE @@FETCH_STATUS = 0 BEGIN
        IF @Saldo<=@CancelA BEGIN
           UPDATE SAACXP Set Saldo=0, SaldoMEx=0
            WHERE NroUnico=@NroUnico;
           SET @CancelA=@CancelA-@Saldo;
        END
        ELSE BEGIN
           UPDATE SAACXP Set Saldo = Saldo - @CancelA,
                             SaldoMEx=case when @FACTORM>0 Then 
                                                saldo/@FactorM 
                                           Else 0 END 
           WHERE NroUnico=@NroUnico;
           SET @CancelA=0;
        END;
        FETCH NEXT FROM McursorCA INTO @NroUnico, @Saldo;
    END;
    CLOSE McursorCA;
    DEALLOCATE McursorCA;
 END;
END
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='SP_ADM_CIERREMENSUAL' AND TYPE='P' )     DROP PROCEDURE [DBO].SP_ADM_CIERREMENSUAL;
GO
CREATE PROCEDURE SP_ADM_CIERREMENSUAL
 (@CodSucu VARCHAR(10), @Fecha DATETIME, @PerOLD VARCHAR(10),@PerNEW VARCHAR(10))
WITH ENCRYPTION AS
BEGIN
SET DATEFORMAT YMD;
DECLARE
  @FechaUC DATETIME,
  @MESESPTOS INT,
  @MesPrf INT,
  @MesOC INT,
  @MesTran INT;
BEGIN TRANSACTION
  SELECT @MesPrf=MesPrf, @MesOC=MesOC, @MesTran=MesTran,
         @FECHAUC=FECHAUC, @MESESPTOS=MESESPTOS
    FROM SACONF WITH (NOLOCK)
   WHERE CODSUCU=@CODSUCU;
  UPDATE SACLIE SET
    SALDOPTOS=(CASE WHEN CONVERT(INT,@FECHA-@FECHAUC)/30>=@MESESPTOS THEN 0 ELSE SALDOPTOS END);
  UPDATE SACONF WITH (ROWLOCK) SET
         FECHAUC=(CASE WHEN CONVERT(INT,@FECHA-@FECHAUC)/30>=@MESESPTOS THEN @FECHA ELSE FECHAUC END)
   WHERE CODSUCU=@CODSUCU;
UPDATE SAEXIS
   SET Existen=(CASE WHEN P.DEsLote=0 AND P.DEsSeri=0 THEN EXISTEN
                     ELSE
                         (CASE WHEN P.DEsSeri=1 THEN P.TEXISTEN
                               ELSE (CASE WHEN P.DESLOTE=1 THEN P.TEXISTEN ELSE EXISTEN END) END) END)
      ,ExUnidad=(CASE WHEN P.DEsLote=0 AND P.DEsSeri=0 THEN EXUNIDAD
                      ELSE
                          (CASE WHEN P.DEsSeri=1 THEN P.TEXUNIDAD
                                ELSE (CASE WHEN P.DESLOTE=1 THEN P.TEXUNIDAD ELSE EXUNIDAD END) END) END)
  FROM (SELECT E.CODPROD, E.CodUbic, P.DEsLote, P.DEsSeri,
               SUM(E.TEXISTEN) AS TEXISTEN, SUM(E.TEXUNIDAD) AS TEXUNIDAD
          FROM (SELECT CODPROD, CODUBIC,
                       SUM(CANTIDAD) AS TEXISTEN, SUM(CANTIDADU) AS TEXUNIDAD
                  FROM SALOTE
                 GROUP BY CODPROD, CODUBIC
                 UNION
                SELECT CODPROD, CODUBIC, COUNT(CodProd) AS TEXISTEN, 0 AS TEXUNIDAD
                  FROM SASERI
                 GROUP BY CODPROD, CODUBIC) E
  LEFT JOIN SAPROD P ON
       (P.CODPROD=E.CodProd)
 GROUP BY E.CODPROD, E.CODUBIC, P.DEsLote, P.DEsSeri ) P
 WHERE (SAEXIS.CodUbic=P.CodUbic) AND (P.CodProd=SAEXIS.CodProd);
UPDATE SAEXIS
   SET EXUNIDAD=EXUNIDAD-FLOOR(EXUNIDAD/P.CANTEMPAQ)*P.CANTEMPAQ,
       EXISTEN =EXISTEN +FLOOR(EXUNIDAD/P.CANTEMPAQ)
  FROM (SELECT CODPROD, (CASE WHEN CANTEMPAQ=0 THEN 1 ELSE CANTEMPAQ END) AS CANTEMPAQ
          FROM SAPROD ) P
 WHERE SAEXIS.CODPROD=P.CODPROD
UPDATE SAPROD
   SET EXISTEN=E.EXISTEN, EXUNIDAD=E.EXUNIDAD
  FROM (SELECT CODPROD, SUM(EXISTEN) AS EXISTEN,SUM(EXUNIDAD) AS EXUNIDAD
          FROM SAEXIS
         GROUP BY CODPROD) E
 WHERE SAPROD.CODPROD=E.CODPROD;
  UPDATE SAINITI SET
         COSTOFINAL= ISNULL(prd.COSTPRO,0),
         EXFINAL= ISNULL(ex.Existen,0),
         EXUNDFINAL= ISNULL(ex.EXUNIDAD,0)
    FROM SAINITI as INI WITH (NOLOCK)
   INNER JOIN SAEXIS AS EX ON
     INI.CODUBIC=EX.CODUBIC AND
     INI.CODPROD=EX.CODPROD
   INNER JOIN SAPROD AS PRD ON
     INI.CODPROD=PRD.CODPROD
   WHERE PERIODO=@PerOLD
  DELETE SAINITI WHERE PERIODO=@PerNEW;
  INSERT INTO SAINITI (CODPROD, CODUBIC, PERIODO, EXINICIAL, EXUNDINI, COSTO)
         SELECT EX.CODPROD, EX.CODUBIC, @PerNEW, EX.EXISTEN, EX.EXUNIDAD, ISNULL(PRD.COSTPRO,0)
           FROM SAEXIS as EX WITH (NOLOCK) inner join SAPROD as PRD on
                EX.CODPROD=PRD.CODPROD;
  UPDATE SAEPRD SET
         EXFINAL=ISNULL(prd.EXISTEN,0),
         COSTOFINAL=ISNULL(prd.EXISTEN*prd.COSTACT,0)
    FROM SAEPRD as EPRD  WITH (NOLOCK) left join SAPROD as PRD on
         EPRD.CodProd=PRD.CODPROD
   WHERE PERIODO=@PerOLD
  DELETE SAEPRD WHERE PERIODO=@PerNEW;
  INSERT INTO SAEPRD (CODPROD, PERIODO, CNTINICIAL, EXINICIAL)
         SELECT CODPROD, @PerNEW, EXISTEN, EXISTEN*COSTACT FROM SAPROD WITH (NOLOCK);
  DELETE FROM SALOTE where Cantidad=0 AND CantidadU=0;
  DELETE SAITEMFAC
   WHERE (CONVERT(INT,(@Fecha-FechaE))/30>=@MesPrf) And (TipoFac='F')
  DELETE SAFACT 
   WHERE CONVERT(INT,(@Fecha-FechaE))/30>=@MesPrf And (TipoFac='F')
  DELETE SAITEMCOM
   WHERE CONVERT(INT,(@Fecha-FechaE))/30>=@MesOC And (TipoCom='S')
  DELETE SACOMP
   WHERE CONVERT(INT,(@Fecha-FechaE))/30>=@MesOC And (TipoCom='S')
  UPDATE SACONF WITH (ROWLOCK) SET MesCurso=@PerNEW
   WHERE CODSUCU=@CODSUCU;
 COMMIT TRANSACTION;
END
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='TR_ADM_UPDATE_EXISTENCIAS' AND TYPE='P' )     DROP PROCEDURE [DBO].TR_ADM_UPDATE_EXISTENCIAS;
GO
CREATE PROCEDURE TR_ADM_UPDATE_EXISTENCIAS(@CodProd varchar(15),
  @CodUbic varchar(10), 
  @Cantidad Decimal(28,4), 
  @EsUnidad SmallInt,
  @FECHAE   VARCHAR(25))
WITH ENCRYPTION AS 
BEGIN
  DECLARE @CANTEMPAQ DECIMAL(28,4);
  DECLARE @PERIODO   VARCHAR(10);
  SET @PERIODO=SUBSTRING(REPLACE(@FECHAE,'-',''),1,6);
  SELECT @CANTEMPAQ=CANTEMPAQ FROM SAPROD WITH (NOLOCK) WHERE CODPROD=@CODPROD
  IF NOT EXISTS(SELECT CODPROD FROM SAEXIS WITH (NOLOCK) WHERE CODPROD=@CODPROD AND CODUBIC=@CODUBIC)
     INSERT SAEXIS (CODPROD, CODUBIC) VALUES (@CODPROD,@CODUBIC);
  IF NOT EXISTS(SELECT CODPROD FROM SAINITI WITH (NOLOCK)
                WHERE CODPROD=@CODPROD AND CODUBIC=@CODUBIC AND PERIODO=@PERIODO) 
     INSERT INTO SAINITI (CodProd,CodUbic,Periodo,ExInicial,ExUndIni) 
          SELECT CodProd,@CodUbic,@Periodo,Existen,ExUnidad 
            FROM SAEXIS WITH (NOLOCK) 
           WHERE (CodProd=@CodProd AND CodUbic=@CodUbic);
  IF NOT EXISTS(SELECT CODPROD FROM SAEPRD WITH (NOLOCK)
                WHERE CODPROD=@CODPROD AND PERIODO=@PERIODO) 
     INSERT INTO SAEPRD (CodProd,Periodo,CNTINICIAL,ExInicial) 
          SELECT CodProd,@Periodo,Existen,Existen*COSTACT 
            FROM SAPROD WITH (NOLOCK) 
           WHERE (CodProd=@CodProd);
  UPDATE SAEXIS SET 
         EXISTEN =EXISTEN+ (CASE @ESUNIDAD WHEN 0 THEN @CANTIDAD ELSE 0 END),
         EXUNIDAD=EXUNIDAD+(CASE @ESUNIDAD WHEN 1 THEN @CANTIDAD ELSE 0 END)
   WHERE (CodProd=@CodProd AND CodUbic=@CodUbic);
  IF (@ESUNIDAD>0)
     BEGIN
       UPDATE SAEXIS 
          SET EXUNIDAD=EXUNIDAD-FLOOR(EXUNIDAD/@CANTEMPAQ)*@CANTEMPAQ,
              EXISTEN=EXISTEN+FLOOR(EXUNIDAD/@CANTEMPAQ) 
        WHERE (CodProd=@CodProd AND CodUbic=@CodUbic);
       UPDATE SALOTE 
          SET CANTIDADU=CANTIDADU-FLOOR(CANTIDADU/@CANTEMPAQ)*@CANTEMPAQ,
              CANTIDAD=CANTIDAD+FLOOR(CANTIDADU/@CANTEMPAQ) 
        WHERE (CodProd=@CodProd AND CodUbic=@CodUbic);
     END;
  UPDATE SAPROD SET 
         EXISTEN =EX.EXISTEN,
         EXUNIDAD=EX.EXUNIDAD
    FROM (SELECT SUM(EXISTEN)  AS EXISTEN, 
                 SUM(EXUNIDAD) AS EXUNIDAD 
            FROM SAEXIS WITH (NOLOCK)
           WHERE CODPROD=@CODPROD) AS EX 
   WHERE (CodProd=@CodProd);
END;
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='UPDATESALDOSSBTRAN' AND TYPE='TR')     DROP TRIGGER [DBO].UPDATESALDOSSBTRAN;
GO
CREATE TRIGGER UPDATESALDOSSBTRAN ON SBTRAN
WITH ENCRYPTION FOR INSERT AS
IF @@ROWCOUNT = 0 RETURN
BEGIN
  DECLARE @CodBanc    varchar(30)
  DECLARE @ActBanc    varchar(30)
  DECLARE @BancIns    varchar(30)
  DECLARE @FechaIns   datetime
  DECLARE @NOpeIns    INT
  DECLARE @Monto      decimal(28,4)
  DECLARE @NOpe       INT
  DECLARE @AOD        varchar(1)
  DECLARE @Fecha      datetime
  DECLARE @Saldo      decimal(28,4)
  DECLARE @SaldoAnt   decimal(28,4)
  SET DATEFORMAT YMD
  SET @BancIns = (SELECT CODBANC FROM INSERTED)
  SET @FechaIns = (SELECT FECHA FROM INSERTED)
  SET @NOpeIns = (SELECT NOpe FROM INSERTED)
  print @NOpeIns
  DECLARE MACTBANCO CURSOR FOR
  Select sb.CodBanc
    from sbbanc sb WITH (NOLOCK)
   Where CodBanc = @BancIns
   Order by sb.CodBanc
  OPEN MACTBANCO
  FETCH NEXT FROM MACTBANCO INTO @ActBanc
  WHILE @@FETCH_STATUS=0 BEGIN
    SET @SALDOANT = 0
    SET @SALDO    = 0
    Select TOP 1 @Saldo = ISNULL(Saldo,0.00) From SBTRAN WITH (NOLOCK)
     Where CodBanc = @ActBanc And Fecha <= @FechaIns And NOpe <> @NOpeIns
          Order By Fecha DESC, NOpe DESC
         SET @SALDOANT = @Saldo
         DECLARE MACTCURSOR CURSOR FOR
         SELECT A.CodBanc, A.Fecha, A.AOD, A.NOpe, A.Monto
          FROM SBTRAN as A WITH (NOLOCK)
          Where A.CodBanc = @ActBanc And A.Fecha >= @FechaIns
          ORDER BY A.Fecha, A.AOD, A.NOpe
         OPEN MACTCURSOR
         FETCH NEXT FROM MACTCURSOR INTO @CodBanc, @Fecha, @AOD, @NOpe, @Monto
         WHILE (@@FETCH_STATUS = 0) BEGIN
          SET @SALDOANT=@SALDOANT+@Monto
          UPDATE SBTRAN SET Saldo = @SALDOANT
           WHERE CodBanc = @ActBanc And Fecha = @Fecha And AOD = @AOD And NOpe = @NOpe
          FETCH NEXT FROM MACTCURSOR
           INTO @CodBanc, @Fecha, @AOD, @NOpe, @Monto
         END
         CLOSE MACTCURSOR
         DEALLOCATE MACTCURSOR
         FETCH NEXT FROM MACTBANCO INTO @ActBanc
      END
      CLOSE MACTBANCO
      DEALLOCATE MACTBANCO
END
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='DELETESALDOSSBTRAN' AND TYPE='TR')     DROP TRIGGER [DBO].DELETESALDOSSBTRAN;
GO
CREATE TRIGGER DELETESALDOSSBTRAN ON SBTRAN WITH ENCRYPTION FOR DELETE AS
IF @@ROWCOUNT > 1 RETURN
BEGIN
        DECLARE @CodBanc    varchar(30)
        DECLARE @ActBanc    varchar(30)
        DECLARE @BancIns    varchar(30)
        DECLARE @FechaIns   datetime
        DECLARE @NOpeIns    INT
        DECLARE @Monto      decimal(28,4)
        DECLARE @NOpe       INT
        DECLARE @AOD        varchar(1)
        DECLARE @Fecha      datetime
        DECLARE @Saldo      decimal(28,4)
        DECLARE @SaldoAnt   decimal(28,4)
        SET DATEFORMAT YMD
        SET @BancIns = (SELECT CODBANC FROM DELETED)
        SET @FechaIns = (SELECT FECHA FROM DELETED)
        SET @NOpeIns = (SELECT NOpe FROM DELETED)
        DECLARE MACTBANCO CURSOR FOR
        Select sb.CodBanc
        from sbbanc sb WITH (NOLOCK)
        Where CodBanc = @BancIns
        Order by sb.CodBanc
        OPEN MACTBANCO
        FETCH NEXT FROM MACTBANCO INTO @ActBanc
        WHILE @@FETCH_STATUS=0 BEGIN
                   SET @SALDOANT = 0
                   SET @SALDO    = 0
                   Select TOP 1 @Saldo = ISNULL(Saldo,0.00) From SBTRAN WITH (NOLOCK)
                   Where CodBanc = @ActBanc And Fecha <= @FechaIns And NOpe <> @NOpeIns
                   Order By Fecha DESC, NOpe DESC
                   SET @SALDOANT = @Saldo
                   DECLARE MACTCURSOR CURSOR FOR
                   SELECT A.CodBanc, A.Fecha, A.AOD, A.NOpe, A.Monto
                   FROM SBTRAN as A WITH (NOLOCK)
                   Where A.CodBanc = @ActBanc And A.Fecha >= @FechaIns And NOpe <> @NOpeIns
                   ORDER BY A.Fecha, A.AOD, A.NOpe
                   OPEN MACTCURSOR
                   FETCH NEXT FROM MACTCURSOR INTO @CodBanc, @Fecha, @AOD, @NOpe, @Monto
                   WHILE (@@FETCH_STATUS = 0) BEGIN
                           SET @SALDOANT=@SALDOANT+@Monto
                           UPDATE SBTRAN SET Saldo = @SALDOANT
                           WHERE CodBanc = @ActBanc And Fecha = @Fecha And AOD = @AOD And NOpe = @NOpe
                           FETCH NEXT
                           FROM MACTCURSOR
                           INTO @CodBanc, @Fecha, @AOD, @NOpe, @Monto
                   END
                   CLOSE MACTCURSOR
                   DEALLOCATE MACTCURSOR
            FETCH NEXT FROM MACTBANCO INTO @ActBanc
        END
        CLOSE MACTBANCO
        DEALLOCATE MACTBANCO
END
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='SP_ADM_PROXCORREL' AND TYPE='P' )     DROP PROCEDURE [DBO].SP_ADM_PROXCORREL;
GO
CREATE PROCEDURE SP_ADM_PROXCORREL
(@CODSUCU VARCHAR(10), @CODESTA  VARCHAR(10),
 @PRVFIELD VARCHAR(15), @PRXFIELD VARCHAR(20),
 @NUMERO  VARCHAR(25) OUTPUT)
WITH ENCRYPTION AS
BEGIN
 DECLARE
   @NUMTEMP    VARCHAR(25),
   @PREFIX     VARCHAR(15),
   @LENCORREL  INT,
   @PROXNUMBER INT;
 SET @PREFIX=ISNULL((SELECT VALUESTR 
                      FROM SACORRELSIS WITH (NOLOCK)
                     WHERE CODSUCU=@CODSUCU AND FIELDNAME=@PRVFIELD),'');
 SET @LENCORREL=(SELECT VALUEINT 
                   FROM SACORRELSIS WITH (NOLOCK)
                  WHERE CODSUCU=@CODSUCU AND FIELDNAME='LENCORREL');
 IF LEN(@PREFIX)>@LENCORREL SET @LENCORREL=19;
 UPDATE SACORRELSIS WITH (ROWLOCK)
    SET @PROXNUMBER=VALUEINT, VALUEINT=VALUEINT+1 
  WHERE CODSUCU=@CODSUCU AND FIELDNAME=@PRXFIELD;
 SET @NUMTEMP=CONVERT(VARCHAR,@PROXNUMBER);
 SET @NUMERO=@PREFIX+ISNULL(REPLICATE('0',@LENCORREL-LEN(@PREFIX)-LEN(@NUMTEMP)),REPLICATE('*',@LENCORREL))+@NUMTEMP;
END;
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='CIERRE_PRXCORREL' AND TYPE='P' )     DROP PROCEDURE [DBO].CIERRE_PRXCORREL;
GO
CREATE PROCEDURE CIERRE_PRXCORREL 
(@CODSUCU VARCHAR(10), @CODESTA VARCHAR(10),
 @TIPO    CHAR(1),     @NUMERO  VARCHAR(20) OUTPUT)
WITH ENCRYPTION AS
BEGIN
 DECLARE @FIELDNAME VARCHAR(20)
 SET @FIELDNAME= CASE WHEN @TIPO='1' THEN 'PrxCierreX'
                      WHEN @TIPO='2' THEN 'PrxCierreZ'
                      ELSE 'PrxCierreD' END
IF @CODESTA<>'' AND @TIPO<>''
   BEGIN
     DECLARE @CORRELATIVO FLOAT
     SELECT @CORRELATIVO=VALUEDEC
       FROM SACORRELSIS WITH (NOLOCK)
      WHERE CODESTA=@CODESTA AND FIELDNAME=@FIELDNAME AND CODSUCU=@CODSUCU
     IF (@CORRELATIVO IS NULL) OR (@CORRELATIVO=0)
        INSERT SACORRELSIS(CODSUCU,FIELDNAME,CODESTA,VALUEDEC)
                    VALUES(@CODSUCU,@FIELDNAME,@CODESTA,0.5)
     SELECT VALUEDEC AS CORRELATIVO
       FROM SACORRELSIS WITH (NOLOCK)
      WHERE CODESTA=@CODESTA AND FIELDNAME=@FIELDNAME AND CODSUCU=@CODSUCU
     UPDATE SACORRELSIS WITH (ROWLOCK) SET VALUEDEC=VALUEDEC+0.5
      WHERE CODESTA=@CODESTA AND FIELDNAME=@FIELDNAME AND CODSUCU=@CODSUCU
   END
ELSE
   BEGIN
     SELECT -1 AS CORRELATIVO
   END
END;
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='TR_ADM_INSERTDOCUMENTOVENTA' AND TYPE='TR')     DROP TRIGGER [DBO].TR_ADM_INSERTDOCUMENTOVENTA;
GO
CREATE TRIGGER TR_ADM_INSERTDOCUMENTOVENTA ON SAFACT
WITH ENCRYPTION FOR INSERT AS
BEGIN 
 DECLARE 
    @TipoFac  VARCHAR(2),
    @NumeroR  VARCHAR(20),
    @NumeroD  VARCHAR(20),
    @CodEsta  VARCHAR(10),
    @CodSUCU  VARCHAR(10),
    @CodCLIE  VARCHAR(15),
    @CODUBIC  VARCHAR(10),
    @PERIODO  VARCHAR(10),
    @CodUsua  VARCHAR(10),
    @MONTO    DECIMAL(28,4),
    @DESCONT  DECIMAL(28,4),
    @FLETES   DECIMAL(28,4),
    @MTOTAX   DECIMAL(28,4),
    @RETENIVA DECIMAL(28,4),
    @COSTO    DECIMAL(28,4),
    @CANCELI  DECIMAL(28,4),
    @CANCELA  DECIMAL(28,4),
    @DESCTOI  DECIMAL(28,4),
    @CONTADO  DECIMAL(28,4),
    @CREDITO  DECIMAL(28,4),
    @CANTPTOS DECIMAL(28,4),
    @FechaE   DateTime;
 SET DATEFORMAT YMD;
 SELECT @TipoFac=TIPOFAC, @NumeroD=NUMEROD, @CodEsta=CODESTA, 
        @CodUsua=CODUSUA, @CodSUCU=CODSUCU, @MONTO=SIGNO*MONTO,
        @DESCONT=SIGNO*(DESCTO1+DESCTO2), @FLETES=SIGNO*FLETES, 
        @MTOTAX=SIGNO*MTOTAX,@COSTO=SIGNO*(COSTOPRD+COSTOSRV), 
        @CONTADO=SIGNO*(CANCELA+CANCELP+CANCELI+CANCELE+CANCELC+CANCELT), 
        @CREDITO=SIGNO*(MONTO+FLETES+MTOTAX-(DESCTO1+DESCTO2)-(CANCELA+CANCELP+CANCELI+CANCELE+CANCELC+CANCELT)), 
        @CODUBIC=CODUBIC, @CANCELA=SIGNO*CANCELA,
        @CANCELI=SIGNO*CANCELI, @DESCTOI=SIGNO*DESCTOP,@RETENIVA=SIGNO*RETENIVA,
        @CANTPTOS=SIGNO*VALORPTOS, @NumeroR=NUMEROR, 
        @CODCLIE=CODCLIE, @FechaE=FECHAE 
   FROM INSERTED;
 IF (@TipoFac In ('A','B')) BEGIN
    SET @PERIODO=REPLACE(SUBSTRING(CONVERT(VARCHAR,@FECHAE,120),1,10),'-','');
    IF NOT EXISTS(SELECT CODSUCU, PERIODO 
                    FROM SAEVTA WITH (NOLOCK)
                   WHERE CODSUCU=@CODSUCU AND PERIODO=@PERIODO)
       INSERT INTO SAEVTA (CODSUCU, PERIODO) 
                   VALUES (@CODSUCU,@PERIODO);
    UPDATE SAEVTA SET 
           MTOVENTAS=MTOVENTAS+@MONTO,
           Descto=Descto+@Descont,
           Fletes=Fletes+@Fletes,
           MtoTax=MtoTax+@MTOTax,
           Contado=Contado+@Contado, 
           Credito=Credito+@Credito, 
           Costo=Costo+@Costo,
           NroFacts=NroFacts+(CASE WHEN @TIPOFAC='A' THEN 1 ELSE 0 END),
           NroDevol=NroDevol+(CASE WHEN @TIPOFAC='B' THEN 1 ELSE 0 END)
     WHERE CODSUCU=@CODSUCU AND PERIODO=@PERIODO;
    SET @PERIODO=REPLACE(SUBSTRING(CONVERT(VARCHAR,@FECHAE,120),1,7),'-','');
    UPDATE SACLIE 
       SET SALDO=SALDO+@CREDITO, PAGOSA=PAGOSA-@CANCELA,
           RETENIVA=RETENIVA+@RETENIVA, SALDOPTOS=SALDOPTOS+@CANTPTOS,
           FECHAUV=@FECHAE, MontoUV=@MONTO, NumeroUV=@NUMEROD, 
           MontoMax=(CASE WHEN @MONTO>MontoMax THEN @MONTO ELSE MONTOMAX END), 
           MtoMaxCred=(CASE WHEN @CREDITO>MtoMaxCred THEN @CREDITO ELSE MTOMAXCRED END)
     WHERE CODCLIE=@CODCLIE;
    IF NOT EXISTS(SELECT CODCLIE, PERIODO 
                    FROM SAECLI WITH (NOLOCK)
                   WHERE CODCLIE=@CODCLIE AND PERIODO=@PERIODO)
       INSERT INTO SAECLI (CODCLIE, PERIODO) 
            VALUES (@CODCLIE,@PERIODO);
    UPDATE SAECLI 
       SET NroFacts=NroFacts+(CASE WHEN @TIPOFAC='A' THEN 1 ELSE 0 END),
           NroDevol=NroDevol+(CASE WHEN @TIPOFAC='B' THEN 1 ELSE 0 END),
           MtoDevol=MtoDevol+@MONTO*(CASE WHEN @TIPOFAC='B' THEN 1 ELSE 0 END),
           Credito=CREDITO+@Credito, Contado=CONTADO+@CONTADO,
           Descto=Descto+@DESCONT, Costo=COSTO+@COSTO,
           MtoRetenImp=MtoRetenImp+@CANCELI
     WHERE CODCLIE=@CODCLIE AND PERIODO=@PERIODO;
    IF (@CANTPTOS>0) BEGIN
       IF NOT EXISTS(SELECT CODCLIE, PERIODO 
                       FROM SAPTOSCLIENTE WITH (NOLOCK)
                      WHERE CODCLIE=@CODCLIE AND PERIODO=@PERIODO)
          INSERT INTO SAPTOSCLIENTE (CODCLIE, PERIODO) 
                      VALUES (@CODCLIE,@PERIODO);
       UPDATE SAPTOSCLIENTE SET 
              FechaE=@FECHAE,
              NroFacts=NroFacts+(CASE WHEN @TIPOFAC='A' THEN 1 ELSE 0 END),
              Credito=Credito+@Credito, 
              Contado=Contado+@Contado, 
              Mtoventas=Mtoventas+@MONTO,
              Descto=Descto+@DESCONT,
              ValorPtos=ValorPtos+@CANTPTOS
        WHERE CODCLIE=@CODCLIE AND PERIODO=@PERIODO;
    END;
 END;
 If (@TIPOFAC IN ('B','D')) BEGIN
    UPDATE SAFACT 
       SET NUMEROR=@NUMEROD
     WHERE (CODSUCU=@CODSUCU) AND
           (NUMEROD=@NumeroR) AND
           (TIPOFAC=(CASE WHEN @TIPOFAC='B' THEN 'A' ELSE 'C' END));
 END;
END;
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='TR_ADM_INSERTDOCUMENTOCOMPRA' AND TYPE='TR')     DROP TRIGGER [DBO].TR_ADM_INSERTDOCUMENTOCOMPRA;
GO
CREATE TRIGGER TR_ADM_INSERTDOCUMENTOCOMPRA ON SACOMP
WITH ENCRYPTION FOR INSERT AS
BEGIN 
 DECLARE 
    @TipoCom  VARCHAR(2),
    @NumeroR  VARCHAR(20),
    @NumeroD  VARCHAR(20),
    @CodEsta  VARCHAR(10),
    @CodSUCU  VARCHAR(10),
    @CodProv  VARCHAR(15),
    @CODUBIC  VARCHAR(10),
    @PERIODO  VARCHAR(10),
    @CodUsua  VARCHAR(10),
    @MONTO    DECIMAL(28,4),
    @DESCONT  DECIMAL(28,4),
    @FLETES   DECIMAL(28,4),
    @MTOTAX   DECIMAL(28,4),
    @RETENIVA DECIMAL(28,4),
    @CANCELI  DECIMAL(28,4),
    @CANCELA  DECIMAL(28,4),
    @DESCTOI  DECIMAL(28,4),
    @CONTADO  DECIMAL(28,4),
    @CREDITO  DECIMAL(28,4),
    @FechaE   DateTime;
 SET DATEFORMAT YMD;
 SELECT @TipoCom=TipoCom, @NumeroD=NUMEROD, @CodEsta=CODESTA, 
        @CodUsua=CODUSUA, @CodSUCU=CODSUCU, @MONTO=SIGNO*MONTO,
        @DESCONT=SIGNO*(DESCTO1+DESCTO2), @FLETES=SIGNO*FLETES, 
        @MTOTAX=SIGNO*MTOTAX, 
        @CONTADO=SIGNO*(CANCELA+CANCELI+CANCELE+CANCELC+CANCELT), 
        @CREDITO=SIGNO*(MONTO+FLETES+MTOTAX-(DESCTO1+DESCTO2)-(CANCELA+CANCELI+CANCELE+CANCELC+CANCELT)), 
        @CODUBIC=CODUBIC, @CANCELA=SIGNO*CANCELA,
        @CANCELI=SIGNO*CANCELI, @DESCTOI=SIGNO*DESCTOP,@RETENIVA=SIGNO*RETENIVA,
        @NumeroR=NUMERON, 
        @CodProv=CodProv, @FechaE=FECHAE 
   FROM INSERTED;
 IF (@TipoCom In ('H','I')) BEGIN
    SET @PERIODO=REPLACE(SUBSTRING(CONVERT(VARCHAR,@FECHAE,120),1,10),'-','');
    IF NOT EXISTS(SELECT CODSUCU, PERIODO 
                    FROM SAECOM WITH (NOLOCK)
                   WHERE CODSUCU=@CODSUCU AND PERIODO=@PERIODO)
           INSERT INTO SAECOM (CODSUCU, PERIODO) 
                  VALUES (@CODSUCU,@PERIODO);
    UPDATE SAECOM SET 
           MTOCOMPRA=MTOCOMPRA+@MONTO,
           Descto=Descto+@Descont,
           Fletes=Fletes+@Fletes,
           MtoTax=MtoTax+@MTOTax,
           Contado=Contado+@Contado, 
           Credito=Credito+@Credito, 
           NroComps=NroComps+(CASE WHEN @TipoCom='H' THEN 1 ELSE 0 END),
           NroDevol=NroDevol+(CASE WHEN @TipoCom='I' THEN 1 ELSE 0 END)
     WHERE CODSUCU=@CODSUCU AND PERIODO=@PERIODO;
    SET @PERIODO=REPLACE(SUBSTRING(CONVERT(VARCHAR,@FECHAE,120),1,7),'-','');
    UPDATE SAPROV 
       SET SALDO=SALDO+@CREDITO, PAGOSA=PAGOSA-@CANCELA,
           RETENIVA=RETENIVA+@RETENIVA, RETENISLR=RETENISLR+@CANCELI,
           FECHAUC=@FECHAE, MontoUC=@MONTO, NumeroUC=@NUMEROD, 
           MontoMax=(CASE WHEN @MONTO>MontoMax THEN @MONTO ELSE MONTOMAX END) 
     WHERE CodProv=@CodProv;
    IF NOT EXISTS(SELECT CodProv, PERIODO 
                    FROM SAEPRV WITH (NOLOCK)
                   WHERE CodProv=@CodProv AND PERIODO=@PERIODO)
           INSERT INTO SAEPRV (CodProv, PERIODO) 
                  VALUES (@CodProv,@PERIODO);
    UPDATE SAEPRV 
       SET NROCOMPS=NROCOMPS+(CASE WHEN @TipoCom='H' THEN 1 ELSE 0 END),
           NroDevol=NroDevol+(CASE WHEN @TipoCom='I' THEN 1 ELSE 0 END),
           MtoDevol=MtoDevol+@MONTO*(CASE WHEN @TipoCom='I' THEN 1 ELSE 0 END),
           Credito=CREDITO+@Credito, Contado=CONTADO+@CONTADO,
           MtoRetenImp=MtoRetenImp+@CANCELI
     WHERE CodProv=@CodProv AND PERIODO=@PERIODO;
 END;
 If (@TipoCom IN ('I','K')) BEGIN
    UPDATE SACOMP 
       SET NUMERON=@NUMEROD
     WHERE (CODSUCU=@CODSUCU) And (NUMEROD=@NumeroR) AND (CODPROV=@CodProv) AND 
           (TipoCom=(CASE WHEN @TipoCom='I' THEN 'H' ELSE 'J' END));
 END;
END;
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='TR_ADM_INSERTDOCUMENTOINVENT' AND TYPE='TR')     DROP TRIGGER [DBO].TR_ADM_INSERTDOCUMENTOINVENT;
GO
CREATE TRIGGER TR_ADM_INSERTDOCUMENTOINVENT ON SAOPEI
WITH ENCRYPTION FOR INSERT AS
BEGIN 
 DECLARE 
    @TipoOpI  VARCHAR(2),
    @NumeroD  VARCHAR(20),
    @CodEsta  VARCHAR(10),
    @CodSUCU  VARCHAR(10),
    @CODUBIC  VARCHAR(10),
    @PERIODO  VARCHAR(10),
    @CodUsua  VARCHAR(10),
    @MONTO    DECIMAL(28,4),
    @FechaE   DateTime;
 SET DATEFORMAT YMD;
 SELECT @TipoOpi=TIPOOPI, @NumeroD=NUMEROD, @CodEsta=CODESTA, 
        @CodUsua=CODUSUA, @CodSUCU=CODSUCU, @MONTO=SIGNO*MONTO,
        @CODUBIC=CODUBIC, @FechaE=FECHAE 
   FROM INSERTED;
 IF (@TipoOPI In ('N','O','P')) BEGIN
    SET @PERIODO=REPLACE(SUBSTRING(CONVERT(VARCHAR,@FECHAE,120),1,7),'-','');
    IF NOT EXISTS(SELECT CODSUCU, PERIODO 
                    FROM SAEOPI WITH (NOLOCK) 
                   WHERE CODSUCU=@CODSUCU AND PERIODO=@PERIODO)
       INSERT INTO SAEOPI (CODSUCU, PERIODO) 
                   VALUES (@CODSUCU,@PERIODO);
    UPDATE SAEOPI SET 
            MtoTraslad=MtoTraslad+(CASE WHEN @TIPOOPI='N' THEN @MONTO ELSE 0 END)
           ,CntTraslad=CntTraslad+(CASE WHEN @TIPOOPI='N' THEN 1      ELSE 0 END)
           ,MtoCargos=MtoCargos+  (CASE WHEN @TIPOOPI='O' THEN @MONTO ELSE 0 END)
           ,CntCargos=CntCargos+  (CASE WHEN @TIPOOPI='O' THEN 1      ELSE 0 END)
           ,MtoDescarg=MtoDescarg+(CASE WHEN @TIPOOPI='P' THEN @MONTO ELSE 0 END)
           ,CntDescarg=CntDescarg+(CASE WHEN @TIPOOPI='P' THEN 1      ELSE 0 END)
     WHERE (CODSUCU=@CODSUCU) AND (PERIODO=@PERIODO);
 END;
END;
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='SP_ADM_DROPTABLETEMP' AND TYPE='P' )     DROP PROCEDURE [DBO].SP_ADM_DROPTABLETEMP;
GO
create procedure SP_ADM_DROPTABLETEMP With Encryption as
declare @Name Sysname
declare cur_delete_tmp cursor for
Select Name
From SysObjects
Where Name Like 'TMP_%' And XType = 'U'
open cur_delete_tmp
fetch next from cur_delete_tmp
into @Name
while @@fetch_status = 0 begin
  exec ('Drop Table '+@Name)
  fetch next from cur_delete_tmp
  into @Name
end;
close cur_delete_tmp
deallocate cur_delete_tmp
