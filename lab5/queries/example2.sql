-- Active: 1795546852266@@127.0.0.1@5432@lab5
-- 2

CREATE OR REPLACE FUNCTION place_order(p_cart_id BIGINT)
RETURNS void AS $$
DECLARE
    v_order_id BIGINT;
    v_order_price NUMERIC(12, 2) := 0;
    v_product_price NUMERIC(12, 2) := 0;
    item RECORD;
BEGIN

    INSERT INTO orders (user_id, status, total_amount)
    VALUES (
        (SELECT user_id FROM carts WHERE id = p_cart_id), 
        'Оформлен', 
        1)
    RETURNING id INTO v_order_id;

    FOR item IN (
        SELECT cart_items.product_id, cart_items.quantity FROM cart_items WHERE cart_items.cart_id = p_cart_id
    ) LOOP
        IF (SELECT stock.quantity FROM stock WHERE stock.product_id = item.product_id) <= item.quantity THEN
            RAISE EXCEPTION 'Недостаточно товара на складе (id=%)', item.product_id;
        END IF;

        v_product_price := (SELECT price FROM products WHERE products.id = item.product_id);

        INSERT INTO
            order_items (order_id, product_id, quantity, unit_price)
        VALUES
            (v_order_id, item.product_id, item.quantity, v_product_price);
            
        v_order_price := v_order_price + item.quantity * v_product_price;
    END LOOP;
    DELETE FROM cart_items WHERE cart_id = p_cart_id;
    UPDATE orders SET total_amount = v_order_price WHERE id = v_order_id;
END;
$$ LANGUAGE plpgsql;

SELECT place_order (212);