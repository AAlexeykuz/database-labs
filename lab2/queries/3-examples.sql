SELECT DISTINCT
    title AS product_title,
    price AS product_price
FROM products;

SELECT id, title, price, is_active
FROM products
WHERE
    is_active = TRUE
    AND (
        price < 3000
        OR category_id = 1
    );

SELECT id, title, description, price
FROM products
WHERE
    price BETWEEN 1000 AND 5000
    AND category_id IN (1, 2)
    AND title LIKE 'Товар №11%'
    AND description IS NULL;

SELECT id, title, price, created_at
FROM products
ORDER BY price DESC, created_at ASC;

SELECT id, title, price FROM products ORDER BY id LIMIT 10 OFFSET 20;