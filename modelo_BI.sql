------- TABLAS PARA DIMENSIONES -----------

create table CALLE_DE_LUNA.BI_Tiempo (
	tiempo_id int identity(1,1),
	tiempo_anio int not null,
	tiempo_cuatri int not null,
	tiempo_mes int not null,
	constraint PK_BI_Tiempo primary key (tiempo_id)
)
go

create table CALLE_DE_LUNA.BI_Ubicacion (
	ubicacion_id int identity(1,1),
	ubicacion_loca nvarchar(255) not null,
	ubicacion_prov nvarchar(255) not null,
	constraint PK_BI_Ubicacion primary key (ubicacion_id)
)
go

create table CALLE_DE_LUNA.BI_Rango_Etario (
	rango_id int identity(1,1),
	rango_desc nvarchar(255) not null,
	rango_fecha_inicio datetime2(6) not null,
	rango_fecha_fin datetime2(6) not null,
	constraint PK_BI_Rango_Etario primary key (rango_id)
)
go

create table CALLE_DE_LUNA.BI_Turno_Ventas (
	turno_id int identity(1,1),
	turno_desc nvarchar(255) not null,
	turno_hora_inicio time(6) not null,
	turno_hora_fin time(6) not null,
	constraint PK_BI_Turno_Ventas primary key (turno_id)
)
go

create table CALLE_DE_LUNA.BI_Tipo_Material (
	tipo_id int identity(1,1),
	tipo_nombre nvarchar(255) not null,
	constraint PK_BI_Tipo_Material primary key (tipo_id)
)
go

create table CALLE_DE_LUNA.BI_Modelo_Sillon (
	sillon_id int identity(1,1),
	sillon_codigo bigint not null,
	sillon_modelo bigint not null,
	sillon_medida int not null,
	constraint PK_BI_Modelo_Sillon primary key (sillon_id)
)
go

create table CALLE_DE_LUNA.BI_Estado_Pedido (
	estado_id int identity(1,1),
	estado_desc nvarchar(255) not null,
	constraint PK_BI_Estado_Pedido primary key (estado_id)
)
go

create table CALLE_DE_LUNA.BI_Sucursal (
	sucu_id int identity(1,1), -- Aunque tener sucu_id y sucu_nro es redundante asi es mas ordenado
	sucu_nro bigint not null,
	constraint PK_BI_Sucursal primary key (sucu_id)
)
go

create table CALLE_DE_LUNA.BI_Cliente (
	cliente_id int identity(1,1),
	cliente_dni bigint not null,
	cliente_nomb nvarchar(255) not null,
	cliente_apell nvarchar(255) not null,
	cliente_fecha_nac datetime2(6) not null,
	constraint PK_BI_Cliente primary key (cliente_id)
)

------- TABLAS DE HECHOS -----------

create table CALLE_DE_LUNA.BI_Hechos_Compras (
	comp_tiempo int foreign key references CALLE_DE_LUNA.BI_Tiempo(tiempo_id),
	comp_ubicacion int foreign key references CALLE_DE_LUNA.BI_Ubicacion(ubicacion_id),
	comp_sucursal int foreign key references CALLE_DE_LUNA.BI_Sucursal(sucu_id),
	comp_tipo_material int foreign key references CALLE_DE_LUNA.BI_Tipo_Material(tipo_id),
	comp_sub_total decimal(18,2) not null,
	--constraint PK_BI_Compras primary key (comp_tiempo, comp_ubicacion, comp_sucursal, comp_tipo_material)
)
go

create table CALLE_DE_LUNA.BI_Hechos_Ventas (
	vent_tiempo int foreign key references CALLE_DE_LUNA.BI_Tiempo(tiempo_id),
	vent_ubicacion int foreign key references CALLE_DE_LUNA.BI_Ubicacion(ubicacion_id),
	vent_sucursal int foreign key references CALLE_DE_LUNA.BI_Sucursal(sucu_id),
	vent_turno_ventas int foreign key references CALLE_DE_LUNA.BI_Turno_Ventas(turno_id),
	vent_modelo_sillon int foreign key references CALLE_DE_LUNA.BI_Modelo_Sillon(sillon_id),
	vent_cliente int foreign key references CALLE_DE_LUNA.BI_Cliente(cliente_id),
	vent_rango_etario int foreign key references CALLE_DE_LUNA.BI_Rango_Etario(rango_id),
	vent_factura bigint not null,
	vent_sub_total decimal(18,2) not null,
	vent_tiempo_fabricacion int not null
	-- constraint PK_BI_Ventas primary key (vent_tiempo, vent_ubicacion, vent_sucursal, vent_turno_ventas, vent_modelo_sillon, vent_cliente, vent_rango_etario)
)
go

create table CALLE_DE_LUNA.BI_Hechos_Pedidos (
	pedi_fecha int foreign key references CALLE_DE_LUNA.BI_Tiempo(tiempo_id),
	pedi_ubicacion int foreign key references CALLE_DE_LUNA.BI_Ubicacion(ubicacion_id),
	pedi_sucursal int foreign key references CALLE_DE_LUNA.BI_Sucursal(sucu_id),
	pedi_turno int foreign key references CALLE_DE_LUNA.BI_Turno_Ventas(turno_id),
	pedi_cliente int foreign key references CALLE_DE_LUNA.BI_Cliente(cliente_id),
	pedi_rango_etario int foreign key references CALLE_DE_LUNA.BI_Rango_Etario(rango_id),
	pedi_estado_pedido int foreign key references CALLE_DE_LUNA.BI_Estado_Pedido(estado_id)
	-- constraint PK_BI_Pedido primary key (pedi_fecha, pedi_ubicacion, pedi_sucursal, pedi_modelo_sillon, pedi_cliente, pedi_rango_etario)
)
go

create table CALLE_DE_LUNA.BI_Hechos_Envios (
	envi_tiempo_programado int foreign key references CALLE_DE_LUNA.BI_Tiempo(tiempo_id),
	--envi_tiempo_entrega int foreign key references CALLE_DE_LUNA.BI_Tiempo(tiempo_id),
	envi_clie_ubicacion int foreign key references CALLE_DE_LUNA.BI_Ubicacion(ubicacion_id),
	envi_sucursal int foreign key references CALLE_DE_LUNA.BI_Sucursal(sucu_id),
	envi_cliente int foreign key references CALLE_DE_LUNA.BI_Cliente(cliente_id),
	envi_rango_etario int foreign key references CALLE_DE_LUNA.BI_Rango_Etario(rango_id),
	envi_precio_total decimal(18,2) not null,
	envi_cumplido int not null
)
go



------- MIGRACION A DIMENSIONES -----------

insert into CALLE_DE_LUNA.BI_Tiempo (tiempo_anio, tiempo_cuatri, tiempo_mes)
	select year(fact_fecha_y_hora), ceiling(datepart(month, fact_fecha_y_hora)/3.0), month(fact_fecha_y_hora) from CALLE_DE_LUNA.Factura
	group by year(fact_fecha_y_hora), ceiling(datepart(month, fact_fecha_y_hora)/3.0), month(fact_fecha_y_hora)
	union
	select year(pedi_fecha_hora), ceiling(datepart(month, pedi_fecha_hora)/3.0), month(pedi_fecha_hora) from CALLE_DE_LUNA.Pedido
	group by year(pedi_fecha_hora), ceiling(datepart(month, pedi_fecha_hora)/3.0), month(pedi_fecha_hora)
	union
	select year(env_fecha_entrega), ceiling(datepart(month, env_fecha_entrega)/3.0), month(env_fecha_entrega) from CALLE_DE_LUNA.Envio
	group by year(env_fecha_entrega), ceiling(datepart(month, env_fecha_entrega)/3.0), month(env_fecha_entrega)
	union
	select year(env_fecha_programada), ceiling(datepart(month, env_fecha_programada)/3.0), month(env_fecha_programada) from CALLE_DE_LUNA.Envio
	group by year(env_fecha_programada), ceiling(datepart(month, env_fecha_programada)/3.0), month(env_fecha_programada)
	union
	select year(comp_fecha), ceiling(datepart(month, comp_fecha)/3.0), month(comp_fecha) from CALLE_DE_LUNA.Compra
	group by year(comp_fecha), ceiling(datepart(month, comp_fecha)/3.0), month(comp_fecha)
go


insert into CALLE_DE_LUNA.BI_Ubicacion (ubicacion_loca, ubicacion_prov)
	select loc_nombre, provincia_nombre from CALLE_DE_LUNA.Localidad
	join CALLE_DE_LUNA.Provincia on provincia_id = loc_provincia
	group by loc_nombre, provincia_nombre
go


insert into CALLE_DE_LUNA.BI_Rango_Etario (rango_desc, rango_fecha_inicio, rango_fecha_fin)
	values ('< 25', dateadd(year, -25, sysdatetime()), sysdatetime())
insert into CALLE_DE_LUNA.BI_Rango_Etario (rango_desc, rango_fecha_inicio, rango_fecha_fin)
	values ('25 - 35', dateadd(year, -35, sysdatetime()), dateadd(year, -25, sysdatetime()))
insert into CALLE_DE_LUNA.BI_Rango_Etario (rango_desc, rango_fecha_inicio, rango_fecha_fin)
	values ('35 - 50', dateadd(year, -50, sysdatetime()), dateadd(year, -35, sysdatetime()))
insert into CALLE_DE_LUNA.BI_Rango_Etario (rango_desc, rango_fecha_inicio, rango_fecha_fin)
	values ('> 50', dateadd(year, -100, sysdatetime()), dateadd(year, -50, sysdatetime()))
go


insert into CALLE_DE_LUNA.BI_Turno_Ventas (turno_desc, turno_hora_inicio, turno_hora_fin)
	values ('08:00 - 14:00', '08:00:00.000000', '14:00:00.000000')
insert into CALLE_DE_LUNA.BI_Turno_Ventas (turno_desc, turno_hora_inicio, turno_hora_fin)
	values ('14:00 - 20:00', '14:00:00.000000', '20:00:00.000000')
go

insert into CALLE_DE_LUNA.BI_Tipo_Material (tipo_nombre)
	values ('Tela')
insert into CALLE_DE_LUNA.BI_Tipo_Material (tipo_nombre)
	values ('Madera')
	insert into CALLE_DE_LUNA.BI_Tipo_Material (tipo_nombre)
	values ('Relleno')
go

insert into CALLE_DE_LUNA.BI_Modelo_Sillon (sillon_codigo, sillon_modelo, sillon_medida)
	select sil_codigo, sil_modelo, sil_medida from CALLE_DE_LUNA.Sillon
	group by sil_codigo, sil_modelo, sil_medida
go

insert into CALLE_DE_LUNA.BI_Estado_Pedido (estado_desc)
	select pedi_estado from CALLE_DE_LUNA.Pedido
	group by pedi_estado
go

insert into CALLE_DE_LUNA.BI_Sucursal (sucu_nro)
	select sucu_nroSucursal from CALLE_DE_LUNA.Sucursal
	group by sucu_nroSucursal
go

insert into CALLE_DE_LUNA.BI_Cliente (cliente_dni, cliente_nomb, cliente_apell, cliente_fecha_nac)
	select clie_dni, clie_nombre, clie_apellido, clie_fechaDeNacimiento from CALLE_DE_LUNA.Cliente
	group by clie_dni, clie_nombre, clie_apellido, clie_fechaDeNacimiento
go


------- FUNCIONES PARA MIGRACION A TABLAS DE HECHOS -----------

create function CALLE_DE_LUNA.obtener_tipo (@desc nvarchar(255))
returns nvarchar(255)
as
begin
	declare @tipo nvarchar(255)
	if (substring(@desc, 1, 1) = 'T')
	begin
		set @tipo = 'Tela'
	end
	if (substring(@desc, 1, 1) = 'M')
	begin
		set @tipo = 'Madera'
	end
	if (substring(@desc, 1, 1) = 'R')
	begin
		set @tipo = 'Relleno'
	end
	return @tipo
end
go


------- MIGRACION A TABLAS DE HECHOS -----------

insert into CALLE_DE_LUNA.BI_Hechos_Compras (comp_tiempo, comp_ubicacion, comp_sucursal, comp_tipo_material, comp_sub_total)
	select Tiempo.tiempo_id,
			Ubicacion.ubicacion_id,
			Sucursal1.sucu_id,
			Tipo1.tipo_id,
			Item.item_sub_total
	from CALLE_DE_LUNA.Item_Compra as Item
	join CALLE_DE_LUNA.Compra as Compra on Compra.compra_id = Item.compra_id
	join CALLE_DE_LUNA.Sucursal as Sucursal on Sucursal.sucu_nroSucursal = Compra.comp_sucursal
	join CALLE_DE_LUNA.Direccion as Direccion on Direccion.dir_id = Sucursal.sucu_direccion
	join CALLE_DE_LUNA.Localidad as Localidad on Localidad.loc_id = Direccion.dir_localidad
	join CALLE_DE_LUNA.Provincia as Provincia on Provincia.provincia_id = Localidad.loc_provincia
	join CALLE_DE_LUNA.Tipo_Material as Tipo on Tipo.tip_id = Item.item_material
	join CALLE_DE_LUNA.BI_Tiempo as Tiempo on Tiempo.tiempo_anio = year(Compra.comp_fecha) and Tiempo.tiempo_mes = month(Compra.comp_fecha)
	join CALLE_DE_LUNA.BI_Sucursal as Sucursal1 on Sucursal1.sucu_nro = Compra.comp_sucursal
	join CALLE_DE_LUNA.BI_Ubicacion as Ubicacion on Ubicacion.ubicacion_loca = Localidad.loc_nombre and Ubicacion.ubicacion_prov = Provincia.provincia_nombre
	join CALLE_DE_LUNA.BI_Tipo_Material as Tipo1 on Tipo1.tipo_nombre = CALLE_DE_LUNA.obtener_tipo(Tipo.tip_descripcion)
go

insert into CALLE_DE_LUNA.BI_Hechos_Ventas(vent_tiempo, vent_ubicacion, vent_sucursal, vent_turno_ventas, vent_modelo_sillon, vent_cliente, vent_rango_etario, vent_factura, vent_sub_total, vent_tiempo_fabricacion)
	select
		Tiempo.tiempo_id,
		Ubicacion.ubicacion_id,
		Sucursal1.sucu_id,
		Turno.turno_id,
		Mod_Sil.sillon_id,
		Cliente1.cliente_id,
		Rango.rango_id,
		Factura.fact_id,
		Detalle.detf_subtotal,
		datediff(day, Pedido.pedi_fecha_hora, Factura.fact_fecha_y_hora)
	from CALLE_DE_LUNA.Detalle_Factura as Detalle
	join CALLE_DE_LUNA.Detalle_Pedido as DetalleP on DetalleP.pedido_id = Detalle.detf_pedido and DetalleP.sillon_id = Detalle.detf_sillon
	join CALLE_DE_LUNA.Pedido as Pedido on Pedido.pedi_id = DetalleP.pedido_id
	join CALLE_DE_LUNA.Factura as Factura on Factura.fact_id = Detalle.detf_factura
	join CALLE_DE_LUNA.Sucursal as Sucursal on Sucursal.sucu_nroSucursal = Factura.fact_sucursal
	join CALLE_DE_LUNA.Direccion as Direccion on Direccion.dir_id = Sucursal.sucu_direccion
	join CALLE_DE_LUNA.Localidad as Localidad on Localidad.loc_id = Direccion.dir_localidad
	join CALLE_DE_LUNA.Provincia as Provincia on Provincia.provincia_id = Localidad.loc_provincia
	join CALLE_DE_LUNA.Sillon as Sillon on Sillon.sil_id = Detalle.detf_sillon
	join CALLE_DE_LUNA.Cliente as Cliente on Cliente.clie_id = Factura.fact_cliente
	join CALLE_DE_LUNA.BI_Tiempo as Tiempo on Tiempo.tiempo_anio = year(Factura.fact_fecha_y_hora) and Tiempo.tiempo_mes = month(Factura.fact_fecha_y_hora)
	join CALLE_DE_LUNA.BI_Sucursal as Sucursal1 on Sucursal1.sucu_nro = Factura.fact_sucursal
	join CALLE_DE_LUNA.BI_Ubicacion as Ubicacion on Ubicacion.ubicacion_loca = Localidad.loc_nombre and Ubicacion.ubicacion_prov = Provincia.provincia_nombre
	join CALLE_DE_LUNA.BI_Turno_Ventas as Turno on Turno.turno_hora_inicio <= cast(Factura.fact_fecha_y_hora as time) and Turno.turno_hora_fin > cast(Factura.fact_fecha_y_hora as time)
	join CALLE_DE_LUNA.BI_Modelo_Sillon as Mod_Sil on Mod_Sil.sillon_codigo = Sillon.sil_codigo and Mod_Sil.sillon_modelo = Sillon.sil_modelo
	join CALLE_DE_LUNA.BI_Cliente as Cliente1 on Cliente1.cliente_dni = Cliente.clie_dni and Cliente1.cliente_nomb = Cliente.clie_nombre
	join CALLE_DE_LUNA.BI_Rango_Etario as Rango on Rango.rango_fecha_inicio <= Cliente.clie_fechaDeNacimiento and Rango.rango_fecha_fin >= Cliente.clie_fechaDeNacimiento
go

insert into CALLE_DE_LUNA.BI_Hechos_Pedidos (pedi_fecha, pedi_ubicacion, pedi_sucursal , pedi_turno, pedi_cliente, pedi_rango_etario, pedi_estado_pedido)
	select
		Tiempo.tiempo_id,
		Ubicacion.ubicacion_id,
		Sucursal1.sucu_id,
		Turno.turno_id,
		Cliente1.cliente_id,
		Rango.rango_id,
		Estado.estado_id
	from CALLE_DE_LUNA.Pedido as Pedido
	join CALLE_DE_LUNA.Sucursal as Sucursal on Sucursal.sucu_nroSucursal = Pedido.pedi_sucursal
	join CALLE_DE_LUNA.Direccion as Direccion on Direccion.dir_id = Sucursal.sucu_direccion
	join CALLE_DE_LUNA.Localidad as Localidad on Localidad.loc_id = Direccion.dir_localidad
	join CALLE_DE_LUNA.Provincia as Provincia on Provincia.provincia_id = Localidad.loc_provincia
	join CALLE_DE_LUNA.Cliente as Cliente on Cliente.clie_id = Pedido.pedi_cliente
	join CALLE_DE_LUNA.BI_Tiempo as Tiempo on Tiempo.tiempo_anio = year(Pedido.pedi_fecha_hora) and Tiempo.tiempo_mes = month(Pedido.pedi_fecha_hora)
	join CALLE_DE_LUNA.BI_Sucursal as Sucursal1 on Sucursal1.sucu_nro = Pedido.pedi_sucursal
	join CALLE_DE_LUNA.BI_Ubicacion as Ubicacion on Ubicacion.ubicacion_loca = Localidad.loc_nombre and Ubicacion.ubicacion_prov = Provincia.provincia_nombre
	join CALLE_DE_LUNA.BI_Turno_Ventas as Turno on Turno.turno_hora_inicio <= cast(Pedido.pedi_fecha_hora as time) and Turno.turno_hora_fin > cast(Pedido.pedi_fecha_hora as time)
	join CALLE_DE_LUNA.BI_Cliente as Cliente1 on Cliente1.cliente_dni = Cliente.clie_dni and Cliente1.cliente_nomb = Cliente.clie_nombre
	join CALLE_DE_LUNA.BI_Rango_Etario as Rango on Rango.rango_fecha_inicio <= Cliente.clie_fechaDeNacimiento and Rango.rango_fecha_fin >= Cliente.clie_fechaDeNacimiento
	join CALLE_DE_LUNA.BI_Estado_Pedido as Estado on Estado.estado_desc = Pedido.pedi_estado
go

insert into CALLE_DE_LUNA.BI_Hechos_Envios (envi_tiempo_programado, envi_clie_ubicacion, envi_sucursal, envi_cliente, envi_rango_etario, envi_precio_total, envi_cumplido)
	select
		Tiempo.tiempo_id,
		Ubicacion.ubicacion_id,
		Sucursal1.sucu_id,
		Cliente1.cliente_id,
		Rango.rango_id,
		Envio.env_precio_total,
		(case when year(Envio.env_fecha_programada) = year(Envio.env_fecha_entrega) and month(Envio.env_fecha_programada) = month(Envio.env_fecha_entrega) then 1 else 0 end)
	from CALLE_DE_LUNA.Envio as Envio
	join CALLE_DE_LUNA.Factura as Factura on Factura.fact_id = Envio.env_factura
	join CALLE_DE_LUNA.Cliente as Cliente on Cliente.clie_id = Factura.fact_cliente
	join CALLE_DE_LUNA.Direccion as Direccion on Direccion.dir_id =Cliente.clie_direccion
	join CALLE_DE_LUNA.Localidad as Localidad on Localidad.loc_id = Direccion.dir_localidad
	join CALLE_DE_LUNA.Provincia as Provincia on Provincia.provincia_id = Localidad.loc_provincia
	join CALLE_DE_LUNA.BI_Tiempo as Tiempo on Tiempo.tiempo_anio = year(Envio.env_fecha_programada) and Tiempo.tiempo_mes = month(Envio.env_fecha_programada)
	join CALLE_DE_LUNA.BI_Sucursal as Sucursal1 on Sucursal1.sucu_nro = Factura.fact_sucursal
	join CALLE_DE_LUNA.BI_Ubicacion as Ubicacion on Ubicacion.ubicacion_loca = Localidad.loc_nombre and Ubicacion.ubicacion_prov = Provincia.provincia_nombre
	join CALLE_DE_LUNA.BI_Cliente as Cliente1 on Cliente1.cliente_dni = Cliente.clie_dni and Cliente1.cliente_nomb = Cliente.clie_nombre
	join CALLE_DE_LUNA.BI_Rango_Etario as Rango on Rango.rango_fecha_inicio <= Cliente.clie_fechaDeNacimiento and Rango.rango_fecha_fin >= Cliente.clie_fechaDeNacimiento
go


------- VISTAS -----------


-- Punto 1: Ganancias
create view CALLE_DE_LUNA.Ganancias
as
	select 
		isnull(sum(Ventas.vent_sub_total),0) - isnull(sum(Compras.comp_sub_total),0) as 'Ganancias'
	from CALLE_DE_LUNA.BI_Tiempo as Tiempo
	cross join CALLE_DE_LUNA.BI_Sucursal as Sucursal
	left join CALLE_DE_LUNA.BI_Hechos_Ventas as Ventas on Ventas.vent_tiempo = Tiempo.tiempo_id and Ventas.vent_sucursal = Sucursal.sucu_id
	left join CALLE_DE_LUNA.BI_Hechos_Compras as Compras on Compras.comp_tiempo = Tiempo.tiempo_id and Compras.comp_sucursal = sucu_id
	group by Tiempo.tiempo_id, Sucursal.sucu_id
	-- order by Tiempo.tiempo_id, Sucursal.sucu_id
go

/*
-- Factura promedio mensual
create view CALLE_DE_LUNA.Factura_promedio_mensual
as
	select provincia_id,
		provincia_nombre as 'Provincia',
		datepart(year, fact_fecha_y_hora) as 'Año',
		ceiling(datepart(month, fact_fecha_y_hora)/3.0) as 'Cuatrimestre',
		(sum(fact_total) / count(*)) as 'Promedio mensual'
	from CALLE_DE_LUNA.Sucursal as Sucursal
	join CALLE_DE_LUNA.Direccion as Direccion on Direccion.dir_id = Sucursal.sucu_direccion
	join CALLE_DE_LUNA.Localidad as Localidad on Localidad.loc_id = Direccion.dir_localidad
	join CALLE_DE_LUNA.Provincia as Provincia on Provincia.provincia_id = Localidad.loc_provincia
	join CALLE_DE_LUNA.Factura as Factura on Factura.fact_sucursal = Sucursal.sucu_nroSucursal
	group by 
		provincia_id,
		datepart(year, fact_fecha_y_hora),
		ceiling(datepart(month, fact_fecha_y_hora)/3.0)
	-- order by
		provincia_id,
		datepart(year, fact_fecha_y_hora),
		ceiling(datepart(monh, fact_fecha_y_hora)/3.0)
go*/


-- Punto 2: Factura promedio mensual 
create view CALLE_DE_LUNA.Factura_promedio_mensual
as
	select
		Sucursal.sucu_nro,
		Ubicacion.ubicacion_prov,
		Tiempo.tiempo_anio,
		Tiempo.tiempo_cuatri,
		sum(Ventas.vent_sub_total)/count(distinct Ventas.vent_factura) as 'Factura promedio mensual'
	from CALLE_DE_LUNA.BI_Hechos_Ventas as Ventas
	join CALLE_DE_LUNA.BI_Sucursal as Sucursal on Sucursal.sucu_id = Ventas.vent_sucursal
	join CALLE_DE_LUNA.BI_Ubicacion as Ubicacion on Ubicacion.ubicacion_id = Ventas.vent_ubicacion
	join CALLE_DE_LUNA.BI_Tiempo as Tiempo on Tiempo.tiempo_id = Ventas.vent_tiempo
	group by Sucursal.sucu_nro, Ubicacion.ubicacion_prov, Tiempo.tiempo_anio, Tiempo.tiempo_cuatri
/*
	--Calculo la cantidades de facturas haciendo un distinct a casi todos los campos ya que suponemos que las facturas son unicas de esa manera
	--chequear si esto es correcto 
	select  s1.sucu_nro,u1.ubicacion_prov,t1.tiempo_cuatri,t1.tiempo_anio,
	sum(v1.vent_sub_total)/nullif((
									select count(*) from (
												select distinct vent_tiempo, vent_sucursal, vent_cliente ,vent_turno_ventas 
												from CALLE_DE_LUNA.BI_Hechos_Ventas v2 join CALLE_DE_LUNA.BI_Tiempo t2 on v2.vent_tiempo = t2.tiempo_id
												join CALLE_DE_LUNA.bi_sucursal s2 on v2.vent_sucursal = s2.sucu_id
												where t2.tiempo_cuatri = t1.tiempo_cuatri and s2.sucu_nro = s1.sucu_nro
												) as facturas
											), 0) / 4 as promedio_mensual
	from CALLE_DE_LUNA.BI_Hechos_Ventas v1
	join CALLE_DE_LUNA.bi_sucursal s1 on v1.vent_sucursal = s1.sucu_id
	join CALLE_DE_LUNA.bi_ubicacion u1 on v1.vent_ubicacion = u1.ubicacion_id
	join CALLE_DE_LUNA.bi_tiempo t1 on v1.vent_tiempo = t1.tiempo_id
	group by s1.sucu_nro,u1.ubicacion_prov,t1.tiempo_cuatri,t1.tiempo_anio
	*/

GO


--Punto 3 
create view CALLE_DE_LUNA.Rendimiento_modelos
as

-- ver como agrupar 3 modelos por cuatrimestre de cada año , ver ej 10 de sql 
	select
			s1.sucu_nro,
			t1.tiempo_cuatri,
			t1.tiempo_anio,
			u1.ubicacion_loca,
			e1.rango_desc,
			m1.sillon_modelo
	from CALLE_DE_LUNA.BI_Hechos_Ventas v1 
	join CALLE_DE_LUNA.BI_Sucursal s1 on v1.vent_sucursal= s1.sucu_id
	join CALLE_DE_LUNA.BI_Ubicacion u1 on v1.vent_ubicacion= u1.ubicacion_id
	join CALLE_DE_LUNA.BI_Tiempo t1 ON v1.vent_tiempo= t1.tiempo_id
	join CALLE_DE_LUNA.BI_Modelo_Sillon m1 on v1.vent_modelo_sillon= m1.sillon_id
	join CALLE_DE_LUNA.BI_Rango_Etario e1 on v1.vent_rango_etario= e1.rango_id
	group by s1.sucu_nro,t1.tiempo_cuatri,t1.tiempo_anio,u1.ubicacion_loca,e1.rango_desc,m1.sillon_modelo
go


-- Punto 4 -- Primer planteo
CREATE VIEW CALLE_DE_LUNA.Volumen_pedidos
AS
	SELECT Tiempo.tiempo_id, Sucursal.sucu_id, Turno.turno_id,	COUNT(*) AS cantidad_pedidos
	FROM CALLE_DE_LUNA.BI_Tiempo AS Tiempo
	CROSS JOIN CALLE_DE_LUNA.BI_Sucursal AS Sucursal
	CROSS JOIN CALLE_DE_LUNA.BI_Turno_Ventas AS Turno
	LEFT JOIN CALLE_DE_LUNA.BI_Hechos_Pedidos AS Pedidos ON Pedidos.pedi_fecha = Tiempo.tiempo_id 
	AND Pedidos.pedi_sucursal = Sucursal.sucu_id 
    AND Pedidos.pedi_turno = Turno.turno_id
GROUP BY Tiempo.tiempo_id, Sucursal.sucu_id, Turno.turno_id
-- order by Tiempo.tiempo_id, Sucursal.sucu_id, Turno.turno_id
GO

-- Punto 5: Conversión de pedidos 
create view CALLE_DE_LUNA.Conversion_de_pedidos
as
	select s1.sucu_nro,  e1.estado_desc ,t1.tiempo_cuatri ,(STR( count(*)*100/ (select  count(*)from CALLE_DE_LUNA.BI_Hechos_Pedidos p2 
				join CALLE_DE_LUNA.BI_Sucursal s2 on p2.pedi_sucursal=sucu_id and s2.sucu_nro =s1.sucu_nro
				join CALLE_DE_LUNA.BI_Tiempo t2 on p2.pedi_fecha= t2.tiempo_id and tiempo_cuatri= t2.tiempo_cuatri),5,1) + '%' ) AS porcentaje
	from CALLE_DE_LUNA.BI_Hechos_Pedidos p1 join CALLE_DE_LUNA.BI_Sucursal s1 on p1.pedi_sucursal=s1.sucu_id
	join CALLE_DE_LUNA.BI_Tiempo t1 on pedi_fecha= t1.tiempo_id join CALLE_DE_LUNA.BI_Estado_Pedido e1 on pedi_estado_pedido= e1.estado_id
	group by  s1.sucu_nro,  e1.estado_desc ,t1.tiempo_cuatri
	
go


-- Punto 6
create view CALLE_DE_LUNA.Tiempo_Promedio_Fabricacion
as
	select Sucursal.sucu_nro, Tiempo.tiempo_anio, Tiempo.tiempo_cuatri, 
		avg(Ventas.vent_tiempo_fabricacion) as 'Tiempo promedio de fabricacion' 
	from CALLE_DE_LUNA.BI_Hechos_Ventas as Ventas
	join CALLE_DE_LUNA.BI_Sucursal as Sucursal on Sucursal.sucu_id = Ventas.vent_sucursal
	join CALLE_DE_LUNA.BI_Tiempo as Tiempo on Tiempo.tiempo_id = Ventas.vent_tiempo
	group by Sucursal.sucu_nro, Tiempo.tiempo_anio, Tiempo.tiempo_cuatri
	-- order by Sucursal.sucu_nro, Tiempo.tiempo_anio, Tiempo.tiempo_cuatri
go


-- Punto 7
create view CALLE_DE_LUNA.Promedio_compras
as
	select Tiempo.tiempo_id, AVG(CAST(Compras.comp_sub_total as Float)) as promedio_compras
	from CALLE_DE_LUNA.BI_Hechos_Compras as Compras
	join CALLE_DE_LUNA.BI_Tiempo as Tiempo on Compras.comp_tiempo = Tiempo.tiempo_id
	group by Tiempo.tiempo_id
	-- order by Tiempo.tiempo_id
go

-- Punto 8
create view CALLE_DE_LUNA.Compras_tipo_material
as
	select Material.tipo_id ,Sucursal.sucu_id, Tiempo.tiempo_cuatri, SUM(Compras.comp_sub_total) as total_gastado
	from CALLE_DE_LUNA.BI_Hechos_Compras as Compras
	join CALLE_DE_LUNA.BI_Tiempo as Tiempo on Compras.comp_tiempo = Tiempo.tiempo_id
	join CALLE_DE_LUNA.BI_Sucursal as Sucursal on Compras.comp_sucursal = Sucursal.sucu_id
	join CALLE_DE_LUNA.BI_Tipo_Material as Material on Compras.comp_tipo_material = Material.tipo_id
	group by Material.tipo_id, Sucursal.sucu_id, Tiempo.tiempo_cuatri
	-- order by Material.tipo_id, Sucursal.sucu_id, Tiempo.tiempo_cuatri
go


-- Punto 9
create view CALLE_DE_LUNA.Porcentaje_cumplimiento_envios
as
	select
		cast(count(*) as float)
		/
		(select cast(count(*) as float) 
		from CALLE_DE_LUNA.BI_Hechos_Envios as Envios1 
		where Envios1.envi_tiempo_programado = Tiempo.tiempo_id and Envios1.envi_cumplido = 1) 
			as 'Porcentaje de cumplimiento de envios'
	from CALLE_DE_LUNA.BI_Tiempo as Tiempo
	join CALLE_DE_LUNA.BI_Hechos_Envios as Envios on Envios.envi_tiempo_programado = Tiempo.tiempo_id
	group by Tiempo.tiempo_id
	-- order by Tiempo.tiempo_id
go

--Punto 10 : Localidades que pagan mayor coste de envio

create view CALLE_DE_LUNA.Localidades_que_pagan_mayor_coste_de_envio
as
	select top 3 ubicacion_loca, ubicacion_prov
	from CALLE_DE_LUNA.BI_Hechos_Envios
	join CALLE_DE_LUNA.BI_Ubicacion on envi_clie_ubicacion = ubicacion_id
	group by ubicacion_loca, ubicacion_prov
	-- order by  avg(envi_precio_total) desc 

	--Ver si es necesario mandar el promedio 
	/*
	select top 3 
		ubicacion_loca, 
		ubicacion_prov,
		avg(envi_precio_total) as promedio_costo_envio
	from CALLE_DE_LUNA.BI_Envios 
	join CALLE_DE_LUNA.BI_Ubicacion on envi_cliente_ubicacion = ubicacion_id
	group by ubicacion_loca, ubicacion_prov
	-- order by promedio_costo_envio desc
	*/go
