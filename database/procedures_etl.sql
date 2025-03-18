-- Procedure para popular tabela DIM_TEMPO
CREATE OR REPLACE PROCEDURE CARGA_DIM_TEMPO AS
    v_data DATE := TO_DATE('01/01/2020', 'DD/MM/YYYY');
BEGIN
    FOR i IN 0..1824 LOOP -- 5 anos de datas
        BEGIN
            INSERT INTO DIM_TEMPO (
                ID_TEMPO,
                ANO,
                MES,
                DIA,
                DATA_COMPLETA
            ) VALUES (
                i + 1,
                EXTRACT(YEAR FROM v_data + i),
                EXTRACT(MONTH FROM v_data + i),
                EXTRACT(DAY FROM v_data + i),
                v_data + i
            );
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao inserir data: ' || (v_data + i) || ' - ' || SQLERRM);
        END;
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na carga de DIM_TEMPO: ' || SQLERRM);
        ROLLBACK;
END CARGA_DIM_TEMPO;
/

-- Execução da procedure para popular tabela DIM_TEMPO
EXEC CARGA_DIM_TEMPO;

-- Procedure para popular tabela DIM_CLIENTE
CREATE OR REPLACE PROCEDURE CARGA_DIM_CLIENTE AS
    TYPE t_nomes IS TABLE OF VARCHAR2(50);
    v_nomes t_nomes := t_nomes('Ana', 'Bruno', 'Carlos', 'Daniela', 'Eduardo', 'Fernanda', 'Gabriel', 'Helena', 'Igor', 'Juliana',
                               'Lucas', 'Mariana', 'Natália', 'Otávio', 'Patrícia', 'Rafael', 'Sofia', 'Thiago', 'Vanessa', 'William');
    v_sobrenomes t_nomes := t_nomes('Silva', 'Santos', 'Oliveira', 'Souza', 'Costa', 'Pereira', 'Almeida', 'Lima', 'Gomes', 'Ribeiro',
                                    'Carvalho', 'Ferreira', 'Rodrigues', 'Martins', 'Araújo', 'Mendes', 'Barbosa', 'Cavalcanti', 'Dias', 'Nunes');
    v_nome_completo VARCHAR2(100);
    v_perfil VARCHAR2(50);
BEGIN
    FOR i IN 1..10000 LOOP
        BEGIN
            -- Combinar nome e sobrenome aleatoriamente
            v_nome_completo := v_nomes(FLOOR(DBMS_RANDOM.VALUE(1, v_nomes.COUNT + 1))) || ' ' ||
                              v_sobrenomes(FLOOR(DBMS_RANDOM.VALUE(1, v_sobrenomes.COUNT + 1)));

            -- Escolher perfil de consumo aleatoriamente
            v_perfil := CASE FLOOR(DBMS_RANDOM.VALUE(1, 4))
                           WHEN 1 THEN 'Alto'
                           WHEN 2 THEN 'Médio'
                           ELSE 'Baixo'
                        END;

            INSERT INTO DIM_CLIENTE (
                COD_CLIENTE,
                NOME_CLIENTE,
                PERFIL_CONSUMO
            ) VALUES (
                i,
                v_nome_completo,
                v_perfil
            );
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao inserir cliente ' || i || ': ' || SQLERRM);
        END;
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na carga de DIM_CLIENTE: ' || SQLERRM);
        ROLLBACK;
END CARGA_DIM_CLIENTE;
/

-- Execução da procedure para popular tabela DIM_CLIENTE
EXEC CARGA_DIM_CLIENTE;

-- Procedure para popular tabela DIM_VENDEDOR
CREATE OR REPLACE PROCEDURE CARGA_DIM_VENDEDOR AS
    TYPE t_nomes IS TABLE OF VARCHAR2(50);
    v_nomes t_nomes := t_nomes('André', 'Beatriz', 'Cláudio', 'Débora', 'Elias', 'Fátima', 'Gustavo', 'Isabela', 'João', 'Karine',
                               'Leandro', 'Mônica', 'Nelson', 'Olga', 'Pedro', 'Quitéria', 'Roberto', 'Sandra', 'Tiago', 'Valéria');
    v_sobrenomes t_nomes := t_nomes('Alves', 'Barros', 'Campos', 'Duarte', 'Farias', 'Gonçalves', 'Hernandes', 'Lopes', 'Moraes', 'Nascimento',
                                    'Pinto', 'Rocha', 'Siqueira', 'Teixeira', 'Viana', 'Xavier', 'Zanetti', 'Brito', 'Castro', 'Freitas');
    v_nome_completo VARCHAR2(100);
BEGIN
    FOR i IN 1..100 LOOP
        BEGIN
            -- Combinar nome e sobrenome aleatoriamente
            v_nome_completo := v_nomes(FLOOR(DBMS_RANDOM.VALUE(1, v_nomes.COUNT + 1))) || ' ' ||
                              v_sobrenomes(FLOOR(DBMS_RANDOM.VALUE(1, v_sobrenomes.COUNT + 1)));

            INSERT INTO DIM_VENDEDOR (
                COD_VENDEDOR,
                NOME_VENDEDOR
            ) VALUES (
                i,
                v_nome_completo
            );
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao inserir vendedor ' || i || ': ' || SQLERRM);
        END;
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na carga de DIM_VENDEDOR: ' || SQLERRM);
        ROLLBACK;
END CARGA_DIM_VENDEDOR;
/

-- Execução da procedure para popular tabela DIM_VENDEDOR
EXEC CARGA_DIM_VENDEDOR;

-- Procedure para popular tabela DIM_LOCALIZACAO
CREATE OR REPLACE PROCEDURE CARGA_DIM_LOCALIZACAO AS
    v_seq NUMBER := 1;
BEGIN
    -- Estrutura para inserir cidades por estado
    DECLARE
        TYPE t_cidades IS TABLE OF VARCHAR2(50);
        v_estados t_cidades := t_cidades('AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA',
                                        'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN',
                                        'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'); -- 27 estados
    BEGIN
        -- AC (Acre)
        FOR i IN 1..5 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'AC', CASE i WHEN 1 THEN 'Rio Branco' WHEN 2 THEN 'Cruzeiro do Sul' ELSE 'Sena Madureira' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- AL (Alagoas)
        FOR i IN 1..10 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'AL', CASE i WHEN 1 THEN 'Maceió' WHEN 2 THEN 'Arapiraca' ELSE 'Palmeira dos Índios' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- AP (Amapá)
        FOR i IN 1..5 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'AP', CASE i WHEN 1 THEN 'Macapá' WHEN 2 THEN 'Santana' ELSE 'Laranjal do Jari' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- AM (Amazonas)
        FOR i IN 1..15 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'AM', CASE i WHEN 1 THEN 'Manaus' WHEN 2 THEN 'Parintins' ELSE 'Itacoatiara' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- BA (Bahia)
        FOR i IN 1..30 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'BA', CASE i WHEN 1 THEN 'Salvador' WHEN 2 THEN 'Feira de Santana' WHEN 3 THEN 'Vitória da Conquista' ELSE 'Ilhéus' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- CE (Ceará)
        FOR i IN 1..25 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'CE', CASE i WHEN 1 THEN 'Fortaleza' WHEN 2 THEN 'Juazeiro do Norte' ELSE 'Sobral' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- DF (Distrito Federal)
        FOR i IN 1..20 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'DF', 'Brasília');
            v_seq := v_seq + 1;
        END LOOP;

        -- ES (Espírito Santo)
        FOR i IN 1..15 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'ES', CASE i WHEN 1 THEN 'Vitória' WHEN 2 THEN 'Vila Velha' ELSE 'Cariacica' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- GO (Goiás)
        FOR i IN 1..25 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'GO', CASE i WHEN 1 THEN 'Goiânia' WHEN 2 THEN 'Aparecida de Goiânia' ELSE 'Anápolis' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- MA (Maranhão)
        FOR i IN 1..15 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'MA', CASE i WHEN 1 THEN 'São Luís' WHEN 2 THEN 'Imperatriz' ELSE 'Caxias' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- MT (Mato Grosso)
        FOR i IN 1..15 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'MT', CASE i WHEN 1 THEN 'Cuiabá' WHEN 2 THEN 'Várzea Grande' ELSE 'Rondonópolis' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- MS (Mato Grosso do Sul)
        FOR i IN 1..15 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'MS', CASE i WHEN 1 THEN 'Campo Grande' WHEN 2 THEN 'Dourados' ELSE 'Três Lagoas' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- MG (Minas Gerais)
        FOR i IN 1..50 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'MG', CASE i WHEN 1 THEN 'Belo Horizonte' WHEN 2 THEN 'Uberlândia' WHEN 3 THEN 'Contagem' ELSE 'Juiz de Fora' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- PA (Pará)
        FOR i IN 1..20 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'PA', CASE i WHEN 1 THEN 'Belém' WHEN 2 THEN 'Ananindeua' ELSE 'Santarém' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- PB (Paraíba)
        FOR i IN 1..15 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'PB', CASE i WHEN 1 THEN 'João Pessoa' WHEN 2 THEN 'Campina Grande' ELSE 'Patos' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- PR (Paraná)
        FOR i IN 1..30 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'PR', CASE i WHEN 1 THEN 'Curitiba' WHEN 2 THEN 'Londrina' WHEN 3 THEN 'Maringá' ELSE 'Ponta Grossa' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- PE (Pernambuco)
        FOR i IN 1..25 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'PE', CASE i WHEN 1 THEN 'Recife' WHEN 2 THEN 'Jaboatão dos Guararapes' ELSE 'Olinda' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- PI (Piauí)
        FOR i IN 1..10 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'PI', CASE i WHEN 1 THEN 'Teresina' WHEN 2 THEN 'Parnaíba' ELSE 'Picos' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- RJ (Rio de Janeiro)
        FOR i IN 1..40 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'RJ', CASE i WHEN 1 THEN 'Rio de Janeiro' WHEN 2 THEN 'Niterói' WHEN 3 THEN 'São Gonçalo' ELSE 'Duque de Caxias' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- RN (Rio Grande do Norte)
        FOR i IN 1..15 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'RN', CASE i WHEN 1 THEN 'Natal' WHEN 2 THEN 'Mossoró' ELSE 'Parnamirim' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- RS (Rio Grande do Sul)
        FOR i IN 1..30 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'RS', CASE i WHEN 1 THEN 'Porto Alegre' WHEN 2 THEN 'Caxias do Sul' WHEN 3 THEN 'Pelotas' ELSE 'Canoas' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- RO (Rondônia)
        FOR i IN 1..10 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'RO', CASE i WHEN 1 THEN 'Porto Velho' WHEN 2 THEN 'Ji-Paraná' ELSE 'Ariquemes' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- RR (Roraima)
        FOR i IN 1..5 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'RR', CASE i WHEN 1 THEN 'Boa Vista' WHEN 2 THEN 'Rorainópolis' ELSE 'Caracaraí' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- SC (Santa Catarina)
        FOR i IN 1..25 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'SC', CASE i WHEN 1 THEN 'Florianópolis' WHEN 2 THEN 'Joinville' WHEN 3 THEN 'Blumenau' ELSE 'São José' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- SP (São Paulo)
        FOR i IN 1..60 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'SP', CASE i WHEN 1 THEN 'São Paulo' WHEN 2 THEN 'Campinas' WHEN 3 THEN 'São Bernardo do Campo' ELSE 'Santo André' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- SE (Sergipe)
        FOR i IN 1..10 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'SE', CASE i WHEN 1 THEN 'Aracaju' WHEN 2 THEN 'Nossa Senhora do Socorro' ELSE 'Lagarto' END);
            v_seq := v_seq + 1;
        END LOOP;

        -- TO (Tocantins)
        FOR i IN 1..10 LOOP
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (v_seq, 'TO', CASE i WHEN 1 THEN 'Palmas' WHEN 2 THEN 'Araguaína' ELSE 'Gurupi' END);
            v_seq := v_seq + 1;
        END LOOP;
    END;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na carga de DIM_LOCALIZACAO: ' || SQLERRM);
        ROLLBACK;
END CARGA_DIM_LOCALIZACAO;
/

-- Execução da procedure para popular tabela DIM_LOCALIZACAO
EXEC CARGA_DIM_LOCALIZACAO;

-- Procedure para popular tabela DIM_PRODUTO
CREATE OR REPLACE PROCEDURE CARGA_DIM_PRODUTO AS
    v_cod_produto NUMBER := 1;
BEGIN
    -- Eletrônicos (200 produtos)
    FOR i IN 1..200 LOOP
        BEGIN
            INSERT INTO DIM_PRODUTO (COD_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO)
            VALUES (
                v_cod_produto,
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 'Smartphone Samsung Galaxy S23'
                    WHEN 2 THEN 'Notebook Dell Inspiron 15'
                    WHEN 3 THEN 'TV LED 55" LG 4K'
                    WHEN 4 THEN 'Fone de Ouvido JBL Tune 500'
                    ELSE 'Console PlayStation 5'
                END,
                'Eletrônicos',
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 4500.00
                    WHEN 2 THEN 3500.00
                    WHEN 3 THEN 2800.00
                    WHEN 4 THEN 150.00
                    ELSE 3999.00
                END
            );
            v_cod_produto := v_cod_produto + 1;
        END;
    END LOOP;

    -- Roupas (200 produtos)
    FOR i IN 1..200 LOOP
        BEGIN
            INSERT INTO DIM_PRODUTO (COD_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO)
            VALUES (
                v_cod_produto,
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 'Camiseta Nike Dry-Fit'
                    WHEN 2 THEN 'Calça Jeans Levi''s 501'
                    WHEN 3 THEN 'Tênis Adidas Ultraboost'
                    WHEN 4 THEN 'Jaqueta Columbia Fleece'
                    ELSE 'Vestido Renner Floral'
                END,
                'Roupas',
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 89.90
                    WHEN 2 THEN 199.90
                    WHEN 3 THEN 499.90
                    WHEN 4 THEN 299.90
                    ELSE 129.90
                END
            );
            v_cod_produto := v_cod_produto + 1;
        END;
    END LOOP;

    -- Alimentos (150 produtos)
    FOR i IN 1..150 LOOP
        BEGIN
            INSERT INTO DIM_PRODUTO (COD_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO)
            VALUES (
                v_cod_produto,
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 'Arroz Tio João 5kg'
                    WHEN 2 THEN 'Feijão Camil Preto 1kg'
                    WHEN 3 THEN 'Macarrão Barilla Spaghetti'
                    WHEN 4 THEN 'Azeite Gallo Extra Virgem 500ml'
                    ELSE 'Chocolate Nestlé KitKat'
                END,
                'Alimentos',
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 25.90
                    WHEN 2 THEN 7.50
                    WHEN 3 THEN 8.90
                    WHEN 4 THEN 34.90
                    ELSE 5.50
                END
            );
            v_cod_produto := v_cod_produto + 1;
        END;
    END LOOP;

    -- Móveis (150 produtos)
    FOR i IN 1..150 LOOP
        BEGIN
            INSERT INTO DIM_PRODUTO (COD_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO)
            VALUES (
                v_cod_produto,
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 'Sofá 3 Lugares TokStok'
                    WHEN 2 THEN 'Mesa de Jantar 6 Cadeiras Etna'
                    WHEN 3 THEN 'Cama Box Queen Ortobom'
                    WHEN 4 THEN 'Armário Cozinha Itatiaia'
                    ELSE 'Cadeira Escritório Giratória'
                END,
                'Móveis',
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 1299.90
                    WHEN 2 THEN 1999.90
                    WHEN 3 THEN 899.90
                    WHEN 4 THEN 599.90
                    ELSE 349.90
                END
            );
            v_cod_produto := v_cod_produto + 1;
        END;
    END LOOP;

    -- Livros (100 produtos)
    FOR i IN 1..100 LOOP
        BEGIN
            INSERT INTO DIM_PRODUTO (COD_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO)
            VALUES (
                v_cod_produto,
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 'Livro Harry Potter e a Pedra Filosofal'
                    WHEN 2 THEN 'Livro O Senhor dos Anéis'
                    WHEN 3 THEN 'Livro 1984 - George Orwell'
                    WHEN 4 THEN 'Livro Dom Casmurro'
                    ELSE 'Livro Sapiens - Yuval Harari'
                END,
                'Livros',
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 39.90
                    WHEN 2 THEN 59.90
                    WHEN 3 THEN 34.90
                    WHEN 4 THEN 29.90
                    ELSE 49.90
                END
            );
            v_cod_produto := v_cod_produto + 1;
        END;
    END LOOP;

    -- Esportes, Beleza, Brinquedos, Ferramentas, Automotivo (300 produtos)
    FOR i IN 1..300 LOOP
        BEGIN
            INSERT INTO DIM_PRODUTO (COD_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO)
            VALUES (
                v_cod_produto,
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 'Bola de Futebol Adidas Tango'
                    WHEN 2 THEN 'Perfume Creed Aventus 100ml'
                    WHEN 3 THEN 'Lego Star Wars Millennium Falcon'
                    WHEN 4 THEN 'Kit Ferramentas Bosch 12 Peças'
                    ELSE 'Pneu Pirelli 205/55 R16'
                END,
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 'Esportes'
                    WHEN 2 THEN 'Beleza'
                    WHEN 3 THEN 'Brinquedos'
                    WHEN 4 THEN 'Ferramentas'
                    ELSE 'Automotivo'
                END,
                CASE FLOOR(DBMS_RANDOM.VALUE(1, 6))
                    WHEN 1 THEN 129.90
                    WHEN 2 THEN 799.90
                    WHEN 3 THEN 499.90
                    WHEN 4 THEN 249.90
                    ELSE 179.90
                END
            );
            v_cod_produto := v_cod_produto + 1;
        END;
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na carga de DIM_PRODUTO: ' || SQLERRM);
        ROLLBACK;
END CARGA_DIM_PRODUTO;
/

-- Execução da procedure para popular tabela DIM_PRODUTO
EXEC CARGA_DIM_PRODUTO;

-- Procedure para popular tabela FATO_VENDAS
CREATE OR REPLACE PROCEDURE CARGA_FATO_VENDAS AS
    v_qtd_max NUMBER := 1000000; -- 1 milhão de registros
BEGIN
    FOR i IN 1..v_qtd_max LOOP
        BEGIN
            INSERT INTO FATO_VENDAS (
                ID_VENDA,
                COD_PEDIDO,
                COD_CLIENTE,
                COD_VENDEDOR,
                SEQ_ENDERECO_CLIENTE,
                ID_TEMPO,
                COD_PRODUTO,
                QTD_PRODUTO_VENDIDO,
                VAL_TOTAL_PEDIDO,
                VAL_DESCONTO
            ) VALUES (
                i, -- ID_VENDA sequencial
                i, -- COD_PEDIDO (simulando 1:1 com ID_VENDA por simplicidade)
                FLOOR(DBMS_RANDOM.VALUE(1, 10001)), -- COD_CLIENTE (1 a 10.000)
                FLOOR(DBMS_RANDOM.VALUE(1, 101)), -- COD_VENDEDOR (1 a 100)
                FLOOR(DBMS_RANDOM.VALUE(1, 501)), -- SEQ_ENDERECO_CLIENTE (1 a 500)
                FLOOR(DBMS_RANDOM.VALUE(1, 1826)), -- ID_TEMPO (1 a 1825)
                FLOOR(DBMS_RANDOM.VALUE(1, 1001)), -- COD_PRODUTO (1 a 1000)
                FLOOR(DBMS_RANDOM.VALUE(1, 11)), -- QTD_PRODUTO_VENDIDO (1 a 10 unidades)
                (SELECT PRECO * FLOOR(DBMS_RANDOM.VALUE(1, 11)) FROM DIM_PRODUTO WHERE COD_PRODUTO = FLOOR(DBMS_RANDOM.VALUE(1, 1001))), -- VAL_TOTAL_PEDIDO (preço x quantidade)
                ROUND(DBMS_RANDOM.VALUE(0, 50), 2) -- VAL_DESCONTO (0 a 50 reais)
            );
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao inserir venda ' || i || ': ' || SQLERRM);
        END;
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na carga de FATO_VENDAS: ' || SQLERRM);
        ROLLBACK;
END CARGA_FATO_VENDAS;
/

-- Execução da procedure para popular tabela FATO_VENDAS
EXEC CARGA_FATO_VENDAS;