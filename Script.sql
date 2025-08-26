CREATE DATABASE db_revenda_davi;

\c db_revenda_davi

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    data_cadastro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE fornecedores (
    id_fornecedor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    contato VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    preco NUMERIC(10, 2) CHECK (preco > 0),
    id_fornecedor INT REFERENCES fornecedores(id_fornecedor)
);

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    data_pedido DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'Pendente',
    total NUMERIC(10,2) CHECK (total >= 0)
);

CREATE TABLE itens_pedido (
    id_pedido INT REFERENCES pedidos(id_pedido),
    id_produto INT REFERENCES produtos(id_produto),
    quantidade INT CHECK (quantidade > 0),
    preco_unitario NUMERIC(10, 2),
    PRIMARY KEY (id_pedido, id_produto)
);

CREATE TABLE estoque (
    id_estoque SERIAL PRIMARY KEY,
    id_produto INT REFERENCES produtos(id_produto),
    quantidade INT DEFAULT 0 CHECK (quantidade >= 0),
    ultima_entrada DATE,
    ultima_saida DATE
);

CREATE VIEW vw_detalhes_pedidos AS
SELECT 
    p.id_pedido,
    c.nome AS cliente,
    p.data_pedido,
    p.status,
    p.total
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente;

CREATE VIEW vw_produtos_fornecedores AS
SELECT 
    pr.id_produto,
    pr.nome AS produto,
    pr.categoria,
    pr.preco,
    f.nome AS fornecedor,
    f.ativo
FROM produtos pr
JOIN fornecedores f ON pr.id_fornecedor = f.id_fornecedor;

INSERT INTO clientes (nome, email, telefone) VALUES
('João Silva', 'joao@gmail.com', '119999999'),
('Maria Souza', 'maria@gmail.com', '119888888'),
('Carlos Dias', 'carlos@gmail.com', '119777777'),
('Ana Lima', 'ana@gmail.com', '119666666'),
('Paulo Cesar', 'paulo@gmail.com', '119555555'),
('Fernanda Rocha', 'fernanda@gmail.com', '119444444'),
('Eduardo Mendes', 'eduardo@gmail.com', '119333333'),
('Patricia Moreira', 'patricia@gmail.com', '119222222'),
('Ricardo Alves', 'ricardo@gmail.com', '119111111'),
('Juliana Reis', 'juliana@gmail.com', '119000000');

INSERT INTO fornecedores (nome, cnpj, contato) VALUES
('Pedal Forte Ltda', '12.345.678/0001-01', 'pedal@fornecedores.com'),
('Ciclo Master', '98.765.432/0001-02', 'ciclo@fornecedores.com'),
('Roda Livre', '11.111.111/0001-11', 'roda@fornecedores.com'),
('BikePro Distrib', '22.222.222/0001-22', 'bikepro@fornecedores.com'),
('MaxBike Parts', '33.333.333/0001-33', 'max@fornecedores.com'),
('ProCiclista', '44.444.444/0001-44', 'pro@fornecedores.com'),
('UltraBike', '55.555.555/0001-55', 'ultra@fornecedores.com'),
('SpeedBike', '66.666.666/0001-66', 'speed@fornecedores.com'),
('TopCiclo', '77.777.777/0001-77', 'top@fornecedores.com'),
('MegaRodas', '88.888.888/0001-88', 'mega@fornecedores.com');

INSERT INTO produtos (nome, categoria, preco, id_fornecedor) VALUES
('Pneu 29" MTB', 'Rodas', 120.00, 1),
('Corrente 10v', 'Transmissão', 90.50, 2),
('Guidão Alumínio', 'Cockpit', 75.00, 3),
('Freio a Disco', 'Freios', 150.00, 4),
('Selim Confort', 'Selim', 65.00, 5),
('Câmbio Traseiro', 'Transmissão', 180.00, 2),
('Pedivela Triplo', 'Pedal', 110.00, 1),
('Câmara de Ar', 'Rodas', 25.00, 6),
('Kit Transmissão', 'Transmissão', 250.00, 2),
('Capacete Bike', 'Acessórios', 95.00, 7);

INSERT INTO estoque (id_produto, quantidade, ultima_entrada) VALUES
(1, 20, '2025-08-01'),
(2, 35, '2025-08-05'),
(3, 50, '2025-08-03'),
(4, 15, '2025-08-10'),
(5, 60, '2025-08-02'),
(6, 25, '2025-08-06'),
(7, 40, '2025-08-07'),
(8, 100, '2025-08-04'),
(9, 10, '2025-08-11'),
(10, 30, '2025-08-08');

INSERT INTO pedidos (id_cliente, data_pedido, status, total) values
(1, '2025-08-20', 'Concluído', 300.00),
(2, '2025-08-21', 'Pendente', 180.50),
(3, '2025-08-22', 'Concluído', 150.00),
(4, '2025-08-23', 'Cancelado', 0.00),
(5, '2025-08-24', 'Concluído', 95.00),
(6, '2025-08-20', 'Pendente', 120.00),
(7, '2025-08-25', 'Concluído', 180.00),
(8, '2025-08-25', 'Concluído', 250.00),
(9, '2025-08-26', 'Pendente', 110.00),
(10, '2025-08-26', 'Pendente', 65.00);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 120.00),
(1, 2, 1, 90.50),
(2, 3, 2, 75.00),
(3, 4, 1, 150.00),
(5, 10, 1, 95.00),
(6, 1, 1, 120.00),
(7, 6, 1, 180.00),
(8, 9, 1, 250.00),
(9, 7, 1, 110.00),
(10, 5, 1, 65.00);

SELECT * FROM vw_detalhes_pedidos;
SELECT * FROM vw_produtos_fornecedores;