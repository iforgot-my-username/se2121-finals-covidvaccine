CREATE TABLE locations (
    loc_name VARCHAR(100) NOT NULL,
    loc_iso_code CHAR(8) NOT NULL PRIMARY KEY
);

CREATE TABLE vaccines (
    vac_name TEXT NOT NULL PRIMARY KEY
);


CREATE TABLE vaccinations_by_manufacturer (
    vbm_id BIGSERIAL NOT NULL PRIMARY KEY,
    vbm_location VARCHAR(100) NOT NULL,
    vbm_date DATE NOT NULL,
    vbm_vaccine TEXT NOT NULL,
    vbm_total_vaccinations BIGINT NOT NULL
);

CREATE TABLE vaccines_by_location (
    vbl_id BIGSERIAL PRIMARY KEY NOT NULL,
    vbl_location VARCHAR(100) NOT NULL,
    vbl_iso_code CHAR(8) NOT NULL,
    vbl_vaccines TEXT NOT NULL,
    vbl_last_observation_date DATE NOT NULL,
    vbl_source_name TEXT NOT NULL,
    vbl_source_website TEXT NOT NULL
);