# ETL e Modelagem Dimensional

## Sobre o Projeto

Este é um projeto desenvolvido por **Larissa Lopes Oliveira**, **Lucas Alcântara Carvalho** e **Murillo Ferreira Ramos** para a disciplina **Disruptive Architectures** da FIAP. O objetivo é criar um **modelo estrela** para análise de vendas, implementando um pipeline de **ETL** para carregamento dos dados e desenvolvendo um **dashboard interativo** no Power BI.

### Funcionalidades Propostas

- Construção de um **modelo estrela** para análise de dados históricos.
- Implementação de **procedures** para tratamento e carga de dados.
- Criação de uma **trigger de auditoria** para monitoramento das inserções.
- Criação de **procedures de ajuste e limpeza dos dados**, garantindo maior realismo e qualidade nas análises.
- Desenvolvimento de um **dashboard** no Power BI para visualização das métricas de vendas.

---

## Estrutura do Projeto

📆 **database**  
- `modelo_estrela.sql` – Script para criação do modelo estrela  
- `procedures_etl.sql` – Procedures principais de carga  
- `triggers_auditoria.sql` – Trigger de auditoria  
- `delete.sql` – Script para reset de tabelas antes da carga  

📆 **scripts**  
- `pipeline_etl.sql` – Pipeline completo do processo ETL  
- `pacotes_etl.sql` – Pacotes consolidados de execução  
- `ajustes_dados.sql` – Scripts para ajustes e correções nos dados (valores realistas, descontos e caracteres especiais)  

📆 **dashboard**  
- `relatorio_vendas.pbix` – Arquivo do Power BI com visualizações  
- `export_dados.xlsx` – Arquivo exportado com os dados finais usados no dashboard  

📆 **docs**  
- `dicionario_dados.md` – Estrutura e explicação das tabelas  
- `evidencias_execucao.md` – Prints das execuções e consultas  
- `documentacao_projeto.docx` – Documentação do projeto com prints, justificativas e metodologia  

---

## Testes e Feedback

O projeto foi testado com dados gerados e tratados no Oracle SQL Developer, validados após execução do pipeline ETL. Também aplicamos **procedures de ajustes** para corrigir valores extremos e limpar caracteres especiais nas tabelas de dimensão. O resultado foi exportado para arquivos `.xlsx` e utilizado para alimentar o **Power BI**, onde foram criadas visualizações consistentes e realistas.

Se você tiver sugestões ou encontrar problemas, sinta-se à vontade para abrir uma **issue** no repositório ou contribuir com **pull requests**.

---

## Integrantes

- **Larissa Lopes Oliveira** – RM 552628  
- **Lucas Alcântara Carvalho** – RM 95111  
- **Murillo Ferreira Ramos** – RM 553315  

---

## Como Executar

1. Clone este repositório:
```bash
git clone https://github.com/mulliru/Check-Point-04-Mastering-Relational-And-Non-relational-Database
```

2. Execute os scripts SQL na seguinte ordem:
   - `delete.sql`
   - `modelo_estrela.sql`
   - `procedures_etl.sql`
   - `triggers_auditoria.sql`
   - `pipeline_etl.sql`
   - `ajustes_dados.sql` (opcional para dados mais realistas)

3. Exporte os dados das tabelas para `.xlsx` caso deseje utilizar no Power BI.

4. Abra o arquivo `relatorio_vendas.pbix` no Power BI para visualizar os dashboards.

---
