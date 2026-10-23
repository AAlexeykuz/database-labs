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

# товары с ценой выше среднего
SELECT title, price
FROM products
WHERE
    price > (
        SELECT AVG(price)
        FROM products
    );

# пользователи, оформлявшие товары
SELECT full_name, email
FROM users
WHERE
    id IN (
        SELECT user_id
        FROM orders
    );

# пользователи, у которых есть корзина с товарами
SELECT users.full_name, users.email
FROM users
WHERE
    EXISTS (
        SELECT 1
        FROM carts
            JOIN cart_items ON carts.id = cart_items.cart_id
        WHERE
            carts.user_id = users.id
    );

# Задание 6

WITH
    user_spending AS (
        SELECT
            user_id,
            SUM(total_amount) AS total_spent
        FROM orders
        GROUP BY
            user_id
    )
SELECT users.full_name, user_spending.total_spent
FROM user_spending
    JOIN users ON user_spending.user_id = users.id
WHERE
    user_spending.total_spent > 19000
ORDER BY user_spending.total_spent DESC;

WITH RECURSIVE
    category_tree AS (
        SELECT id, parent_id, name, 1 AS depth
        FROM categories
        WHERE
            id = 1
        UNION ALL
        SELECT categories.id, categories.parent_id, categories.name, category_tree.depth + 1
        FROM categories
            JOIN category_tree ON categories.parent_id = category_tree.id
    )
SELECT id, parent_id, name, depth
FROM category_tree;

# Задание 7

CREATE VIEW v_active_products AS
SELECT products.id, products.title, products.price, categories.name AS category_name, sellers.store_name
FROM
    products
    JOIN categories ON products.category_id = categories.id
    JOIN sellers ON products.seller_id = sellers.user_id
WHERE
    products.is_active = TRUE;

SELECT
    title,
    price,
    category_name,
    store_name
FROM v_active_products
WHERE
    price < 5000
ORDER BY price ASC;

CREATE VIEW v_seller_performance AS
SELECT
    sellers.user_id,
    sellers.store_name,
    COUNT(DISTINCT order_items.order_id) AS total_orders_count,
    SUM(
        order_items.quantity * order_items.unit_price
    ) AS total_revenue
FROM
    sellers
    JOIN products ON sellers.user_id = products.seller_id
    JOIN order_items ON products.id = order_items.product_id
GROUP BY
    sellers.user_id,
    sellers.store_name;

SELECT
    store_name,
    total_orders_count,
    total_revenue
FROM v_seller_performance
ORDER BY total_revenue DESC;