CREATE TABLE clients (
                         id SERIAL PRIMARY KEY,
                         service_name TEXT NOT NULL,
                         username TEXT NOT NULL UNIQUE,
                         password TEXT NOT NULL,
                         pass_key VARCHAR(64) NOT NULL CHECK (char_length(pass_key) = 64),
                         active BOOLEAN DEFAULT TRUE,
                         last_update_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE services (
                          id SERIAL PRIMARY KEY,
                          client_id INTEGER NOT NULL,
                          endpoint TEXT NOT NULL,
                          method VARCHAR(10) CHECK (method IN ('GET', 'POST', 'PUT', 'DELETE', 'PATCH')),
                          FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);

CREATE VIEW registered_services AS
SELECT
    c.id AS client_id,
    c.service_name,
    c.active,
    c.last_update_dt,
    s.endpoint,
    s.method
FROM
    clients c
        JOIN
    services s ON s.client_id = c.id;