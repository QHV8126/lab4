-- 1 consultas básicas de selección

-- nombre y correos de los Usuarios
SELECT nombre, email 
FROM Usuarios;

-- salario y nombre Empleados (producto cartesiano)
SELECT Usuarios.nombre, Empleados.salario
FROM Empleados, Usuarios
WHERE Usuarios.id = Empleados.usuarioId;

-- salario y nombre Empleados (join)
SELECT Usuarios.nombre, Empleados.salario
FROM Usuarios JOIN Empleados ON Usuarios.id = Empleados.usuarioId;

-- Productos precio >= 20.00
SELECT *
FROM Productos 
WHERE Productos.precio >= 20.00;

-- direccionEnvio, codigoPostal, fechaNacimiento de Clientes
SELECT Usuarios.nombre, Clientes.direccionEnvio, Clientes.codigoPostal, Clientes.fechaNacimiento 
FROM Usuarios JOIN Clientes ON Clientes.usuarioId = Usuarios.id;


-- 2 consultas con condiciones específicas y funciones agregadas

-- salario promedio empleados
SELECT AVG(Empleados.salario)
FROM Empleados;

-- número productos de cada tipo (solo conteo)
SELECT COUNT(*)
FROM Productos
GROUP BY Productos.tipoProductoId;

-- número productos de cada tipo (id y conteo)
SELECT Productos.tipoProductoId, COUNT(*)
FROM Productos
GROUP BY Productos.tipoProductoId;

-- número productos de cada tipo (nombre y conteo) con join
SELECT TiposProducto.nombre, COUNT(*)
FROM Productos JOIN TiposProducto ON Productos.tipoProductoId = TiposProducto.id
GROUP BY Productos.tipoProductoId;

-- número productos de cada tipo (nombre y conteo) con producto cartesiano
SELECT TiposProducto.nombre, COUNT(*)
FROM Productos, TiposProducto
WHERE Productos.tipoProductoId = TiposProducto.id
GROUP BY Productos.tipoProductoId;

-- nombre, fecha realizacion de los pedidos de cada cliente con join
SELECT Usuarios.nombre, Pedidos.fechaRealizacion
FROM Clientes 
    JOIN Pedidos ON Clientes.id = Pedidos.clienteId
    JOIN Usuarios ON Usuarios.id = Clientes.usuarioId;
    
-- nombre, fecha realizacion de los pedidos de cada cliente con producto cartesiano
SELECT Usuarios.nombre, Pedidos.fechaRealizacion
FROM Clientes, Pedidos, Usuarios
WHERE Clientes.id = Pedidos.clienteId AND Usuarios.id = Clientes.usuarioId;


-- 3 Consultas con JOIN y filtrado avanzado

-- pedidos clientes edad >= 18
SELECT Usuarios.nombre, Pedidos.*
FROM Clientes 
    JOIN Pedidos ON Clientes.id = Pedidos.clienteId
    JOIN Usuarios ON Usuarios.id = Clientes.usuarioId
WHERE TIMESTAMPDIFF(YEAR, Clientes.fechaNacimiento, Pedidos.fechaRealizacion)>=18;


-- inventados profesor

-- productos precio más caro y más barato
SELECT *
FROM Productos
WHERE
    precio = (SELECT MAX(Productos.precio) FROM Productos)
    OR
    precio = (SELECT MIN(Productos.precio) FROM Productos);

-- nombre producto, precio +10% de los <50€
SELECT Productos.nombre, 1.1*Productos.precio
FROM Productos
WHERE precio < 50.00;

-- nombre producto, precio +10% de los <50€ (nombres bonitos, precio rondeado)
SELECT Productos.nombre AS Producto, ROUND(1.1*Productos.precio, 2) AS Precio
FROM Productos
WHERE precio < 50.00;

-- nombre producto, precio +10% de los <50€ y los otros sin modificar
SELECT Productos.nombre AS Producto, ROUND(1.1*Productos.precio, 2) AS Precio
FROM Productos
WHERE precio < 50.00
UNION
SELECT Productos.nombre, 1.1*Productos.precio
FROM Productos
WHERE precio >= 50.00;

-- nombre producto, precio +10% de los <50€ y los otros sin modificar (ORDENADO)
SELECT Productos.nombre AS Producto, ROUND(1.1*Productos.precio, 2) AS Precio
FROM Productos
WHERE precio < 50.00
UNION
SELECT Productos.nombre, 1.1*Productos.precio
FROM Productos
WHERE precio >= 50.00
ORDER BY precio DESC -- o ASC;

-- clientes sin pedidos
SELECT Usuarios.nombre
FROM Usuarios
    JOIN Clientes ON Usuarios.id = Clientes.usuarioId
    LEFT JOIN Pedidos ON Clientes.id = Pedidos.clienteId
WHERE Pedidos.id IS NULL;

-- clientes con pedidos con productos > 100
SELECT DISTINCT Clientes.id
FROM Clientes
    JOIN Pedidos ON Clientes.id = Pedidos.clienteId
    JOIN LineasPedido ON LineasPedido.pedidoId = Pedidos.id
WHERE LineasPedido.precio >= 100;

-- empleados con salario > salario medio
SELECT *
FROM Empleados
WHERE salario >= (SELECT AVG(Empleados.salario) FROM Empleados);

-- clientes nacidos este mes (fecha parseada)
SELECT Usuarios.nombre, Clientes.direccionEnvio, DATE_FORMAT(Clientes.fechaNacimiento, "%d-%m-%Y")
FROM Usuarios
    JOIN Clientes ON Clientes.usuarioId = Usuarios.id
WHERE MONTH(Clientes.fechaNacimiento) = MONTH(CURDATE());

-- cliente, importe total (orden decreciente)
SELECT Clientes.*, COALESCE(SUM(LineasPedido.unidades * LineasPedido.precio),0) AS importe
FROM Clientes
    LEFT JOIN Pedidos ON Clientes.id = Pedidos.clienteId
    LEFT JOIN LineasPedido ON LineasPedido.pedidoId = Pedidos.id
GROUP BY Clientes.id
ORDER BY importe DESC;

-- clientes con más de 3 pedidos
SELECT Usuarios.nombre, COUNT(Pedidos.id) AS total
FROM Usuarios
	JOIN Clientes ON Clientes.usuarioId = Usuarios.id
	JOIN Pedidos ON Clientes.id = Pedidos.clienteId
GROUP BY Clientes.id
HAVING total >= 3; -- el group by va con HAVING no con WHERE

-- unidades vendidas de cada producto
SELECT LineasPedido.productoId, SUM(LineasPedido.unidades)
FROM LineasPedido
GROUP BY LineasPedido.productoId;

-- produtos más populares de cada tipo
SELECT Productos.nombre as producto, TiposProducto.nombre as tipo, MAX(vendidos)
FROM ( -- produce una vista
    SELECT Pedidos.productoId, SUM(LineasPedido.unidades) as vendidos
    FROM LineasPedido
    GROUP BY LineasPedido.productoId
    ) as ventas
    JOIN Producto ON ventas.productoId = Producto.id 
    JOIN TiposProducto ON TiposProducto.id = Producto.tipoProductoId
GROUP BY TiposProducto.nombre;