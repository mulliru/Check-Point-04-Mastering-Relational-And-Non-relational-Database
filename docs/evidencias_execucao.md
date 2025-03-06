# Evidências de Execução

Este documento contém as evidências de execução dos scripts SQL do projeto, incluindo a criação de tabelas, inserção de dados, execução de procedures, triggers e visualização dos dados. Todas as evidências foram registradas por meio de prints e logs para validação do funcionamento correto das operações.

---

## 1. Criação do Modelo Estrela
**Arquivo executado:** `modelo_estrela.sql`

**Comando executado:**
```sql
SELECT nome_tabela FROM user_tables;
```

**Resultado esperado:**
| nome_tabela    |
|--------------|
| Fato_Teste  |
| Dim_Usuarios |
| Dim_Itens |
| Dim_Data    |
| Dim_Responsaveis |

**Print da execução:**
<br>
![Criação de tabelas](imagens/criacao_tabelas.png)

**Status:** Concluído

---

## 2. Inserção de Dados
**Arquivo executado:** `carga_dados.sql`

**Comando executado:**
```sql
SELECT COUNT(*) FROM Fato_Teste;
```

**Resultado esperado:**
| COUNT(*) |
|----------|
| 1050     |

**Print da execução:**
<br>
![Carga de dados](imagens/carga_dados.png)

**Status:** Concluído

---

## 3. Execução das Procedures
**Arquivo executado:** `procedures_etl.sql`

**Comando executado:**
```sql
BEGIN 
    Inserir_Cliente(1, 'João Silva', 'SP'); 
END;
```

**Print da execução:**
<br>
![Execução da procedure](imagens/executando_procedure.png)

**Status:** Concluído

---

## 4. Trigger de Auditoria
**Arquivo executado:** `triggers_auditoria.sql`

**Comando executado:**
```sql
INSERT INTO Dim_Usuarios (id_cliente, nome, estado) VALUES (2, 'Maria Santos', 'RJ');
```

**Consulta da auditoria:**
```sql
SELECT * FROM Auditoria_Usuarios;
```

**Print da execução:**
<br>
![Trigger de auditoria](imagens/trigger_auditoria.png)

**Status:** Concluído

---

## 5. Dashboard no Power BI
**Arquivo utilizado:** `relatorio_vendas.pbix`

**Print da execução:**
<br>

![Dashboard Power BI](imagens/dashboard_vendas.png)

**Status:** Concluído

---

## Conclusão
Todos os scripts foram executados corretamente e os dados foram carregados conforme esperado. As evidências foram registradas e podem ser acessadas nos diretórios especificados. Caso seja necessário refazer alguma etapa, recomenda-se consultar os prints e logs acima.
