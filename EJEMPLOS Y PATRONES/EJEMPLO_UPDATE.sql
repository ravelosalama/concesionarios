--**** EJEMPLO DE USO DE UPDATE() EN TRIGGER UPDATE
 
 
if exists (select * from dbo.sysobjects where id = object_id(N'[TG_PRUEBA_UPDATE]'))
drop TRIGGER TG_PRUEBA_UPDATE  
GO
 
 if exists (select * from dbo.sysobjects where id = object_id(N'[TG_PRUEBA_UPDATE]'))
drop TRIGGER TG_PRUEBA_UPDATE  
GO
  
CREATE TRIGGER TG_PRUEBA_UPDATE ON CERO
 WITH ENCRYPTION
AFTER  UPDATE
AS
-----------------------------------
-- DECLARACION DE VARIABLES 
-----------------------------------
 Declare @codigo varchar(20)
 Declare @Descrip varchar(100)
 Declare @Coditem varchar(30)
   
  
-----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------

-- Recoge datos de la tabla: INSERTED
   SELECT @Codigo=Codigo,
          @Descrip=Descripción,
          @Coditem=Coditem
          FROM INSERTED
 
 
 
-- Se valida sobre el campo directo de la tabla 
IF UPDATE (Codigo)
     RAISERROR ('SE MODIFICO UN CODIGO',16,1)
IF UPDATE (Descripción)
     RAISERROR ('SE MODIFICO UNA DESCRIPCION',16,1)
IF UPDATE  (Coditem)     
     RAISERROR ('SE MODIFICO UN ITEM',16,1)
  
   
   