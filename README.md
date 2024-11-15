# Lab4: Data Query Language
Partiendo de la base de datos `tiendaOnline` e insertando datos, diseñe las consultas SQL que respondan a los siguientes ejercicios.


### 1. Consultas básicas de selección
<details>
<summary><b>Lista todos los usuarios en la tabla `Usuarios`, mostrando solo sus nombres y correos electrónicos.</b></summary>

  ```sql
   SELECT nombre, email FROM Usuarios;
  ```
</details>

<details>
<summary><b>Muestra los empleados con su salario y el nombre correspondiente en la tabla `Usuarios`.</b></summary>

  ```sql
   SELECT Usuarios.nombre, Empleados.salario 
   FROM Empleados 
   JOIN Usuarios ON Empleados.usuarioId = Usuarios.id;
  ```
</details>

<details>
<summary><b>Obtén los productos de la tabla `Productos` que tienen un precio mayor o igual a 20.00.</b></summary>

  ```sql
   SELECT nombre, precio FROM Productos WHERE precio >= 20.00;
  ```
</details>

<details>
<summary><b>Lista los clientes con su dirección de envío, código postal y fecha de nacimiento.</b></summary>

  ```sql
   SELECT Usuarios.nombre, Clientes.direccionEnvio, Clientes.codigoPostal, Clientes.fechaNacimiento 
   FROM Clientes 
   JOIN Usuarios ON Clientes.usuarioId = Usuarios.id;
  ```
</details>

---

### 2. Consultas con condiciones específicas y funciones agregadas
<details>
<summary><b>Encuentra el salario promedio de los empleados.</b></summary>

  ```sql
   SELECT AVG(salario) AS salario_promedio FROM Empleados;
  ```
</details>

<details>
<summary><b>Obtén el número total de productos agrupados por tipo de producto.</b></summary>

  ```sql
   SELECT TiposProducto.nombre AS tipo, COUNT(Productos.id) AS total_productos 
   FROM Productos 
   JOIN TiposProducto ON Productos.tipoProductoId = TiposProducto.id 
   GROUP BY TiposProducto.nombre;
  ```
</details>

<details>
<summary><b>Lista los pedidos realizados por cada cliente con su nombre y la fecha de realización.</b></summary>

  ```sql
   SELECT Usuarios.nombre AS cliente, Pedidos.fechaRealizacion 
   FROM Pedidos 
   JOIN Clientes ON Pedidos.clienteId = Clientes.id 
   JOIN Usuarios ON Clientes.usuarioId = Usuarios.id;
  ```
</details>

---

### 3. Consultas con JOIN y filtrado avanzado
<details>
<summary><b>Encuentra los pedidos realizados por clientes mayores de edad (18 años o más).</b></summary>

  ```sql
   SELECT Usuarios.nombre AS cliente, Pedidos.fechaRealizacion 
   FROM Pedidos 
   JOIN Clientes ON Pedidos.clienteId = Clientes.id 
   JOIN Usuarios ON Clientes.usuarioId = Usuarios.id 
   WHERE TIMESTAMPDIFF(YEAR, Clientes.fechaNacimiento, CURDATE()) >= 18;
  ```
</details>

<details>
<summary><b>Muestra los pedidos y las líneas de pedido asociadas, incluyendo el nombre del producto y las unidades solicitadas.</b></summary>

  ```sql
   SELECT Pedidos.id AS pedido_id, Productos.nombre AS producto, LineasPedido.unidades 
   FROM LineasPedido 
   JOIN Pedidos ON LineasPedido.pedidoId = Pedidos.id 
   JOIN Productos ON LineasPedido.productoId = Productos.id;
  ```
</details>

<details>
<summary><b>Lista los productos no permitidos para menores (`puedeVenderseAMenores = FALSE`) y sus precios.</b></summary>

  ```sql
   SELECT nombre, precio 
   FROM Productos 
   WHERE puedeVenderseAMenores = FALSE;
  ```
</details>

---

### 4. Consultas con subconsultas y cálculos
<details>
<summary><b>Encuentra el cliente con el mayor número de pedidos.</b></summary>

  ```sql
   SELECT Usuarios.nombre AS cliente, COUNT(Pedidos.id) AS total_pedidos 
   FROM Pedidos 
   JOIN Clientes ON Pedidos.clienteId = Clientes.id 
   JOIN Usuarios ON Clientes.usuarioId = Usuarios.id 
   GROUP BY Usuarios.nombre 
   ORDER BY total_pedidos DESC 
   LIMIT 1;
  ```
</details>

<details>
<summary><b>Muestra los pedidos con un total calculado de precio para cada pedido (sumando `precio * unidades` de `LineasPedido`).</b></summary>

  ```sql
   SELECT Pedidos.id AS pedido_id, SUM(LineasPedido.precio * LineasPedido.unidades) AS total_precio 
   FROM Pedidos 
   JOIN LineasPedido ON Pedidos.id = LineasPedido.pedidoId 
   GROUP BY Pedidos.id;
  ```
</details>

<details>
<summary><b>Lista los productos que no tienen pedidos asociados en `LineasPedido`.</b></summary>

  ```sql
   SELECT Productos.nombre 
   FROM Productos 
   LEFT JOIN LineasPedido ON Productos.id = LineasPedido.productoId 
   WHERE LineasPedido.productoId IS NULL;
  ```
</details>

---
