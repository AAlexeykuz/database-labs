CREATE TABLE average_rating (
    product_id BIGINT NOT NULL UNIQUE REFERENCES products (id),
    avg_rating DECIMAL(3, 2)
);

CREATE OR REPLACE FUNCTION update_average_rating()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO average_rating (product_id, avg_rating) VALUES (NEW.product_id, 2)
    ON CONFLICT DO NOTHING;
    UPDATE average_rating
    SET avg_rating = (SELECT AVG(score) FROM reviews WHERE product_id = NEW.product_id)
    WHERE product_id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql

CREATE OR REPLACE TRIGGER trigger_update_average_rating
AFTER INSERT ON reviews
FOR EACH ROW EXECUTE FUNCTION update_average_rating();

INSERT INTO reviews (user_id, product_id, score) VALUES (1, 1, 3);