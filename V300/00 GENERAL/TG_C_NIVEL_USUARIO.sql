-- ********************************************************************************
-- NUEVO TRIGGER CREADO PARA FUNCIONAR A PARTIR DE LA VERSION 901X CREADO POR: JOSE RAVELO MAR-2016 
-- DETECTA INSTER O UPDATE EN SSUSRS Y VALIDA LOS 2 PRIMEROS DIGITOS DEL NOMBRE PARA OBLIGAR AL USUARIO A
-- INDICAR EL VALOR DEL NIVEL O GRUPO A QUE PERTENECE EL USUARIO TOMANDO EN CUENTA EL VALOR DE LOS PRIMEROS 2 DIGITOS.
-- DEL CAMPO DESCRIP DE SSNVL EL CUAL DESCRIBE UN VALOR UNICO y DEPENDE DEL CODIGO DE CUANDO FUERE CREADO
-- DANDO OPCION A QUE EN CADA CONCESIONARIOS SE HAYAN CREADO EN MOMENTOS DIFERENTES PERO LA PROGRAGRAMACOPN DE LA APLICACION NO SE AFECTE
-- PARA ELLO HAY QUE CONCILIAR LOS CODIGOS DE TODAS LAS TABLAS SSNIVL DE LOS DISTINTOS CONCESIONARIOS A LA DEL PILOTO.
-- NO SE PUEDE VALIDAR EL VALOR DEL CODIGO NI EL VALOR DE ACTIVO PORQUE ESTAN ENCRIPTADOS EN SSUSRS.  
-- SOLO SE VALIDA QUE LOS DOS PRIMEROS DIGITOS DE NOMBRE SEAN NUMEROS. 
--
-- ********************************************************************************
 
 
if exists (select * from dbo.sysobjects where id = object_id(N'[TG_NIVEL_USUARIO]'))
drop TRIGGER TG_NIVEL_USUARIO  
GO
 
 if exists (select * from dbo.sysobjects where id = object_id(N'[TG_C_NIVEL_USUARIO]'))
drop TRIGGER TG_C_NIVEL_USUARIO  
GO
  
CREATE TRIGGER TG_C_NIVEL_USUARIO ON SSUSRS
-- WITH ENCRYPTION
AFTER INSERT, UPDATE
AS
-----------------------------------
-- DECLARACION DE VARIABLES 
-----------------------------------
DECLARE @STATUSERROR INT,
        @DESCRIPERROR VARCHAR(300)
    SET @STATUSERROR=0  
    
-- Contenido de campos de saCOMP
  
DECLARE @CODUSUA VARCHAR(10),
        @Descrip VARCHAR(50)       
        
-----------------------------------------------------
--- RECOLECCION DE DATOS - (CORRECCION Y PREPARACION)
-----------------------------------------------------

-- Recoge datos de la tabla: INSERTED
   SELECT @Codusua=Codusua,
          @Descrip=Descrip 
   FROM INSERTED
   
   
   
  IF  (substring(@descrip,1,1)<>'1' and substring(@descrip,1,1)<>'2' and substring(@descrip,1,1)<>'3' and substring(@descrip,1,1)<>'4' and substring(@descrip,1,1)<>'5' and substring(@descrip,1,1)<>'6' and substring(@descrip,1,1)<>'7' and substring(@descrip,1,1)<>'8' and substring(@descrip,1,1)<>'9') or (substring(@descrip,2,1)<>' ' and substring(@descrip,3,1)<>' ') 
  
  
   BEGIN
      SELECT @DESCRIPERROR=DESCRIPCION FROM SA_CERROR WHERE CODERR='01097'
      EXECUTE SP_00_VENTANA_ERROR @DESCRIPERROR
     END 
   
   
   -- FALTA QUE CUANDO SE DESACTIVE UN USUARIO POR EL CONFIGURADOR ESTE DEBE PASAR A TENER EL VALO 99 EN LOS 2 PRIMEROS DIGITOS DEL CAMPO DESPRIP EN SSUURS
   -- POR LO PRNTO SE LE PIDE AL USUARIO DIRECTIVO QUE LO INDIQUE CUANDO ESTE EN EL CONFIGURADOR 