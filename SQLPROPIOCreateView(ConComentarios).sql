/*
En esta vista se consultan los datos de Users en INNER JOIN con Customer_orders para mostrar el total de pedidos por usuario y coste total de la suma de todos los pedidos de cada usuario.
Para ello hay que usar COUNT para saber cuántos pedidos ha realizado cada cliente y SUM para saber el total de la suma de cada pedido. En el último caso, había que incluir una cláusula que sumara el monto total de cada pedido solo cuando ese pedido no hubiera sido cancelado y por tanto sin un pago efectivo, para no desvirtuar los resultados de gasto total por cada usuario.
Sin embargo, sí se tiene en cuenta la cantidad total de pedidos realizados por cada usuario, puesto que, aunque fuese cancelado, es un pedido que se llegó a realizar.
*/
CREATE VIEW purchases_per_user AS
SELECT Users.*, COUNT(*) as total_purchases, SUM(CASE WHEN order_status != 'cancelled' THEN total_cost ELSE 0 END) as all_purchases_amount
FROM Users
INNER JOIN Customer_Orders ON Users.user_id = Customer_Orders.customer_id
GROUP BY username
ORDER BY total_cost DESC;

/*
En esta vista se muestra el total de usuarios nuevos a partir de una determinada fecha, agrupados por "administrative_division" para conocer qué zonas concretas están teniendo un mayor
crecimiento de usuarios.
*/
CREATE VIEW most_new_users_per_region AS
SELECT administrative_division, COUNT(users.user_id) as total_users
FROM Users
WHERE user_since >= '2023-01-01'
GROUP BY administrative_division
ORDER BY total_users DESC;

--Consulta sencilla donde vemos el total de usuarios que han realizado algún pedido, todos los pedidos y el total de ingresos por todos los pedidos.
CREATE VIEW total_income AS
SELECT SUM(CASE WHEN order_status != 'cancelled' THEN 1 ELSE 0 END) as all_customers, COUNT(Customer_Orders.customer_id) as all_orders, SUM(CASE WHEN order_status != 'cancelled' THEN total_cost ELSE 0 END) as all_sold
FROM Users
INNER JOIN Customer_Orders ON Users.user_id = Customer_Orders.customer_id;

--version alternatriva de total_income
SELECT Count(customer_orders.customer_id) as all_customers, COUNT(Customer_Orders.customer_id) as all_orders, SUM(customer_orders.total_cost) as all_sold
FROM Users
INNER JOIN Customer_Orders ON Users.user_id = Customer_Orders.customer_id
WHERE order_status!='cancelled';
------------------------------------------------
/*
Consulta sobre el total (en kg) vendidos de cada producto usando inner join. También se muestra el % vendido respecto al stock y en ambos casos no se tienen en cuenta las cantidades vendidas
en aquellos productos cuyo 'orcer_status' sea cancelled, usando where != cancelled.
*/
CREATE VIEW amount_sold AS
SELECT Items.name, Items.stock, SUM(Carts.quantity) as total_sold, (SUM(Carts.quantity) / Items.stock) * 100 as percentage_sold
FROM Items
INNER JOIN Carts ON Carts.item_cart_id = Items.item_id
INNER JOIN Customer_Orders ON Carts.cart_id = Customer_Orders.order_id
WHERE Customer_Orders.order_status != 'cancelled'
GROUP BY Items.name
ORDER BY total_sold DESC;

--En esta consulta, se usa la función TIMEDIFF para restar order_date-user_since y así mostrar cuanto tiempo le tomó a cada usuario realizar su primer pedido.
CREATE VIEW timediff_user_first_order AS
SELECT Users.user_id, Users.username, TIMEDIFF(Customer_Orders.order_date, Users.user_since) as 'time_taken'
FROM Customer_Orders
INNER JOIN Users ON Customer_Orders.customer_id = Users.user_id;

--Esta consulta devuelve la cantidad de veces que un item ha sigo agregado al carrito, y así ver qué productos se han comprado más veces.
CREATE VIEW times_added_to_cart AS
SELECT Carts.item_cart_id, Items.name AS item_name, COUNT(*) as times_added_to_cart
FROM Carts
INNER JOIN Items ON Carts.item_cart_id = Items.item_id
INNER JOIN Customer_Orders ON 
GROUP BY Carts.item_cart_id
ORDER BY COUNT(*) DESC;

--VERSION MEJORADA DE LA ANTERIOR
CREATE VIEW times_added_to_cart AS
SELECT carts.item_cart_id AS item_id, Items.name AS item_name, COUNT(*) as times_added_to_cart
FROM Carts
INNER JOIN Items ON carts.item_cart_id = Items.item_id
INNER JOIN Customer_orders ON carts.cart_id=customer_orders.customer_id
WHERE customer_orders.order_status!='cancelled'
GROUP BY carts.item_cart_id
ORDER BY times_added_to_cart DESC;

/*
consulta muestra los pedidos datos especificados con status success desde la fecha indicada en adelante. Los resultados se muestran de
pagos más recientes a menos recientes. Al igual que he seleccionado "payment_status=success" se podrían elegir otros status a conveniencia como "pending" o "failed".
*/
SELECT payment_id, payment_method, payment_status, amount, transaction_date
FROM Payments
WHERE payment_status = 'success' AND transaction_date >= '2023-01-01'
ORDER BY transaction_date DESC;

/*
Con esta consulta muestro todas las reviews cuyo "rating" sea >=5 && <=10.
Esta consulta tan sencilla me dio un problema al arrojar siempre el valor de rating-1. Sin saber por qué
la consulta restaba 1 a cada rating. Estuve investigando y resulta que ENUM usa strings, y cada uno de los
strings tiene asignada una posición de 1 a n, por lo que cuando yo pedía "where rating=5" me devolvía el valor
string de la posición 5, que en este caso era 4. Sí pedía "where rating between 5 and 10" me mostraba los valores
de rating alterados 4,5,6,7,8,9. La solución era cambiar a tipo de dato INT y escribir en comentarios CHECK (rating BETWEEN 0 AND 10)
*/
CREATE VIEW rating_from_5to10 AS
SELECT * FROM Reviews WHERE rating BETWEEN 5 AND 10
ORDER BY review_id DESC
