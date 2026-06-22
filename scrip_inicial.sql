------------------------------ CREACIÓN DE ESQUEMA -----------------------------

USE [GD1C2025]
GO 
CREATE SCHEMA CALLE_DE_LUNA
GO


------------------------------ CREACIÓN DE TABLAS ------------------------------

/* TABLAS: PROVINCIA, LOCALIDAD, DIRECCION */

CREATE TABLE CALLE_DE_LUNA.Provincia(
    provincia_id int identity(1,1),
    provincia_nombre nvarchar(255) not null,
    CONSTRAINT PK_Provincia PRIMARY KEY (provincia_id)
)

CREATE TABLE CALLE_DE_LUNA.Localidad (
    loc_id int identity(1,1),
    loc_nombre NVARCHAR(255) NOT NULL,
	CONSTRAINT PK_LOCALIDAD PRIMARY KEY (loc_id),
    loc_provincia int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Provincia(provincia_id)
)

CREATE TABLE CALLE_DE_LUNA.Direccion(
    dir_id int identity(1,1) NOT NULL,
    dir_descripcion NVARCHAR(255) NOT NULL,
    CONSTRAINT PK_Direccion PRIMARY KEY (dir_id),
    dir_localidad int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Localidad(loc_id)
)

/* TABLAS: CLIENTE Y PROVEEDOR */

CREATE TABLE CALLE_DE_LUNA.Cliente(
	clie_id int IDENTITY(1,1),
	clie_nombre nvarchar(255) not null,
	clie_apellido nvarchar(255) not null,
	clie_fechaDeNacimiento datetime2(6) not null,
	clie_mail nvarchar(255) not null,
	clie_direccion int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Direccion(dir_id),
	clie_telefono nvarchar(255) not null,
	clie_dni bigint not null,
	CONSTRAINT PK_Cliente PRIMARY KEY (clie_id)
)

CREATE TABLE CALLE_DE_LUNA.Proveedor(
    prov_id int IDENTITY(1,1),
    prov_direccion nvarchar(255) not null,
    prov_mail nvarchar(255) not null,
    prov_telefono nvarchar(255) not null,
    prov_razon_social nvarchar(255) not null,
    prov_cuit nvarchar(255) not null,
    CONSTRAINT PK_Proveedor PRIMARY KEY (prov_id)
)

/* TABLA: SUCURSAL */
CREATE TABLE CALLE_DE_LUNA.Sucursal(
    sucu_nroSucursal bigint NOT NULL,
    sucu_telefono NVARCHAR(255) NOT NULL,
    sucu_mail NVARCHAR (255) NOT NULL,
    CONSTRAINT PK_Sucursal PRIMARY KEY (sucu_nroSucursal),
	sucu_direccion int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Direccion(dir_id),
)


/* TABLAS: SILLON + MEDIDA + MODELO */

CREATE TABLE CALLE_DE_LUNA.Medida (
    med_id int IDENTITY(1,1) NOT NULL,
    med_alto decimal(18,2) NOT NULL,
    med_ancho decimal(18,2) NOT NULL,
    med_profundidad decimal(18,2) NOT NULL,
	med_precio decimal(18,2) NOT NULL,
    CONSTRAINT PK_Medida PRIMARY KEY (med_id)
)

CREATE TABLE CALLE_DE_LUNA.Modelo (
    mod_id bigint NOT NULL,
    mod_nombre nvarchar(255) NOT NULL,
	mod_descripcion nvarchar(255),
    mod_precio decimal(18,2) NOT NULL,
    CONSTRAINT PK_Modelo PRIMARY KEY (mod_id)
)

CREATE TABLE CALLE_DE_LUNA.Sillon (
    sil_id int identity(1,1),
	sil_codigo bigint NOT NULL,
    sil_medida int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Medida(med_id),
    sil_modelo bigint FOREIGN KEY REFERENCES CALLE_DE_LUNA.Modelo(mod_id),
    CONSTRAINT PK_Sillon PRIMARY KEY (sil_id)
)

/* TABLAS: TIPO_MATERIAL + MATERIAL + RELLENO + MADERA + TELA */

CREATE TABLE CALLE_DE_LUNA.Tipo_Material(
    tip_id int identity(1,1),
    tip_nombre NVARCHAR(255) NOT NULL,
    tip_descripcion NVARCHAR(255),
    tip_precio_venta decimal(38,2) NOT NULL,
    CONSTRAINT PK_Tipo_Material PRIMARY KEY (tip_id)
)

CREATE TABLE CALLE_DE_LUNA.Material(
	mat_tipo_id int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Tipo_Material(tip_id),
	mat_sillon_id int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Sillon(sil_id),
    CONSTRAINT PK_Material PRIMARY KEY (mat_tipo_id, mat_sillon_id)
)

CREATE TABLE CALLE_DE_LUNA.Relleno(
    rel_densidad decimal(38,2) NOT NULL,
    rel_material_id int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Tipo_Material(tip_id),
    CONSTRAINT PK_Relleno PRIMARY KEY (rel_material_id)
)

CREATE TABLE CALLE_DE_LUNA.Madera(
    mad_color NVARCHAR(255) NOT NULL,
    mad_dureza NVARCHAR(255) NOT NULL,
    mad_material_id int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Tipo_Material(tip_id),
    CONSTRAINT PK_Madera PRIMARY KEY (mad_material_id)
)

CREATE TABLE CALLE_DE_LUNA.Tela(
    tel_color NVARCHAR(255) NOT NULL,
    tel_texto NVARCHAR(255) NOT NULL,
    tel_material_id int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Tipo_Material(tip_id),
    CONSTRAINT PK_Tela PRIMARY KEY (tel_material_id)
)


/* TABLAS: ENVIO, PEDIDO, DETALLE_PEDIDO Y CANCELACION */

CREATE TABLE CALLE_DE_LUNA.Pedido(
    pedi_id decimal(18,0) NOT NULL,
    pedi_fecha_hora datetime2(6),
    pedi_total decimal(18,2),
    pedi_estado NVARCHAR(255) CHECK (pedi_estado IN ('CANCELADO','ENTREGADO','PENDIENTE')),
    CONSTRAINT PK_Pedido PRIMARY KEY (pedi_id),
    pedi_sucursal bigint FOREIGN KEY REFERENCES CALLE_DE_LUNA.Sucursal(sucu_nroSucursal),
    pedi_cliente int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Cliente(clie_id)
)

CREATE TABLE CALLE_DE_LUNA.Detalle_Pedido(
    detp_cantidad bigint not null,
    detp_ped_precio decimal(18,2) NOT NULL,
    detp_subtotal decimal(18,2) NOT NULL,
	sillon_id int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Sillon(sil_id), 
    pedido_id decimal(18,0) FOREIGN KEY REFERENCES CALLE_DE_LUNA.Pedido(pedi_id),
	CONSTRAINT PK_Detalle_Pedido PRIMARY KEY (sillon_id,pedido_id)
)

CREATE TABLE CALLE_DE_LUNA.Cancelacion (
    canc_id int IDENTITY(1,1),
    canc_motivo NVARCHAR(255),
    canc_fecha datetime2(6),
    CONSTRAINT PK_Cancelacion PRIMARY KEY (canc_id),
    can_pedido_id decimal(18,0) FOREIGN KEY REFERENCES CALLE_DE_LUNA.Pedido(pedi_id)
)



/* TABLAS: FACTURA Y DETALLE FACTURA */

CREATE TABLE CALLE_DE_LUNA.Factura(
    fact_id bigint NOT NULL,
    fact_fecha_y_hora datetime2(6),
    fact_total decimal (38,2),
    CONSTRAINT PK_Factura PRIMARY KEY (fact_id),
    fact_cliente int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Cliente(clie_id),
    fact_sucursal bigint FOREIGN KEY REFERENCES CALLE_DE_LUNA.Sucursal(sucu_nroSucursal)
)

CREATE TABLE CALLE_DE_LUNA.Detalle_Factura(
    detf_id int IDENTITY(1,1),
    detf_cantidad int NOT NULL,
    detf_precio decimal(18,2) NOT NULL,
    detf_subtotal decimal(18,2) NOT NULL,
    CONSTRAINT PK_Detalle_Factura PRIMARY KEY (detf_id),
    detf_factura bigint FOREIGN KEY REFERENCES CALLE_DE_LUNA.Factura(fact_id),
	detf_sillon int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Sillon(sil_id),
	detf_pedido decimal(18,0) FOREIGN KEY REFERENCES CALLE_DE_LUNA.Pedido(pedi_id)
)

CREATE TABLE CALLE_DE_LUNA.Envio (
    env_id int NOT NULL,
    env_fecha_programada datetime2(6),
    env_fecha_entrega datetime2(6),
    env_precio_base decimal(18,2),
    env_precio_subida decimal(18,2),
    env_precio_total decimal(18,2),
    CONSTRAINT PK_Envio PRIMARY KEY (env_id),
    env_factura bigint FOREIGN KEY REFERENCES CALLE_DE_LUNA.Factura(fact_id)
)

/* TABLAS: COMPRA + ITEM_COMPRA*/

CREATE TABLE CALLE_DE_LUNA.Compra(
    compra_id decimal(18,0) NOT NULL, 
    comp_sucursal bigint NOT NULL, 
    comp_fecha datetime2(6),
    comp_total decimal(18,2),
    CONSTRAINT PK_Compra PRIMARY KEY (compra_id)
)

CREATE TABLE CALLE_DE_LUNA.Item_Compra(
    item_precio_compra decimal(18,2) NOT NULL,
    item_cantidad decimal(18,2) NOT NULL,
    item_sub_total decimal(18,2) NOT NULL,
    compra_id decimal(18,0) FOREIGN KEY REFERENCES CALLE_DE_LUNA.Compra(compra_id),
    item_material int FOREIGN KEY REFERENCES CALLE_DE_LUNA.Tipo_Material(tip_id)
)
go


--------------------------- CREACIÓN DE PROCEDIMIENTOS -------------------------

-- Sucursal
create procedure CALLE_DE_LUNA.migrar_Sucursal
as
begin
	insert into CALLE_DE_LUNA.Sucursal (sucu_nroSucursal, sucu_telefono, sucu_mail, sucu_direccion)
	select
		Maestra.Sucursal_NroSucursal,
		Maestra.Sucursal_telefono,
		Maestra.Sucursal_mail,
		Direccion.dir_id 
	from gd_esquema.Maestra as Maestra
    join CALLE_DE_LUNA.Direccion as Direccion on Direccion.dir_descripcion = Maestra.Sucursal_Direccion
    join CALLE_DE_LUNA.Localidad as Localidad on Localidad.loc_id = Direccion.dir_localidad and Localidad.loc_nombre = Maestra.Sucursal_Localidad
    join CALLE_DE_LUNA.Provincia as Provincia on Provincia.provincia_id = Localidad.loc_provincia and Provincia.provincia_nombre = Maestra.Sucursal_Provincia
	where
		Maestra.Sucursal_NroSucursal is NOT NULL
		and Maestra.Sucursal_Direccion is NOT NULL
		and Maestra.Sucursal_telefono is NOT NULL
		and Maestra.Sucursal_mail is NOT NULL
	group by Maestra.Sucursal_NroSucursal,
		Maestra.Sucursal_telefono,
		Maestra.Sucursal_mail,
		Direccion.dir_id
end
go

--Modelo
CREATE PROCEDURE CALLE_DE_LUNA.migrar_modelos
AS
BEGIN
    INSERT INTO CALLE_DE_LUNA.Modelo (mod_id, mod_nombre, mod_descripcion, mod_precio)
    SELECT DISTINCT 
        Sillon_Modelo_Codigo, 
        Sillon_Modelo, 
        Sillon_Modelo_Descripcion, 
        Sillon_Modelo_Precio
    FROM gd_esquema.Maestra
    WHERE Sillon_Modelo_Codigo IS NOT NULL
        AND NOT EXISTS (
            SELECT 1 
            FROM CALLE_DE_LUNA.Modelo 
            WHERE mod_id = Sillon_Modelo_Codigo
        );
END
GO

-- Medida
CREATE PROCEDURE CALLE_DE_LUNA.migrar_medidas
AS
BEGIN
    -- Insertar directamente las medidas únicas en la tabla Medida
    INSERT INTO CALLE_DE_LUNA.Medida (med_alto, med_ancho, med_profundidad, med_precio)
    SELECT DISTINCT 
        Sillon_Medida_Alto, 
        Sillon_Medida_Ancho, 
        Sillon_Medida_Profundidad, 
        Sillon_Medida_Precio
    FROM gd_esquema.Maestra
    WHERE Sillon_Codigo IS NOT NULL;
END
GO

-- SILLON

CREATE PROCEDURE CALLE_DE_LUNA.migrar_sillones
AS
BEGIN
    INSERT INTO CALLE_DE_LUNA.Sillon (sil_codigo, sil_medida, sil_modelo)
    SELECT distinct
        m.Sillon_Codigo,
        me.med_id,
        m.Sillon_Modelo_Codigo
    FROM gd_esquema.Maestra m
        JOIN CALLE_DE_LUNA.Medida me ON 
            me.med_alto = m.Sillon_Medida_Alto AND
            me.med_ancho = m.Sillon_Medida_Ancho AND
            me.med_profundidad = m.Sillon_Medida_Profundidad AND
            me.med_precio = m.Sillon_Medida_Precio
    WHERE m.Sillon_Codigo IS NOT NULL
END
GO

-- MATERIAL

CREATE PROCEDURE CALLE_DE_LUNA.migrar_material
AS
BEGIN
    INSERT INTO CALLE_DE_LUNA.Material (mat_sillon_id, mat_tipo_id)
    SELECT distinct sil_id, tm.tip_id
    FROM gd_esquema.Maestra m
        JOIN CALLE_DE_LUNA.Tipo_Material tm 
            ON m.Material_Nombre = tm.tip_nombre 
            AND m.Material_Descripcion = tm.tip_descripcion
            AND m.Material_Precio = tm.tip_precio_venta
		join CALLE_DE_LUNA.Sillon
			on sil_codigo = m.Sillon_Codigo
			and sil_modelo = m.Sillon_Modelo_Codigo
    WHERE m.Sillon_Codigo IS NOT NULL
        AND m.Material_Tipo IS NOT NULL
        AND NOT EXISTS (
            SELECT 1 
            FROM CALLE_DE_LUNA.Material
			join CALLE_DE_LUNA.Sillon a on a.sil_codigo = m.Sillon_Codigo and a.sil_modelo = m.Sillon_Modelo_Codigo
            WHERE mat_sillon_id = a.sil_codigo
            AND mat_tipo_id = tm.tip_id
        );
END
GO

--PROVINCIA

create procedure CALLE_DE_LUNA.migrar_provincia
as
begin
		insert into CALLE_DE_LUNA.Provincia (provincia_nombre)
		select Maestra.Cliente_Provincia from gd_esquema.Maestra 
		where Maestra.Cliente_Provincia is not null
		group by Maestra.Cliente_Provincia

end
go


--LOCALIDAD
create procedure CALLE_DE_LUNA.migrar_localidad
as
begin
		insert into CALLE_DE_LUNA.Localidad (loc_nombre, loc_provincia)
		select Maestra.Cliente_localidad, Provincia.provincia_id
		from gd_esquema.Maestra as Maestra join CALLE_DE_LUNA.Provincia as Provincia on Provincia.provincia_nombre = Maestra.Cliente_provincia
		group by Maestra.Cliente_localidad, Provincia.provincia_id
		union
		select Maestra.Sucursal_Localidad, Provincia.provincia_id
		from gd_esquema.Maestra as Maestra
		join CALLE_DE_LUNA.Provincia as Provincia on Provincia.provincia_nombre = Maestra.Sucursal_Provincia
		where
			Maestra.Sucursal_Localidad is NOT NULL
			and Maestra.Sucursal_Provincia is NOT NULL
		group by Maestra.Sucursal_Localidad, Provincia.provincia_id
		union
		select Maestra.Proveedor_Localidad, Provincia.provincia_id
		from gd_esquema.Maestra as Maestra
		join CALLE_DE_LUNA.Provincia as Provincia on Provincia.provincia_nombre = Maestra.Proveedor_Provincia
		where
			Maestra.Proveedor_Localidad is NOT NULL
			and Maestra.Proveedor_Provincia is NOT NULL
		group by Maestra.Proveedor_Localidad, Provincia.provincia_id
end
go

-- DIRECCION
create procedure CALLE_DE_LUNA.migrar_Direccion 
as
begin
		insert into CALLE_DE_LUNA.Direccion(dir_descripcion,dir_localidad)
		select Maestra.Cliente_Direccion ,CALLE_DE_LUNA.Localidad.loc_id from gd_esquema.Maestra
		join CALLE_DE_LUNA.Localidad on Maestra.Cliente_Localidad=CALLE_DE_LUNA.Localidad.loc_nombre
		join CALLE_DE_LUNA.Provincia on Maestra.Cliente_Provincia = CALLE_DE_LUNA.Provincia.provincia_nombre
		where Maestra.Cliente_Direccion is not null 
		and Maestra.Cliente_Provincia is not null  and Maestra.Cliente_Localidad is not null
		group by Maestra.Cliente_Direccion ,CALLE_DE_LUNA.Localidad.loc_id
		union
        select Maestra.Sucursal_Direccion ,CALLE_DE_LUNA.Localidad.loc_id from gd_esquema.Maestra
        join CALLE_DE_LUNA.Localidad on Maestra.Sucursal_Localidad = CALLE_DE_LUNA.Localidad.loc_nombre
        join CALLE_DE_LUNA.Provincia as Provincia on Maestra.Sucursal_Provincia = Provincia.provincia_nombre
        where Maestra.Sucursal_Direccion is not null and Maestra.Sucursal_Provincia is not null  and Maestra.Sucursal_Localidad is not null
        group by Maestra.Sucursal_Direccion ,CALLE_DE_LUNA.Localidad.loc_id
		union
		select Maestra.Proveedor_Direccion ,CALLE_DE_LUNA.Localidad.loc_id from gd_esquema.Maestra
        join CALLE_DE_LUNA.Localidad on Maestra.Proveedor_Localidad = CALLE_DE_LUNA.Localidad.loc_nombre
        join CALLE_DE_LUNA.Provincia as Provincia on Maestra.Proveedor_Provincia = Provincia.provincia_nombre
        where Maestra.Proveedor_Direccion is not null and Maestra.Proveedor_Provincia is not null  and Maestra.Proveedor_Localidad is not null
        group by Maestra.Proveedor_Direccion ,CALLE_DE_LUNA.Localidad.loc_id
end
go

--Cliente

create procedure CALLE_DE_LUNA.migrar_Cliente
as 
begin
	insert into CALLE_DE_LUNA.Cliente (clie_nombre, clie_apellido, clie_fechaDeNacimiento, clie_mail, clie_direccion, clie_telefono, clie_dni)
	select
		Maestra.Cliente_Nombre,
		Maestra.Cliente_Apellido,
		Maestra.Cliente_FechaNacimiento,
		Maestra.Cliente_Mail,
		Direccion.dir_id,
		Maestra.Cliente_Telefono,
		Maestra.Cliente_Dni
	from gd_esquema.Maestra as Maestra
	join CALLE_DE_LUNA.Direccion as Direccion on Direccion.dir_descripcion = Maestra.Cliente_Direccion
	join CALLE_DE_LUNA.Localidad as Localidad on Localidad.loc_id = Direccion.dir_localidad and Localidad.loc_nombre = Maestra.Cliente_Localidad
	join CALLE_DE_LUNA.Provincia as Provincia on Provincia.provincia_id = Localidad.loc_provincia and Provincia.provincia_nombre = Maestra.Cliente_Provincia
	group by 
		Maestra.Cliente_Nombre,
		Maestra.Cliente_Apellido,
		Maestra.Cliente_FechaNacimiento,
		Maestra.Cliente_Mail,
		Direccion.dir_id,
		Maestra.Cliente_Telefono,
		Maestra.Cliente_Dni
end
go


-- Factura
create procedure CALLE_DE_LUNA.migrar_Factura
as
begin
	insert into CALLE_DE_LUNA.Factura (fact_id, fact_fecha_y_hora, fact_total, fact_cliente, fact_sucursal)
	select
		Maestra.Factura_Numero,
		Maestra.Factura_Fecha,
		Maestra.Factura_Total,
		Cliente.clie_id,
		Maestra.Sucursal_NroSucursal
	from gd_esquema.Maestra as Maestra
	join CALLE_DE_LUNA.Cliente as Cliente on Cliente.clie_dni = Maestra.Cliente_Dni and Cliente.clie_nombre = Maestra.Cliente_Nombre
	where 
		Maestra.Factura_Numero is NOT NULL
		and Maestra.Factura_Fecha is NOT NULL
		and Maestra.Factura_Total is NOT NULL
		and Maestra.Cliente_Dni is NOT NULL
		and Maestra.Sucursal_NroSucursal is NOT NULL
	group by
		Maestra.Factura_Numero,
		Maestra.Factura_Fecha,
		Maestra.Factura_Total,
		Cliente.clie_id,
		Maestra.Sucursal_NroSucursal
end
go

-- Detalle_Factura
create procedure CALLE_DE_LUNA.migrar_Detalle_Factura
as
begin
	insert into CALLE_DE_LUNA.Detalle_Factura (detf_cantidad, detf_precio, detf_subtotal, detf_factura, detf_sillon, detf_pedido)
	select
		Maestra.Detalle_Factura_Cantidad,
		Maestra.Detalle_Factura_Precio,
		Maestra.Detalle_Factura_SubTotal,
		Maestra.Factura_Numero,
		Sillon.sil_id,
		Maestra.Pedido_Numero
	from gd_esquema.Maestra as Maestra
	join CALLE_DE_LUNA.Detalle_Pedido as DP
		on DP.pedido_id = Maestra.Pedido_Numero
		and DP.detp_cantidad = Maestra.Detalle_Pedido_Cantidad
		and DP.detp_ped_precio = Maestra.Detalle_Pedido_Precio
	join CALLE_DE_LUNA.Sillon as Sillon
		on Sillon.sil_id = DP.sillon_id
	where
		Maestra.Detalle_Factura_Cantidad is NOT NULL
		and Maestra.Detalle_Factura_Precio is NOT NULL
		and Maestra.Detalle_Factura_SubTotal is NOT NULL
		and Maestra.Factura_Numero is NOT NULL
		and Maestra.Pedido_Numero is NOT NULL
	group by
		Maestra.Detalle_Factura_Cantidad,
		Maestra.Detalle_Factura_Precio,
		Maestra.Detalle_Factura_SubTotal,
		Maestra.Factura_Numero,
		Sillon.sil_id,
		Maestra.Pedido_Numero
end
go


-- Pedido
create procedure CALLE_DE_LUNA.migrar_Pedido
as
begin
	insert into CALLE_DE_LUNA.Pedido (pedi_id, pedi_fecha_hora, pedi_total, pedi_estado, pedi_sucursal, pedi_cliente)
	select
		Maestra.Pedido_Numero,
		Maestra.Pedido_Fecha,
		Maestra.Pedido_Total,
		Maestra.Pedido_Estado,
		Maestra.Sucursal_NroSucursal,
		Cliente.clie_id
	from gd_esquema.Maestra as Maestra
	join CALLE_DE_LUNA.Cliente as Cliente on Cliente.clie_dni = Maestra.Cliente_Dni and Cliente.clie_nombre = Maestra.Cliente_Nombre
	where
		Maestra.Pedido_Numero is NOT NULL
		and Maestra.Pedido_Fecha is NOT NULL
		and Maestra.Pedido_Total is NOT NULL
		and Maestra.Pedido_Estado is NOT NULL
		and Maestra.Sucursal_NroSucursal is NOT NULL
		and Maestra.Cliente_Dni is NOT NULL
	group by
		Maestra.Pedido_Numero,
		Maestra.Pedido_Fecha,
		Maestra.Pedido_Total,
		Maestra.Pedido_Estado,
		Maestra.Sucursal_NroSucursal,
		Cliente.clie_id
end
go

-- Detalle_Pedido
create procedure CALLE_DE_LUNA.migrar_Detalle_Pedido
as
begin
	insert into CALLE_DE_LUNA.Detalle_Pedido (detp_cantidad, detp_ped_precio, detp_subtotal, sillon_id, pedido_id)
	select
		Maestra.Detalle_Pedido_Cantidad,
		Maestra.Detalle_Pedido_Precio,
		Maestra.Detalle_Pedido_SubTotal,
		Sillon.sil_id,
		Maestra.Pedido_Numero
	from gd_esquema.Maestra as Maestra
	join CALLE_DE_LUNA.Sillon as Sillon on Sillon.sil_codigo = Maestra.Sillon_Codigo and Sillon.sil_modelo = Maestra.Sillon_Modelo_Codigo
	where
		Maestra.Detalle_Pedido_Cantidad is NOT NULL
		and Maestra.Detalle_Pedido_Precio is NOT NULL
		and Maestra.Detalle_Pedido_SubTotal is NOT NULL
		and Maestra.Sillon_Codigo is NOT NULL
		and Maestra.Pedido_Numero is NOT NULL
	group by
		Maestra.Detalle_Pedido_Cantidad,
		Maestra.Detalle_Pedido_Precio,
		Maestra.Detalle_Pedido_SubTotal,
		Maestra.Sillon_Codigo,
		Sillon.sil_id,
		Maestra.Pedido_Numero
end
go

-- Cancelacion
create procedure CALLE_DE_LUNA.migrar_Cancelacion
as
begin	
	insert into CALLE_DE_LUNA.Cancelacion (canc_motivo, canc_fecha, can_pedido_id)
	select
		Maestra.Pedido_Cancelacion_Motivo,
		Maestra.Pedido_Cancelacion_Fecha,
		Maestra.Pedido_Numero
	from gd_esquema.Maestra as Maestra
	where
		Maestra.Pedido_Cancelacion_Motivo is NOT NULL
		and Maestra.Pedido_Cancelacion_Fecha is NOT NULL
		and Maestra.Pedido_Numero is NOT NULL
	group by
		Maestra.Pedido_Cancelacion_Motivo,
		Maestra.Pedido_Cancelacion_Fecha,
		Maestra.Pedido_Numero
end
go


-- Envio
create Procedure CALLE_DE_LUNA.migrar_Envio
as
begin
	insert into CALLE_DE_LUNA.Envio (env_id, env_fecha_programada, env_fecha_entrega, env_precio_base, env_precio_subida, env_precio_total, env_factura)
	select
		Maestra.Envio_Numero,
		Maestra.Envio_Fecha_Programada,
		Maestra.Envio_Fecha,
		Maestra.Envio_ImporteTraslado,
		Maestra.Envio_importeSubida,
		Maestra.Envio_Total,
		Maestra.Factura_Numero
	from gd_esquema.Maestra as Maestra
	where
		Maestra.Envio_Numero is NOT NULL
		and Maestra.Envio_Fecha_Programada is NOT NULL
		and Maestra.Envio_Fecha is NOT NULL
		and Maestra.Envio_ImporteTraslado is NOT NULL
		and Maestra.Envio_importeSubida is NOT NULL
		and Maestra.Envio_Total is NOT NULL
		and Maestra.Factura_Numero is NOT NULL
	group by
		Maestra.Envio_Numero,
		Maestra.Envio_Fecha_Programada,
		Maestra.Envio_Fecha,
		Maestra.Envio_ImporteTraslado,
		Maestra.Envio_importeSubida,
		Maestra.Envio_Total,
		Maestra.Factura_Numero
end
go

/*  PROVEEDOR + COMPRA + ITEM_COMPRA */

-- Proveedor

create Procedure CALLE_DE_LUNA.migrar_Proveedor
as
begin
	insert into CALLE_DE_LUNA.Proveedor(prov_direccion,prov_mail,prov_telefono,prov_razon_social,prov_cuit)
	select distinct
		Direccion.dir_id,
		Maestra.Proveedor_Mail,
		Maestra.Proveedor_Telefono,
		Maestra.Proveedor_RazonSocial,
		Maestra.Proveedor_Cuit
	from gd_esquema.Maestra as Maestra
		JOIN CALLE_DE_LUNA.Direccion as Direccion on Direccion.dir_descripcion = Maestra.Proveedor_Direccion
		JOIN CALLE_DE_LUNA.Localidad as Localidad on Localidad.loc_id = Direccion.dir_localidad and Localidad.loc_nombre = Maestra.Proveedor_Localidad
		JOIN CALLE_DE_LUNA.Provincia as Provincia on Provincia.provincia_id = Localidad.loc_provincia and Provincia.provincia_nombre = Maestra.Proveedor_Provincia
	group by
		Direccion.dir_id,
		Maestra.Proveedor_Mail,
		Maestra.Proveedor_Telefono,
		Maestra.Proveedor_RazonSocial,
		Maestra.Proveedor_Cuit
end 
go


-- Compra
create Procedure CALLE_DE_LUNA.migrar_Compra
as
begin
	insert into CALLE_DE_LUNA.Compra(compra_id,comp_sucursal,comp_fecha,comp_total)
	select 
		Maestra.Compra_Numero,
		Sucursal.sucu_nroSucursal,
		Maestra.Compra_Fecha,
		Maestra.Compra_Total
	from gd_esquema.Maestra
		JOIN CALLE_DE_LUNA.Sucursal as Sucursal on Sucursal.sucu_nroSucursal = Maestra.Sucursal_NroSucursal
	where 
		Maestra.Sucursal_NroSucursal is not null 
		and Maestra.Compra_Fecha is not null
	group by
		Maestra.Compra_Numero,
		Sucursal.sucu_nroSucursal,
		Maestra.Compra_Fecha,
		Maestra.Compra_Total
end 
go



-- Item compra
create Procedure CALLE_DE_LUNA.migrar_Item_Compra
as 
begin
    insert into CALLE_DE_LUNA.Item_Compra(compra_id,item_material,item_precio_compra,item_cantidad,item_sub_total)
    select 
        Maestra.Compra_Numero,
        Tipo_Material.tip_id,
        Maestra.Detalle_Compra_Precio,
        Maestra.Detalle_Compra_Cantidad,
        Maestra.Detalle_Compra_SubTotal
        from gd_esquema.Maestra as Maestra
        JOIN CALLE_DE_LUNA.Compra as Compra on Compra.compra_id = Maestra.Compra_Numero
        JOIN CALLE_DE_LUNA.Tipo_Material as Tipo_Material on Tipo_Material.tip_descripcion = Maestra.Material_Descripcion
        group by 
        Maestra.Compra_Numero,
        Tipo_Material.tip_id,
        Maestra.Detalle_Compra_Precio,
        Maestra.Detalle_Compra_Cantidad,
        Maestra.Detalle_Compra_SubTotal
end
go




/* TIPO_MATERIAL , TELA, MADERA Y RELLENO */
--TELA
create procedure CALLE_DE_LUNA.migrar_Tela 
as 
begin
		declare @tipo_material_id int,
				@mat_nombre nvarchar(255),
				@mat_descripcion nvarchar(255),
				@mat_precio decimal(38,2),
				@tela_color nvarchar(255),
				@tela_textura nvarchar(255)

		declare cursor_tela CURSOR FOR
		Select  distinct
				Maestra.Material_Nombre,
				Maestra.Material_Descripcion, 
				Maestra.Material_Precio,
				Maestra.Tela_Color,
				Maestra.Tela_Textura
		from gd_esquema.Maestra
		where 
				Maestra.Material_Nombre is not null and
				Maestra.Material_Tipo is not null and
				Maestra.Material_Descripcion is not null and
				Maestra.Material_Precio is not null and
				Maestra.Tela_Color is not null and 
				Maestra.Tela_Textura is not null 
	
				

		open cursor_tela
		FETCH NEXT 
		FROM cursor_tela 
		into 
		@mat_nombre,
		@mat_descripcion,
		@mat_precio,
		@tela_color ,
		@tela_textura


		WHILE @@FETCH_STATUS = 0 
		BEGIN
		--Insertamos Tipo_Material 

		
		INSERT INTO CALLE_DE_LUNA.Tipo_Material (tip_nombre,tip_descripcion,tip_precio_venta)
		values(@mat_nombre,@mat_descripcion,@mat_precio)
		set @tipo_material_id = SCOPE_IDENTITY();


		-- Insertar Tela 
		INSERT INTO CALLE_DE_LUNA.TELA(tel_material_id,tel_color, tel_texto)
		values(@tipo_material_id,@tela_color,@tela_textura)

		FETCH NEXT 
		from cursor_tela
		INTO 
		@mat_nombre,
		@mat_descripcion,
		@mat_precio,
		@tela_color ,
		@tela_textura

		END
close cursor_tela
deallocate cursor_tela

end 
go

--MADERA

create procedure CALLE_DE_LUNA.migrar_Madera 
as 
begin 
	declare @tipo_material_id int ,
			@mat_nombre nvarchar(255),
			@mat_descripcion nvarchar(255),
			@mat_precio decimal(38,2),
			@madera_color nvarchar(255),
			@madera_dureza nvarchar(255)

	declare cursor_madera CURSOR For
	select  distinct 
		Maestra.Material_Nombre,
		Maestra.Material_Descripcion, 
		Maestra.Material_Precio,
		Maestra.Madera_Color,
		Maestra.Madera_Dureza

	from gd_esquema.Maestra 
	where
		Material_Tipo is not null and
		Material_Descripcion is not null and
		Material_Precio is not null and
		Madera_Color is not null and
		Madera_Dureza is not null and
		Material_Nombre is not null

	open cursor_madera 
	fetch next from cursor_madera 
	into 
		@mat_nombre,
		@mat_descripcion,
		@mat_precio,
		@madera_color,
		@madera_dureza

	WHILE @@FETCH_STATUS = 0 
		BEGIN
		--Insertamos Tipo_Material 

		INSERT INTO CALLE_DE_LUNA.Tipo_Material (tip_nombre,tip_descripcion,tip_precio_venta)
		values(@mat_nombre,@mat_descripcion,@mat_precio)
		set @tipo_material_id = SCOPE_IDENTITY();

		--Insertar Madera 
		INSERT INTO CALLE_DE_LUNA.Madera (mad_material_id,mad_color,mad_dureza)
		values(@tipo_material_id,@madera_color,@madera_dureza)

		fetch next from cursor_Madera
		into 
		@mat_nombre,
		@mat_descripcion,
		@mat_precio,
		@madera_color,
		@madera_dureza

		END 

	close cursor_Madera 
	deallocate cursor_Madera
end


go

--RELLENO

create procedure CALLE_DE_LUNA.migrar_Relleno 
as 
begin 
	declare @tipo_material_id int ,
		@mat_nombre nvarchar(255),
		@mat_descripcion nvarchar(255),
		@mat_precio decimal(38,2),
		@relleno_densidad decimal(38,2)

	declare cursor_relleno CURSOR For
	select  distinct 
			Material_Nombre,
			Material_Descripcion, 
			Material_Precio,
			Relleno_Densidad

	from gd_esquema.Maestra 
	where	Material_Tipo is not null and
			Material_Descripcion is not null and
			Material_Nombre is not null and
			Material_Precio is not null and
			Relleno_Densidad is not null

	open cursor_relleno
	fetch next from cursor_relleno
	into 
		@mat_nombre,
		@mat_descripcion,
		@mat_precio,
		@relleno_densidad

	WHILE @@FETCH_STATUS = 0 
		BEGIN
		--Insertamos Tipo_Material 

		INSERT INTO CALLE_DE_LUNA.Tipo_Material (tip_nombre,tip_descripcion,tip_precio_venta)
		values(@mat_nombre,@mat_descripcion,@mat_precio)
		set @tipo_material_id = SCOPE_IDENTITY();

		--Insertar Relleno
		INSERT INTO CALLE_DE_LUNA.Relleno (rel_material_id,rel_densidad)
		values(@tipo_material_id,@relleno_densidad)

		fetch next from cursor_relleno
		into 
		@mat_nombre,
		@mat_descripcion,
		@mat_precio,
		@relleno_densidad

		END 

	close cursor_relleno 
	deallocate cursor_relleno
end
GO

------------------------------------ MIGRACIÓN ---------------------------------

exec CALLE_DE_LUNA.migrar_provincia;
exec CALLE_DE_LUNA.migrar_localidad;
exec CALLE_DE_LUNA.migrar_Direccion;
exec CALLE_DE_LUNA.migrar_Cliente;
exec CALLE_DE_LUNA.migrar_Proveedor;
exec CALLE_DE_LUNA.migrar_Sucursal;
exec CALLE_DE_LUNA.migrar_medidas;
exec CALLE_DE_LUNA.migrar_modelos;
exec CALLE_DE_LUNA.migrar_sillones;
exec CALLE_DE_LUNA.migrar_Tela;
exec CALLE_DE_LUNA.migrar_Madera;
exec CALLE_DE_LUNA.migrar_Relleno;
exec CALLE_DE_LUNA.migrar_material;
exec CALLE_DE_LUNA.migrar_Pedido;
exec CALLE_DE_LUNA.migrar_Detalle_Pedido;
exec CALLE_DE_LUNA.migrar_Cancelacion;
exec CALLE_DE_LUNA.migrar_Factura;
exec CALLE_DE_LUNA.migrar_Envio;
exec CALLE_DE_LUNA.migrar_Detalle_Factura;
exec CALLE_DE_LUNA.migrar_Compra;
exec CALLE_DE_LUNA.migrar_Item_Compra;

--------------------------------- SELECTS ---------------------------------------
/*select * from CALLE_DE_LUNA.Provincia
select * from CALLE_DE_LUNA.Localidad
select * from CALLE_DE_LUNA.Direccion
select * from CALLE_DE_LUNA.Sucursal 
select * from CALLE_DE_LUNA.Cliente
select * from CALLE_DE_LUNA.Proveedor

select * from CALLE_DE_LUNA.Medida
select * from CALLE_DE_LUNA.Modelo
select * from CALLE_DE_LUNA.Sillon
select * from CALLE_DE_LUNA.Tela
select * from CALLE_DE_LUNA.Madera
select * from CALLE_DE_LUNA.Relleno
select * from CALLE_DE_LUNA.Material
select * from CALLE_DE_LUNA.Tipo_Material

select * from CALLE_DE_LUNA.Compra
select * from CALLE_DE_LUNA.Item_Compra

select * from CALLE_DE_LUNA.Pedido
select * from CALLE_DE_LUNA.Detalle_Pedido
select * from CALLE_DE_LUNA.Cancelacion
select * from CALLE_DE_LUNA.Factura
select * from CALLE_DE_LUNA.Envio 
select * from CALLE_DE_LUNA.Detalle_Factura


