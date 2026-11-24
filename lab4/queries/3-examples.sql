# 1
SELECT categories.name, products.title, products.price, ROW_NUMBER() OVER w, RANK() OVER w, DENSE_RANK() OVER w
FROM products
JOIN categories ON (categories.id = products.category_id)
WINDOW w AS (PARTITION BY products.category_id ORDER BY products.price DESC);

# 2
WITH ranked_products AS (
    SELECT categories.name as category, title, price, ROW_NUMBER() OVER w
    FROM products
    JOIN categories ON (categories.id = category_id)
    WINDOW w AS (PARTITION BY category_id ORDER BY price DESC)
)
SELECT
    category,
    title,
    price
FROM ranked_products
WHERE row_number <= 3;

# 3
SELECT 
    paid_at::date AS payment_date,
    SUM(amount) as day_amount,
    SUM(SUM(amount)) OVER (ORDER BY paid_at::date ASC)
FROM payments
GROUP BY payment_date

SELECT category_id, SUM(price) FROM products GROUP BY category_id;

# 4
SELECT
    sellers.store_name,
    products.category_id,
    SUM(order_items.unit_price * order_items.quantity) / 
    SUM(SUM(order_items.unit_price * order_items.quantity)) OVER (PARTITION BY products.category_id) AS revenue_percentage
FROM
    sellers
    JOIN products ON products.seller_id = sellers.user_id
    JOIN order_items ON order_items.product_id = products.id
GROUP BY
    sellers.store_name,
    products.category_id
ORDER BY store_name, category_id;

# 5
SELECT
    paid_at::date AS payment_date,
    SUM(amount) as day_amount,
    LEAD(SUM(amount)) OVER (
        ORDER BY paid_at::date ASC
    ) - SUM(amount) as next_day_difference,
    SUM(amount) - LAG(SUM(amount)) OVER (
        ORDER BY paid_at::date ASC 
    ) as previous_day_difference
FROM payments
GROUP BY
    payment_date

# 6

WITH categories_revenue AS (
    SELECT category_id, SUM(order_items.unit_price * order_items.quantity) as category_revenue
    FROM products
    JOIN order_items ON order_items.product_id = products.id
    GROUP BY
    products.category_id
)
SELECT 
    sellers.store_name, 
    products.category_id, 
    SUM(order_items.unit_price * order_items.quantity) / (SELECT category_revenue FROM categories_revenue WHERE category_id = products.category_id) AS revenue_percentage
FROM
    sellers
    JOIN products ON products.seller_id = sellers.user_id
    JOIN order_items ON order_items.product_id = products.id
GROUP BY sellers.user_id, products.category_id
ORDER BY store_name, category_id;