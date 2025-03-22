--Criação de Packages Consolidando as Procedures

--Package para carregamento de dados
CREATE OR REPLACE PACKAGE PKG_CARGA_DADOS AS
    PROCEDURE CARGA_TODAS_DIMENSOES;
    PROCEDURE CARGA_DIM_TEMPO(p_data_inicio DATE DEFAULT '01/01/2020', p_anos NUMBER DEFAULT 5);
    PROCEDURE CARGA_DIM_CLIENTE(p_qtd_max NUMBER DEFAULT 10000);
    PROCEDURE CARGA_DIM_VENDEDOR(p_qtd_max NUMBER DEFAULT 100);
    PROCEDURE CARGA_DIM_LOCALIZACAO;
    PROCEDURE CARGA_DIM_PRODUTO(p_qtd_max NUMBER DEFAULT 1000);
    PROCEDURE CARGA_FATO_VENDAS(p_qtd_max NUMBER DEFAULT 1000000);
END PKG_CARGA_DADOS;
/

CREATE OR REPLACE PACKAGE BODY PKG_CARGA_DADOS AS
    PROCEDURE CARGA_TODAS_DIMENSOES IS
    BEGIN
        CARGA_DIM_TEMPO;
        CARGA_DIM_CLIENTE;
        CARGA_DIM_VENDEDOR;
        CARGA_DIM_LOCALIZACAO;
        CARGA_DIM_PRODUTO;
        
        DBMS_OUTPUT.PUT_LINE('Carga completa de dimensões finalizada com sucesso.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro na carga de dimensões: ' || SQLERRM);
            RAISE;
    END CARGA_TODAS_DIMENSOES;

    PROCEDURE CARGA_DIM_TEMPO(p_data_inicio DATE DEFAULT '01/01/2020', p_anos NUMBER DEFAULT 5) IS
        v_data DATE := p_data_inicio;
    BEGIN
        FOR i IN 1..p_anos*365 LOOP
            INSERT INTO DIM_TEMPO (ID_TEMPO, ANO, MES, DIA, DATA_COMPLETA)
            VALUES (i, EXTRACT(YEAR FROM v_data), EXTRACT(MONTH FROM v_data), EXTRACT(DAY FROM v_data), v_data);
            v_data := v_data + 1;
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Carga de DIM_TEMPO concluída.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro na carga de DIM_TEMPO: ' || SQLERRM);
            ROLLBACK;
            RAISE;
    END CARGA_DIM_TEMPO;

    PROCEDURE CARGA_DIM_CLIENTE(p_qtd_max NUMBER DEFAULT 10000) IS
    BEGIN
        FOR i IN 1..p_qtd_max LOOP
            INSERT INTO DIM_CLIENTE (COD_CLIENTE, NOME_CLIENTE, PERFIL_CONSUMO)
            VALUES (i, 'Cliente ' || i, CASE WHEN MOD(i,3) = 0 THEN 'Alto' WHEN MOD(i,3) = 1 THEN 'Médio' ELSE 'Baixo' END);
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Carga de DIM_CLIENTE concluída.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro na carga de DIM_CLIENTE: ' || SQLERRM);
            ROLLBACK;
            RAISE;
    END CARGA_DIM_CLIENTE;

    PROCEDURE CARGA_DIM_VENDEDOR(p_qtd_max NUMBER DEFAULT 100) IS
    BEGIN
        FOR i IN 1..p_qtd_max LOOP
            INSERT INTO DIM_VENDEDOR (COD_VENDEDOR, NOME_VENDEDOR)
            VALUES (i, 'Vendedor ' || i);
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Carga de DIM_VENDEDOR concluída.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro na carga de DIM_VENDEDOR: ' || SQLERRM);
            ROLLBACK;
            RAISE;
    END CARGA_DIM_VENDEDOR;

    PROCEDURE CARGA_DIM_LOCALIZACAO IS
    BEGIN
        FOR i IN 1..27 LOOP -- 27 estados brasileiros
            INSERT INTO DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE, ESTADO, CIDADE)
            VALUES (i, 'UF' || LPAD(i, 2, '0'), 'Cidade ' || i);
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Carga de DIM_LOCALIZACAO concluída.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro na carga de DIM_LOCALIZACAO: ' || SQLERRM);
            ROLLBACK;
            RAISE;
    END CARGA_DIM_LOCALIZACAO;

    PROCEDURE CARGA_DIM_PRODUTO(p_qtd_max NUMBER DEFAULT 1000) IS
    BEGIN
        FOR i IN 1..p_qtd_max LOOP
            INSERT INTO DIM_PRODUTO (COD_PRODUTO, NOME_PRODUTO, CATEGORIA)
            VALUES (i, 'Produto ' || i, 'Categoria ' || MOD(i, 10));
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Carga de DIM_PRODUTO concluída.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro na carga de DIM_PRODUTO: ' || SQLERRM);
            ROLLBACK;
            RAISE;
    END CARGA_DIM_PRODUTO;

    PROCEDURE CARGA_FATO_VENDAS(p_qtd_max NUMBER DEFAULT 1000000) IS
    BEGIN
        FOR i IN 1..p_qtd_max LOOP
            INSERT INTO FATO_VENDAS (
                ID_VENDA, COD_CLIENTE, COD_VENDEDOR, SEQ_ENDERECO_CLIENTE, 
                ID_TEMPO, COD_PRODUTO, QTD_PRODUTO_VENDIDO, VAL_TOTAL_PEDIDO, VAL_DESCONTO
            ) VALUES (
                i, 
                FLOOR(DBMS_RANDOM.VALUE(1, 10001)), -- COD_CLIENTE
                FLOOR(DBMS_RANDOM.VALUE(1, 101)),   -- COD_VENDEDOR
                FLOOR(DBMS_RANDOM.VALUE(1, 28)),    -- SEQ_ENDERECO_CLIENTE
                FLOOR(DBMS_RANDOM.VALUE(1, 1826)),  -- ID_TEMPO
                FLOOR(DBMS_RANDOM.VALUE(1, 1001)),  -- COD_PRODUTO
                FLOOR(DBMS_RANDOM.VALUE(1, 11)),    -- QTD_PRODUTO_VENDIDO
                ROUND(DBMS_RANDOM.VALUE(10, 1000), 2), -- VAL_TOTAL_PEDIDO
                ROUND(DBMS_RANDOM.VALUE(0, 100), 2)    -- VAL_DESCONTO
            );
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Carga de FATO_VENDAS concluída.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro na carga de FATO_VENDAS: ' || SQLERRM);
            ROLLBACK;
            RAISE;
    END CARGA_FATO_VENDAS;

END PKG_CARGA_DADOS;
/


--Package para correções e validações de dados
CREATE OR REPLACE PACKAGE PKG_VALIDACOES_CORRECOES AS
    PROCEDURE CORRIGE_REFERENCIAS_INVALIDAS;
    PROCEDURE VALIDA_DIMENSOES;
END PKG_VALIDACOES_CORRECOES;
/

CREATE OR REPLACE PACKAGE BODY PKG_VALIDACOES_CORRECOES AS
    PROCEDURE CORRIGE_REFERENCIAS_INVALIDAS IS
        v_count NUMBER;
    BEGIN
        -- Correção para DIM_CLIENTE
        UPDATE FATO_VENDAS
        SET COD_CLIENTE = (SELECT MIN(COD_CLIENTE) FROM DIM_CLIENTE)
        WHERE COD_CLIENTE NOT IN (SELECT COD_CLIENTE FROM DIM_CLIENTE);
        v_count := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Corrigidos ' || v_count || ' registros com cliente inválido.');

        -- Correção para DIM_VENDEDOR
        UPDATE FATO_VENDAS
        SET COD_VENDEDOR = (SELECT MIN(COD_VENDEDOR) FROM DIM_VENDEDOR)
        WHERE COD_VENDEDOR NOT IN (SELECT COD_VENDEDOR FROM DIM_VENDEDOR);
        v_count := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Corrigidos ' || v_count || ' registros com vendedor inválido.');

        -- Correção para DIM_LOCALIZACAO
        UPDATE FATO_VENDAS
        SET SEQ_ENDERECO_CLIENTE = (SELECT MIN(SEQ_ENDERECO_CLIENTE) FROM DIM_LOCALIZACAO)
        WHERE SEQ_ENDERECO_CLIENTE NOT IN (SELECT SEQ_ENDERECO_CLIENTE FROM DIM_LOCALIZACAO);
        v_count := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Corrigidos ' || v_count || ' registros com localização inválida.');

        -- Correção para DIM_TEMPO
        UPDATE FATO_VENDAS
        SET ID_TEMPO = (SELECT MIN(ID_TEMPO) FROM DIM_TEMPO)
        WHERE ID_TEMPO NOT IN (SELECT ID_TEMPO FROM DIM_TEMPO);
        v_count := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Corrigidos ' || v_count || ' registros com tempo inválido.');

        -- Correção para DIM_PRODUTO
        UPDATE FATO_VENDAS
        SET COD_PRODUTO = (SELECT MIN(COD_PRODUTO) FROM DIM_PRODUTO)
        WHERE COD_PRODUTO NOT IN (SELECT COD_PRODUTO FROM DIM_PRODUTO);
        v_count := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Corrigidos ' || v_count || ' registros com produto inválido.');

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Erro na correção de referências: ' || SQLERRM);
            RAISE;
    END CORRIGE_REFERENCIAS_INVALIDAS;

    PROCEDURE VALIDA_DIMENSOES IS
        v_count NUMBER;
    BEGIN
        -- Validação para DIM_CLIENTE
        SELECT COUNT(*) INTO v_count
        FROM DIM_CLIENTE
        WHERE COD_CLIENTE IS NULL OR NOME_CLIENTE IS NULL OR PERFIL_CONSUMO IS NULL;
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || v_count || ' registros inválidos em DIM_CLIENTE.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Validação de DIM_CLIENTE concluída com sucesso.');
        END IF;

        -- Validação para DIM_VENDEDOR
        SELECT COUNT(*) INTO v_count
        FROM DIM_VENDEDOR
        WHERE COD_VENDEDOR IS NULL OR NOME_VENDEDOR IS NULL;
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || v_count || ' registros inválidos em DIM_VENDEDOR.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Validação de DIM_VENDEDOR concluída com sucesso.');
        END IF;

        -- Validação para DIM_LOCALIZACAO
        SELECT COUNT(*) INTO v_count
        FROM DIM_LOCALIZACAO
        WHERE SEQ_ENDERECO_CLIENTE IS NULL OR ESTADO IS NULL OR CIDADE IS NULL;
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || v_count || ' registros inválidos em DIM_LOCALIZACAO.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Validação de DIM_LOCALIZACAO concluída com sucesso.');
        END IF;

        -- Validação para DIM_TEMPO
        SELECT COUNT(*) INTO v_count
        FROM DIM_TEMPO
        WHERE ID_TEMPO IS NULL OR ANO IS NULL OR MES IS NULL OR DIA IS NULL OR DATA_COMPLETA IS NULL;
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || v_count || ' registros inválidos em DIM_TEMPO.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Validação de DIM_TEMPO concluída com sucesso.');
        END IF;

        -- Validação para DIM_PRODUTO
        SELECT COUNT(*) INTO v_count
        FROM DIM_PRODUTO
        WHERE COD_PRODUTO IS NULL OR NOME_PRODUTO IS NULL OR CATEGORIA IS NULL;
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || v_count || ' registros inválidos em DIM_PRODUTO.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Validação de DIM_PRODUTO concluída com sucesso.');
        END IF;
    END VALIDA_DIMENSOES;
END PKG_VALIDACOES_CORRECOES;

--Validações da tabela fato
CREATE OR REPLACE PACKAGE PKG_ETL_FATOS AS
    PROCEDURE CARGA_FATO_VENDAS(p_qtd_max NUMBER DEFAULT 1000000);
    PROCEDURE VALIDA_INTEGRIDADE_FATO;
    PROCEDURE CORRIGE_INCONSISTENCIAS_FATO;

    -- Constantes para configuração
    c_batch_size CONSTANT NUMBER := 10000; -- Processar em lotes
END PKG_ETL_FATOS;
/

CREATE OR REPLACE PACKAGE BODY PKG_ETL_FATOS AS
    PROCEDURE CARGA_FATO_VENDAS(p_qtd_max NUMBER DEFAULT 1000000) IS
        v_qtd_inserida NUMBER := 0;
    BEGIN
        FOR i IN 1..CEIL(p_qtd_max/c_batch_size) LOOP
            -- Processar um lote
            INSERT INTO FATO_VENDAS (
                ID_VENDA, COD_CLIENTE, COD_VENDEDOR, SEQ_ENDERECO_CLIENTE, 
                ID_TEMPO, COD_PRODUTO, QTD_PRODUTO_VENDIDO, VAL_TOTAL_PEDIDO, VAL_DESCONTO
            )
            SELECT 
                ROWNUM + v_qtd_inserida,
                FLOOR(DBMS_RANDOM.VALUE(1, 10001)),
                FLOOR(DBMS_RANDOM.VALUE(1, 101)),
                FLOOR(DBMS_RANDOM.VALUE(1, 501)),
                FLOOR(DBMS_RANDOM.VALUE(1, 1826)),
                FLOOR(DBMS_RANDOM.VALUE(1, 1001)),
                FLOOR(DBMS_RANDOM.VALUE(1, 11)),
                ROUND(DBMS_RANDOM.VALUE(10, 1000), 2),
                ROUND(DBMS_RANDOM.VALUE(0, 100), 2)
            FROM 
                DUAL
            CONNECT BY LEVEL <= LEAST(c_batch_size, p_qtd_max - v_qtd_inserida);
            
            v_qtd_inserida := v_qtd_inserida + SQL%ROWCOUNT;
            COMMIT;
            
            DBMS_OUTPUT.PUT_LINE('Processados ' || v_qtd_inserida || ' de ' || p_qtd_max || ' registros');
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('Carga finalizada. Total: ' || v_qtd_inserida || ' registros');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro na carga de FATO_VENDAS: ' || SQLERRM);
            RAISE;
    END CARGA_FATO_VENDAS;

    PROCEDURE VALIDA_INTEGRIDADE_FATO AS
        v_count NUMBER;
    BEGIN
        -- Verificar COD_CLIENTE
        SELECT COUNT(*) INTO v_count
        FROM FATO_VENDAS f
        LEFT JOIN DIM_CLIENTE c ON f.COD_CLIENTE = c.COD_CLIENTE
        WHERE c.COD_CLIENTE IS NULL;
        
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || v_count || ' registros em FATO_VENDAS com COD_CLIENTE inválido.');
        END IF;

        -- Verificar COD_VENDEDOR
        SELECT COUNT(*) INTO v_count
        FROM FATO_VENDAS f
        LEFT JOIN DIM_VENDEDOR v ON f.COD_VENDEDOR = v.COD_VENDEDOR
        WHERE v.COD_VENDEDOR IS NULL;
        
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || v_count || ' registros em FATO_VENDAS com COD_VENDEDOR inválido.');
        END IF;

        -- Verificar SEQ_ENDERECO_CLIENTE
        SELECT COUNT(*) INTO v_count
        FROM FATO_VENDAS f
        LEFT JOIN DIM_LOCALIZACAO l ON f.SEQ_ENDERECO_CLIENTE = l.SEQ_ENDERECO_CLIENTE
        WHERE l.SEQ_ENDERECO_CLIENTE IS NULL;
        
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || v_count || ' registros em FATO_VENDAS com SEQ_ENDERECO_CLIENTE inválido.');
        END IF;

        -- Verificar ID_TEMPO
        SELECT COUNT(*) INTO v_count
        FROM FATO_VENDAS f
        LEFT JOIN DIM_TEMPO t ON f.ID_TEMPO = t.ID_TEMPO
        WHERE t.ID_TEMPO IS NULL;
        
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || v_count || ' registros em FATO_VENDAS com ID_TEMPO inválido.');
        END IF;

        -- Verificar COD_PRODUTO
        SELECT COUNT(*) INTO v_count
        FROM FATO_VENDAS f
        LEFT JOIN DIM_PRODUTO p ON f.COD_PRODUTO = p.COD_PRODUTO
        WHERE p.COD_PRODUTO IS NULL;
        
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || v_count || ' registros em FATO_VENDAS com COD_PRODUTO inválido.');
        END IF;

        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Validação concluída: Nenhum erro de integridade encontrado em FATO_VENDAS.');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro na validação de integridade: ' || SQLERRM);
    END VALIDA_INTEGRIDADE_FATO;

    PROCEDURE CORRIGE_INCONSISTENCIAS_FATO IS
        -- Implementação da correção de inconsistências
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Correção de inconsistências não implementada.');
    END CORRIGE_INCONSISTENCIAS_FATO;

END PKG_ETL_FATOS;

