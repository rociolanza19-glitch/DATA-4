USE Ventas_Tech_DB;
GO

--CONSULTA 1
SELECT MONTH(fecha_venta)              AS mes,
       SUM(cantidad * precio_unitario) AS total_facturado,
       COUNT(*)                        AS cantidad_pedidos,
       AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

--CONSULTA 2
SELECT TOP 5 id_producto,
       SUM(cantidad)                   AS unidades_vendidas,
       SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

--CONSULTA 3
SELECT id_cliente,
       COUNT(*)                        AS cantidad_pedidos,
       SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;


--CONSULTA 4
WITH totales AS (
    SELECT id_producto,
           SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT id_producto,
       total_facturado,
       CASE WHEN total_facturado > (SELECT AVG(total_facturado) FROM totales)
            THEN 'Por encima'
            ELSE 'Por debajo'
       END AS comparacion_promedio
FROM totales
ORDER BY total_facturado DESC;

-- === HALLAZGOS ===
-- 1. El producto 1 es el que más plata genera: 3600 de los 6444 totales
--    (más de la mitad, el 56%).
-- 2. El producto 2 es el que más unidades vende (13 de 29), pero genera poca
--    plata (364, solo el 6%) porque es barato (28 cada uno).
-- 3. Los clientes 1 y 5 gastaron 4740 de los 6444 totales (el 74%).
--    Los otros 3 clientes gastaron 674 o menos cada uno