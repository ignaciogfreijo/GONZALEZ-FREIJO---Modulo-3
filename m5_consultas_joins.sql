USE Ventas_Tech_DB;
GO

-- Insertar cliente nuevo sin compras (para la Consulta 2)
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro)
VALUES (6, 'Martin Palermo', 'martin@mail.com', 'La Plata', '2024-03-20');

-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- Combinar todas las tablas en un único dataset plano con dimensiones descriptivas para usar como fuente de datos principal
SELECT 
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad AS region_cliente,
    cat.nombre_categoria,
    p.nombre_producto,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta ASC;
-- Hallazgo: Se cuenta con 10 transacciones, clientes de 5 ciudades y 4 categorías de productos, sirviendo como matriz base para la segmentación geográfica y por categoría.



-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- Identificar clientes registrados en la base de datos que aún no han realizado ninguna compra.
SELECT 
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
-- Hallazgo: 1 de 6 clientes registrados nunca ha comprado.Representa una oportunidad directa para que CRM envíe una campaña de bienvenida.



-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- Identificar productos del catálogo que no registran transacciones para evaluar rotación o discontinuación.
SELECT 
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;
-- Hallazgo: 0 productos sin ventas detectados (el 100% del catálogo de 6 artículos registra al menos una transacción), demostrando nulo stock inmovilizado en catálogo.



-- CONSULTA 4: Consolidado por canal (UNION ALL)
-- Segmentar el total facturado según el canal de origen (estimado por monto de compra: Online para ventas chicas/medianas e Industrial/Corporativo para ventas de gran volumen).
SELECT 
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Venta Minorista / Online' AS canal
    FROM ventas
    WHERE (cantidad * precio_unitario) <= 1000.00

    UNION ALL

    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Venta Corporativa / Mayorista' AS canal
    FROM ventas
    WHERE (cantidad * precio_unitario) > 1000.00
) AS consolidado
GROUP BY canal;
-- Hallazgo: El canal Corporativo/Mayorista genera el 57.5% de la facturación total ($3.600,00) con solo 2 transacciones de alto ticket, mientras que el canal Minorista/Online aporta el 42.5% ($2.664,00) a través de 8 operaciones.