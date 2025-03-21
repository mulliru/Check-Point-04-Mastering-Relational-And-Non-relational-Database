--Desenvolvimento das Procedures e Functions

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
    IF v_perfil_consumo NOT IN ('ALTO', 'MÉDIO', 'BAIXO') THEN
      v_perfil_consumo := 'MÉDIO'; -- valor padrão
    END IF;
    
    -- Atualizar o registro se houve alterações
    IF v_nome_cliente != r_cliente.NOME_CLIENTE OR v_perfil_consumo != r_cliente.PERFIL_CONSUMO THEN
      UPDATE DIM_CLIENTE
      SET NOME_CLIENTE = v_nome_cliente,
          PERFIL_CONSUMO = v_perfil_consumo
      WHERE CURRENT OF c_clientes;
      
      DBMS_OUTPUT.PUT_LINE('Cliente ' || r_cliente.COD_CLIENTE || ' atualizado.');
    END IF;
  END LOOP;
  
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Correção de dados concluída.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Erro ao corrigir dados: ' || SQLERRM);
END CORRIGE_DADOS_CLIENTE;

EXEC CORRIGE_DADOS_CLIENTE;

--Validação de dados
CREATE OR REPLACE PROCEDURE VALIDAR_DADOS (
    p_uf IN VARCHAR2,
    p_data IN DATE
) AS
    v_uf_valida BOOLEAN;
    v_id_tempo NUMBER;
    v_count NUMBER;
BEGIN
    -- Validar UF usando dados da DIM_LOCALIZACAO
    SELECT COUNT(*) INTO v_count
    FROM DIM_LOCALIZACAO
    WHERE UPPER(TRIM(ESTADO)) = UPPER(TRIM(p_uf));
    
    v_uf_valida := (v_count > 0);
    
    -- Obter ID_TEMPO da DIM_TEMPO
    SELECT COUNT(*) INTO v_count
    FROM DIM_TEMPO
    WHERE DATA_COMPLETA = TRUNC(p_data);
    
    IF v_count > 0 THEN
        SELECT ID_TEMPO INTO v_id_tempo
        FROM DIM_TEMPO
        WHERE DATA_COMPLETA = TRUNC(p_data);
    ELSE
        v_id_tempo := NULL;
    END IF;
    
    -- Registrar resultado da validação usando DBMS_OUTPUT.PUT_LINE
    IF v_uf_valida AND v_id_tempo IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Validação bem-sucedida: UF válida e data encontrada na DIM_TEMPO');
    ELSE
        IF NOT v_uf_valida THEN
            DBMS_OUTPUT.PUT_LINE('Erro: UF inválida');
        END IF;
        IF v_id_tempo IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Data não encontrada na DIM_TEMPO');
        END IF;
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na validação de dados: ' || SQLERRM);
END VALIDAR_DADOS;

EXEC VALIDAR_DADOS;

--






