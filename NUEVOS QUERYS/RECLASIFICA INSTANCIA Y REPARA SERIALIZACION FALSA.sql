
UPDATE    SAPROD
SET              DEsSeri = 0
WHERE     (DEsSeri = 1) AND (CodInst <> '11')


UPDATE    SAPROD
SET              CodInst = 32
WHERE     (CodInst = 36)


UPDATE    SAPROD
SET              Compro = 0, Pedido = 0
