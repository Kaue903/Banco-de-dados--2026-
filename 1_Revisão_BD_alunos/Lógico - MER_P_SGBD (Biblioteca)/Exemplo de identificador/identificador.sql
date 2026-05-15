-- O que isso garante (para você explicar)

-- id_pedido em itens_pedido:
-- é FK → aponta para pedidos
-- é PK → faz parte da identificação do registro

-- Ou seja:

-- Um item não existe sem um pedido → isso caracteriza o relacionamento identificador

-- Tabela pai
CREATE TABLE pedidos (
    id_pedido INT NOT NULL AUTO_INCREMENT,
    data DATE NOT NULL,
    total DECIMAL(10,2),
    PRIMARY KEY (id_pedido)
);

-- Tabela dependente (relacionamento identificador)
CREATE TABLE itens_pedido (
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,

    -- 🔑 Chave primária composta
    PRIMARY KEY (id_pedido, id_produto),

    -- 🔗 Chave estrangeira que também faz parte da PK
    CONSTRAINT fk_itens_pedido_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);