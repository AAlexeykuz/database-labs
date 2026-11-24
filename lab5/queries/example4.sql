-- 4

CREATE TABLE price_audit (
    product_id BIGINT,
    old_price NUMERIC(12, 2),
    new_price NUMERIC(12, 2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION log_price_chance()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO price_audit
    (product_id, old_price, new_price)
    VALUES
    (NEW.id, OLD.price, NEW.price);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_log_price_chance
AFTER UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION log_price_chance();

UPDATE products SET price = 2000 WHERE id = 1;