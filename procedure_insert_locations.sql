CREATE OR REPLACE PROCEDURE insertLocations()
LANGUAGE PLPGSQL
AS
$$
    BEGIN
        INSERT INTO locations (
                loc_name,
                loc_iso_code
            ) 
        SELECT 
            vbl_location, 
            vbl_iso_code 
        FROM 
            vaccines_by_location
        ON CONFLICT 
            (loc_iso_code)
        DO NOTHING;
        COMMIT;
    END;
$$