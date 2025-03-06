# ETL e Modelagem Dimensional

## Sobre o Projeto

Este é um projeto desenvolvido por **Larissa Lopes Oliveira**, **Lucas Alcântara Carvalho** e **Murillo Ferreira Ramos** para a disciplina **Disruptive Architectures** da FIAP. O objetivo é criar um **modelo estrela** para análise de vendas, implementando um pipeline de **ETL** para carregamento dos dados e desenvolvendo um **dashboard interativo** no Power BI.

### Funcionalidades Propostas

- Construção de um **modelo estrela** para análise de dados históricos.
- Implementação de **procedures** para tratamento e carga de dados.
- Criação de uma **trigger de auditoria** para monitoramento das inserções.
- Desenvolvimento de um **dashboard** no Power BI para visualização das métricas de vendas.

---

## Estrutura do Projeto

📦 **database**  
- `modelo_estrela.sql` - Script para criação do modelo estrela  
- `carga_dados.sql` - Scripts de carga para a tabela fato e dimensões  
- `procedures_etl.sql` - Procedures para validação e inserção  
- `triggers_auditoria.sql` - Trigger para auditoria  

📦 **scripts**  
- `pipeline_etl.sql` - Script de execução completa do ETL  
- `pacotes_etl.sql` - Packages consolidados  

📦 **dashboard**  
- `relatorio_vendas.pbix` - Arquivo do Power BI com visualizações  

📦 **docs**  
- `dicionario_dados.md` - Estrutura e explicação das tabelas  
- `evidencias_execucao.md` - Prints das execuções e consultas  
- `documentacao_projeto.docx` - Documentação do projeto com prints e explicações


---

## Testes e Feedback

O projeto será testado com dados reais para garantir a **consistência e integridade** do pipeline ETL. Prints e logs das execuções serão registrados para validação.  

Se você tiver sugestões ou encontrar problemas, sinta-se à vontade para abrir uma **issue** no repositório ou contribuir com **pull requests**.

---

## Integrantes

- **Larissa Lopes Oliveira** - RM 552628  
- **Lucas Alcântara Carvalho** - RM 95111  
- **Murillo Ferreira Ramos** - RM 553315  

---

## Como Executar

1. Clone este repositório:
```bash
git clone https://github.com/mulliru/Check-Point-04-Mastering-Relational-And-Non-relational-Database
