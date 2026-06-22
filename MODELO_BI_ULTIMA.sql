USE [GD1C2025]
GO
---------------------------------------------------------------
-- 1. DIMENSIONES
---------------------------------------------------------------
/* Tiempo */
CREATE TABLE CALLE_DE_LUNA.BI_Dimension_Tiempo(
    tiempo_id      INT IDENTITY PRIMARY KEY,
    anio           INT         NOT NULL,
    cuatrimestre  INT NOT NULL,
    mes           INT NOT NULL,
    fecha     	   Date      NOT NULL,
    UNIQUE (fecha)
);
GO

/* Ubicaci�n */
CREATE TABLE CALLE_DE_LUNA.BI_Dimension_Ubicacion(
    ubicacion_id   INT IDENTITY PRIMARY KEY,
    provincia      NVARCHAR(120) NOT NULL,
    localidad      NVARCHAR(120) NOT NULL,
    UNIQUE (provincia, localidad)
);
GO
/* Rango etario */
CREATE TABLE CALLE_DE_LUNA.BI_Dimension_Rango_Etario(
    rango_id       		INT IDENTITY PRIMARY KEY,
    rango_descripcion   VARCHAR(10)   NOT NULL UNIQUE,
    fecha_inicio      	DATE          NOT NULL,
    fecha_fin      		DATE          NOT NULL,
    CHECK (fecha_inicio < fecha_fin)
);
GO
/* Turno de venta */
CREATE TABLE CALLE_DE_LUNA.BI_Dimension_Turno_Venta(
    turno_id       		INT IDENTITY PRIMARY KEY,
    turno_descripcion   VARCHAR(15) NOT NULL UNIQUE,
    hora_inicio       	TIME        NOT NULL,
    hora_fin       		TIME        NOT NULL,
    CHECK (hora_inicio < hora_fin)
);
GO
/* Tipo de material */
CREATE TABLE CALLE_DE_LUNA.BI_Dimension_Tipo_Material(
    tipo_material_id    INT IDENTITY PRIMARY KEY,
    tipo_descripcion    VARCHAR(20) NOT NULL UNIQUE
);
GO
/* Modelo de sill�n */
CREATE TABLE CALLE_DE_LUNA.BI_Dimension_Modelo(
    modelo_id      INT IDENTITY PRIMARY KEY,
    modelo_codigo  NVARCHAR(120) NOT NULL,
    modelo_descripcion    NVARCHAR(40) NOT NULL,
	modelo_precio int not null

    UNIQUE ( modelo_codigo)
);
GO
/* Estado de pedido */
CREATE TABLE CALLE_DE_LUNA.BI_Dimension_Estado_Pedido(
    estado_id      		INT IDENTITY PRIMARY KEY,
    estado_descripcion  VARCHAR(15) NOT NULL UNIQUE
);
GO
/* Sucursal */
CREATE TABLE CALLE_DE_LUNA.BI_Dimension_Sucursal(
    sucursal_id    INT IDENTITY PRIMARY KEY,
    nro_sucursal   INT          NOT NULL UNIQUE,
    provincia      NVARCHAR(120) NOT NULL,
    localidad      NVARCHAR(120) NOT NULL
);
GO
/* Cliente */
CREATE TABLE CALLE_DE_LUNA.BI_Dimension_Cliente(
    cliente_id     		INT IDENTITY PRIMARY KEY,
    dni            		BIGINT       NOT NULL UNIQUE,
    nombre         		NVARCHAR(120) NOT NULL,
    apellido       		NVARCHAR(120) NOT NULL,
    fecha_nacimiento 	DATE         NOT NULL
);
GO
---------------------------------------------------------------
-- 2. HECHOS
---------------------------------------------------------------
CREATE TABLE CALLE_DE_LUNA.BI_Hecho_Compras(
    compra_id   	BIGINT IDENTITY PRIMARY KEY,
    tiempo      	INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Tiempo(tiempo_id),
    sucursal    	INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Sucursal(sucursal_id),
    tipo_material 	INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Tipo_Material(tipo_material_id),
    ubicacion   	INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Ubicacion(ubicacion_id),
    subtotal    	INT NOT NULL
);
GO

CREATE TABLE CALLE_DE_LUNA.BI_Hecho_Ventas(
    venta_id    BIGINT IDENTITY PRIMARY KEY,
    tiempo      INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Tiempo(tiempo_id),
    sucursal    INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Sucursal(sucursal_id),
    turno       INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Turno_Venta(turno_id),
    modelo_sillon INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Modelo(modelo_id),
    ubicacion   INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Ubicacion(ubicacion_id),
    cliente     INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Cliente(cliente_id),
    rango_etario INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Rango_Etario(rango_id),
    estado_pedido INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Estado_Pedido(estado_id),
    cantidad 		INT NOT NULL,
    tiempo_fabricacion INT NOT NULL,
    subtotal       INT NOT NULL
);
GO

CREATE TABLE CALLE_DE_LUNA.BI_Hecho_Pedidos(
    pedido_id   BIGINT IDENTITY PRIMARY KEY,
    tiempo      INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Tiempo(tiempo_id),
    sucursal    INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Sucursal(sucursal_id),
    ubicacion   INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Ubicacion(ubicacion_id),
    cliente     INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Cliente(cliente_id),
    rango_etario INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Rango_Etario(rango_id),
    estado_pedido INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Estado_Pedido(estado_id)
);
GO

CREATE TABLE CALLE_DE_LUNA.BI_Hecho_Envios(
    envio_id    BIGINT IDENTITY PRIMARY KEY,
    tiempo_prog INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Tiempo(tiempo_id),
    sucursal    INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Sucursal(sucursal_id),
    ubicacion_cli INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Ubicacion(ubicacion_id),
    cliente     INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Cliente(cliente_id),
    rango_etario INT NOT NULL REFERENCES CALLE_DE_LUNA.BI_Dimension_Rango_Etario(rango_id),
    costo_total    DECIMAL(18,2) NOT NULL,
	cantidad_total INT NOT NULL,
	cantidad_total_cumplido int NOT NULL
);
GO



---------------------------------------------------------------
-- 3. DATA DIMENSIONES
---------------------------------------------------------------
/* 3.1  Tiempo */
insert into CALLE_DE_LUNA.BI_Dimension_Tiempo(anio, cuatrimestre,mes,fecha)
    select year(fact_fecha_y_hora), ceiling(datepart(month, fact_fecha_y_hora)/4.0), month(fact_fecha_y_hora) ,CAST(fact_fecha_y_hora AS date) from CALLE_DE_LUNA.Factura
    group by year(fact_fecha_y_hora), ceiling(datepart(month, fact_fecha_y_hora)/4.0), month(fact_fecha_y_hora),fact_fecha_y_hora
    union
    select year(pedi_fecha_hora), ceiling(datepart(month, pedi_fecha_hora)/4.0), month(pedi_fecha_hora), CAST(pedi_fecha_hora as Date) from CALLE_DE_LUNA.Pedido
    group by year(pedi_fecha_hora), ceiling(datepart(month, pedi_fecha_hora)/4.0), month(pedi_fecha_hora),pedi_fecha_hora 
    union
    select year(env_fecha_entrega), ceiling(datepart(month, env_fecha_entrega)/4.0), month(env_fecha_entrega) , CAST(env_fecha_entrega as Date) from CALLE_DE_LUNA.Envio
    group by year(env_fecha_entrega), ceiling(datepart(month, env_fecha_entrega)/4.0), month(env_fecha_entrega), env_fecha_entrega
    union
    select year(env_fecha_programada), ceiling(datepart(month, env_fecha_programada)/4.0), month(env_fecha_programada), Cast(env_fecha_programada as Date) from CALLE_DE_LUNA.Envio
    group by year(env_fecha_programada), ceiling(datepart(month, env_fecha_programada)/4.0), month(env_fecha_programada),env_fecha_programada
    union
    select year(comp_fecha), ceiling(datepart(month, comp_fecha)/4.0), month(comp_fecha), CAST(comp_fecha as DATE )from CALLE_DE_LUNA.Compra
    group by year(comp_fecha), ceiling(datepart(month, comp_fecha)/4.0), month(comp_fecha), comp_fecha
go



/* 3.2  Ubicaciones */
INSERT INTO CALLE_DE_LUNA.BI_Dimension_Ubicacion (provincia, localidad)
SELECT DISTINCT provincia_nombre, loc_nombre
FROM CALLE_DE_LUNA.Provincia
	JOIN CALLE_DE_LUNA.Localidad ON loc_provincia = provincia_id
WHERE NOT EXISTS (
    SELECT 1 FROM CALLE_DE_LUNA.BI_Dimension_Ubicacion
    WHERE provincia = provincia_nombre
      AND localidad = loc_nombre
);
GO


/* 3.3 Rangos etarios est�ticos */
INSERT INTO CALLE_DE_LUNA.BI_Dimension_Rango_Etario (rango_descripcion, fecha_inicio, fecha_fin)
VALUES ('<25', DATEADD(YEAR,-25,GETDATE()), GETDATE()),
       ('25-35', DATEADD(YEAR,-35,GETDATE()), DATEADD(YEAR,-25,GETDATE())),
       ('35-50', DATEADD(YEAR,-50,GETDATE()), DATEADD(YEAR,-35,GETDATE())),
       ('>50', '19000101', DATEADD(YEAR,-50,GETDATE()));
GO


/* 3.4  Turnos fijos */
INSERT INTO CALLE_DE_LUNA.BI_Dimension_Turno_Venta(turno_descripcion, hora_inicio, hora_fin) VALUES
('08-14', '08:00', '14:00'),
('14-20', '14:00', '20:00');
GO

/* 3.5 Tipo material */
INSERT INTO CALLE_DE_LUNA.BI_Dimension_Tipo_Material (tipo_descripcion)
VALUES ('Tela'), ('Madera'), ('Relleno');
GO

/* 3.6 Modelos de sillón */
INSERT INTO CALLE_DE_LUNA.BI_Dimension_Modelo ( modelo_codigo, modelo_descripcion, modelo_precio)
	SELECT M.mod_id, M.mod_descripcion, M.mod_precio
	FROM CALLE_DE_LUNA.modelo as M
GO


/* 3.7 Estados de pedido */
INSERT INTO CALLE_DE_LUNA.BI_Dimension_Estado_Pedido(estado_descripcion)
SELECT DISTINCT pedi_estado
FROM CALLE_DE_LUNA.Pedido p
WHERE NOT EXISTS (SELECT 1 FROM CALLE_DE_LUNA.BI_Dimension_Estado_Pedido d WHERE d.estado_descripcion = p.pedi_estado);
GO
INSERT INTO CALLE_DE_LUNA.BI_Dimension_Estado_Pedido VALUES ('PENDIENTE')



/* 3.8 Sucursales */
INSERT INTO CALLE_DE_LUNA.BI_Dimension_Sucursal (nro_sucursal, provincia, localidad)
SELECT DISTINCT sucu_nroSucursal,
       prov.provincia_nombre,
       loc.loc_nombre
FROM CALLE_DE_LUNA.Sucursal s
	JOIN CALLE_DE_LUNA.Direccion dir ON dir.dir_id = s.sucu_direccion
	JOIN CALLE_DE_LUNA.Localidad loc ON loc.loc_id = dir.dir_localidad
	JOIN CALLE_DE_LUNA.Provincia prov ON prov.provincia_id = loc.loc_provincia
WHERE NOT EXISTS (SELECT 1 FROM CALLE_DE_LUNA.BI_Dimension_Sucursal d WHERE d.nro_sucursal = s.sucu_nroSucursal);
GO

/* 3.9 Clientes */
INSERT INTO CALLE_DE_LUNA.BI_Dimension_Cliente (dni,nombre,apellido,fecha_nacimiento)
SELECT DISTINCT clie_dni, clie_nombre, clie_apellido, clie_fechaDeNacimiento
FROM CALLE_DE_LUNA.Cliente c
WHERE NOT EXISTS (SELECT 1 FROM CALLE_DE_LUNA.BI_Dimension_Cliente d WHERE d.dni = c.clie_dni);
GO

---------------------------------------------------------------
-- 4. HECHOS
---------------------------------------------------------------
/*----------------------------------------------------------------
  4.1  COMPRAS
----------------------------------------------------------------*/
INSERT INTO CALLE_DE_LUNA.BI_Hecho_Compras(tiempo,sucursal,tipo_material,ubicacion, subtotal)
SELECT 
    dtiempo.tiempo_id,
    dsuc.sucursal_id,
    dmat.tipo_material_id,
    dubic.ubicacion_id,
    ic.item_sub_total
FROM CALLE_DE_LUNA.Item_Compra ic
	JOIN CALLE_DE_LUNA.Compra c ON c.compra_id = ic.compra_id
	JOIN CALLE_DE_LUNA.BI_Dimension_Sucursal dsuc ON dsuc.nro_sucursal = c.comp_sucursal
	JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo dtiempo ON dtiempo.fecha = CAST(c.comp_fecha AS date)
	JOIN CALLE_DE_LUNA.Tipo_Material tm ON tm.tip_id = ic.item_material
	JOIN CALLE_DE_LUNA.BI_Dimension_Tipo_Material dmat ON dmat.tipo_descripcion = CASE LEFT(tm.tip_descripcion,1) WHEN 'T' THEN 'Tela' WHEN 'M' THEN 'Madera' ELSE 'Relleno' END
	JOIN CALLE_DE_LUNA.Sucursal suc ON suc.sucu_nroSucursal = c.comp_sucursal
	JOIN CALLE_DE_LUNA.Direccion dir ON dir.dir_id = suc.sucu_direccion
	JOIN CALLE_DE_LUNA.Localidad loc ON loc.loc_id = dir.dir_localidad
	JOIN CALLE_DE_LUNA.Provincia prov ON prov.provincia_id = loc.loc_provincia
	JOIN CALLE_DE_LUNA.BI_Dimension_Ubicacion dubic ON dubic.provincia = prov.provincia_nombre AND dubic.localidad = loc.loc_nombre;
GO
/*----------------------------------------------------------------
  4.2  VENTAS
----------------------------------------------------------------*/
delete from CALLE_DE_LUNA.BI_Hecho_Ventas
INSERT INTO CALLE_DE_LUNA.BI_Hecho_Ventas
      (tiempo,sucursal,turno,modelo_sillon,ubicacion,
       cliente,rango_etario,estado_pedido, cantidad, tiempo_fabricacion, subtotal)
SELECT
    dtiempo.tiempo_id,
    dsuc.sucursal_id,
    dturno.turno_id,
    dsillon.modelo_id,
    dubic.ubicacion_id,
	dcli.cliente_id,
    dredad.rango_id,
	destado.estado_id,
    sum(df.detf_cantidad),
   avg( datediff(day, p.pedi_fecha_hora, f.fact_fecha_y_hora)),
    sum(df.detf_subtotal)
FROM CALLE_DE_LUNA.Detalle_Factura df
JOIN CALLE_DE_LUNA.Factura f ON f.fact_id = df.detf_factura
JOIN CALLE_DE_LUNA.Pedido p ON p.pedi_id = df.detf_pedido
JOIN CALLE_DE_LUNA.BI_Dimension_Estado_Pedido destado ON destado.estado_descripcion = p.pedi_estado
JOIN CALLE_DE_LUNA.BI_Dimension_Sucursal dsuc ON dsuc.nro_sucursal = f.fact_sucursal
JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo dtiempo ON dtiempo.fecha = CAST(f.fact_fecha_y_hora AS date)
JOIN CALLE_DE_LUNA.BI_Dimension_Turno_Venta dturno ON CAST(f.fact_fecha_y_hora AS time) BETWEEN dturno.hora_inicio AND dturno.hora_fin
JOIN CALLE_DE_LUNA.Sillon sill ON sill.sil_id = df.detf_sillon
JOIN CALLE_DE_LUNA.BI_Dimension_Modelo dsillon ON dsillon.modelo_codigo = sill.sil_modelo
JOIN CALLE_DE_LUNA.Cliente cli ON cli.clie_id = f.fact_cliente
JOIN CALLE_DE_LUNA.BI_Dimension_Cliente dcli ON dcli.dni = cli.clie_dni
JOIN CALLE_DE_LUNA.BI_Dimension_Rango_Etario dredad ON cli.clie_fechaDeNacimiento BETWEEN dredad.fecha_inicio AND dredad.fecha_fin
JOIN CALLE_DE_LUNA.Direccion dir ON dir.dir_id = dsuc.nro_sucursal
JOIN CALLE_DE_LUNA.Localidad loc ON loc.loc_id = dir.dir_localidad
JOIN CALLE_DE_LUNA.Provincia prov ON prov.provincia_id = loc.loc_provincia
JOIN CALLE_DE_LUNA.BI_Dimension_Ubicacion dubic ON dubic.provincia = prov.provincia_nombre AND dubic.localidad = loc.loc_nombre
group by dtiempo.tiempo_id, dsuc.sucursal_id , dsillon.modelo_id, dredad.rango_id , dcli.cliente_id, dubic.ubicacion_id,  dturno.turno_id,	destado.estado_id
GO
/*----------------------------------------------------------------
  4.3  PEDIDOS
----------------------------------------------------------------*/
INSERT INTO CALLE_DE_LUNA.BI_Hecho_Pedidos (tiempo,sucursal,ubicacion,cliente, rango_etario,estado_pedido)
SELECT
    dtiempo.tiempo_id,
    dsuc.sucursal_id,
    dubic.ubicacion_id,
    dcli.cliente_id,
    dredad.rango_id,
    destado.estado_id
FROM CALLE_DE_LUNA.Pedido p
JOIN CALLE_DE_LUNA.BI_Dimension_Sucursal dsuc ON dsuc.nro_sucursal = p.pedi_sucursal
JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo dtiempo ON dtiempo.fecha = CAST(p.pedi_fecha_hora AS date)
JOIN CALLE_DE_LUNA.Cliente cli ON cli.clie_id = p.pedi_cliente
JOIN CALLE_DE_LUNA.BI_Dimension_Cliente dcli ON dcli.dni = cli.clie_dni
JOIN CALLE_DE_LUNA.BI_Dimension_Rango_Etario dredad ON cli.clie_fechaDeNacimiento BETWEEN dredad.fecha_inicio AND dredad.fecha_fin
JOIN CALLE_DE_LUNA.BI_Dimension_Estado_Pedido destado ON destado.estado_descripcion = p.pedi_estado
JOIN CALLE_DE_LUNA.Direccion dir ON dir.dir_id = dsuc.nro_sucursal
JOIN CALLE_DE_LUNA.Localidad loc ON loc.loc_id = dir.dir_localidad
JOIN CALLE_DE_LUNA.Provincia prov ON prov.provincia_id = loc.loc_provincia
JOIN CALLE_DE_LUNA.BI_Dimension_Ubicacion dubic
     ON dubic.provincia = prov.provincia_nombre
    AND dubic.localidad = loc.loc_nombre
group by dsuc.sucursal_Id, dtiempo.tiempo_id, dcli.cliente_id,dredad.rango_id,destado.estado_id, dubic.ubicacion_id
GO
/*----------------------------------------------------------------
  4.4  ENVIOS
----------------------------------------------------------------*/

INSERT INTO CALLE_DE_LUNA.BI_Hecho_Envios (tiempo_prog,sucursal,ubicacion_cli,cliente,rango_etario,costo_total ,cantidad_total,cantidad_total_cumplido)
SELECT
    dtProg.tiempo_id,
    dsuc.sucursal_id,
    dubic.ubicacion_id,
    dcli.cliente_id,
    dredad.rango_id,
	sum(e.env_precio_total),
	count(*) ,--envios totales 
    sum(CASE WHEN year(e.env_fecha_programada) = year(e.env_fecha_entrega) and month(e.env_fecha_programada) = month(e.env_fecha_entrega) THEN 1 ELSE 0 END)
FROM CALLE_DE_LUNA.Envio e
JOIN CALLE_DE_LUNA.Factura f ON f.fact_id = e.env_factura
JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo dtProg ON dtProg.fecha = CAST(e.env_fecha_programada AS date)
JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo dtReal ON dtReal.fecha = CAST(e.env_fecha_entrega AS date)
JOIN CALLE_DE_LUNA.BI_Dimension_Sucursal dsuc ON dsuc.nro_sucursal = f.fact_sucursal
JOIN CALLE_DE_LUNA.Cliente cli ON cli.clie_id = f.fact_cliente
JOIN CALLE_DE_LUNA.BI_Dimension_Cliente dcli ON dcli.dni = cli.clie_dni
JOIN CALLE_DE_LUNA.BI_Dimension_Rango_Etario dredad ON cli.clie_fechaDeNacimiento BETWEEN dredad.fecha_inicio AND dredad.fecha_fin
JOIN CALLE_DE_LUNA.Direccion dir ON dir.dir_id = cli.clie_direccion
JOIN CALLE_DE_LUNA.Localidad loc ON loc.loc_id = dir.dir_localidad
JOIN CALLE_DE_LUNA.Provincia prov ON prov.provincia_id = loc.loc_provincia
JOIN CALLE_DE_LUNA.BI_Dimension_Ubicacion dubic
     ON dubic.provincia = prov.provincia_nombre
    AND dubic.localidad = loc.loc_nombre

group by  dtProg.tiempo_id, dsuc.sucursal_id, dcli.cliente_id, dredad.rango_id,dubic.ubicacion_id
GO
---------------------------------------------------------------
-- 5. VISTAS DE INDICADORES
---------------------------------------------------------------
/* 5.1 Ganancias */
CREATE VIEW CALLE_DE_LUNA.Ganancias AS
SELECT
  dti.anio, dti.mes,
  dsuc.nro_sucursal,
  SUM(ISNULL(hv.subtotal,0)) AS ingresos,
  SUM(ISNULL(hc.subtotal,0)) AS egresos,
  SUM(ISNULL(hv.subtotal,0)) - SUM(ISNULL(hc.subtotal,0)) AS ganancia
FROM CALLE_DE_LUNA.BI_Dimension_Sucursal dsuc
	JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo dti on 1=1
LEFT JOIN CALLE_DE_LUNA.BI_Hecho_Ventas hv ON hv.sucursal = dsuc.sucursal_id AND hv.tiempo = dti.tiempo_id
LEFT JOIN CALLE_DE_LUNA.BI_Hecho_Compras hc ON hc.sucursal = dsuc.sucursal_id AND hc.tiempo = dti.tiempo_id
GROUP BY dti.anio,dti.mes,dsuc.nro_sucursal;
GO

/* 5.2 Factura promedio mensual */ 
CREATE VIEW CALLE_DE_LUNA.Factura_Promedio_Mensual AS
SELECT anio, cuatrimestre, provincia, AVG(subtotal) AS factura_prom_mensual
FROM CALLE_DE_LUNA.BI_Hecho_Ventas
	JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo ON tiempo = tiempo_id
	JOIN CALLE_DE_LUNA.BI_Dimension_Ubicacion ON ubicacion = ubicacion_id
GROUP BY anio, cuatrimestre, provincia;
GO

/* 5.3 Top 3 modelos por rango etario/localidad/cuatrimestre */
CREATE OR ALTER VIEW CALLE_DE_LUNA.Top_3_Modelos AS
WITH Rank AS (
    SELECT 
        dti.anio, 
        dti.cuatrimestre, 
        dub.localidad, 
        dred.rango_descripcion, 
        dsil.modelo_codigo,
        dsil.modelo_descripcion,
        SUM(hv.cantidad) AS total_unidades,
        ROW_NUMBER() OVER (
            PARTITION BY dti.anio, dti.cuatrimestre, dub.localidad, dred.rango_descripcion
            ORDER BY SUM(hv.cantidad) DESC
        ) AS rn
    FROM CALLE_DE_LUNA.BI_Hecho_Ventas AS hv
    JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo AS dti ON dti.tiempo_id = hv.tiempo
    JOIN CALLE_DE_LUNA.BI_Dimension_Ubicacion AS dub ON dub.ubicacion_id = hv.ubicacion
    JOIN CALLE_DE_LUNA.BI_Dimension_Rango_Etario AS dred ON dred.rango_id = hv.rango_etario
    JOIN CALLE_DE_LUNA.BI_Dimension_Modelo AS dsil ON dsil.modelo_id = hv.modelo_sillon
    GROUP BY 
        dti.anio, dti.cuatrimestre, dub.localidad, dred.rango_descripcion, 
        dsil.modelo_codigo, dsil.modelo_descripcion
)
SELECT anio, cuatrimestre, localidad, rango_descripcion, modelo_codigo, modelo_descripcion, total_unidades
FROM Rank
WHERE rn <= 3;

GO

/* 5.4 Volumen de pedidos por turno */
CREATE VIEW CALLE_DE_LUNA.Volumen_Pedidos AS
SELECT dti.anio, dti.mes, dsuc.nro_sucursal, dturn.turno_descripcion, COUNT(*) AS pedidos
FROM CALLE_DE_LUNA.BI_Hecho_Ventas hv
	JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo dti ON dti.tiempo_id = hv.tiempo
	JOIN CALLE_DE_LUNA.BI_Dimension_Sucursal dsuc ON dsuc.sucursal_id = hv.sucursal
	JOIN CALLE_DE_LUNA.BI_Dimension_Turno_Venta dturn ON dturn.turno_id = hv.turno
GROUP BY dti.anio, dti.mes, dsuc.nro_sucursal, dturn.turno_descripcion;
GO

/* 5.5 Conversi�n de pedidos */
CREATE VIEW CALLE_DE_LUNA.Conversion_Pedidos AS
SELECT dti.anio, dti.cuatrimestre, dsuc.nro_sucursal, dest.estado_descripcion,
  CAST(COUNT(*)*100.0/SUM(COUNT(*)) OVER (PARTITION BY dti.anio,dti.cuatrimestre,dsuc.nro_sucursal) AS DECIMAL(5,2)) AS porcentaje
FROM CALLE_DE_LUNA.BI_Hecho_Pedidos hp
	JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo dti ON dti.tiempo_id = hp.tiempo
	JOIN CALLE_DE_LUNA.BI_Dimension_Sucursal dsuc ON dsuc.sucursal_id = hp.sucursal
	JOIN CALLE_DE_LUNA.BI_Dimension_Estado_Pedido dest ON dest.estado_id = hp.estado_pedido
GROUP BY dti.anio, dti.cuatrimestre, dsuc.nro_sucursal, dest.estado_descripcion;
GO


/* 5.6 Tiempo promedio de fabricaci�n */
CREATE VIEW CALLE_DE_LUNA.Tiempo_Promedio_Fabricacion AS
SELECT dsuc.nro_sucursal, htp.cuatrimestre, htp.anio, avg(hv.tiempo_fabricacion) AS dias_promedio
FROM CALLE_DE_LUNA.BI_Hecho_Ventas hv 
	JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo htp ON htp.tiempo_id = hv.tiempo
	JOIN CALLE_DE_LUNA.BI_Dimension_Sucursal dsuc ON dsuc.sucursal_id = hv.sucursal
GROUP BY dsuc.nro_sucursal, htp.cuatrimestre, htp.anio;
GO

/* 5.7 Promedio compras mes */
CREATE VIEW CALLE_DE_LUNA.Promedio_Compras AS
SELECT anio, mes, AVG(subtotal) AS promedio_compra_mes
FROM CALLE_DE_LUNA.BI_Hecho_Compras
JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo ON tiempo_id = tiempo
GROUP BY anio, mes;
GO

/* 5.8 Compras por tipo material */
CREATE VIEW CALLE_DE_LUNA.Compras_Por_Tipo_Material AS
SELECT anio, cuatrimestre, nro_sucursal, tipo_descripcion, SUM(subtotal) AS total
FROM CALLE_DE_LUNA.BI_Hecho_Compras
	JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo ON tiempo_id = tiempo
	JOIN CALLE_DE_LUNA.BI_Dimension_Sucursal ON sucursal_id = sucursal
	JOIN CALLE_DE_LUNA.BI_Dimension_Tipo_Material ON tipo_material_id = tipo_material
GROUP BY anio, cuatrimestre, nro_sucursal, tipo_descripcion;
GO


/* 5.9 Cumplimiento env�os */
CREATE VIEW CALLE_DE_LUNA.Cumplimiento_Envios AS
SELECT anio, mes, CAST(SUM (cantidad_total_cumplido)as float)/Cast(Sum(cantidad_total) as float ) AS porcentaje_cumplimiento 
FROM CALLE_DE_LUNA.BI_Hecho_Envios 
JOIN CALLE_DE_LUNA.BI_Dimension_Tiempo ON tiempo_id = tiempo_prog
GROUP BY anio, mes;
GO


/* 5.10 Top-3 localidades costo env�o */
CREATE VIEW CALLE_DE_LUNA.Top_Localidades_Costo_Envio AS
SELECT TOP 3 WITH TIES localidad, provincia, AVG(costo_total) AS costo_promedio
FROM CALLE_DE_LUNA.BI_Hecho_Envios JOIN CALLE_DE_LUNA.BI_Dimension_Ubicacion ON ubicacion_id = ubicacion_cli
GROUP BY localidad, provincia
ORDER BY AVG(costo_total) DESC;
GO
