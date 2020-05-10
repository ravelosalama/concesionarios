-- ESTE PROCESO DEBE HACERSE UNA SOLA VEZ DADO QUE EL RESPALDO DEL CAMPO NUMEROD SOBRE NOTAS2 PUEDE perderse SI SE REPITE EL PROCESO.
-- en todo caso si se requiere repetir, se debe desahbilitar la primera consulta de este scrips.

-- IMPORTANTE: FECHAE - Fecha de posteo dentro del mes de trabajo. (normalmente es fecha de registro)
--             FECHAI - Fecha real del documento. (Dentro o fuera del mes de trabajo).
--             FECHAT - Fecha de la estacion de trabajo. (Fecha de la transaccion) fuera o dentro del mes de trabajo




-- RESPALDO CAMPO NUMEROD EN NOTAS2 esta instruccion puede shicharse como comentarios para procesar varias veces esta consulta.

UPDATE SAACXP SET Notas2=NumeroD WHERE TipoCxP='81'


-- CONSTRUYO EN NUMEROD, 1RA PARTE DEL FORMATO DE NUMERO DE COMPROBANTE SIN EL CERO DEL MES 1 AL 9
UPDATE SAACXP SET NumeroD= CAST(year(fechaE) as varchar(4) )+CAST(month(fechaE) as varchar(2)) + '00'+RIGHT(NumeroD,6)
WHERE TipoCxP='81' -- AND LEN(NUMEROD)<>6

-- AGREGO CERO FALTANTE EN EL MES DEL 1 AL 9 
UPDATE SAACXP SET NumeroD=  SUBSTRING(NumeroD,1,4)+'0'+SUBSTRING(NumeroD,5,1)+'00'+RIGHT(NUMEROD,6)
WHERE TipoCxP='81' AND LEN(NUMEROD)<14

-- ACTUALIZO VALOR DE NUMERO DE RETENCION EN SACOMP 
UPDATE    SACOMP
SET               NumeroR = Y.NumeroD
                    
FROM         SACOMP INNER JOIN
                      SAACXP AS Y ON SACOMP.NumeroD = Y.NumeroN
WHERE     (SACOMP.TipoCom = 'H') AND (Y.TipoCxP = '81')

/* CONSULTAS DE REVISION Y AUDITORIAS DE ESTE PROCESO
-- MUESTRO RESULTADOS
select NumeroD,LEN(NUMEROD),TipoCxP,fechae, CAST(year(fechae) as varchar(4) )+CAST(month(fechae) as varchar(2)) as periodo, LEN(CAST(year(fechae) as varchar(4) )+CAST(month(fechae) as varchar(2))),Notas1,LEN(NOTAS1),Notas2,LEN(NOTAS2)  from saacxp where tipocxp='81'
order by NroUnico

-- VALIDO LONGITUD DEL CAMPO NUMERO DE COMPROBANTE
SELECT * FROM SAACXP WHERE LEN(NumeroD)<>14 AND TipoCxP='81'

-- VALIDO ULTIMOS 6 DE CAMPO RECONSTRUIDO CON ULTIMOS SEIS DE CAMPO ANTIGUO.
SELECT * FROM SAACXP WHERE RIGHT(NOTAS2,6)<>RIGHT(NUMEROD,6) AND TIPoCxP='81'

-- REVISO LONGITUD Y VALOR DEL CAMPO COMRPOBANTE DE RETENCION EN COMPRAS
SELECT NumeroR,LEN(NumeroR) FROM SACOMP WHERE TipoCom='H'

 SELECT * FROM SAACXP WHERE NumeroD<>Notas1 AND TIPOCXP='81'
 */