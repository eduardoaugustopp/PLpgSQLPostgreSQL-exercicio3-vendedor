PGDMP  )    3                |            veiculo    16.3    16.3 <    /           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            0           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            1           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            2           1262    16793    veiculo    DATABASE     ~   CREATE DATABASE veiculo WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE veiculo;
                postgres    false            b           1247    16812    dois_valores    TYPE     H   CREATE TYPE public.dois_valores AS (
	soma integer,
	produto integer
);
    DROP TYPE public.dois_valores;
       public          postgres    false            �            1255    16819    cria_a(character varying)    FUNCTION     �   CREATE FUNCTION public.cria_a(nome character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO a(nome) VALUES('Maria Costa');
    END;
$$;
 5   DROP FUNCTION public.cria_a(nome character varying);
       public          postgres    false            �            1255    16880 9   cria_estacionamento(character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.cria_estacionamento(nome_estacionamento character varying, nome_categoria character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    id_categoria INTEGER;
BEGIN
    -- Verifica se a categoria existe
    SELECT id INTO id_categoria FROM categoria WHERE nome = nome_categoria;

    -- Se não encontrou a categoria, insere uma nova categoria
    IF NOT FOUND THEN
        INSERT INTO categoria (nome) VALUES (nome_categoria) RETURNING id INTO id_categoria;
    ELSE
        -- Se encontrou a categoria, usa o id encontrado
        id_categoria := id_categoria;
    END IF;

    -- Insere o estacionamento com a categoria
    INSERT INTO estacionamento (nome, categoria_id) VALUES (nome_estacionamento, id_categoria);
END;
$$;
 s   DROP FUNCTION public.cria_estacionamento(nome_estacionamento character varying, nome_categoria character varying);
       public          postgres    false            �            1255    16881 )   cria_vendedor(character varying, numeric)    FUNCTION     H  CREATE FUNCTION public.cria_vendedor(nome_vendedor character varying, salario_vendedor numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
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
$$;
 _   DROP FUNCTION public.cria_vendedor(nome_vendedor character varying, salario_vendedor numeric);
       public          postgres    false            �            1259    16795    vendedor    TABLE        CREATE TABLE public.vendedor (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    salario numeric(10,2)
);
    DROP TABLE public.vendedor;
       public         heap    postgres    false            �            1255    16802    cria_vendedor_falso()    FUNCTION     �   CREATE FUNCTION public.cria_vendedor_falso() RETURNS public.vendedor
    LANGUAGE plpgsql
    AS $$ 
    DECLARE
        retorno vendedor;
    BEGIN
       SELECT 22, 'Nome falso', 200::DECIMAL INTO retorno; 

       RETURN retorno;
    END
$$;
 ,   DROP FUNCTION public.cria_vendedor_falso();
       public          postgres    false    216            �            1255    16801 !   dobro_do_salario(public.vendedor)    FUNCTION     �   CREATE FUNCTION public.dobro_do_salario(public.vendedor) RETURNS numeric
    LANGUAGE sql
    AS $_$ 
    SELECT $1.salario * 2 AS dobro;
$_$;
 8   DROP FUNCTION public.dobro_do_salario(public.vendedor);
       public          postgres    false    216            �            1255    16816    primeira_pl()    FUNCTION     <  CREATE FUNCTION public.primeira_pl() RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
    DECLARE 
        primeira_variavel INTEGER DEFAULT 3;
    BEGIN
        primeira_variavel := primeira_variavel * 2;

        BEGIN
            primeira_variavel := 7;
        END;

        RETURN primeira_variavel;
    END
$$;
 $   DROP FUNCTION public.primeira_pl();
       public          postgres    false            �            1255    16830    salario_ok(integer)    FUNCTION       CREATE FUNCTION public.salario_ok(id_vendedor integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    vendedor RECORD;
BEGIN
    SELECT * FROM vendedor WHERE id = id_vendedor INTO vendedor;

    RETURN CASE
        WHEN vendedor.salario > 300 THEN
            'Salário está ótimo'
        WHEN vendedor.salario = 300 THEN
            'Salário está ok.'
        WHEN vendedor.salario > 200 THEN
            'Salário pode aumentar'
        ELSE
            'Salário está defasado'
    END;
END;
$$;
 6   DROP FUNCTION public.salario_ok(id_vendedor integer);
       public          postgres    false            �            1255    16809     soma_e_produto(integer, integer)    FUNCTION     �   CREATE FUNCTION public.soma_e_produto(numero_1 integer, numero_2 integer, OUT soma integer, OUT produto integer) RETURNS record
    LANGUAGE sql
    AS $$
    SELECT numero_1 + numero_2 AS soma, numero_1 * numero_2 AS produto;
$$;
 p   DROP FUNCTION public.soma_e_produto(numero_1 integer, numero_2 integer, OUT soma integer, OUT produto integer);
       public          postgres    false            �            1255    16832    tabuada(integer)    FUNCTION       CREATE FUNCTION public.tabuada(numero integer) RETURNS SETOF character varying
    LANGUAGE plpgsql
    AS $$ 
    BEGIN  
        FOR multiplicador IN 1..9 LOOP
            RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
        END LOOP;
    END;
$$;
 .   DROP FUNCTION public.tabuada(numero integer);
       public          postgres    false            �            1255    16833    vendedor_com_salario()    FUNCTION     �  CREATE FUNCTION public.vendedor_com_salario(OUT nome character varying, OUT salario_ok character varying) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
    DECLARE
        vendedor vendedor;
    BEGIN  
        FOR vendedor IN SELECT * FROM vendedor LOOP
            nome := vendedor.id;
            salario_ok = salario_ok(vendedor.id);

            RETURN NEXT;
        END LOOP;
    END;
$$;
 i   DROP FUNCTION public.vendedor_com_salario(OUT nome character varying, OUT salario_ok character varying);
       public          postgres    false            �            1255    16823    vendedores_bem_pagos(numeric)    FUNCTION     �   CREATE FUNCTION public.vendedores_bem_pagos(valor_salario numeric) RETURNS SETOF public.vendedor
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY SELECT * FROM vendedor WHERE salario > valor_salario;
    END;
$$;
 B   DROP FUNCTION public.vendedores_bem_pagos(valor_salario numeric);
       public          postgres    false    216            �            1259    16820    a    TABLE     D   CREATE TABLE public.a (
    nome character varying(255) NOT NULL
);
    DROP TABLE public.a;
       public         heap    postgres    false            �            1259    16835    carro    TABLE     �   CREATE TABLE public.carro (
    id integer NOT NULL,
    titulo character varying(255) NOT NULL,
    autor character varying(255) NOT NULL,
    data_cadastro date NOT NULL
);
    DROP TABLE public.carro;
       public         heap    postgres    false            �            1259    16864    carro_estacionamento    TABLE     t   CREATE TABLE public.carro_estacionamento (
    carro_id integer NOT NULL,
    estacionamento_id integer NOT NULL
);
 (   DROP TABLE public.carro_estacionamento;
       public         heap    postgres    false            �            1259    16834    carro_id_seq    SEQUENCE     �   CREATE SEQUENCE public.carro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.carro_id_seq;
       public          postgres    false    220            3           0    0    carro_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.carro_id_seq OWNED BY public.carro.id;
          public          postgres    false    219            �            1259    16844 	   categoria    TABLE     e   CREATE TABLE public.categoria (
    id integer NOT NULL,
    nome character varying(255) NOT NULL
);
    DROP TABLE public.categoria;
       public         heap    postgres    false            �            1259    16843    categoria_id_seq    SEQUENCE     �   CREATE SEQUENCE public.categoria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.categoria_id_seq;
       public          postgres    false    222            4           0    0    categoria_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.categoria_id_seq OWNED BY public.categoria.id;
          public          postgres    false    221            �            1259    16853    estacionamento    TABLE     �   CREATE TABLE public.estacionamento (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    categoria_id integer NOT NULL
);
 "   DROP TABLE public.estacionamento;
       public         heap    postgres    false            �            1259    16852    estacionamento_id_seq    SEQUENCE     �   CREATE SEQUENCE public.estacionamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.estacionamento_id_seq;
       public          postgres    false    224            5           0    0    estacionamento_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.estacionamento_id_seq OWNED BY public.estacionamento.id;
          public          postgres    false    223            �            1259    16883    log_vendedores    TABLE     �   CREATE TABLE public.log_vendedores (
    id integer NOT NULL,
    informacao character varying(255),
    momento_criacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
 "   DROP TABLE public.log_vendedores;
       public         heap    postgres    false            �            1259    16882    log_vendedores_id_seq    SEQUENCE     �   CREATE SEQUENCE public.log_vendedores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.log_vendedores_id_seq;
       public          postgres    false    227            6           0    0    log_vendedores_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.log_vendedores_id_seq OWNED BY public.log_vendedores.id;
          public          postgres    false    226            �            1259    16794    vendedor_id_seq    SEQUENCE     �   CREATE SEQUENCE public.vendedor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.vendedor_id_seq;
       public          postgres    false    216            7           0    0    vendedor_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.vendedor_id_seq OWNED BY public.vendedor.id;
          public          postgres    false    215            |           2604    16838    carro id    DEFAULT     d   ALTER TABLE ONLY public.carro ALTER COLUMN id SET DEFAULT nextval('public.carro_id_seq'::regclass);
 7   ALTER TABLE public.carro ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219    220            }           2604    16847    categoria id    DEFAULT     l   ALTER TABLE ONLY public.categoria ALTER COLUMN id SET DEFAULT nextval('public.categoria_id_seq'::regclass);
 ;   ALTER TABLE public.categoria ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    222    222            ~           2604    16856    estacionamento id    DEFAULT     v   ALTER TABLE ONLY public.estacionamento ALTER COLUMN id SET DEFAULT nextval('public.estacionamento_id_seq'::regclass);
 @   ALTER TABLE public.estacionamento ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223    224                       2604    16886    log_vendedores id    DEFAULT     v   ALTER TABLE ONLY public.log_vendedores ALTER COLUMN id SET DEFAULT nextval('public.log_vendedores_id_seq'::regclass);
 @   ALTER TABLE public.log_vendedores ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226    227            {           2604    16798    vendedor id    DEFAULT     j   ALTER TABLE ONLY public.vendedor ALTER COLUMN id SET DEFAULT nextval('public.vendedor_id_seq'::regclass);
 :   ALTER TABLE public.vendedor ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215    216            #          0    16820    a 
   TABLE DATA           !   COPY public.a (nome) FROM stdin;
    public          postgres    false    218   }Q       %          0    16835    carro 
   TABLE DATA           A   COPY public.carro (id, titulo, autor, data_cadastro) FROM stdin;
    public          postgres    false    220   �Q       *          0    16864    carro_estacionamento 
   TABLE DATA           K   COPY public.carro_estacionamento (carro_id, estacionamento_id) FROM stdin;
    public          postgres    false    225   �Q       '          0    16844 	   categoria 
   TABLE DATA           -   COPY public.categoria (id, nome) FROM stdin;
    public          postgres    false    222   �Q       )          0    16853    estacionamento 
   TABLE DATA           @   COPY public.estacionamento (id, nome, categoria_id) FROM stdin;
    public          postgres    false    224   R       ,          0    16883    log_vendedores 
   TABLE DATA           I   COPY public.log_vendedores (id, informacao, momento_criacao) FROM stdin;
    public          postgres    false    227   XR       "          0    16795    vendedor 
   TABLE DATA           5   COPY public.vendedor (id, nome, salario) FROM stdin;
    public          postgres    false    216   �R       8           0    0    carro_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.carro_id_seq', 1, false);
          public          postgres    false    219            9           0    0    categoria_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.categoria_id_seq', 2, true);
          public          postgres    false    221            :           0    0    estacionamento_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.estacionamento_id_seq', 2, true);
          public          postgres    false    223            ;           0    0    log_vendedores_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.log_vendedores_id_seq', 3, true);
          public          postgres    false    226            <           0    0    vendedor_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.vendedor_id_seq', 9, true);
          public          postgres    false    215            �           2606    16868 .   carro_estacionamento carro_estacionamento_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.carro_estacionamento
    ADD CONSTRAINT carro_estacionamento_pkey PRIMARY KEY (carro_id, estacionamento_id);
 X   ALTER TABLE ONLY public.carro_estacionamento DROP CONSTRAINT carro_estacionamento_pkey;
       public            postgres    false    225    225            �           2606    16842    carro carro_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.carro
    ADD CONSTRAINT carro_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.carro DROP CONSTRAINT carro_pkey;
       public            postgres    false    220            �           2606    16851    categoria categoria_nome_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_nome_key UNIQUE (nome);
 F   ALTER TABLE ONLY public.categoria DROP CONSTRAINT categoria_nome_key;
       public            postgres    false    222            �           2606    16849    categoria categoria_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.categoria DROP CONSTRAINT categoria_pkey;
       public            postgres    false    222            �           2606    16858 "   estacionamento estacionamento_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.estacionamento
    ADD CONSTRAINT estacionamento_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.estacionamento DROP CONSTRAINT estacionamento_pkey;
       public            postgres    false    224            �           2606    16889 "   log_vendedores log_vendedores_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.log_vendedores
    ADD CONSTRAINT log_vendedores_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.log_vendedores DROP CONSTRAINT log_vendedores_pkey;
       public            postgres    false    227            �           2606    16800    vendedor vendedor_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.vendedor
    ADD CONSTRAINT vendedor_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.vendedor DROP CONSTRAINT vendedor_pkey;
       public            postgres    false    216            �           2606    16869 7   carro_estacionamento carro_estacionamento_carro_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.carro_estacionamento
    ADD CONSTRAINT carro_estacionamento_carro_id_fkey FOREIGN KEY (carro_id) REFERENCES public.carro(id);
 a   ALTER TABLE ONLY public.carro_estacionamento DROP CONSTRAINT carro_estacionamento_carro_id_fkey;
       public          postgres    false    220    225    4740            �           2606    16874 @   carro_estacionamento carro_estacionamento_estacionamento_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.carro_estacionamento
    ADD CONSTRAINT carro_estacionamento_estacionamento_id_fkey FOREIGN KEY (estacionamento_id) REFERENCES public.estacionamento(id);
 j   ALTER TABLE ONLY public.carro_estacionamento DROP CONSTRAINT carro_estacionamento_estacionamento_id_fkey;
       public          postgres    false    224    4746    225            �           2606    16859 /   estacionamento estacionamento_categoria_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estacionamento
    ADD CONSTRAINT estacionamento_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES public.categoria(id);
 Y   ALTER TABLE ONLY public.estacionamento DROP CONSTRAINT estacionamento_categoria_id_fkey;
       public          postgres    false    222    224    4744            #      x��M,�LTp�/.I����� 2��      %      x������ � �      *      x������ � �      '   (   x�3�LN,*�W(�/(�I,�2��SsRK�2��b���� �)�      )   0   x�3��,.ITpN�+)J��4�2�tO,JLOU��/*I�4����� �       ,   �   x���1�0�99���D�!�8 k/��%V	�H��s�b�K��K�?��g՘g^#x��gH2�U���0x����!5��vh��v��;�^Syaᰁ�p��`�N��hy����$�/�V缧�������3�F]�/Fk�,]P.      "   �   x�-ͻ
1F���S�,�h��؉���`�	$�<�����sz<5�[K��rFomg��r�1�C}eMG,�i�$�c�	��i�U2��3n��i�yg�O��!���_??�^��P%8q�H�+���@+     