-- DOS QUERYS PARA RASTREAR LA ULTIMA TABLA EN ACTUALIZACE EN UN PROCESO

SELECT      tab.name, ius.last_user_update, user_updates
FROM         sys.dm_db_index_usage_stats AS ius INNER JOIN
                      sys.tables AS tab ON tab.object_id = ius.object_id
WHERE     (ius.database_id = DB_ID(N'LIBERTYCarsAnualDB'))
ORDER BY ius.last_user_update
GO


SELECT * FROM SAFACT_04
GO



SELECT * FROM SA_CTRANSAC 
GO


SELECT * FROM logTransacciones
ORDER BY FechaTrn
GO

