-- ============================================================================
-- MÓDULO 5 · PRE-ENTREGA: CONSULTAS CON JOINS PARA EL PROYECTO
-- Proyecto Integrador: RetailPro
-- Base de datos: Ventas_Tech_DB (SQL Server / SSMS)
-- Archivo: m5_consultas_joins.sql
-- Autor: Lucía Chiarandini
-- Fecha: 19/11/2026
-- ============================================================================

USE Ventas_Tech_DB;
GO


-- ----------------------------------------------------------------------------
-- Consulta 1: Vista base enriquecida del proyecto (INNER JOIN)
-- Propósito: cruzar la tabla de hechos ventas con las dimensiones clientes,
-- productos y categorias para generar la tabla plana enriquecida que
-- alimentará el modelo y los filtros/agrupaciones de Power BI en M7.
-- ----------------------------------------------------------------------------
SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre                      AS nombre_cliente,
    c.ciudad                      AS ciudad_cliente,
    p.id_producto,
    p.nombre_producto             AS descripcion_producto,
    cat.nombre_categoria          AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c    ON v.id_cliente   = c.id_cliente
INNER JOIN productos p   ON v.id_producto  = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta, v.id_venta;
-- Hallazgo: La vista integra las 10 transacciones válidas ($6.464,00 facturados) combinando 5 ciudades y 4 categorías de producto, dejando lista la dimensión geográfica (ciudad) para filtrar y la categoría para agrupar en Power BI.
GO


-- ----------------------------------------------------------------------------
-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: identificar clientes registrados en el maestro que aún no
-- realizaron ninguna compra, aislando los casos con WHERE IS NULL para CRM.
-- ----------------------------------------------------------------------------
SELECT
    c.id_cliente,
    c.nombre,
    c.email,
    c.ciudad,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro;
-- Hallazgo: Aparecieron 0 clientes sin ventas sobre los 5 clientes registrados actualmente; para CRM esto confirma una tasa de conversión del 100% sobre la cartera inicial, aunque la consulta queda lista como alerta automatizada para detectar futuros registros inactivos.
GO


-- ----------------------------------------------------------------------------
-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: identificar artículos del catálogo activo que no registran
-- ninguna transacción en ventas, aislando los casos con WHERE IS NULL.
-- ----------------------------------------------------------------------------
SELECT
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio,
    p.stock
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v        ON p.id_producto  = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;
-- Hallazgo: Aparecieron 0 productos sin ventas sobre los 6 artículos cargados en el catálogo; para el área de Producto esto indica que el 100% del surtido inicial tiene rotación comercial activa y no presenta inventario inmovilizado sin demanda.
GO


-- ----------------------------------------------------------------------------
-- Consulta 4: Consolidado de facturación por tramo operativo (UNION ALL)
-- Propósito: apilar dos subconjuntos independientes de ventas creando una
-- columna literal de origen sin deduplicar transacciones, y consolidar el
-- monto total facturado por cada tramo.
-- ----------------------------------------------------------------------------
SELECT
    origen_periodo,
    COUNT(*)   AS cantidad_operaciones,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Primera Decena (01-10 Mar)' AS origen_periodo
    FROM ventas
    WHERE fecha_venta <= '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Segunda Decena (11-15 Mar)' AS origen_periodo
    FROM ventas
    WHERE fecha_venta > '2024-03-10'
) AS consolidado
GROUP BY origen_periodo
ORDER BY total_canal DESC;
-- Hallazgo: La Primera Decena (01-10 Mar) lidera la facturación con $3.620,00 frente a los $2.844,00 de la Segunda Decena (11-15 Mar), concentrando el 56,0% de los ingresos totales ($6.464,00) en las primeras 5 operaciones del mes.
GO
