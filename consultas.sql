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