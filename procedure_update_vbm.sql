CREATE OR REPLACE PROCEDURE update_vbm(
    param_location VARCHAR(100),
    param_date DATE,
    param_vaccine TEXT,
    param_total_vaccinations BIGINT
)
LANGUAGE PLPGSQL
AS
$$
    BEGIN
        UPDATE vaccinations_by_manufacturer
        SET 
            vbm_total_vaccinations = param_total_vaccinations
        WHERE 
            LOWER(vbm_location) = LOWER(param_location) AND
            vbm_date = param_date AND
            LOWER(vbm_vaccine) = LOWER(param_vaccine);            
        COMMIT;
    END;
$$