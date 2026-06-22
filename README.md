# BD-CALLE_DE_LUNA
# Base de Datos - Trabajo Práctico

Repositorio que contiene los scripts SQL desarrollados para el Trabajo Práctico de la materia **Gestión de Datos** (UTN FRBA).

## Descripción

El proyecto consiste en el diseño e implementación de una base de datos para una plataforma inmobiliaria que permite administrar:

- Publicación de propiedades.
- Gestión de usuarios (clientes, agentes y propietarios).
- Reservas de visitas.
- Compras y alquileres.
- Pagos.
- Comisiones.
- Reseñas.
- Reportes para análisis del negocio.

El objetivo principal fue modelar la base de datos relacional e implementar la lógica necesaria mediante SQL.

## Contenido del repositorio

Los archivos incluidos corresponden únicamente a scripts SQL:

- Creación de tablas.
- Definición de claves primarias y foráneas.
- Constraints.
- Índices.
- Stored Procedures.
- Functions.
- Triggers.
- Vistas.
- Migración de datos.
- Consultas SQL solicitadas en el enunciado.

> **Nota:** Este repositorio no incluye una aplicación ni interfaz gráfica. Solo contiene la implementación de la base de datos mediante scripts SQL.

## Requisitos

- SQL Server 2019 o superior.
- SQL Server Management Studio (SSMS) o Azure Data Studio.

## Ejecución

Se recomienda ejecutar los scripts en el siguiente orden (según los nombres de los archivos):

1. Creación de la base de datos.
2. Creación de tablas.
3. Restricciones (PK, FK y CHECK).
4. Índices.
5. Funciones.
6. Stored Procedures.
7. Triggers.
8. Vistas.
9. Migración de datos.
10. Consultas finales.

En SQL Server Management Studio:

```sql
:r nombre_del_script.sql
```

o simplemente abrir cada archivo `.sql` y ejecutarlo con:

```
Execute (F5)
```

## Comandos útiles

Crear una base de datos:

```sql
CREATE DATABASE GD1C2025;
GO

USE GD1C2025;
GO
```

Verificar la base seleccionada:

```sql
SELECT DB_NAME();
```

Listar tablas:

```sql
SELECT *
FROM INFORMATION_SCHEMA.TABLES;
```

Ver procedimientos almacenados:

```sql
SELECT name
FROM sys.procedures;
```

Ver funciones:

```sql
SELECT name
FROM sys.objects
WHERE type IN ('FN','IF','TF');
```

Ver vistas:

```sql
SELECT *
FROM INFORMATION_SCHEMA.VIEWS;
```

## Tecnologías

- SQL Server
- Transact-SQL (T-SQL)

## Autores

Trabajo práctico realizado para la materia **Base de Datos**.

Universidad Tecnológica Nacional - Facultad Regional Buenos Aires.
