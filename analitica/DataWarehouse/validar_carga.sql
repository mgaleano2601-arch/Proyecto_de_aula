-- Consultas de control para SQLite o MySQL, después de la carga.
-- En MySQL seleccionar previamente bovicontrol_dw_demo.
SELECT COUNT(*) AS Animales FROM DimAnimal; -- 24
SELECT SUM(Dosis) AS Aplicaciones FROM FactVacunacion; -- 72
SELECT COUNT(*) AS Registros, ROUND(SUM(Litros),2) AS Litros FROM FactLeche; -- 2376; 22595.22
SELECT EstadoKey, SUM(Dosis) AS Dosis FROM FactVacunacion
WHERE EsUltimoRegistro=1 GROUP BY EstadoKey; -- 1:19, 2:26, 3:21, 4:6
-- Estas consultas deben devolver cero filas.
SELECT AnimalKey, FechaKey, TurnoKey, COUNT(*) AS Repeticiones
FROM FactLeche GROUP BY AnimalKey, FechaKey, TurnoKey HAVING COUNT(*)>1;
SELECT f.LecheKey FROM FactLeche f LEFT JOIN DimAnimal a ON f.AnimalKey=a.AnimalKey WHERE a.AnimalKey IS NULL;
SELECT f.VacunacionKey FROM FactVacunacion f LEFT JOIN DimFecha d ON f.FechaAplicacionKey=d.FechaKey WHERE d.FechaKey IS NULL;
SELECT f.VacunacionKey FROM FactVacunacion f LEFT JOIN DimFecha d ON f.FechaProximaKey=d.FechaKey WHERE f.FechaProximaKey IS NOT NULL AND d.FechaKey IS NULL;
SELECT * FROM FactLeche WHERE Litros < 0;
SELECT * FROM FactVacunacion WHERE FechaProximaKey < FechaAplicacionKey;
-- Control de tendencia: octubre es parcial.
SELECT d.AnioMes, ROUND(SUM(f.Litros),2) AS Litros
FROM FactLeche f JOIN DimFecha d ON f.FechaKey=d.FechaKey
GROUP BY d.AnioMes ORDER BY d.AnioMes;
