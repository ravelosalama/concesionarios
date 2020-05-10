--**** VALIDA SACLIE 
-- VALIDA OTROS CRITERIOS DESPUES DE HABER GRABADO CODCLIE.
-- TIPOCLI= 0 - CONTRIBUYENTE
--          1 - CONSUMIDOR FINAL
--          2 - EXPORTACION
--          3 - INTERNO NO GRAVABLE
--          4 - CONTRIBUYENTE ESPECIAL


GO
-- Coloca a PJ tipocli '0' - Contribuyente.
UPDATE    SACLIE
SET              TipoCli = 0
WHERE     (SUBSTRING(CodClie, 1, 1) = 'J' OR
          SUBSTRING(CodClie, 1, 1) = 'G') AND (TipoCli <> '0') AND (TipoCli <> '4')
SELECT * FROM SACLIE 
WHERE     (SUBSTRING(CodClie, 1, 1) = 'J' OR
          SUBSTRING(CodClie, 1, 1) = 'G') AND (TipoCli <> '0') AND (TipoCli <> '4')


UPDATE    SACLIE
SET              TipoCli = 0
WHERE     (SUBSTRING(ID3, 1, 1) = 'J' OR
                      SUBSTRING(ID3, 1, 1) = 'G') AND (TipoCli <> '0') AND (TipoCli <> '4')
                      
SELECT * FROM SACLIE
WHERE     (SUBSTRING(ID3, 1, 1) = 'J' OR
                      SUBSTRING(ID3, 1, 1) = 'G') AND (TipoCli <> '0') AND (TipoCli <> '4')
                                         
                       

-- Coloca a V,E,P tipoclie '1' - Consumidor final                      
UPDATE    SACLIE
SET              TipoCli = '1'
WHERE     (SUBSTRING(CodClie, 1, 1) = 'V' OR SUBSTRING(CodClie, 1, 1) = 'E' OR SUBSTRING(CodClie, 1, 1) = 'P') 
          AND (TipoCli <> '1')  
          
 SELECT * FROM SACLIE
WHERE     (SUBSTRING(CodClie, 1, 1) = 'V' OR SUBSTRING(CodClie, 1, 1) = 'E' OR SUBSTRING(CodClie, 1, 1) = 'P') 
          AND (TipoCli <> '1')  
                  
  
UPDATE    SACLIE
SET              TipoCli = '1'
WHERE     (SUBSTRING(ID3, 1, 1) = 'V' OR
                      SUBSTRING(ID3, 1, 1) = 'E' OR
                      SUBSTRING(ID3, 1, 1) = 'P') AND (TipoCli <> '1')   
   

SELECT * FROM SACLIE
WHERE     (SUBSTRING(ID3, 1, 1) = 'V' OR
                      SUBSTRING(ID3, 1, 1) = 'E' OR
                      SUBSTRING(ID3, 1, 1) = 'P') AND (TipoCli <> '1')   
                         
   
   
   
                      
GO                                   
                                                              
                      
                      
                      