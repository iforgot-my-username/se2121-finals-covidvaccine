CREATE OR REPLACE FUNCTION total_vaccinations( 
    loc_name VARCHAR(100), 
    vac_date CHAR(7) 
)
RETURNS TEXT
LANGUAGE PLPGSQL
AS $$
DECLARE 
    date_input DATE := TO_DATE (vac_date, 'YYYY-MM');
    rec record;
    result_t text;
    cnt INT;
    rows_cnt INT;
BEGIN
    IF NOT EXISTS( SELECT * FROM vaccinations_by_manufacturer WHERE vbm_location = loc_name ) THEN
        return 'Country not found';

    ELSIF NOT (SELECT vac_date SIMILAR TO '\d{4}-(0[1-9]|1[0-2])') THEN
        return 'Date is invalid';
        
    ELSE
        DROP TABLE IF EXISTS results;

        CREATE TEMP TABLE results (
            vaccine TEXT PRIMARY KEY NOT NULL,
            total_vaccinations BIGINT NOT NULL
        );

        FOR rec IN
            ( SELECT 
                vbm_vaccine,
                vbm_total_vaccinations
            FROM 
                vaccinations_by_manufacturer 
            WHERE
                vac_date = TO_char(vbm_date, 'YYYY-MM')
                AND vbm_location = loc_name)
        LOOP
            INSERT INTO 
                results ( vaccine, total_vaccinations ) 
            VALUES
                (rec.vbm_vaccine, rec.vbm_total_vaccinations)
            ON CONFLICT (vaccine)
            DO UPDATE SET 
                total_vaccinations = results.total_vaccinations + rec.vbm_total_vaccinations;
        END LOOP;


        SELECT 
            COUNT(*) 
        INTO rows_cnt  
        FROM results;

        IF rows_cnt < 1 THEN
            RETURN 'Date is invalid';
        END IF;

        result_t := TO_CHAR(date_input, 'Mon.') || EXTRACT(YEAR FROM date_input) || ': ';
        cnt := 1; 

        FOR rec IN 
            (SELECT * FROM results)
        LOOP
            IF (cnt < rows_cnt AND cnt > 1) THEN
                result_t := result_t || ', ';
            ELSIF (cnt > 1) THEN
                result_t := result_t || ', and ';
            END IF;
            result_t := result_t || rec.vaccine|| ' has ' ||  rec.total_vaccinations || ' vaccinations';
            cnt:= cnt + 1;      
        END LOOP;
        RETURN result_t;

    END IF;
    DROP TABLE IF EXISTS results;
END;$$
