-- Criar um banco de dados
CREATE DATABASE Loja;
USE Loja;

-- Criar tabela de clientes
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    DataCadastro DATE DEFAULT CURDATE()
);

-- Criar tabela de pedidos
CREATE TABLE Pedidos (
    PedidoID INT PRIMARY KEY AUTO_INCREMENT,
    ClienteID INT,
    DataPedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    Valor DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID) ON DELETE CASCADE
);

-- Inserir dados nas tabelas
INSERT INTO Clientes (Nome, Email) VALUES 
('João Silva', 'joao@email.com'),
('Maria Souza', 'maria@email.com'),
('Carlos Mendes', 'carlos@email.com');

INSERT INTO Pedidos (ClienteID, Valor) VALUES
(1, 150.75),
(2, 299.99),
(1, 89.50);

-- Atualizar um cliente
UPDATE Clientes SET Email = 'joaosilva@email.com' WHERE ClienteID = 1;

-- Excluir um pedido
DELETE FROM Pedidos WHERE PedidoID = 3;

-- Consultar dados com JOIN
SELECT 
    c.ClienteID, c.Nome, p.PedidoID, p.Valor, p.DataPedido
FROM 
    Clientes c
JOIN 
    Pedidos p ON c.ClienteID = p.ClienteID
WHERE 
    p.Valor > 100
ORDER BY 
    p.Valor DESC;

-- Criar uma View para listar pedidos e clientes
CREATE VIEW Vw_PedidosClientes AS
SELECT 
    c.Nome AS Cliente, p.PedidoID, p.Valor, p.DataPedido
FROM 
    Clientes c
JOIN 
    Pedidos p ON c.ClienteID = p.ClienteID;

-- Criar uma Procedure para adicionar um novo pedido
DELIMITER //
CREATE PROCEDURE AdicionarPedido(IN p_ClienteID INT, IN p_Valor DECIMAL(10,2))
BEGIN
    INSERT INTO Pedidos (ClienteID, Valor) VALUES (p_ClienteID, p_Valor);
END //
DELIMITER ;

-- Criar um Trigger para registrar alteração no valor do pedido
DELIMITER //
CREATE TRIGGER AtualizarPedido BEFORE UPDATE ON Pedidos
FOR EACH ROW
BEGIN
    INSERT INTO Log_Alteracoes (PedidoID, ValorAntigo, ValorNovo, DataAlteracao)
    VALUES (OLD.PedidoID, OLD.Valor, NEW.Valor, NOW());
END //
DELIMITER ;

-- Criar tabela de logs para o trigger
CREATE TABLE Log_Alteracoes (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    PedidoID INT,
    ValorAntigo DECIMAL(10,2),
    ValorNovo DECIMAL(10,2),
    DataAlteracao DATETIME DEFAULT CURRENT_TIMESTAMP
);

