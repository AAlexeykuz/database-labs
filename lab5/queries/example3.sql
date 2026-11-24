-- 3

CREATE OR REPLACE FUNCTION average_rating(p_product_id BIGINT)
RETURNS DECIMAL AS $$
DECLARE
    v_average_rating DECIMAL(3, 2);
BEGIN
    SELECT ROUND(AVG(reviews.score), 2)
    INTO v_average_rating
    FROM reviews
    WHERE
        reviews.product_id = p_product_id;
    RETURN v_average_rating;
END;
$$ LANGUAGE plpgsql;

SELECT average_rating (1289);