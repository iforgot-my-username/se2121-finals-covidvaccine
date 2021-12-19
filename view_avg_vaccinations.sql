CREATE OR REPLACE VIEW avg_vaccinations_per_day AS
    SELECT 
        AVG(vbm_total_vaccinations) as avg_vaccinations,
        loc_iso_code,
        vbm_vaccine
    FROM 
        vaccinations_by_manufacturer 
    INNER JOIN 
        locations 
    ON 
        vbm_location = loc_name 
    GROUP BY  
        loc_iso_code,
        vbm_vaccine
    ORDER BY 
        avg_vaccinations DESC;