# RetailPro — Pipeline de Análisis de Datos Comerciales

Proyecto integrador de analítica de datos orientado a transformar datos transaccionales de retail tecnológico en métricas accionables para la toma de decisiones comerciales, de inventario y de fidelización de clientes.

## Arquitectura y Herramientas Utilizadas
* **Motor de Base de Datos:** SQL Server (`Ventas_Tech_DB`) / SQL Server Management Studio (SSMS).
* **Modelado y Visualización:** Power BI Desktop (esquema estrella, Power Query M y medidas DAX).
* **Control de Versiones:** GitHub.

## Estructura del Repositorio
* `m4_consultas_negocio.sql`: Consultas de agregación y negocio (resumen ejecutivo mensual, ranking Top 5 de productos, recurrencia de clientes y brecha frente al promedio de facturación mediante CTE).
* `m5_consultas_joins.sql`: Consultas relacionales avanzadas (`INNER JOIN` para la vista base enriquecida, `LEFT JOIN` para detección de clientes y productos sin ventas en CRM/Stock, y `UNION ALL` para consolidación por tramos operativos).

## Cómo Ejecutar los Scripts SQL
1. Asegurarse de tener creada y poblada la base de datos `Ventas_Tech_DB` con las tablas `ventas`, `clientes`, `productos` y `categorias`.
2. Abrir **SQL Server Management Studio (SSMS)** y conectarse a la instancia local.
3. Abrir primero `m4_consultas_negocio.sql` y luego `m5_consultas_joins.sql`, verificar que el contexto apunte a `USE Ventas_Tech_DB;` y ejecutar cada bloque delimitado por `GO` (`F5`).

## Autoría
* **Analista:** Lucía Chiarandini
* **Repositorio:** [luciaavrchiarandini-hub/proyecto-retailpro](https://github.com/luciaavrchiarandini-hub/proyecto-retailpro)
