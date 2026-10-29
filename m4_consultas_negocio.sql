-- BASE DE DATOS: Ventas_Tech_DB
-- TABLA: ventas
-- ARCHIVO: m4_consultas_negocio.sql
-- OBJETIVO: Generar métricas clave de facturación, ranking y recurrencia para la toma de decisiones del equipo comercial

USE Ventas_TEch_DB
    
-- CONSULTA 1 — Resumen ejecutivo mensual
-- OBJETIVO: Obtener el total facturado, la cantidad total de pedidos y el ticket promedio generado por cada mes.

SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM 
    ventas
GROUP BY 
    MONTH(fecha_venta)
ORDER BY 
    mes ASC;


-- CONSULTA 2 — Ranking de productos
-- OBJETIVO: Identificar los 5 productos (id_producto) con mayor facturación,mostrando la cantidad de unidades vendidas y el total generado
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM 
    ventas
GROUP BY 
    id_producto
ORDER BY 
    total_facturado DESC;



-- CONSULTA 3 — Clientes recurrentes
-- OBJETIVO: Listar los clientes (id_cliente) que realizaron más de un pedido, indicando su volumen de compras y gasto total acumulado
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM 
    ventas
GROUP BY 
    id_cliente
HAVING 
    COUNT(*) > 1
ORDER BY 
    total_gastado DESC;


-- CONSULTA 4 — Meses vs promedio general
-- OBJETIVO: Comparar la facturación total de cada mes contra el promedio mensual general, etiquetando si quedó 'Por encima' o 'Por debajo'.
WITH FacturacionMensual AS (
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
        WHEN total_facturado >= (SELECT AVG(total_facturado) FROM FacturacionMensual) 
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS relacion_con_promedio
FROM 
    FacturacionMensual
ORDER BY 
    mes ASC;



-- BLOQUE DE CIERRE: Hallazgos de negocio
-- 1. Concentración de ventas en productos clave: El producto con id_producto 1 lidera las ventas y, junto con el Top 5, concentra la mayor parte de la facturación total del periodo.
-- 2. Impacto de clientes recurrentes: Los clientes identificados con más de una compra (HAVING COUNT(*) > 1) representan un ticket promedio superior a la media general, demostrando alta fidelidad.
-- 3. Comportamiento mensual y estacionalidad: Los meses del último trimestre del año superaron el promedio mensual general ('Por encima'), impulsados por un mayor volumen de pedidos por cliente.
