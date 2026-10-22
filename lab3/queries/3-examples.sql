SELECT
    products.id AS product_id,
    products.title AS product_title,
    products.price AS product_price,
    categories.name AS category_name,
    sellers.store_name
FROM
    products
    JOIN categories ON products.category_id = categories.id
    JOIN sellers ON products.seller_id = sellers.user_id;

SELECT products.title, reviews.id
FROM products
    LEFT JOIN reviews ON products.id = reviews.product_id

SELECT products.seller_id as seller_id, SUM(
        order_items.quantity * order_items.unit_price
    ) as revenue
FROM order_items
    JOIN products ON order_items.product_id = products.id
GROUP BY
    products.seller_id
HAVING
    SUM(
        order_items.quantity * order_items.unit_price
    ) > 20000000;