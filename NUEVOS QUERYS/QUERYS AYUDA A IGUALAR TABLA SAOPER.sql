SELECT    *
FROM         BAKSAOPER AS X LEFT OUTER JOIN
                      SAOPER AS Y ON X.CodOper = Y.CodOper
                      
ORDER BY X.TIPOOPE,X.CodOper
 
 
 
 /*                   
UPDATE BAKSAOPER SET TIPOOPE=1 
FROM         BAKSAOPER AS X LEFT OUTER JOIN
                      SAOPER AS Y ON X.CodOper = Y.CodOper WHERE Y.CodOper IS NULL
                       
                      
UPDATE BAKSAOPER SET TIPOOPE=2 
FROM         BAKSAOPER AS X LEFT OUTER JOIN
                      SAOPER AS Y ON X.CodOper = Y.CodOper WHERE Y.DESCRIP<>X.DESCRIP  */
                      
                      
                      
DELETE FROM BAKSAOPER WHERE TipoOpe=0    

--DELETE FROM BAKSAOPER WHERE TipoOpe=2

                                     