-- PREPARA BASE DE DATOS RECEPTORA


-- LIMPIEZA TOTAL


-- SWICHE DE PROTECCION 
 
-- TABLAS OPERATIVAS

-- TABLAS DE SISTEMA
DELETE FROM SAREPO
DELETE FROM SAITRE -- REPORTES BIN
DELETE FROM SAUSRREP

DELETE FROM SSFLDS
DELETE FROM SSNIVL -- PERFILES 
DELETE FROM SSOPMN -- OPC DEL MENU
DELETE FROM SFTITM --FORMATOS BIN 
DELETE FROM SFTFLD -- CARPETAS
DELETE FROM SSFMTS -- ASIGNACION
DELETE FROM SSPARD
DELETE FROM SSPARM
DELETE FROM SSAUTR -- 
DELETE FROM SSUSRS WHERE DESCRIP LIKE '%SISTEMA%' OR CodUsua='001' OR CodUsua='002' OR CodUsua='GARANTIA' OR CodUsua='ACCESORIO' OR CodUsua='CAJA' OR CodUsua='REPUESTO' OR CodUsua='ADM' OR CodUsua='SERVICIO' OR CodUsua='SUPERR' OR CodUsua='SUPERS' OR CodUsua='SUPERV' OR CodUsua='TRAFICO' OR CodUsua='VEHICULO' 

DELETE FROM SAOPER -- OPERACIONES
DELETE FROM SADEPO -- DEPOSITOS
DELETE FROM SAINSTA -- INSTANCIAS REVISAR ORIGEN PARA SABER SI ACTIVAR PROCESO DE RECLASIFICACION
DELETE FROM SACLIE WHERE CodClie LIKE '990%' 
DELETE FROM SASERV WHERE CODSERV='S0000' OR CODSERV='S9999' -- LIKE 'S4-%' OR CODSERV LIKE 'S6-%' OR CODSERV LIKE 'S8-%' OR CODSERV LIKE 'S9-%' -- OJO PRESTIGE
DELETE FROM SAVEND WHERE DESCRIP LIKE '%SISTEMA%'
 
 
 
 
 
 
 