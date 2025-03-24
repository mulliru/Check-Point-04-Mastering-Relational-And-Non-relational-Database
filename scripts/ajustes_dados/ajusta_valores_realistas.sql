CREATE OR REPLACE PROCEDURE AJUSTA_VALORES_REALISTAS AS
    v_preco_unitario NUMBER;
    v_qtd NUMBER;
    v_desconto NUMBER;
BEGIN
    FOR r IN (
        SELECT ID_VENDA, COD_PRODUTO 
        FROM FATO_VENDAS
    ) LOOP
        BEGIN
            v_qtd := TRUNC(DBMS_RANDOM.VALUE(1, 11));

            SELECT CASE dp.CATEGORIA
                       WHEN 'Eletrônicos' THEN ROUND(DBMS_RANDOM.VALUE(150, 4500), 2)
                       WHEN 'Roupas'       THEN ROUND(DBMS_RANDOM.VALUE(30, 500), 2)
                       WHEN 'Alimentos'    THEN ROUND(DBMS_RANDOM.VALUE(5, 35), 2)
                       WHEN 'Móveis'       THEN ROUND(DBMS_RANDOM.VALUE(300, 2000), 2)
                       WHEN 'Livros'       THEN ROUND(DBMS_RANDOM.VALUE(25, 70), 2)
                       WHEN 'Esportes'     THEN ROUND(DBMS_RANDOM.VALUE(40, 300), 2)
                       WHEN 'Beleza'       THEN ROUND(DBMS_RANDOM.VALUE(20, 400), 2)
                       WHEN 'Brinquedos'   THEN ROUND(DBMS_RANDOM.VALUE(30, 250), 2)
                       WHEN 'Ferramentas'  THEN ROUND(DBMS_RANDOM.VALUE(50, 500), 2)
                       WHEN 'Automotivo'   THEN ROUND(DBMS_RANDOM.VALUE(60, 400), 2)
                       ELSE 100
                   END
            INTO v_preco_unitario
            FROM DIM_PRODUTO dp
            WHERE dp.COD_PRODUTO = r.COD_PRODUTO;

            IF DBMS_RANDOM.VALUE(0, 1) <= 0.3 THEN
                v_desconto := ROUND(DBMS_RANDOM.VALUE(5, 150), 2);
            ELSE
                v_desconto := 0;
            END IF;

            UPDATE FATO_VENDAS
            SET QTD_PRODUTO_VENDIDO = v_qtd,
                VAL_TOTAL_PEDIDO = ROUND((v_qtd * v_preco_unitario), 2),
                VAL_DESCONTO = v_desconto
            WHERE ID_VENDA = r.ID_VENDA;

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao ajustar ID_VENDA ' || r.ID_VENDA || ': ' || SQLERRM);
        END;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Ajustes realistas aplicados com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na procedure AJUSTA_VALORES_REALISTAS: ' || SQLERRM);
        ROLLBACK;
END AJUSTA_VALORES_REALISTAS;
