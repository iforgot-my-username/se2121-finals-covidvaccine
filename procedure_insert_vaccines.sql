CREATE OR REPLACE PROCEDURE insertVaccines()
LANGUAGE PLPGSQL
AS
$$
    DECLARE
        vacs TEXT;
        vac_bits TEXT[];
        vac TEXT;
    BEGIN
        FOR vacs IN
            SELECT vbl_vaccines
            FROM vaccines_by_location
        LOOP
            SELECT STRING_TO_ARRAY(vacs, ', ') INTO vac_bits;
            FOREACH vac IN ARRAY vac_bits
                LOOP
                INSERT INTO vaccines(vac_name) VALUES (vac)
                ON CONFLICT (vac_name) DO NOTHING;
            END LOOP;
        END LOOP;
    END;
$$



--     CREATE OR REPLACE PROCEDURE insertVaccines()
-- LANGUAGE PLPGSQL
-- AS
-- $$
--     BEGIN
--         INSERT INTO vaccines (
--                 vac_name
--             ) 
--             SELECT 
--                 vbl_vaccines
--             FROM 
--                 vaccines_by_location
--             ON CONFLICT 
--                 (vac_name)
--             DO NOTHING
--         COMMIT;
--     END;
-- $$