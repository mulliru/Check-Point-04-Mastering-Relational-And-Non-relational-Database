-- Dimensão Tempo
CREATE TABLE DIM_TEMPO (
    ID_TEMPO NUMBER(10,0) NOT NULL ENABLE,
    ANO NUMBER(4,0),
    MES NUMBER(2,0),
    DIA NUMBER(2,0),
    DATA_COMPLETA DATE,
    CONSTRAINT PK_DIM_TEMPO PRIMARY KEY (ID_TEMPO)
);

-- Dimensão Cliente
CREATE TABLE DIM_CLIENTE (
    COD_CLIENTE NUMBER(10,0) NOT NULL ENABLE,
    NOME_CLIENTE VARCHAR2(100 BYTE),
    PERFIL_CONSUMO VARCHAR2(50 BYTE),
    CONSTRAINT PK_DIM_CLIENTE PRIMARY KEY (COD_CLIENTE)
);

-- Dimensão Vendedor
CREATE TABLE DIM_VENDEDOR (
    COD_VENDEDOR NUMBER(4,0) NOT NULL ENABLE,
    NOME_VENDEDOR VARCHAR2(100 BYTE),
    CONSTRAINT PK_DIM_VENDEDOR PRIMARY KEY (COD_VENDEDOR)
);

-- Dimensão Localização
CREATE TABLE DIM_LOCALIZACAO (
    SEQ_ENDERECO_CLIENTE NUMBER(10,0) NOT NULL ENABLE,
    ESTADO VARCHAR2(2 BYTE),
    CIDADE VARCHAR2(50 BYTE),
    CONSTRAINT PK_DIM_LOCALIZACAO PRIMARY KEY (SEQ_ENDERECO_CLIENTE)
);

-- Dimensão Produto 
CREATE TABLE DIM_PRODUTO (
    COD_PRODUTO NUMBER(10,0) NOT NULL ENABLE,
    NOME_PRODUTO VARCHAR2(100 BYTE),
    CATEGORIA VARCHAR2(50 BYTE),
    CONSTRAINT PK_DIM_PRODUTO PRIMARY KEY (COD_PRODUTO)
);

-- Fato: Vendas
CREATE TABLE FATO_VENDAS (
    ID_VENDA NUMBER(12,0) NOT NULL ENABLE,  
    COD_CLIENTE NUMBER(10,0),
    COD_VENDEDOR NUMBER(4,0),
    SEQ_ENDERECO_CLIENTE NUMBER(10,0),
    ID_TEMPO NUMBER(10,0),
    COD_PRODUTO NUMBER(10,0),  
    QTD_PRODUTO_VENDIDO NUMBER(10,0),  
    VAL_TOTAL_PEDIDO NUMBER(12,2),
    VAL_DESCONTO NUMBER(12,2),
    CONSTRAINT PK_FATO_VENDAS PRIMARY KEY (ID_VENDA),
    CONSTRAINT FK_FATO_CLIENTE FOREIGN KEY (COD_CLIENTE) REFERENCES DIM_CLIENTE (COD_CLIENTE) ENABLE,
    CONSTRAINT FK_FATO_VENDEDOR FOREIGN KEY (COD_VENDEDOR) REFERENCES DIM_VENDEDOR (COD_VENDEDOR) ENABLE,
    CONSTRAINT FK_FATO_LOCALIZACAO FOREIGN KEY (SEQ_ENDERECO_CLIENTE) REFERENCES DIM_LOCALIZACAO (SEQ_ENDERECO_CLIENTE) ENABLE,
    CONSTRAINT FK_FATO_TEMPO FOREIGN KEY (ID_TEMPO) REFERENCES DIM_TEMPO (ID_TEMPO) ENABLE,
    CONSTRAINT FK_FATO_PRODUTO FOREIGN KEY (COD_PRODUTO) REFERENCES DIM_PRODUTO (COD_PRODUTO) ENABLE
);
