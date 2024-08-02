CREATE TABLE vendedor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    salario DECIMAL(10, 2)
);

INSERT INTO vendedor (nome, salario) VALUES ('Vinicius Dias', 100);

CREATE FUNCTION dobro_do_salario(vendedor) RETURNS DECIMAL AS $$
    SELECT $1.salario * 2 AS dobro;
$$ LANGUAGE SQL;

SELECT nome, dobro_do_salario(vendedor.*) FROM vendedor;

CREATE OR REPLACE FUNCTION cria_vendedor_falso() RETURNS vendedor AS $$
    SELECT 22, 'Nome falso', 200::DECIMAL;
$$ LANGUAGE SQL;

SELECT cria_vendedor_falso();

SELECT * FROM cria_vendedor_falso(); 

SELECT id, salario FROM cria_vendedor_falso(); 

INSERT INTO vendedor (nome, salario) VALUES ('Carlos Silva', 200);
INSERT INTO vendedor (nome, salario) VALUES ('Ana Pereira', 300);
INSERT INTO vendedor (nome, salario) VALUES ('Pedro Alves', 400);
INSERT INTO vendedor (nome, salario) VALUES ('Maria Costa', 500);

DROP FUNCTION IF EXISTS vendedores_bem_pagos;
CREATE FUNCTION vendedores_bem_pagos(valor_salario DECIMAL) RETURNS TABLE (id INTEGER, nome VARCHAR, salario DECIMAL) AS $$
    SELECT * FROM vendedor WHERE salario > valor_salario;
$$ LANGUAGE SQL;

SELECT * FROM vendedores_bem_pagos(300);

CREATE TYPE dois_valores AS (soma INTEGER, produto INTEGER);

DROP FUNCTION IF EXISTS soma_e_produto;
CREATE FUNCTION soma_e_produto(numero_1 INTEGER, numero_2 INTEGER) RETURNS dois_valores AS $$
    SELECT numero_1 + numero_2 AS soma, numero_1 * numero_2 AS produto;
$$ LANGUAGE SQL;

SELECT * FROM soma_e_produto(3, 3);

DROP FUNCTION IF EXISTS vendedores_bem_pagos;
CREATE FUNCTION vendedores_bem_pagos(valor_salario DECIMAL, OUT nome VARCHAR, OUT salario DECIMAL) RETURNS SETOF record AS $$
    SELECT nome, salario FROM vendedor WHERE salario > valor_salario;
$$ LANGUAGE SQL;

SELECT * FROM vendedores_bem_pagos(300);

CREATE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    SELECT 1;
$$ LANGUAGE plpgsql;

DROP FUNCTION primeira_pl;

CREATE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    BEGIN
        SELECT 1;
    END
$$ LANGUAGE plpgsql;

SELECT primeira_pl();

CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    BEGIN
        RETURN 1;
    END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER DEFAULT 3;
    BEGIN
        RETURN primeira_variavel;
    END
$$ LANGUAGE plpgsql;

SELECT primeira_pl();

CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER DEFAULT 3;
    BEGIN
        primeira_variavel := primeira_variavel * 2;
        RETURN primeira_variavel;
    END
$$ LANGUAGE plpgsql;

SELECT primeira_pl();

CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER = 3;
    BEGIN
        primeira_variavel = primeira_variavel * 2;
        RETURN primeira_variavel;
    END
$$ LANGUAGE plpgsql;

SELECT primeira_pl();

CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER DEFAULT 3;
    BEGIN
        primeira_variavel := primeira_variavel * 2;
        RETURN primeira_variavel;
    END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER DEFAULT 3;
    BEGIN
        primeira_variavel := primeira_variavel * 2;
        DECLARE
            primeira_variavel INTEGER;
        BEGIN
            primeira_variavel := 7;
        END;
        RETURN primeira_variavel;
    END
$$ LANGUAGE plpgsql;

SELECT primeira_pl();

CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER DEFAULT 3;
    BEGIN
        primeira_variavel := primeira_variavel * 2;
        BEGIN
            primeira_variavel := 7;
        END;
        RETURN primeira_variavel;
    END
$$ LANGUAGE plpgsql;

SELECT primeira_pl();

DROP FUNCTION IF EXISTS cria_a;

CREATE TABLE a (
    nome VARCHAR(255) NOT NULL
);

CREATE OR REPLACE FUNCTION cria_a(nome VARCHAR) RETURNS void AS $$
BEGIN
    INSERT INTO a(nome) VALUES('Maria Costa');
END;
$$ LANGUAGE plpgsql;

SELECT cria_a('Vinicius Dias');

DROP FUNCTION IF EXISTS cria_vendedor_falso;

CREATE OR REPLACE FUNCTION cria_vendedor_falso() RETURNS vendedor AS $$
BEGIN
    RETURN ROW(22, 'Nome falso', 200::DECIMAL)::vendedor;
END
$$ LANGUAGE plpgsql;

SELECT id, salario FROM cria_vendedor_falso();

CREATE OR REPLACE FUNCTION cria_vendedor_falso() RETURNS vendedor AS $$
DECLARE
    retorno vendedor;
BEGIN
    SELECT 22, 'Nome falso', 200::DECIMAL INTO retorno;
    RETURN retorno;
END
$$ LANGUAGE plpgsql;

SELECT id, salario FROM cria_vendedor_falso();

DROP FUNCTION IF EXISTS vendedores_bem_pagos;

CREATE FUNCTION vendedores_bem_pagos(valor_salario DECIMAL) RETURNS SETOF vendedor AS $$
BEGIN
    RETURN QUERY SELECT * FROM vendedor WHERE salario > valor_salario;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM vendedores_bem_pagos(300);

DROP FUNCTION IF EXISTS salario_ok;

CREATE FUNCTION salario_ok(id_vendedor INTEGER) RETURNS VARCHAR AS $$
DECLARE
    vendedor vendedor;
BEGIN
    SELECT * FROM vendedor WHERE id = id_vendedor INTO vendedor;
    RETURN CASE
        WHEN vendedor.salario > 300 THEN 'Salário está ótimo'
        WHEN vendedor.salario = 300 THEN 'Salário está ok.'
        WHEN vendedor.salario > 200 THEN 'Salário pode aumentar'
        ELSE 'Salário está defasado'
    END;
END;
$$ LANGUAGE plpgsql;

SELECT nome, salario_ok(vendedor.id) FROM vendedor;

CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF INTEGER AS $$
DECLARE
    multiplicador INTEGER DEFAULT 1;
BEGIN
    LOOP
        RETURN NEXT numero * multiplicador;
        multiplicador := multiplicador + 1;
        EXIT WHEN multiplicador = 10;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS tabuada(integer);

CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF VARCHAR AS $$
DECLARE
    multiplicador INTEGER DEFAULT 1;
BEGIN
    WHILE multiplicador < 10 LOOP
        RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
        multiplicador := multiplicador + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF VARCHAR AS $$
BEGIN
    FOR multiplicador IN 1..9 LOOP
        RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION vendedor_com_salario(OUT nome VARCHAR, OUT salario_ok VARCHAR) RETURNS SETOF record AS $$
DECLARE
    vendedor vendedor;
BEGIN
    FOR vendedor IN SELECT * FROM vendedor LOOP
        nome := vendedor.id;
        salario_ok = salario_ok(vendedor.id);
        RETURN NEXT;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE carro (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(255) NOT NULL,
    data_cadastro DATE NOT NULL
);

CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE estacionamento (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE carro_estacionamento (
    carro_id INTEGER NOT NULL REFERENCES carro(id),
    estacionamento_id INTEGER NOT NULL REFERENCES estacionamento(id),
    PRIMARY KEY (carro_id, estacionamento_id)
);

CREATE FUNCTION cria_estacionamento(nome_estacionamento VARCHAR, nome_categoria VARCHAR) RETURNS void AS $$
DECLARE
    id_categoria INTEGER;
BEGIN
    SELECT id INTO id_categoria FROM categoria WHERE nome = nome_categoria;
    IF NOT FOUND THEN
        INSERT INTO categoria (nome) VALUES (nome_categoria) RETURNING id INTO id_categoria;
    ELSE
        id_categoria := id_categoria;
    END IF;
    INSERT INTO estacionamento (nome, categoria_id) VALUES (nome_estacionamento, id_categoria);
END;
$$ LANGUAGE plpgsql;

SELECT cria_estacionamento('Pista Central', 'carro popular');
SELECT * FROM estacionamento;
SELECT * FROM categoria;
SELECT cria_estacionamento('Garage Norte', 'carro eletrico');
SELECT * FROM estacionamento;

CREATE TABLE log_vendedores (
    id SERIAL PRIMARY KEY,
    informacao VARCHAR(255),
    momento_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE FUNCTION cria_vendedor(nome_vendedor VARCHAR, salario_vendedor DECIMAL) RETURNS void AS $$ 
    DECLARE
        id_vendedor_inserido INTEGER;
        media_salarial DECIMAL;
        vendedor_recebe_menos INTEGER DEFAULT 0;
        total_vendedores INTEGER DEFAULT 0;
        salario DECIMAL;
        percentual DECIMAL;
    BEGIN
        INSERT INTO vendedor (nome, salario) VALUES (nome_vendedor, salario_vendedor) RETURNING id INTO id_vendedor_inserido;
        SELECT AVG(vendedor.salario) INTO media_salarial FROM vendedor WHERE id <> id_vendedor_inserido;
        IF salario_vendedor > media_salarial THEN
            INSERT INTO log_vendedores (informacao) VALUES (nome_vendedor || ' recebe acima da média');
        END IF;
        FOR salario IN SELECT vendedor.salario FROM vendedor WHERE id <> id_vendedor_inserido LOOP
            total_vendedores := total_vendedores + 1;
            IF salario_vendedor > salario THEN
                vendedor_recebe_menos := vendedor_recebe_menos + 1;
            END IF;    
        END LOOP;
        percentual = vendedor_recebe_menos::DECIMAL / total_vendedores::DECIMAL * 100;
        INSERT INTO log_vendedores (informacao) 
            VALUES (nome_vendedor || ' recebe mais do que ' || percentual || '% da grade de vendedores');
    END;
$$ LANGUAGE plpgsql;

SELECT * FROM vendedor;
SELECT cria_vendedor('Fulano de tal', 1000);
SELECT * FROM log_vendedores;
SELECT cria_vendedor('Outro vendedora', 400);
SELECT * FROM log_vendedores;
