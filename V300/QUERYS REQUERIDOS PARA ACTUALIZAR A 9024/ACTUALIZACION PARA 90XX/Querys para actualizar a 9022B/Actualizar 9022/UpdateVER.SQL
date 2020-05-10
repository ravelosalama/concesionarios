-- ******************* SAINT ANNUAL ENTERPRISE AUTOMOTRIZ **********************-- ******************* ACTUALIZA OBJETOS PARA VERSION 9039  ****************************-- SCRIPTS REALIZADO POR: JOSE RAVELO / ENERO 2019 --         TESTEADO: POR: JOSE RAVELO / ENERO 2019--         EJECUTADO: -- Corrige y genera Tablas, indices para subsanar error en actualización 9037 y 9038-- *****************************************************************************
 
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'ValorPtosV' And so.id = si.id And so.name = 'SACONF') 
ALTER TABLE [dbo].SACONF WITH NOCHECK ADD ValorPtosV DECIMAL(28,3) NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'RUCUser' And so.id = si.id And so.name = 'SACONF') 
ALTER TABLE [dbo].SACONF WITH NOCHECK ADD RUCUser VARCHAR(20) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'RUCPwd' And so.id = si.id And so.name = 'SACONF') 
ALTER TABLE [dbo].SACONF WITH NOCHECK ADD RUCPwd VARCHAR(20) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'MtoTax' And so.id = si.id And so.name = 'SAITEMFAC') 
ALTER TABLE [dbo].SAITEMFAC WITH NOCHECK ADD MtoTax DECIMAL(28,3) NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'PriceO' And so.id = si.id And so.name = 'SAITEMFAC') 
ALTER TABLE [dbo].SAITEMFAC WITH NOCHECK ADD PriceO DECIMAL(28,3) NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'MtoTax' And so.id = si.id And so.name = 'SAITEMCOM') 
ALTER TABLE [dbo].SAITEMCOM WITH NOCHECK ADD MtoTax DECIMAL(28,3) NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'CostOrg' And so.id = si.id And so.name = 'SAITEMCOM') 
ALTER TABLE [dbo].SAITEMCOM WITH NOCHECK ADD CostOrg DECIMAL(28,3) NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'CodSucu' And so.id = si.id And so.name = 'SAITEMPLANI') 
ALTER TABLE [dbo].SAITEMPLANI WITH NOCHECK ADD CodSucu VARCHAR(5) NOT NULL DEFAULT ('00000') WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'CodSucu' And so.id = si.id And so.name = 'SAIPACXC') 
ALTER TABLE [dbo].SAIPACXC WITH NOCHECK ADD CodSucu VARCHAR(5) NOT NULL DEFAULT ('00000') WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'CodSucu' And so.id = si.id And so.name = 'SASEPRFAC') 
ALTER TABLE [dbo].SASEPRFAC WITH NOCHECK ADD CodSucu VARCHAR(5) NOT NULL DEFAULT ('00000') WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'CodSucu' And so.id = si.id And so.name = 'SASEPRCOM') 
ALTER TABLE [dbo].SASEPRCOM WITH NOCHECK ADD CodSucu VARCHAR(5) NOT NULL DEFAULT ('00000') WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'CodSucu' And so.id = si.id And so.name = 'SASEPROPI') 
ALTER TABLE [dbo].SASEPROPI WITH NOCHECK ADD CodSucu VARCHAR(5) NOT NULL DEFAULT ('00000') WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'CodSucu' And so.id = si.id And so.name = 'SAPRIMCOM') 
ALTER TABLE [dbo].SAPRIMCOM WITH NOCHECK ADD CodSucu VARCHAR(5) NOT NULL DEFAULT ('00000') WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NroEstable' And so.id = si.id And so.name = 'SACONF') 
ALTER TABLE [dbo].SACONF WITH NOCHECK ADD NroEstable VARCHAR(10) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NroEstable' And so.id = si.id And so.name = 'SACOMP') 
ALTER TABLE [dbo].SACOMP WITH NOCHECK ADD NroEstable VARCHAR(10) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'PtoEmision' And so.id = si.id And so.name = 'SACOMP') 
ALTER TABLE [dbo].SACOMP WITH NOCHECK ADD PtoEmision VARCHAR(10) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'AutSRI' And so.id = si.id And so.name = 'SACOMP') 
ALTER TABLE [dbo].SACOMP WITH NOCHECK ADD AutSRI VARCHAR(40) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'TipoSus' And so.id = si.id And so.name = 'SACOMP') 
ALTER TABLE [dbo].SACOMP WITH NOCHECK ADD TipoSus SMALLINT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'TipoTraE' And so.id = si.id And so.name = 'SACOMP') 
ALTER TABLE [dbo].SACOMP WITH NOCHECK ADD TipoTraE SMALLINT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NroEstable' And so.id = si.id And so.name = 'SAACXP') 
ALTER TABLE [dbo].SAACXP WITH NOCHECK ADD NroEstable VARCHAR(10) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'PtoEmision' And so.id = si.id And so.name = 'SAACXP') 
ALTER TABLE [dbo].SAACXP WITH NOCHECK ADD PtoEmision VARCHAR(10) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'AutSRI' And so.id = si.id And so.name = 'SAACXP') 
ALTER TABLE [dbo].SAACXP WITH NOCHECK ADD AutSRI VARCHAR(40) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'TipoSus' And so.id = si.id And so.name = 'SAACXP') 
ALTER TABLE [dbo].SAACXP WITH NOCHECK ADD TipoSus SMALLINT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'TipoTraE' And so.id = si.id And so.name = 'SAACXP') 
ALTER TABLE [dbo].SAACXP WITH NOCHECK ADD TipoTraE SMALLINT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'TipoTraE' And so.id = si.id And so.name = 'SAACXC') 
ALTER TABLE [dbo].SAACXC WITH NOCHECK ADD TipoTraE SMALLINT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'AutSRI' And so.id = si.id And so.name = 'SAACXC') 
ALTER TABLE [dbo].SAACXC WITH NOCHECK ADD AutSRI VARCHAR(40) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NroEstable' And so.id = si.id And so.name = 'SAACXC') 
ALTER TABLE [dbo].SAACXC WITH NOCHECK ADD NroEstable VARCHAR(10) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'PtoEmision' And so.id = si.id And so.name = 'SAACXC') 
ALTER TABLE [dbo].SAACXC WITH NOCHECK ADD PtoEmision VARCHAR(10) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'Pais' And so.id = si.id And so.name = 'SACLIE') 
ALTER TABLE [dbo].SACLIE WITH NOCHECK ADD Pais INT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'Estado' And so.id = si.id And so.name = 'SACLIE') 
ALTER TABLE [dbo].SACLIE WITH NOCHECK ADD Estado INT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'Ciudad' And so.id = si.id And so.name = 'SACLIE') 
ALTER TABLE [dbo].SACLIE WITH NOCHECK ADD Ciudad INT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'Municipio' And so.id = si.id And so.name = 'SACLIE') 
ALTER TABLE [dbo].SACLIE WITH NOCHECK ADD Municipio INT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'ZipCode' And so.id = si.id And so.name = 'SACLIE') 
ALTER TABLE [dbo].SACLIE WITH NOCHECK ADD ZipCode VARCHAR(20) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'Pais' And so.id = si.id And so.name = 'SAPROV') 
ALTER TABLE [dbo].SAPROV WITH NOCHECK ADD Pais INT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'Estado' And so.id = si.id And so.name = 'SAPROV') 
ALTER TABLE [dbo].SAPROV WITH NOCHECK ADD Estado INT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'Ciudad' And so.id = si.id And so.name = 'SAPROV') 
ALTER TABLE [dbo].SAPROV WITH NOCHECK ADD Ciudad INT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'Municipio' And so.id = si.id And so.name = 'SAPROV') 
ALTER TABLE [dbo].SAPROV WITH NOCHECK ADD Municipio INT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'ZipCode' And so.id = si.id And so.name = 'SAPROV') 
ALTER TABLE [dbo].SAPROV WITH NOCHECK ADD ZipCode VARCHAR(20) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'TipoIns' And so.id = si.id And so.name = 'SATARJ') 
ALTER TABLE [dbo].SATARJ WITH NOCHECK ADD TipoIns SMALLINT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NroUnico' And so.id = si.id And so.name = 'SAIPRV') 
ALTER TABLE [dbo].SAIPRV WITH NOCHECK ADD NroUnico INT IDENTITY (1,1) NOT NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NroUnico' And so.id = si.id And so.name = 'SAICLI') 
ALTER TABLE [dbo].SAICLI WITH NOCHECK ADD NroUnico INT IDENTITY (1,1) NOT NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NroUnico' And so.id = si.id And so.name = 'SAIPRD') 
ALTER TABLE [dbo].SAIPRD WITH NOCHECK ADD NroUnico INT IDENTITY (1,1) NOT NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NroUnico' And so.id = si.id And so.name = 'SAIMEC') 
ALTER TABLE [dbo].SAIMEC WITH NOCHECK ADD NroUnico INT IDENTITY (1,1) NOT NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NroUnico' And so.id = si.id And so.name = 'SAIVEN') 
ALTER TABLE [dbo].SAIVEN WITH NOCHECK ADD NroUnico INT IDENTITY (1,1) NOT NULL;
GO
UPDATE SAITEMFAC SET PRICEO=PRECIO;
UPDATE SAITEMCOM SET COSTORG=COSTO;
UPDATE SAACXC SET NUMEROD='' WHERE NUMEROD IS NULL;
UPDATE SAPAGCXC SET NUMEROD='' WHERE NUMEROD IS NULL;
UPDATE SAACXP SET NUMEROD='' WHERE NUMEROD IS NULL;
UPDATE SAPVPR SET NUMEROD='' WHERE NUMEROD IS NULL;
UPDATE SAPAGCXP SET NUMEROD='' WHERE NUMEROD IS NULL;
update safact   set CodSucu='00000' where codsucu is null
update sataxcxc set CodSucu='00000' where codsucu is null
update sataxcxp set CodSucu='00000' where codsucu is null
update sataxcom set CodSucu='00000' where codsucu is null
update sataxitc set CodSucu='00000' where codsucu is null
update sataxitf set CodSucu='00000' where codsucu is null
update sataxVTA set CodSucu='00000' where codsucu is null
update saIPAVTA set CodSucu='00000' where codsucu is null
update saIPAcxc set CodSucu='00000' where codsucu is null
update SAITEMCOM set codsucu='00000' where codsucu is null
update SAITEMFAC set CodSucu='00000' where codsucu is null
update SAPLANI set CodSucu='00000' where codsucu is null
update SAOPEI set CodSucu='00000' where codsucu is null
update SAITEMOPI set CodSucu='00000' where codsucu is null
update SAACXC set CodSucu='00000' where codsucu is null
update SAACXP set CodSucu='00000' where codsucu is null
update SAPAGCXC set CodSucu='00000' where codsucu is null
update SAPAGCXP set CodSucu='00000' where codsucu is null
update SAITEMPLANI set CodSucu='00000' where codsucu is null
update SAPVPR set TipoCom='H' where TipoCom is null
GO
ALTER TABLE SACLIE ALTER COLUMN NUMEROUV VARCHAR(20);
ALTER TABLE SACLIE ALTER COLUMN NUMEROUP VARCHAR(20);
ALTER TABLE SAFACT ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SAITEMFAC ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SATAXITF ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SATAXVTA ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SASEPRFAC ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SAPRNGIROS ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SAIPAVTA ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SAOPEI ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SAITEMOPI ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SASEPROPI ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SAACXC ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SAACXP ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SAPAGCXC ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SAPLANI ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SAITEMPLANI ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SAPAGCXP ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
ALTER TABLE SAPAGCXP ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL
ALTER TABLE SATAXCXC ALTER COLUMN CODSUCU VARCHAR(5)  NOT NULL
ALTER TABLE SATAXCXP ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL
ALTER TABLE SACOMP ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAITEMCOM ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SATAXCOM ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SATAXITC ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAFACT ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAITEMFAC ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SATAXITF ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SATAXVTA ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAPLANI ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAIPAVTA ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAIPACXC ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAOPEI ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAITEMOPI ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAACXC ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAACXP ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAPAGCXC ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAITEMPLANI ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAPAGCXP ALTER COLUMN CODSUCU VARCHAR(5) NOT NULL;
ALTER TABLE SAFACT ALTER COLUMN NUMEROR VARCHAR(20);
ALTER TABLE SAFACT ALTER COLUMN NUMEROE VARCHAR(20);
ALTER TABLE SACOMP ALTER COLUMN NUMEROR VARCHAR(20);
ALTER TABLE SACOMP ALTER COLUMN NUMEROP VARCHAR(20);
ALTER TABLE SACOMP ALTER COLUMN NUMEROE VARCHAR(20);
ALTER TABLE SACOMP ALTER COLUMN NUMEROC VARCHAR(20);
ALTER TABLE SACOMP ALTER COLUMN NUMERON VARCHAR(20);
ALTER TABLE SAACXC ALTER COLUMN NUMERON VARCHAR(20);
ALTER TABLE SAPVPR ALTER COLUMN TIPOCOM VARCHAR(1) NOT NULL;
ALTER TABLE SAPVPR ALTER COLUMN NUMEROD VARCHAR(20) NOT NULL;
update saIPAcxc set CodSucu='00000' where codsucu is null
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='SP_ADM_ConvertB10ToB36' AND TYPE='P' )     DROP PROCEDURE [DBO].SP_ADM_ConvertB10ToB36;
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='TR_ADM_INSCONVERTCodInstToCodAlte' AND TYPE='TR')     DROP TRIGGER [DBO].TR_ADM_INSCONVERTCodInstToCodAlte;
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='TR_ADM_UPDCONVERTCodInstToCodAlte' AND TYPE='TR')     DROP TRIGGER [DBO].TR_ADM_UPDCONVERTCodInstToCodAlte;
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='TR_ADM_DELCONVERTCodInstToCodAlte' AND TYPE='TR')     DROP TRIGGER [DBO].TR_ADM_DELCONVERTCodInstToCodAlte;
GO
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='TR_ADM_INSUPDPRODINSTANCIAS' AND TYPE='TR')     DROP TRIGGER [DBO].TR_ADM_INSUPDPRODINSTANCIAS;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAINSTA_IX0' AND object_id = OBJECT_ID('SAINSTA'))
   ALTER TABLE SAINSTA DROP CONSTRAINT SAINSTA_IX0;
GO
IF EXISTS(Select NAME From SysIndexes Where Name='SAINSTA_IX1')     DROP INDEX SAINSTA.SAINSTA_IX1;
GO
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAFACT_IX0' AND object_id = OBJECT_ID('SAFACT'))
   ALTER TABLE SAFACT DROP CONSTRAINT SAFACT_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAFACT_IX1' AND object_id = OBJECT_ID('SAFACT'))
   DROP INDEX SAFACT_IX1 ON SAFACT;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAFACT_IX2' AND object_id = OBJECT_ID('SAFACT'))
   DROP INDEX SAFACT_IX2 ON SAFACT;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAITEMFAC_IX0' AND object_id = OBJECT_ID('SAITEMFAC'))
   ALTER TABLE SAITEMFAC DROP CONSTRAINT SAITEMFAC_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SATAXITF_IX0' AND object_id = OBJECT_ID('SATAXITF'))
   ALTER TABLE SATAXITF DROP CONSTRAINT SATAXITF_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SASEPRFAC_IX0' AND object_id = OBJECT_ID('SASEPRFAC'))
   ALTER TABLE SASEPRFAC DROP CONSTRAINT SASEPRFAC_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SATAXVTA_IX0' AND object_id = OBJECT_ID('SATAXVTA'))
   ALTER TABLE SATAXVTA DROP CONSTRAINT SATAXVTA_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAIPAVTA_IX0' AND object_id = OBJECT_ID('SAIPAVTA'))
   ALTER TABLE SAIPAVTA DROP CONSTRAINT SAIPAVTA_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SACOMP_IX0' AND object_id = OBJECT_ID('SACOMP'))
   ALTER TABLE SACOMP DROP CONSTRAINT SACOMP_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SACOMP_IX1' AND object_id = OBJECT_ID('SACOMP'))
   DROP INDEX SACOMP_IX1 ON SACOMP;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SACOMP_IX2' AND object_id = OBJECT_ID('SACOMP'))
   DROP INDEX SACOMP_IX2 ON SACOMP;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SATAXCOM_IX0' AND object_id = OBJECT_ID('SATAXCOM'))
   ALTER TABLE SATAXCOM DROP CONSTRAINT SATAXCOM_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAITEMCOM_IX0' AND object_id = OBJECT_ID('SAITEMCOM'))
   ALTER TABLE SAITEMCOM DROP CONSTRAINT SAITEMCOM_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SATAXITC_IX0' AND object_id = OBJECT_ID('SATAXITC'))
   ALTER TABLE SATAXITC DROP CONSTRAINT SATAXITC_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SASEPRCOM_IX0' AND object_id = OBJECT_ID('SASEPRCOM'))
   ALTER TABLE SASEPRCOM DROP CONSTRAINT SASEPRCOM_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAPRIMCOM_IX0' AND object_id = OBJECT_ID('SAPRIMCOM'))
   ALTER TABLE SAPRIMCOM DROP CONSTRAINT SAPRIMCOM_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAOPEI_IX0' AND object_id = OBJECT_ID('SAOPEI'))
   ALTER TABLE SAOPEI DROP CONSTRAINT SAOPEI_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAOPEI_IX1' AND object_id = OBJECT_ID('SAOPEI'))
   DROP INDEX SAOPEI_IX1 ON SAOPEI;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAOPEI_IX2' AND object_id = OBJECT_ID('SAOPEI'))
   DROP INDEX SAOPEI_IX2 ON SAOPEI;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAITEMOPI_IX0' AND object_id = OBJECT_ID('SAITEMOPI'))
   ALTER TABLE SAITEMOPI DROP CONSTRAINT SAITEMOPI_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SASEPROPI_IX0' AND object_id = OBJECT_ID('SASEPROPI'))
   ALTER TABLE SASEPROPI DROP CONSTRAINT SASEPROPI_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAPLANI_IX0' AND object_id = OBJECT_ID('SAPLANI'))
   ALTER TABLE SAPLANI DROP CONSTRAINT SAPLANI_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAITEMPLANI_IX0' AND object_id = OBJECT_ID('SAITEMPLANI'))
   ALTER TABLE SAITEMPLANI DROP CONSTRAINT SAITEMPLANI_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAACXC_IX0' AND object_id = OBJECT_ID('SAACXC'))
   ALTER TABLE SAACXC DROP CONSTRAINT SAACXC_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAACXC_IX1' AND object_id = OBJECT_ID('SAACXC'))
   DROP INDEX SAACXC_IX1 ON SAACXC;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAPAGCXC_IX0' AND object_id = OBJECT_ID('SAPAGCXC'))
   ALTER TABLE SAPAGCXC DROP CONSTRAINT SAPAGCXC_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SATAXCXC_IX0' AND object_id = OBJECT_ID('SATAXCXC'))
   ALTER TABLE SATAXCXC DROP CONSTRAINT SATAXCXC_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAIPACXC_IX0' AND object_id = OBJECT_ID('SAIPACXC'))
   ALTER TABLE SAIPACXC DROP CONSTRAINT SAIPACXC_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAACXP_IX0' AND object_id = OBJECT_ID('SAACXP'))
   ALTER TABLE SAACXP DROP CONSTRAINT SAACXP_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAACXP_IX1' AND object_id = OBJECT_ID('SAACXP'))
   DROP INDEX SAACXP_IX1 ON SAACXP;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAPAGCXP_IX0' AND object_id = OBJECT_ID('SAPAGCXP'))
   ALTER TABLE SAPAGCXP DROP CONSTRAINT SAPAGCXP_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SATAXCXP_IX0' AND object_id = OBJECT_ID('SATAXCXP'))
   ALTER TABLE SATAXCXP DROP CONSTRAINT SATAXCXP_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAPVPR_IX0' AND object_id = OBJECT_ID('SAPVPR'))
   ALTER TABLE SAPVPR DROP CONSTRAINT SAPVPR_IX0;
IF EXISTS(SELECT * FROM sys.indexes 
           WHERE name='SAPVPR_IX1' AND object_id = OBJECT_ID('SAPVPR'))
   DROP INDEX SAPVPR_IX1 ON SAPVPR;
GO
ALTER TABLE [dbo].SAPVPR WITH NOCHECK ADD
   CONSTRAINT SAPVPR_IX0 PRIMARY KEY CLUSTERED  (TIPOCOM,CODITEM,CODPROV);
CREATE INDEX SAPVPR_IX1 ON [dbo].SAPVPR (TIPOCOM,CODPROV,CODITEM);
ALTER TABLE SAINSTA WITH NOCHECK
      ADD CONSTRAINT SAINSTA_IX0 PRIMARY KEY CLUSTERED (CODINST);
ALTER TABLE SAFACT WITH NOCHECK
      ADD CONSTRAINT SAFACT_IX0 PRIMARY KEY CLUSTERED (CODSUCU,TIPOFAC,NUMEROD);
ALTER TABLE SAIPAVTA WITH NOCHECK
      ADD CONSTRAINT SAIPAVTA_IX0 PRIMARY KEY CLUSTERED (CODSUCU,TIPOFAC,NUMEROD,NROUNICO);
ALTER TABLE SATAXVTA WITH NOCHECK
      ADD CONSTRAINT SATAXVTA_IX0 PRIMARY KEY CLUSTERED (CODSUCU,TIPOFAC,NUMEROD,CODTAXS);
ALTER TABLE SAITEMFAC WITH NOCHECK
      ADD CONSTRAINT SAITEMFAC_IX0 PRIMARY KEY CLUSTERED (CODSUCU,TIPOFAC,NUMEROD,NROLINEA,NROLINEAC);
ALTER TABLE SATAXITF WITH NOCHECK
      ADD CONSTRAINT SATAXITF_IX0 PRIMARY KEY CLUSTERED (CODSUCU,TIPOFAC,NUMEROD,NROLINEA,NROLINEAC,CODTAXS);
ALTER TABLE SASEPRFAC WITH NOCHECK
      ADD CONSTRAINT SASEPRFAC_IX0 PRIMARY KEY CLUSTERED (CODSUCU,TIPOFAC,NUMEROD,NROLINEA,NROLINEAC,NROSERIAL);
ALTER TABLE SACOMP WITH NOCHECK
      ADD CONSTRAINT SACOMP_IX0 PRIMARY KEY CLUSTERED (CODSUCU,CODPROV,TIPOCOM,NUMEROD);
ALTER TABLE SATAXCOM WITH NOCHECK
      ADD CONSTRAINT SATAXCOM_IX0 PRIMARY KEY CLUSTERED (CODSUCU,CODPROV,TIPOCOM,NUMEROD,CODTAXS);
ALTER TABLE SAITEMCOM WITH NOCHECK
      ADD CONSTRAINT SAITEMCOM_IX0 PRIMARY KEY CLUSTERED (CODSUCU,CODPROV,TIPOCOM,NUMEROD,NROLINEA);
ALTER TABLE SATAXITC WITH NOCHECK
      ADD CONSTRAINT SATAXITC_IX0 PRIMARY KEY CLUSTERED (CODSUCU,CODPROV,TIPOCOM,NUMEROD,NROLINEA,CODTAXS);
ALTER TABLE SASEPRCOM WITH NOCHECK
      ADD CONSTRAINT SASEPRCOM_IX0 PRIMARY KEY CLUSTERED (CODSUCU,CODPROV,TIPOCOM,NUMEROD,NROLINEA,NROSERIAL);
ALTER TABLE SAPRIMCOM WITH NOCHECK
      ADD CONSTRAINT SAPRIMCOM_IX0 PRIMARY KEY CLUSTERED (CODSUCU,CODPROV,TIPOCOM,NUMEROD,NROLINEA);
ALTER TABLE SAOPEI WITH NOCHECK
      ADD CONSTRAINT SAOPEI_IX0 PRIMARY KEY CLUSTERED (CODSUCU,TIPOOPI,NUMEROD);
ALTER TABLE SAITEMOPI WITH NOCHECK
      ADD CONSTRAINT SAITEMOPI_IX0 PRIMARY KEY CLUSTERED (CODSUCU,TIPOOPI,NUMEROD,NROLINEA);
ALTER TABLE SASEPROPI WITH NOCHECK
      ADD CONSTRAINT SASEPROPI_IX0 PRIMARY KEY CLUSTERED (CODSUCU,TIPOOPI,NUMEROD,NROLINEA,NROSERIAL);
ALTER TABLE SAPLANI WITH NOCHECK
      ADD CONSTRAINT SAPLANI_IX0 PRIMARY KEY CLUSTERED (CODSUCU,NUMEROD);
ALTER TABLE SAITEMPLANI WITH NOCHECK
      ADD CONSTRAINT SAITEMPLANI_IX0 PRIMARY KEY CLUSTERED (CODSUCU,NUMEROD,NROLINEA);
ALTER TABLE SAACXC WITH NOCHECK
      ADD CONSTRAINT SAACXC_IX0 PRIMARY KEY CLUSTERED (CODSUCU,CODCLIE,NROUNICO);
ALTER TABLE SAPAGCXC WITH NOCHECK
      ADD CONSTRAINT SAPAGCXC_IX0 PRIMARY KEY CLUSTERED (CODSUCU,NROPPAL,NROUNICO);
ALTER TABLE SATAXCXC WITH NOCHECK
      ADD CONSTRAINT SATAXCXC_IX0 PRIMARY KEY CLUSTERED (CODSUCU,NROPPAL,NROUNICO,CODTAXS);
ALTER TABLE SAIPACXC WITH NOCHECK
      ADD CONSTRAINT SAIPACXC_IX0 PRIMARY KEY CLUSTERED (CODSUCU,NROPPAL,NROUNICO);
ALTER TABLE SAACXP WITH NOCHECK
      ADD CONSTRAINT SAACXP_IX0 PRIMARY KEY CLUSTERED (CODSUCU,CODPROV,NROUNICO);
ALTER TABLE SAPAGCXP WITH NOCHECK
      ADD CONSTRAINT SAPAGCXP_IX0 PRIMARY KEY CLUSTERED (CODSUCU,NROPPAL,NROUNICO);
ALTER TABLE SATAXCXP WITH NOCHECK
      ADD CONSTRAINT SATAXCXP_IX0 PRIMARY KEY CLUSTERED (CODSUCU,NROPPAL,NROUNICO,CODTAXS);
IF EXISTS(SELECT Name From Sysobjects Where Name= 'SAPRSRI') 
   DROP TABLE SAPRSRI
GO
ALTER TABLE SAFACT ALTER COLUMN AutSRI VARCHAR(40);
IF NOT EXISTS(SELECT Name From Sysobjects Where Name= 'SAPRSRI') 
Begin
  CREATE TABLE [dbo].SAPRSRI(
    CODPROV     VARCHAR(15) Not Null,
    NroEstable  VARCHAR(10) Not Null,
    PtoEmision  VARCHAR(10) Not Null,
    FechaV      DATETIME,
    NroInicio   int Not Null default(0),
    NroFinal    int Not Null default(0),
    AutSRI      VARCHAR(40) )
  ALTER TABLE [dbo].SAPRSRI WITH NOCHECK ADD
   CONSTRAINT SAPRSRI_IX0 PRIMARY KEY CLUSTERED  (CodProv,NroEstable,PtoEmision);
End;
IF NOT EXISTS(SELECT Name From Sysobjects Where Name= 'SAAUTORIZ') 
Begin
  CREATE TABLE [dbo].SAAUTORIZ(
    NroUnico    INT IDENTITY (1,1) NOT NULL,
    Tipo        VARCHAR(1),
    CodEsta     VARCHAR(10) NOT NULL,
    FechaV      DATETIME,
    NroInicio   int Not Null default(0),
    NroFinal    int Not Null default(0),
    AutSRI      VARCHAR(40) );
End;
IF NOT EXISTS(SELECT Name From Sysobjects Where Name= 'SAANULAC') 
Begin
  CREATE TABLE [dbo].SAANULAC(
    NroUnico    INT IDENTITY (1,1) NOT NULL,
    Tipo        VARCHAR(1), 
    AutSRI      VARCHAR(40), 
    NroEstable  VARCHAR(10) Not Null,
    PtoEmision  VARCHAR(10) Not Null,
    FechaE      DATETIME,
    FechaL      DATETIME,
    NroInicio   int Not Null default(0),
    NroFinal    int Not Null default(0));
End;
GO
GO
-------------------------------- */

-------------------------------- */
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'RUCUser' And so.id = si.id And so.name = 'SACONF') 
ALTER TABLE [dbo].SACONF WITH NOCHECK ADD RUCUser VARCHAR(20) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'RUCPwd' And so.id = si.id And so.name = 'SACONF') 
ALTER TABLE [dbo].SACONF WITH NOCHECK ADD RUCPwd VARCHAR(20) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'TipoOpe' And so.id = si.id And so.name = 'SAFALO') 
ALTER TABLE [dbo].SAFALO WITH NOCHECK ADD TipoOpe SMALLINT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'DiasTole' And so.id = si.id And so.name = 'SAPROD') 
ALTER TABLE [dbo].SAPROD WITH NOCHECK ADD DiasTole INT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'EsReten' And so.id = si.id And so.name = 'SATAXVTA') 
ALTER TABLE [dbo].SATAXVTA WITH NOCHECK ADD EsReten SMALLINT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'EsReten' And so.id = si.id And so.name = 'SATAXCOM') 
ALTER TABLE [dbo].SATAXCOM WITH NOCHECK ADD EsReten SMALLINT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'EsReten' And so.id = si.id And so.name = 'SATAXCXC') 
ALTER TABLE [dbo].SATAXCXC WITH NOCHECK ADD EsReten SMALLINT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'EsReten' And so.id = si.id And so.name = 'SATAXCXP') 
ALTER TABLE [dbo].SATAXCXP WITH NOCHECK ADD EsReten SMALLINT NOT NULL DEFAULT (0) WITH VALUES;
ALTER TABLE SAFACT ALTER COLUMN AutSRI VARCHAR(40);
IF NOT EXISTS(SELECT Name From Sysobjects Where Name= 'SAPRSRI') 
Begin
  CREATE TABLE [dbo].SAPRSRI(
    CODPROV     VARCHAR(15) Not Null,
    NroEstable  VARCHAR(10) Not Null,
    PtoEmision  VARCHAR(10) Not Null,
    FechaV      DATETIME,
    NroInicio   int Not Null default(0),
    NroFinal    int Not Null default(0),
    AutSRI      VARCHAR(40) )
  ALTER TABLE [dbo].SAPRSRI WITH NOCHECK ADD
   CONSTRAINT SAPRSRI_IX0 PRIMARY KEY CLUSTERED  (CodProv,NroEstable,PtoEmision);
End;
IF NOT EXISTS(SELECT Name From Sysobjects Where Name= 'SAAUTORIZ') 
Begin
  CREATE TABLE [dbo].SAAUTORIZ(
    NroUnico    INT IDENTITY (1,1) NOT NULL,
    Tipo        VARCHAR(1),
    CodEsta     VARCHAR(10) NOT NULL,
    FechaV      DATETIME,
    NroInicio   int Not Null default(0),
    NroFinal    int Not Null default(0),
    AutSRI      VARCHAR(40) );
End;
IF NOT EXISTS(SELECT Name From Sysobjects Where Name= 'SAANULAC') 
Begin
  CREATE TABLE [dbo].SAANULAC(
    NroUnico    INT IDENTITY (1,1) NOT NULL,
    Tipo        VARCHAR(1), 
    AutSRI      VARCHAR(40), 
    NroEstable  VARCHAR(10) Not Null,
    PtoEmision  VARCHAR(10) Not Null,
    FechaE      DATETIME,
    FechaL      DATETIME,
    NroInicio   int Not Null default(0),
    NroFinal    int Not Null default(0));
End;
GO
GO
---------------------------------------
---------------------------------------

IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'DiasTole' And so.id = si.id And so.name = 'SAPROD') 
ALTER TABLE [dbo].SAPROD WITH NOCHECK ADD DiasTole INT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'TGravable0' And so.id = si.id And so.name = 'SAFACT') 
ALTER TABLE [dbo].SAFACT WITH NOCHECK ADD TGravable0 DECIMAL(28,3) NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'TGravable0' And so.id = si.id And so.name = 'SACOMP') 
ALTER TABLE [dbo].SACOMP WITH NOCHECK ADD TGravable0 DECIMAL(28,3) NOT NULL DEFAULT (0) WITH VALUES;
GO
------------------------------- */
------------------------------- */
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NumeroF' And so.id = si.id And so.name = 'SAACXC') 
ALTER TABLE [dbo].SAACXC WITH NOCHECK ADD NumeroF VARCHAR(20) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NumeroP' And so.id = si.id And so.name = 'SAACXC') 
ALTER TABLE [dbo].SAACXC WITH NOCHECK ADD NumeroP VARCHAR(15) NULL;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'Value' And so.id = si.id And so.name = 'SAACAMPOS') 
ALTER TABLE [dbo].SAACAMPOS WITH NOCHECK ADD Value NVARCHAR(MAX) NULL;
GO
