CREATE OR REPLACE FUNCTION used_vaccine_per_month()
RETURNS TABLE (
    iso_code CHAR(8),
    vaccines_used TEXT,
    month INT,
    year INT
)
LANGUAGE PLPGSQL
AS $$
DECLARE 
    rec record;    
BEGIN
    DROP TABLE IF EXISTS results;

    CREATE TEMP TABLE results (
    temp_iso_code CHAR(8) NOT NULL, 
    temp_vaccines_used TEXT NOT NULL,
    temp_month INT NOT NULL,
    temp_year INT NOT NULL,
    CONSTRAINT 
        temp_pk PRIMARY KEY (temp_iso_code, temp_month, temp_year)
    );



    FOR rec IN


       SELECT
            loc_iso_code, 
            vbm_vaccine,
            EXTRACT( YEAR FROM vbm_date )::INT as vbm_year, 
            EXTRACT( MONTH FROM vbm_date )::INT as vbm_month 
        FROM 
            vaccinations_by_manufacturer 
        INNER JOIN 
            locations 
        ON 
            vbm_location = loc_name
        GROUP BY 
        vbm_year, vbm_month, loc_iso_code, vbm_vaccine


    LOOP
        INSERT INTO results (
            temp_iso_code, 
            temp_vaccines_used, 
            temp_month, 
            temp_year
            )
        VALUES 
            ( rec.loc_iso_code, rec.vbm_vaccine, rec.vbm_month, rec.vbm_year )
        ON CONFLICT 
        ON CONSTRAINT 
            temp_pk 
        DO UPDATE SET 
            temp_vaccines_used = results.temp_vaccines_used || ', ' || rec.vbm_vaccine;
    END LOOP;

    RETURN QUERY 
        SELECT * FROM  results 
        ORDER BY 
            temp_iso_code, temp_year, temp_month;

    DROP TABLE IF EXISTS results;
    
END;$$
