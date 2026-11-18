-- ============================================================================
-- MÓDULO 4 · PRE-ENTREGA: CONSULTAS SQL DE NEGOCIO
-- Proyecto Integrador: RetailPro
-- Base de datos: Ventas_Tech_DB (SQL Server)
-- Archivo: m4_consultas_negocio.sql
-- ============================================================================

USE Ventas_Tech_DB;
GO

-- CONSULTA 1: Resumen ejecutivo mensual
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO

-- CONSULTA 2: Ranking de productos (Top 5)
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
GO

-- CONSULTA 3: Clientes recurrentes
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC, cantidad_pedidos DESC;
GO

-- CONSULTA 4: Productos por encima / por debajo del promedio de facturación
WITH facturacion_por_producto AS (
    SELECT 
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT 
    id_producto,
    total_facturado,
    CASE 
        WHEN total_facturado >= (SELECT AVG(total_facturado) FROM facturacion_por_producto) 
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS estado_vs_promedio
FROM facturacion_por_producto
ORDER BY total_facturado DESC;
GO

-- ============================================================================
-- BLOQUE DE CIERRE: HALLAZGOS DE NEGOCIO
-- ============================================================================
-- 1. Concentración temporal: La totalidad de las operaciones registradas en la
--    base inicial corresponde al mes de marzo (mes = 3), lo que permite fijar
--    una línea base clara de facturación total y ticket promedio para comparar
--    el desempeño de los meses siguientes.
-- 2. Principio de Pareto en el catálogo: El Top 5 de productos concentra la
--    mayor proporción de los ingresos generados, impulsado principalmente por
--    artículos de alto precio unitario más que por volumen puro de unidades.
-- 3. Recurrencia y brecha frente al promedio: Un grupo reducido de clientes
--    recurrentes (más de 1 pedido) sostiene una parte significativa del gasto
--    total, mientras que pocos productos superan el promedio de facturación por
--    SKU, evidenciando oportunidad para campañas de venta cruzada en el resto
--    del catálogo.
