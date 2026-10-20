--1. CREACIÓN DE BASE DE DATOS
CREATE DATABASE Ventas_Tech_DB;
USE Ventas_Tech_DB;

  --  2. ELIMINACIÓN DE TABLAS (SI ES QUE EXISTIERAN)
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

--3.- CREACIÓN DE TABLAS

--3. 1.- Tabla Categorías
CREATE TABLE categorias (
    			id_categoria INT PRIMARY KEY,
  			 nombre_categoria VARCHAR(50) NOT NULL, 
  			 descripcion VARCHAR(200) 
);

--3. 2.- Tabla Clientes
CREATE TABLE clientes (
 	id_cliente INT PRIMARY KEY, 
 nombre VARCHAR(100) NOT NULL,
 email VARCHAR(100) UNIQUE,
 ciudad VARCHAR(50),
 fecha_registro DATE NOT NULL 
);

--3.3.- Tabla Productos
CREATE TABLE productos (
 	id_producto INT PRIMARY KEY,
nombre_producto VARCHAR(100) NOT NULL,
id_categoria INT,
precio DECIMAL(10, 2) NOT NULL,
stock INT DEFAULT 0,
activo TINYINT DEFAULT 1,
    	CONSTRAINT fk_productos_categorias FOREIGN KEY (id_categoria)
    		REFERENCES categorias(id_categoria)
);

--3.4.- Tabla Ventas
CREATE TABLE ventas (
 	id_venta INT PRIMARY KEY,
id_cliente INT NOT NULL,
id_producto INT NOT NULL,
cantidad INT NOT NULL,
precio_unitario DECIMAL(10, 2) NOT NULL,
fecha_venta DATE NOT NULL,
CONSTRAINT fk_ventas_clientes FOREIGN KEY (id_cliente)
    		REFERENCES clientes(id_cliente),
CONSTRAINT fk_ventas_productos FOREIGN KEY (id_producto)
REFERENCES productos(id_producto) 
);


   -- 4.  CARGA DE DATOS

--4.1.- Categorías
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion)
VALUES 
(1, 'Computación', 'Laptops, PCs y Monitores'),
(2, 'Accesorios', 'Periféricos y complementos'),
(3, 'Audio', 'Auriculares y parlantes'),
(4, 'Almacenamiento', 'Discos y memorias');
--4.2.- Clientes
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro)
VALUES 
(1, 'María López', 'maria@mail.com', 'Buenos Aires', '2024-01-05'),
(2, 'Carlos Ruiz', 'carlos@mail.com', 'Cordoba', '2024-01-10'),
(3, 'Ana Gomez', 'ana@mail.com', 'Rosario', '2024-02-01'),
(4, 'Pedro Sanz', 'pedro@mail.com', 'Mendoza', '2024-02-15'),
(5, 'Laura Torres', 'laura@mail.com', 'Tucuman', '2024-03-01');

--4.3.- Productos
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo)
VALUES 
(1, 'Laptop Pro 15', 1, 1200.00, 15, 1),
(2, 'Mouse Inalambrico', 2, 28.00, 80, 1),
(3, 'Monitor 4k 27"', 1, 450.00, 12, 1),
(4, 'Auriculares BT Pro', 3, 120.00, 35, 1),
(5, 'SSD Externo 1TB', 4, 130.00, 18, 1),
(6, 'Teclado Mecanico', 2, 95.00, 40, 1);

--4.4.- Ventas
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta)
VALUES 
(1, 1, 1, 2, 1200.00, '2024-03-05'),
(2, 2, 2, 5, 28.00, '2024-03-06'),
(3, 3, 3, 1, 450.00, '2024-03-07'),
(4, 1, 4, 2, 120.00, '2024-03-08'),
(5, 4, 5, 3, 130.00, '2024-03-10'),
(6, 2, 6, 4, 95.00, '2024-03-11'),
(7, 5, 1, 1, 1200.00, '2024-03-12'),
(8, 3, 2, 8, 28.00, '2024-03-13'),
(9, 4, 4, 1, 120.00, '2024-03-14'),
(10, 5, 3, 2, 450.00, '2024-03-15');

 --   5. VERIFICACIÓN DE INTEGRIDAD
--5.1.- Tabla categorias
SELECT * FROM categorias;
--5.2.- Tabla clientes
SELECT * FROM clientes;
--5.3.- Tabla productos
SELECT * FROM productos;
--5.4.- Tabla ventas
SELECT * FROM ventas;