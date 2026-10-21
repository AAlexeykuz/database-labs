-- Active: 1792611103814@@127.0.0.1@5432@lab3
INSERT INTO
    users (full_name, email)
SELECT 'Имя №' || g, 'email' || g || '@mail.ru'
FROM generate_series(1, 1500) AS g;

INSERT INTO
    sellers (user_id, store_name)
SELECT id, 'Название магазина №' || FLOOR(RANDOM() * 1000000 + 1)::INTEGER
FROM users
ORDER BY RANDOM()
LIMIT 100;

INSERT INTO
    categories (name)
VALUES ('Электроника'),
    ('Книги'),
    ('Одежда');

INSERT INTO
    products (
        seller_id,
        category_id,
        title,
        price
    )
SELECT (
        SELECT user_id
        FROM sellers
        WHERE
            g IS NOT NULL
        ORDER BY RANDOM()
        LIMIT 1
    ), FLOOR(RANDOM() * 3 + 1)::INTEGER, 'Товар №' || FLOOR(RANDOM() * 1000000 + 1)::INTEGER, (RANDOM() * 9000 + 1000)::NUMERIC(12, 2)
FROM generate_series(1, 2000) AS g;

INSERT INTO
    stock (product_id, quantity)
SELECT id, FLOOR(RANDOM() * 101)::INTEGER
FROM products;

INSERT INTO
    carts (user_id)
SELECT (
        SELECT id
        FROM users
        WHERE
            g IS NOT NULL
        ORDER BY RANDOM()
        LIMIT 1
    )
FROM generate_series(1, 1000) AS g;

INSERT INTO
    cart_items (cart_id, product_id, quantity)
SELECT sub.cart_id, sub.product_id, (
        SELECT FLOOR(RANDOM() * quantity + 1)::INTEGER
        FROM stock
        WHERE
            product_id = sub.product_id
    )
FROM (
        SELECT DISTINCT (
                SELECT id
                FROM carts
                WHERE
                    g IS NOT NULL
                ORDER BY RANDOM()
                LIMIT 1
            ) AS cart_id, (
                SELECT id
                FROM products
                WHERE
                    g IS NOT NULL
                ORDER BY RANDOM()
                LIMIT 1
            ) AS product_id
        FROM generate_series(1, 5000) AS g
    ) AS sub;

INSERT INTO
    orders (user_id, status, total_amount)
SELECT id, (
        SELECT val
        FROM (
                VALUES ('Собирается'), ('В доставке'), ('Доставлен'), ('Отменён')
            ) AS t (val)
        WHERE
            id IS NOT NULL
        ORDER BY RANDOM()
        LIMIT 1
    ), (RANDOM() * 29000 + 1000)::NUMERIC(12, 2)
FROM users
ORDER BY RANDOM()
LIMIT 1000;

INSERT INTO
    order_items (
        order_id,
        product_id,
        quantity,
        unit_price
    )
SELECT sub.order_id, sub.product_id, FLOOR(RANDOM() * 100 + 1)::INTEGER, (
        SELECT price
        FROM products
        WHERE
            id = sub.product_id
    )
FROM (
        SELECT DISTINCT (
                SELECT id
                FROM orders
                WHERE
                    g IS NOT NULL
                ORDER BY RANDOM()
                LIMIT 1
            ) AS order_id, (
                SELECT id
                FROM products
                WHERE
                    g IS NOT NULL
                ORDER BY RANDOM()
                LIMIT 1
            ) AS product_id
        FROM generate_series(1, 5000) AS g
    ) AS sub;

INSERT INTO
    payments (order_id, amount, status)
SELECT id, total_amount, 'Успешно'
FROM orders
WHERE
    status = 'Доставлен'

INSERT INTO
    reviews (user_id, product_id, score)
SELECT (
        SELECT id
        FROM users
        WHERE
            g IS NOT NULL
        ORDER BY RANDOM()
        LIMIT 1
    ), (
        SELECT id
        FROM products
        WHERE
            g IS NOT NULL
        ORDER BY RANDOM()
        LIMIT 1
    ), FLOOR(RANDOM() * 5 + 1)::INTEGER
FROM generate_series(1, 1000) AS g;

INSERT INTO
    addresses (
        user_id,
        city,
        street,
        house,
        apartment
    )
SELECT id, 'Город №' || FLOOR(RANDOM() * 1000000 + 1)::INTEGER, 'Улица №' || FLOOR(RANDOM() * 1000000 + 1)::INTEGER, 'Дом' || FLOOR(RANDOM() * 1000000 + 1)::INTEGER, 'Квартира №' || FLOOR(RANDOM() * 1000000 + 1)::INTEGER
FROM users;

INSERT INTO
    deliveries (
        order_id,
        address_id,
        delivery_status
    )
SELECT id, (
        SELECT id
        FROM addresses
        WHERE
            orders.id IS NOT NULL
        ORDER BY RANDOM()
        LIMIT 1
    ), 'Успешно'
FROM orders
WHERE
    status = 'Доставлен';