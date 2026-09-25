-- seed.sql
-- Rode no EC2 conectado ao RDS: psql -h <ENDPOINT> -U <USER> -d <DB> -f seed.sql

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO orders (customer_name, product, quantity, total) VALUES
    ('Maria Silva', 'Laptop TechNova Pro', 1, 4599.90),
    ('Joao Santos', 'Monitor 27"', 2, 2398.00),
    ('Ana Costa', 'Teclado Mecanico', 3, 897.00);

SELECT * FROM orders;
