
--CONSULTA 1 – RESUMEN EJECUTIVO MENSUAL
SELECT
	MONTH(fecha_venta) AS mes,
	SUM(cantidad * precio_unitario) AS total_facturado,
	COUNT(id_venta) AS cantidad_pedidos,
	AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes; 

--CONSULTA 2 – RANKING DE PRODUCTOS
SELECT
	TOP 5 id_producto,
	SUM(cantidad) AS unidades_vendidas,
	SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC; 

--CONSULTA 3 – CLIENTES RECURRENTES
SELECT 
    id_cliente,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM 
    ventas
GROUP BY 
    id_cliente
HAVING 
    COUNT(*) > 1;


--CONSULTA 4 – MESES POR ENCIMA/POR DEBAJO DEL PROMEDIO
WITH ventas_por_mes AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM 
        ventas
    GROUP BY 
        MONTH(fecha_venta)
)
SELECT 
    mes,
    total_facturado,
    CASE 
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM ventas_por_mes) THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado) FROM ventas_por_mes) THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS evaluacion_promedio
FROM 
    ventas_por_mes
ORDER BY 
    mes;


--Hallazgo Consulta 1
--En marzo 2024 se realizaron 10 operaciones con un total facturado de $6.440 siendo el promedio de $644,40

--Hallazgo  Consulta 2
--En términos de ingresos el id_producto 1 generó la mayor recaudación con $3.600,00 (3 unidades)
--En términos de cantidades, el id_producto 2 registra la mayor cantidad de unidades vendidas y el menor total en términos monetarios.

--Hallazgo Consulta 3
--De los clientes registrados, todos han realizado 2 pedidos, donde id_cliente 1 y 5 son los que mas gastaron.