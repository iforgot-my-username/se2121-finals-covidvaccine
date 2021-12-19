CREATE OR REPLACE FUNCTION top10_most_vaccinations()
RETURNS TEXT
LANGUAGE PLPGSQL
AS $$
DECLARE 
    rec record;
    result_t text;
    cnt INT;
BEGIN
    DROP TABLE IF EXISTS results ;
    CREATE TEMP TABLE results (
        vac_date DATE,
        location VARCHAR(100) NOT NULL,
        total_vaccinations BIGINT NOT NULL,
        CONSTRAINT 
            res_pk PRIMARY KEY (location)
    );


 

    INSERT INTO 
        results ( vac_date, location, total_vaccinations )
        SELECT 
            vbm_date, vbm_location, SUM (vbm_total_vaccinations) as total_vaccinations
        FROM 
        vaccinations_by_manufacturer 
        GROUP BY (vbm_date, vbm_location )
        ORDER by total_vaccinations DESC
        ON CONFLICT 
        ON CONSTRAINT 
            res_pk 
        DO NOTHING;


    DROP TABLE IF EXISTS loc_total_vacs;
 
    cnt = 0;
    result_t = '';
    FOR rec IN 
        (select * from results LIMIT 10)
    LOOP
         result_t := concat( result_t, 'Top ', 10 - cnt, ' - ', rec.location, ' with ', rec.total_vaccinations, ' vaccinattions on ', rec.vac_date);
        IF (cnt < 9) THEN
            result_t := concat(result_t, E'\n');
        END IF;
        cnt:= cnt + 1;      
    END LOOP;
    DROP TABLE IF EXISTS results;
    RETURN result_t;
END;$$
