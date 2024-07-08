##################################
##### M2 EVALUACION ESTRELLA #####
#################################
-- Se usará la BBDD sakila que tiene numerosas tablas llamamos a la bbdd
USE sakila;
-- usaremos distintas tablas que podemos explorar asi 
SELECT * FROM film
LIMIT 10;

-- #1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
-- Usamos la tabla film  y la exploro elijo la columna title podemos hacer una consulta simple 
-- pero si me dice que no hay duplicados podemos usar el operador DISTINC que nos muestra valores unicos en una columna
SELECT * FROM film;

SELECT DISTINCT title 
FROM film;

-- #2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
-- revisando la tabla film tenemos una columna rating que clasifica las peliculas en esta categoria
SELECT film_id, title, rating
FROM film
WHERE rating ="pg-13";

-- #3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
-- usamos LIKE para buscar un patron de texto dentro de una columna

SELECT title, description 
FROM film
WHERE description LIKE "%amazing%";  

-- #4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
-- usaremos la columna length y cogeremos las que sean mayores a 120

SELECT title, length 
FROM film
WHERE length > 120;

-- #5. Recupera los nombres de todos los actores.

SELECT actor_id, first_name, last_name
FROM actor;

-- #6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE "%Gibson%";

-- #7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
-- la primera consulta que he hecho no incluye el 10 ni el 20 
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id > 10
AND actor_id < 20;
-- si quiero que incluya el 10 y el 20 
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id >= 10
AND actor_id <= 20;

-- #8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
-- EL ejercicio nos pide que NO SEAN por lo que usamos el NOT IN, es decir NO "R" Y NO "PG-13"
SELECT * FROM film;

SELECT film_id, title, rating
FROM film
WHERE rating NOT IN ("pg-13", "R");

-- #9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
-- lo primero que voy a hacer es revisar cuantos valores distintos hay en la columna rating
SELECT DISTINCT rating 
FROM film;
-- los resultados que obtengo son "PG" "G" "NC-7" "PG-13" "R" tiene 5 categorias o valores distintos 
-- la verdad que lo primero que pensé fue añadir una columna con valor de un número, lo he descartado pero me ha servido para repasarlo ( es mas operativo contar)
ALTER TABLE film
ADD COLUMN recuento FLOAT;
-- ahora voy contar todas las peliculas las agrupo y le voy a poner el alias recuento.
SELECT rating, COUNT(film_id) AS recuento
FROM film
GROUP BY rating;

-- # 10. Encuentra la cantidad total de películas alquiladas por cada cliente (como aparece la palabra cantidad hay que contar)
-- y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.(como aparece la palabra cantidad hay que contar)
-- voy a usar las siguientes tablas:
SELECT * FROM customer -- customer_id  first_name last_name
LIMIT 10;
SELECT * FROM rental -- rental_id customer_id
LIMIT 10;

SELECT c.customer_id AS numero_cliente,
c.first_name AS nombre,
c.last_name AS apellido,
COUNT(r.rental_id) AS cantidad_alquilada
FROM customer AS c
LEFT JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY c.first_name, c.last_name, c.customer_id;

-- # 11. Encuentra la cantidad total de películas alquiladas por categoría  
-- y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT * FROM rental -- rental_id inventory_id
LIMIT 10;
SELECT * FROM inventory -- inventory_id film_id
LIMIT 10;
SELECT * FROM film_category  -- film_id  category_id
LIMIT 10;
SELECT * FROM category  -- category_id name
LIMIT 10;

-- voy a contar la cantidad total de peliculas alquiladas por categoria (como aparece la palabra cantidad hay que contar)
-- tengo que unir la tabla rental con category

SELECT c.name AS categoria, COUNT(r.rental_id) AS cantidad_alquilada
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN inventory AS i ON i.film_id = fc.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
GROUP BY c.name;

-- #12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film 
-- y muestra la clasificación junto con el promedio de duración.
-- Voy a usar las siguiente tabla y columnas:
SELECT * FROM film -- length rating
LIMIT 10;
 -- en el ejercicio #9 hice una consulta que me daba como resultado las 5 categorias distintas son "PG" "G" "NC-7" "PG-13" "R" 
SELECT DISTINCT rating 
FROM film;
-- Me piden el promedio de duracion de la clasificacion del grupo de esas peliculas,  ejemplo  cojo todas las peliculas de la categoria R y hago el promedio de duracion
-- El resultado es la media de duración de cada una de las categorias 

SELECT rating AS categoria, AVG(length) AS promedio_duracion_categoria
FROM film
GROUP BY rating;

-- # 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
-- Voy a usar las siguientes tablas y columnas:

SELECT * FROM film -- film_id title
LIMIT 10;
SELECT * FROM actor -- actor_id first_name last_name
LIMIT 10;
SELECT * FROM film_actor -- film_id actor_id
LIMIT 10;
-- con esto averiguo el film_id y ahora puedo buscar al elenco film_id = 458
SELECT title, film_id 
FROM film
WHERE title LIKE "Indian_Love%"; 
-- con esto otro averiguo los actor_id del el film "Indian Love"
SELECT actor_id, film_id
FROM film_actor
WHERE film_id = 458;
-- con lo que he averiguado puedo hacer está query (creo que puedo hacerlo de otro modo mas generico lo pensaré mas tarde)
SELECT actor_id, first_name, last_name, title, film_id
FROM actor
INNER JOIN film_actor
USING (actor_id)
INNER JOIN film 
USING (film_id)
WHERE title LIKE "Indian_Love%" AND film_id = 458;

-- ahora viendolo en global puedo usar un INNER JOIN con un ON
SELECT ac.actor_id, ac.first_name, ac.last_name
FROM actor AS ac
INNER JOIN film_actor AS fa
ON ac.actor_id = fa.actor_id
INNER JOIN film AS f
ON fa.film_id = f.film_id
WHERE title = "Indian Love";

-- #14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
-- Voy a usar las siguientes tablas y columnas:
SELECT * FROM film -- film_id title description
LIMIT 10;
-- voy a usar un LIKE 
SELECT title, film_id, description
FROM film
WHERE description LIKE "%dog%" OR "%Cat%";

-- # 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.
-- voy a consultar las siguientes tablas y columnas 

SELECT * FROM actor -- actor_id first_name last_name
LIMIT 10;
SELECT * FROM film -- film_id title
LIMIT 10;
SELECT * FROM film_actor -- film_id actor_id
LIMIT 10;
-- vamos a comprobar que en la tabla film_actor hay algun actor o actriz que no tenga asociada ninguna pelicula es decir que sea nulo 
SELECT ac.actor_id, ac.first_name, ac.last_name
FROM actor AS ac
INNER JOIN film_actor AS fa
ON ac.actor_id = fa.actor_id
INNER JOIN film AS f
ON fa.film_id = f.film_id
WHERE ac.actor_id IS NULL; -- no me devuelve nada pero creo que tengo que volver a pensarla

-- #16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010
-- Voy a usar la tabla y las siguientes columnas 
SELECT * FROM film -- film_id title release_year
LIMIT 10;

SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2006;

-- #17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
-- Voy a usar las tablas y las siguientes columnas 
SELECT * FROM film_category -- film_id category_id 
LIMIT 10;
SELECT * FROM category --  category_id name
LIMIT 10;
SELECT * FROM film -- film_id title 
LIMIT 10;
-- FASE 1 cuando lo hago me salen duplicados 
SELECT f.title, f.film_id, fc.film_id, fc.category_id, c.category_id, c.name
FROM film AS f
INNER JOIN film_category AS fc
ON f.film_id = fc.film_id
INNER JOIN category AS c
ON c.category_id = fc.category_id
WHERE c.name = "Family";
-- FASE 2 ahora lo limpio 
SELECT f.title, c.name. -- puedo quitar la columna de nombre de la categoria pero quiero que salga
FROM film AS f
INNER JOIN film_category AS fc
ON f.film_id = fc.film_id
INNER JOIN category AS c
ON c.category_id = fc.category_id
WHERE c.name = "Family";

-- # 18.Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
-- Voy a usar las tablas y las siguientes columnas 
SELECT * FROM actor -- actor_id first_name last_name
LIMIT 10;
SELECT * FROM film -- film_id title
LIMIT 10;
SELECT * FROM film_actor -- film_id actor_id
LIMIT 10;
-- FASE 1 pienso que tablas tengo que unir y tienen las columnas iguales
SELECT ac.first_name, ac.last_name, f.title
FROM actor AS ac
INNER JOIN film_actor AS fa
ON ac.actor_id = fa.actor_id
INNER JOIN film AS f
ON fa.film_id = f.film_id
WHERE ac.actor_id IN
-- voy a contar la cantidad de veces que aparecen los actores en peliculas distintas (con un film_id)
-- compruebo que esta query cuenta 
SELECT COUNT(fa.film_id) AS cantidad_peliculas_sale, fa.actor_id
FROM film_actor AS fa
GROUP BY fa.actor_id
HAVING COUNT(fa.film_id) >= 10;

-- Uno las dos anteriores con una subquery pero me salia error 
-- y al leer el error me decia que "algo de contar en select" bueno que me he dado cuenta que habia que quitarlo.
-- lo he dejado de este modo y creo que da

SELECT ac.first_name, ac.last_name, f.title
FROM actor AS ac
INNER JOIN film_actor AS fa
ON ac.actor_id = fa.actor_id
INNER JOIN film AS f
ON fa.film_id = f.film_id
WHERE ac.actor_id IN (
SELECT fa.actor_id
FROM film_actor AS fa
GROUP BY fa.actor_id
HAVING COUNT(fa.film_id) >= 10
);

-- # 19. Encuentra el título de todas las películas que son "R" 
-- y tienen una duración mayor a 2 horas en la tabla film.
-- Voy a necesitar la siguiente tabla y columnas
SELECT * FROM film -- film_id title rating legth
LIMIT 10;
-- con esta query consigo consultar las peliculas que se clasifican R lo pongo con los minutos para revisar
SELECT title, rating, length
FROM film
WHERE rating IN ("R");

-- duracion mayor a 2 horas es mayor a 120 minutos ahora lo uno con un AND
SELECT title, rating, length
FROM film
WHERE rating IN ("R") AND length > 120;

-- #20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos 
-- y muestra el nombre de la categoría junto con el promedio de duración.
-- Voy a necesitar la siguiente tabla y columnas
SELECT * FROM film -- film_id length
LIMIT 10;
SELECT * FROM category -- category_id name
LIMIT 10;
SELECT * FROM film_category -- film_id category_id
LIMIT 10;
-- consulto las tablas para conocerlas y veo que tiene 16 categorias ( me devuelve 16 rows)
SELECT DISTINCT name AS categoria
FROM category;

SELECT c.name AS categoria, AVG(f.length) AS promedio_mas_doshoras_categoria
FROM film AS f
INNER JOIN film_category AS fc 
ON fc.film_id = f.film_id
INNER JOIN category AS c 
ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 120;

-- #21. Encuentra los actores que han actuado en al menos 5 películas 
-- y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT * FROM actor -- actor_id first_name last_name
LIMIT 10;
SELECT * FROM film -- film_id title
LIMIT 10;
SELECT * FROM film_actor -- film_id actor_id
LIMIT 10;
-- he intentado hacer el ejercicio con un CASE pero no lo he conseguido 
-- primero intento contar en la tabla film_actor cuantos actores tienen 5 peliculas o mas 
SELECT actor_id, COUNT(film_id) AS cantidad_peliculas
FROM film_actor 
GROUP BY actor_id 
HAVING COUNT(film_id) >= 5;

SELECT ac.first_name, ac.last_name,COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS ac
INNER JOIN film_actor AS fa
ON ac.actor_id = fa.actor_id
WHERE ac.actor_id IN (
(SELECT actor_id
FROM film_actor 
GROUP BY actor_id 
HAVING COUNT(film_id) >= 5)
)
GROUP BY ac.actor_id;

-- # 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
-- Utiliza una subconsulta para encontrar los rental_id con una duración superior a 5 días 
-- y luego selecciona las películas correspondientes.

SELECT * FROM film -- film_id title
LIMIT 10;
SELECT * FROM inventory -- inventory_id film_id
LIMIT 10;
SELECT * FROM rental -- inventory_id  return_date  rental_date
LIMIT 10;
-- segun los apuntes el dato que tenemos dentro de rental_date y return_date es un tipo de dato DATETIME AAAA-MM-DD HH:MM:SS Tenemos la pista DATEDIFF (fecha2,fiecha1)
SELECT rental_id,inventory_id, 
DATEDIFF (return_date,rental_date)>5 AS Alquiladas_mas_cinco_dias
FROM rental
GROUP BY rental_id,inventory_id;
-- al hacer esta consulta la columna "Alquiladas_mas_cinco_dias" me devuelve 0 si la diferencia NO es más de cinco dias y 1 si la diferencia SI es más de cinco días 
-- tengo que mejorar la consulta
-- probando y equivocandome he comprobado que es mejor 
SELECT rental_id,DATEDIFF (return_date,rental_date)>5 AS Alquiladas_mas_cinco_dias
FROM rental
WHERE DATEDIFF (return_date,rental_date)>5; -- mejor un WHERE asi solo salen las alquiladas mas de cinco dia s

-- Pienso las uniones 
SELECT f.title, DATEDIFF (return_date,rental_date)>5 AS Alquiladas_mas_cinco_dias
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r ON r.inventory_id = i.inventory_id
WHERE r.rental_id IN (
SELECT rental_id
FROM rental
WHERE DATEDIFF (return_date,rental_date)>5
)
GROUP BY title,Alquiladas_mas_cinco_dias;


-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" 
-- y luego exclúyelos de la lista de actores.

SELECT * FROM actor -- actor_id first_name last_name
LIMIT 10;
SELECT * FROM category -- category_id name
LIMIT 10;
SELECT * FROM film_category -- film_id category_id
LIMIT 10;
SELECT * FROM film_actor -- film_id actor_id
LIMIT 10;
-- CON ESTO AVERIGUAMOS  las peliculas film_id que hay en la categoria "Horror" 
-- tambien quiero sabe cual es la category_id de "horror" que es el 11 aunque no me sirva puedo hacer consultas que me ayudan luego quitaré lo que no necesite
SELECT film_id, category_id, name
FROM film_category 
INNER JOIN category
USING (category_id)
WHERE name = "horror";
-- exploro con la category_id me retorna 317 ROWS ACTORES cotilleo 
SELECT actor_id, first_name, last_name, film_id, category_id
FROM actor 
INNER JOIN film_actor
USING (actor_id)
INNER JOIN film_category
USING (film_id)
INNER JOIN category
USING (category_id)
WHERE category_id = 11;
-- ##########################
-- con esto averiguo los actores que han actuado en películas de la categoría "Horror" 
SELECT DISTINCT actor_id
FROM film_actor
WHERE film_id IN (
SELECT film_id
FROM film_category 
INNER JOIN category
USING (category_id)
WHERE name = "horror"
);
-- nombre y apellido de los actores que NO HAN  actuado en NINGUNA película de la categoría "Horror". 
-- lo que habia hecho antes lo puedo usar de subconsulta
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id NOT IN(
SELECT DISTINCT actor_id
FROM film_actor
WHERE film_id IN (
SELECT film_id
FROM film_category 
INNER JOIN category
USING (category_id)
WHERE name = "horror")
);
-- Esto me devuelve todos los actores que hayan actuado en peliculas de horror
SELECT a.first_name, a.last_name, a.actor_id
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film AS f ON fa.film_id = f.film_id
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = "Horror";

-- Esto me devuelve todos los actores que hayan actuado en peliculas distintas a horror
SELECT a.first_name, a.last_name, a.actor_id
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film AS f ON fa.film_id = f.film_id
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name <> "Horror";

-- no puedo pensar claro

-- #################################



##### BONUS  #####
-- # 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film
-- voy a necesitar las siguientes tablas 
SELECT * FROM film -- film_id title length
LIMIT 10;
SELECT * FROM film_category -- film_id category_id
LIMIT 10;
SELECT * FROM category -- category_id name
LIMIT 10;

SELECT f.title,f.length,c.name
FROM film AS f
INNER JOIN film_category AS fc
ON fc.film_id = f.film_id
INNER JOIN category AS c
ON c.category_id = fc.category_id 
WHERE c.name = "Comedy" AND f.length > 180;

-- # 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
-- La consulta debe mostrar el nombre y apellido de los actores 
-- y el número de películas en las que han actuado juntos.
SELECT * FROM actor -- actor_id first_name last_name
LIMIT 10;
SELECT * FROM film -- film_id title
LIMIT 10;
SELECT * FROM film_actor -- film_id actor_id
LIMIT 10;


SELECT
        actor.actor_id,
        actor.first_name,
        actor.last_name,
        COUNT(film_actor.film_id) AS num_films
    FROM
        actor
    JOIN
        film_actor ON actor.actor_id = film_actor.actor_id
    GROUP BY
        actor.actor_id;