USE sakila;

-- 1. Obtenga el número de clientes activos mensuales.
SELECT YEAR(p.payment_date) AS Año,
       MONTH(p.payment_date) AS mes,
       COUNT(DISTINCT c.customer_id) AS num_clientes_activos
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY YEAR(p.payment_date), MONTH(p.payment_date)
ORDER BY Año, Mes;

-- 2. Usuarios activos en el mes anterior.
SELECT 
    Año,
    Mes,
    num_clientes_activos,
    LAG(num_clientes_activos) OVER (ORDER BY Año, Mes) AS num_clientes_activos_mes_anterior,
    num_clientes_activos - LAG(num_clientes_activos) OVER (ORDER BY Año, Mes) AS diferencia
FROM
    (SELECT 
        YEAR(p.payment_date) AS Año,
            MONTH(p.payment_date) AS Mes,
            COUNT(DISTINCT c.customer_id) AS num_clientes_activos
    FROM
        customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY YEAR(p.payment_date) , MONTH(p.payment_date)) AS clientes_por_mes;
    
-- 3. Variación porcentual en el número de clientes activos.
SELECT 
    Año,
    Mes,
    num_clientes_activos,
    LAG(num_clientes_activos) OVER (ORDER BY Año, Mes) AS num_clientes_activos_mes_anterior,
    num_clientes_activos - LAG(num_clientes_activos) OVER (ORDER BY Año, Mes) AS diferencia_absoluta,
    ROUND(((num_clientes_activos - LAG(num_clientes_activos) OVER (ORDER BY Año, Mes)) / LAG(num_clientes_activos) OVER (ORDER BY Año, Mes)) * 100, 2) AS variacion_porcentual
FROM
    (SELECT 
        YEAR(p.payment_date) AS Año,
            MONTH(p.payment_date) AS Mes,
            COUNT(DISTINCT c.customer_id) AS num_clientes_activos
    FROM
        customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY YEAR(p.payment_date) , MONTH(p.payment_date)) AS clientes_por_mes;
    
-- 4. Clientes retenidos todos los meses.
SELECT DISTINCT c.customer_id, 
                CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.payment_date >= '2005-01-01'
AND p.payment_date <= '2006-03-31'
ORDER BY c.customer_id;


