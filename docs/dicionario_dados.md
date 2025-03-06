#  Dicionário de Dados

##  Tabela: Fato_Vendas  
Contém os registros das vendas realizadas, associando dimensões como cliente, produto, tempo e vendedor.

| Nome da Coluna  | Tipo de Dado | Descrição |
|----------------|------------|-----------|
| id_venda       | INT (PK)   | Identificador único da venda |
| id_cliente     | INT (FK)   | Chave estrangeira referenciando a dimensão Cliente |
| id_produto     | INT (FK)   | Chave estrangeira referenciando a dimensão Produto |
| id_tempo       | INT (FK)   | Chave estrangeira referenciando a dimensão Tempo |
| id_vendedor    | INT (FK)   | Chave estrangeira referenciando a dimensão Vendedor |
| quantidade     | INT        | Quantidade de produtos vendidos |
| valor_total    | DECIMAL(10,2) | Valor total da venda |

##  Tabela: Dim_Clientes  
Armazena informações dos clientes que realizaram compras.

| Nome da Coluna | Tipo de Dado | Descrição |
|---------------|------------|-----------|
| id_cliente    | INT (PK)   | Identificador único do cliente |
| nome          | VARCHAR(100) | Nome do cliente |
| estado        | VARCHAR(2) | Estado onde o cliente reside |


## Tabela x
