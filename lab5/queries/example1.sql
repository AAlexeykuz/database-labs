-- 1

BEGIN;

INSERT INTO
    users (full_name, email)
VALUES ('pon pon', 'email4@gmail.com');

INSERT INTO
    carts (user_id)
SELECT id
FROM users
WHERE
    email = 'email4@gmail.com';

DO $$
BEGIN
    IF COALESCE((SELECT quantity FROM stock WHERE product_id = 1 FOR UPDATE), 0) < 5 THEN
        RAISE EXCEPTION 'Недостаточно товара на складе (id=1)';
    END IF;
END;
$$;

INSERT INTO
    cart_items (cart_id, product_id, quantity)
SELECT c.id, 1, 5
FROM carts c
    JOIN users u ON u.id = c.user_id
WHERE
    u.email = 'email4@gmail.com';

COMMIT;

# 2