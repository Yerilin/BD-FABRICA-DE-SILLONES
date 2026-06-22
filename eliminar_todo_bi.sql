USE GD1C2025
GO

IF OBJECT_ID('CALLE_DE_LUNA.Top_Localidades_Costo_Envio', 'V') IS NOT NULL
    DROP VIEW CALLE_DE_LUNA.Top_Localidades_Costo_Envio;
IF OBJECT_ID('CALLE_DE_LUNA.Cumplimiento_Envios', 'V') IS NOT NULL
    DROP VIEW CALLE_DE_LUNA.Cumplimiento_Envios;
IF OBJECT_ID('CALLE_DE_LUNA.Compras_Por_Tipo_Material', 'V') IS NOT NULL
    DROP VIEW CALLE_DE_LUNA.Compras_Por_Tipo_Material;
IF OBJECT_ID('CALLE_DE_LUNA.Promedio_Compras', 'V') IS NOT NULL
    DROP VIEW CALLE_DE_LUNA.Promedio_Compras;
IF OBJECT_ID('CALLE_DE_LUNA.Tiempo_Promedio_Fabricacion', 'V') IS NOT NULL
    DROP VIEW CALLE_DE_LUNA.Tiempo_Promedio_Fabricacion;
IF OBJECT_ID('CALLE_DE_LUNA.Conversion_Pedidos', 'V') IS NOT NULL
    DROP VIEW CALLE_DE_LUNA.Conversion_Pedidos;
IF OBJECT_ID('CALLE_DE_LUNA.Volumen_Pedidos', 'V') IS NOT NULL
    DROP VIEW CALLE_DE_LUNA.Volumen_Pedidos;
IF OBJECT_ID('CALLE_DE_LUNA.Top_3_Modelos', 'V') IS NOT NULL
    DROP VIEW CALLE_DE_LUNA.Top_3_Modelos;
IF OBJECT_ID('CALLE_DE_LUNA.Factura_Promedio_Mensual', 'V') IS NOT NULL
    DROP VIEW CALLE_DE_LUNA.Factura_Promedio_Mensual;
IF OBJECT_ID('CALLE_DE_LUNA.Ganancias', 'V') IS NOT NULL
    DROP VIEW CALLE_DE_LUNA.Ganancias;


IF OBJECT_ID('CALLE_DE_LUNA.BI_Hecho_Envios', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Hecho_Envios;
IF OBJECT_ID('CALLE_DE_LUNA.BI_Hecho_Pedidos', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Hecho_Pedidos;
IF OBJECT_ID('CALLE_DE_LUNA.BI_Hecho_Ventas', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Hecho_Ventas;
IF OBJECT_ID('CALLE_DE_LUNA.BI_Hecho_Compras', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Hecho_Compras;


IF OBJECT_ID('CALLE_DE_LUNA.BI_Dimension_Turno_Venta', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Dimension_Turno_Venta;
IF OBJECT_ID('CALLE_DE_LUNA.BI_Dimension_Estado_Pedido', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Dimension_Estado_Pedido;
IF OBJECT_ID('CALLE_DE_LUNA.BI_Dimension_Cliente', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Dimension_Cliente;
IF OBJECT_ID('CALLE_DE_LUNA.BI_Dimension_Sucursal', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Dimension_Sucursal;
IF OBJECT_ID('CALLE_DE_LUNA.BI_Dimension_Modelo', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Dimension_Modelo;
IF OBJECT_ID('CALLE_DE_LUNA.BI_Dimension_Tipo_Material', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Dimension_Tipo_Material;
IF OBJECT_ID('CALLE_DE_LUNA.BI_Dimension_Rango_Etario', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Dimension_Rango_Etario;
IF OBJECT_ID('CALLE_DE_LUNA.BI_Dimension_Ubicacion', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Dimension_Ubicacion;
IF OBJECT_ID('CALLE_DE_LUNA.BI_Dimension_Tiempo', 'U') IS NOT NULL
    DROP TABLE CALLE_DE_LUNA.BI_Dimension_Tiempo;

