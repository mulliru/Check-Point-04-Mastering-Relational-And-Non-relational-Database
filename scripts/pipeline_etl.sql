--Refatorar as Procedures Existentes
CREATE OR REPLACE PROCEDURE CORRIGE_DADOS_CLIENTE AS
  CURSOR c_clientes IS 
    SELECT COD_CLIENTE, NOME_CLIENTE, PERFIL_CONSUMO
    FROM DIM_CLIENTE
    FOR UPDATE OF NOME_CLIENTE, PERFIL_CONSUMO;
  
  v_nome_cliente VARCHAR2(100);
  v_perfil_consumo VARCHAR2(50);
BEGIN
  FOR r_cliente IN c_clientes LOOP
    -- Normalizar nome (capitalize primeira letra de cada palavra)
    v_nome_cliente := INITCAP(TRIM(r_cliente.NOME_CLIENTE));
    
    -- Validar e corrigir perfil de consumo
    v_perfil_consumo := UPPER(TRIM(r_cliente.PERFIL_CONSUMO));
    IF v_perfil_consumo NOT IN ('ALTO', 'M�DIO', 'BAIXO') THEN
      v_perfil_consumo := 'M�DIO'; -- valor padr�o
    END IF;
    
    -- Atualizar o registro se houve altera��es
    IF v_nome_cliente != r_cliente.NOME_CLIENTE OR v_perfil_consumo != r_cliente.PERFIL_CONSUMO THEN
      UPDATE DIM_CLIENTE
      SET NOME_CLIENTE = v_nome_cliente,
          PERFIL_CONSUMO = v_perfil_consumo
      WHERE CURRENT OF c_clientes;
      
      DBMS_OUTPUT.PUT_LINE('Cliente ' || r_cliente.COD_CLIENTE || ' atualizado.');
    END IF;
  END LOOP;
  
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Corre��o de dados conclu�da.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Erro ao corrigir dados: ' || SQLERRM);
END CORRIGE_DADOS_CLIENTE;

EXEC CORRIGE_DADOS_CLIENTE;

--Valida��o de dados
CREATE OR REPLACE PROCEDURE VALIDAR_DADOS AS
    -- Cursor para UF na DIM_LOCALIZACAO
    CURSOR c_uf IS 
        SELECT ESTADO 
        FROM DIM_LOCALIZACAO;
    
    -- Cursor para datas na DIM_TEMPO
    CURSOR c_data IS 
        SELECT DATA_COMPLETA 
        FROM DIM_TEMPO;
    
    v_uf_valida BOOLEAN;
    v_id_tempo NUMBER;
    v_count NUMBER;
BEGIN
    -- Validar UFs existentes na DIM_LOCALIZACAO
    DBMS_OUTPUT.PUT_LINE('Validando UFs...');
    FOR r_uf IN c_uf LOOP
        SELECT COUNT(*) INTO v_count
        FROM DIM_LOCALIZACAO
        WHERE UPPER(TRIM(ESTADO)) = UPPER(TRIM(r_uf.ESTADO));
        
        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: UF ' || r_uf.ESTADO || ' n�o encontrada.');
        END IF;
    END LOOP;

    -- Validar datas na DIM_TEMPO
    DBMS_OUTPUT.PUT_LINE('Validando datas...');
    FOR r_data IN c_data LOOP
        BEGIN
            SELECT ID_TEMPO INTO v_id_tempo
            FROM DIM_TEMPO
            WHERE DATA_COMPLETA = TRUNC(r_data.DATA_COMPLETA);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Erro: Data ' || r_data.DATA_COMPLETA || ' n�o encontrada.');
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Valida��o conclu�da.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na valida��o de dados: ' || SQLERRM);
END VALIDAR_DADOS;


EXEC VALIDAR_DADOS;

--Corrigindo refer�ncias erradas
CREATE OR REPLACE PROCEDURE CORRIGE_REFERENCIAS_INVALIDAS AS
    v_count_cliente NUMBER := 0;
    v_count_vendedor NUMBER := 0;
    v_count_localizacao NUMBER := 0;
    v_count_tempo NUMBER := 0;
    v_count_produto NUMBER := 0;
BEGIN
    -- Corrigir clientes inv�lidos
    UPDATE FATO_VENDAS
    SET COD_CLIENTE = (SELECT MIN(COD_CLIENTE) FROM DIM_CLIENTE)
    WHERE COD_CLIENTE NOT IN (SELECT COD_CLIENTE FROM DIM_CLIENTE);
    
    v_count_cliente := SQL%ROWCOUNT;
    
    IF v_count_cliente > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Corrigidos ' || v_count_cliente || ' registros com cliente inv�lido');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nenhum registro de cliente inv�lido encontrado');
    END IF;

    -- Corrigir vendedores inv�lidos
    UPDATE FATO_VENDAS
    SET COD_VENDEDOR = (SELECT MIN(COD_VENDEDOR) FROM DIM_VENDEDOR)
    WHERE COD_VENDEDOR NOT IN (SELECT COD_VENDEDOR FROM DIM_VENDEDOR);
    
    v_count_vendedor := SQL%ROWCOUNT;
    
    IF v_count_vendedor > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Corrigidos ' || v_count_vendedor || ' registros com vendedor inv�lido');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nenhum registro de vendedor inv�lido encontrado');
    END IF;

    -- Corrigir localiza��es inv�lidas
    UPDATE FATO_VENDAS
    SET SEQ_ENDERECO_CLIENTE = (SELECT MIN(SEQ_ENDERECO_CLIENTE) FROM DIM_LOCALIZACAO)
    WHERE SEQ_ENDERECO_CLIENTE NOT IN (SELECT SEQ_ENDERECO_CLIENTE FROM DIM_LOCALIZACAO);
    
    v_count_localizacao := SQL%ROWCOUNT;
    
    IF v_count_localizacao > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Corrigidos ' || v_count_localizacao || ' registros com localiza��o inv�lida');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nenhum registro de localiza��o inv�lida encontrado');
    END IF;

    -- Corrigir tempos inv�lidos
    UPDATE FATO_VENDAS
    SET ID_TEMPO = (SELECT MIN(ID_TEMPO) FROM DIM_TEMPO)
    WHERE ID_TEMPO NOT IN (SELECT ID_TEMPO FROM DIM_TEMPO);
    
    v_count_tempo := SQL%ROWCOUNT;
    
    IF v_count_tempo > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Corrigidos ' || v_count_tempo || ' registros com tempo inv�lido');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nenhum registro de tempo inv�lido encontrado');
    END IF;

    -- Corrigir produtos inv�lidos
    UPDATE FATO_VENDAS
    SET COD_PRODUTO = (SELECT MIN(COD_PRODUTO) FROM DIM_PRODUTO)
    WHERE COD_PRODUTO NOT IN (SELECT COD_PRODUTO FROM DIM_PRODUTO);
    
    v_count_produto := SQL%ROWCOUNT;
    
    IF v_count_produto > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Corrigidos ' || v_count_produto || ' registros com produto inv�lido');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nenhum registro de produto inv�lido encontrado');
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Corre��o de refer�ncias conclu�da com sucesso');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro na corre��o de refer�ncias: ' || SQLERRM);
        RAISE;
END CORRIGE_REFERENCIAS_INVALIDAS;

EXEC CORRIGE_REFERENCIAS_INVALIDAS;







