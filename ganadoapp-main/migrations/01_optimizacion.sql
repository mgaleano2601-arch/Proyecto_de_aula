-- Ejecutar una vez sobre el esquema existente antes del perfil normal (ddl-auto=validate).
-- El perfil taller genera estas tablas en su base aislada mediante Hibernate.
CREATE TABLE IF NOT EXISTS io_atencion (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 fecha DATE NOT NULL, vacuna_id BIGINT NOT NULL,
 name VARCHAR(120) NOT NULL, topic VARCHAR(60) NOT NULL,
 priority INT NOT NULL, duration_minutes INT NOT NULL,
 UNIQUE KEY uk_io_atencion_fecha (fecha,vacuna_id),
 CHECK (priority BETWEEN 1 AND 3), CHECK (duration_minutes BETWEEN 1 AND 480)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS io_turno (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 fecha DATE NOT NULL, usuario_id BIGINT NOT NULL,
 name VARCHAR(120) NOT NULL, specialty VARCHAR(60) NOT NULL,
 max_capacity INT NOT NULL, available_minutes INT NOT NULL, available BIT NOT NULL,
 UNIQUE KEY uk_io_turno_fecha (fecha,usuario_id),
 CHECK (max_capacity BETWEEN 0 AND 100), CHECK (available_minutes BETWEEN 0 AND 480)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS io_run (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 fecha DATE, creada_en DATETIME(6), request_json LONGTEXT, response_json LONGTEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
