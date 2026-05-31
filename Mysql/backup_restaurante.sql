-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           8.0.43 - MySQL Community Server - GPL
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para bd_restaurante
DROP DATABASE IF EXISTS `bd_restaurante`;
CREATE DATABASE IF NOT EXISTS `bd_restaurante` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `bd_restaurante`;

-- Copiando estrutura para tabela bd_restaurante.cardapio
DROP TABLE IF EXISTS `cardapio`;
CREATE TABLE IF NOT EXISTS `cardapio` (
  `codCardapio` int NOT NULL AUTO_INCREMENT,
  `nomeComida` varchar(150) NOT NULL,
  `valorComida` decimal(6,2) NOT NULL,
  `descricaoComida` varchar(500) DEFAULT NULL,
  `categoria_codCategoria` int NOT NULL,
  PRIMARY KEY (`codCardapio`,`categoria_codCategoria`),
  KEY `fk_cardapio_categoria1_idx` (`categoria_codCategoria`),
  CONSTRAINT `fk_cardapio_categoria1` FOREIGN KEY (`categoria_codCategoria`) REFERENCES `categoria` (`codCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.cardapio: ~9 rows (aproximadamente)
INSERT INTO `cardapio` (`codCardapio`, `nomeComida`, `valorComida`, `descricaoComida`, `categoria_codCategoria`) VALUES
	(1, 'BIGTITES', 10.20, 'Grande molho cheddar', 1),
	(2, 'Cheeseburger Clássico', 7.99, 'Pão, hambúrguer artesanal, queijo prato, alface, tomate e molho especial', 1),
	(3, 'Cheesebacon', 22.50, 'Hambúrguer artesanal, queijo cheddar, bacon crocante e maionese da casa', 1),
	(4, 'Smash Duplo', 26.90, 'Dois hambúrgueres smash 100g, queijo cheddar, cebola caramelizada e pão brioche', 1),
	(5, 'Batata Frita Tradicional', 7.98, 'Porção média de batata frita crocante', 4),
	(6, 'Batata com Cheddar e Bacon', 18.00, 'Batata frita coberta com cheddar cremoso e bacon em cubos', 4),
	(7, 'Refrigerante Lata', 6.00, 'Coca-Cola, Guaraná ou Fanta (350ml)', 2),
	(8, 'Milkshake de Chocolate', 15.00, 'Milkshake cremoso com calda de chocolate', 3),
	(9, 'Brownie com Sorvete', 16.50, 'Brownie caseiro com bola de sorvete de creme e calda de chocolate', 3),
	(10, 'a', 0.00, 'a', 1);

-- Copiando estrutura para tabela bd_restaurante.cardapio_por_ingrediente
DROP TABLE IF EXISTS `cardapio_por_ingrediente`;
CREATE TABLE IF NOT EXISTS `cardapio_por_ingrediente` (
  `cardapio_por_ingredientecol` int NOT NULL AUTO_INCREMENT,
  `cardapio_codCardapio` int NOT NULL,
  `ingrediente_codIngrediente` int NOT NULL,
  `quantidadePorComida` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`cardapio_por_ingredientecol`,`cardapio_codCardapio`,`ingrediente_codIngrediente`),
  KEY `fk_cardapio_has_ingrediente_ingrediente1_idx` (`ingrediente_codIngrediente`),
  KEY `fk_cardapio_has_ingrediente_cardapio1_idx` (`cardapio_codCardapio`),
  CONSTRAINT `fk_cardapio_has_ingrediente_cardapio1` FOREIGN KEY (`cardapio_codCardapio`) REFERENCES `cardapio` (`codCardapio`),
  CONSTRAINT `fk_cardapio_has_ingrediente_ingrediente1` FOREIGN KEY (`ingrediente_codIngrediente`) REFERENCES `ingrediente` (`codIngrediente`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.cardapio_por_ingrediente: ~23 rows (aproximadamente)
INSERT INTO `cardapio_por_ingrediente` (`cardapio_por_ingredientecol`, `cardapio_codCardapio`, `ingrediente_codIngrediente`, `quantidadePorComida`) VALUES
	(1, 2, 6, 4.00),
	(2, 1, 6, 2.00),
	(3, 1, 8, 3.00),
	(4, 1, 6, 2.00),
	(5, 1, 7, 3.00),
	(6, 1, 8, 2.00),
	(11, 1, 6, 2.00),
	(12, 1, 7, 3.00),
	(13, 1, 8, 2.00),
	(18, 1, 6, 2.00),
	(19, 1, 7, 3.00),
	(20, 1, 8, 2.00),
	(25, 1, 17, 2.00),
	(26, 1, 7, 3.00),
	(27, 1, 8, 2.00),
	(28, 2, 17, 2.00),
	(29, 2, 7, 2.00),
	(30, 2, 9, 1.00),
	(31, 2, 21, 1.50),
	(32, 5, 17, 1.00),
	(33, 5, 8, 1.00),
	(34, 8, 22, 2.00),
	(35, 8, 23, 3.00);

-- Copiando estrutura para tabela bd_restaurante.cargo
DROP TABLE IF EXISTS `cargo`;
CREATE TABLE IF NOT EXISTS `cargo` (
  `codCargo` int NOT NULL AUTO_INCREMENT,
  `nomeCargo` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`codCargo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.cargo: ~5 rows (aproximadamente)
INSERT INTO `cargo` (`codCargo`, `nomeCargo`) VALUES
	(1, 'Cozinheiro'),
	(2, 'Garçom'),
	(3, 'Gerente'),
	(4, 'Atentende'),
	(5, 'ddd');

-- Copiando estrutura para tabela bd_restaurante.categoria
DROP TABLE IF EXISTS `categoria`;
CREATE TABLE IF NOT EXISTS `categoria` (
  `codCategoria` int NOT NULL AUTO_INCREMENT,
  `nomeCategoria` varchar(150) NOT NULL,
  PRIMARY KEY (`codCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.categoria: ~4 rows (aproximadamente)
INSERT INTO `categoria` (`codCategoria`, `nomeCategoria`) VALUES
	(1, 'Hamburguer'),
	(2, 'Bebida'),
	(3, 'Sobremesa'),
	(4, 'Petiscos');

-- Copiando estrutura para tabela bd_restaurante.cliente
DROP TABLE IF EXISTS `cliente`;
CREATE TABLE IF NOT EXISTS `cliente` (
  `codCliente` int NOT NULL AUTO_INCREMENT,
  `nomeCliente` varchar(150) NOT NULL,
  `cpfCliente` varchar(45) NOT NULL,
  `senhaCliente` varchar(150) NOT NULL,
  `telefone` varchar(50) DEFAULT NULL,
  `dataCadastro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`codCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.cliente: ~3 rows (aproximadamente)
INSERT INTO `cliente` (`codCliente`, `nomeCliente`, `cpfCliente`, `senhaCliente`, `telefone`, `dataCadastro`) VALUES
	(1, 'YUJI', '', 'otaviano', '293821', '2025-09-13 19:15:50'),
	(2, 'Otavio', '', 'marmota', '(35)99999-9999', '2025-09-14 12:30:38'),
	(3, 'Pedro', 'luquinhas', '67', '(35)91022-1202', '2025-09-14 12:31:02'),
	(5, 'rogerio', 'dsd', 'sdd', '23131', '2025-10-29 09:15:35');

-- Copiando estrutura para evento bd_restaurante.event_disponibilidadeTrabalho
DROP EVENT IF EXISTS `event_disponibilidadeTrabalho`;
DELIMITER //
CREATE EVENT `event_disponibilidadeTrabalho` ON SCHEDULE EVERY 1 HOUR STARTS '2025-10-29 09:35:26' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
-- Verifica se o horário atual está dentro do horário do turno
	UPDATE funcionario f
    inner JOIN turnos t ON f.turnos_codTurnos = t.codTurnos
    SET f.disponivel = 
        CASE
            
            WHEN NOW() BETWEEN t.horarioInicio AND t.horarioFinal THEN TRUE
            ELSE FALSE
   END;
END//
DELIMITER ;

-- Copiando estrutura para tabela bd_restaurante.feedback
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE IF NOT EXISTS `feedback` (
  `codFeedback` int NOT NULL AUTO_INCREMENT,
  `nota` int NOT NULL,
  `descricao` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `dataFeedback` datetime NOT NULL DEFAULT (now()),
  `cliente_codCliente` int NOT NULL,
  PRIMARY KEY (`codFeedback`,`cliente_codCliente`),
  KEY `fk_feedback_cliente1_idx` (`cliente_codCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.feedback: ~3 rows (aproximadamente)
INSERT INTO `feedback` (`codFeedback`, `nota`, `descricao`, `dataFeedback`, `cliente_codCliente`) VALUES
	(1, 10, 'Lanche muito Bom', '2025-09-20 17:52:44', 3),
	(2, 4, 'Mediana', '2025-09-20 17:53:00', 2),
	(3, 2, 'Mal atendimento', '2025-11-01 00:37:38', 1);

-- Copiando estrutura para tabela bd_restaurante.fornecedores
DROP TABLE IF EXISTS `fornecedores`;
CREATE TABLE IF NOT EXISTS `fornecedores` (
  `codFornecedor` int NOT NULL AUTO_INCREMENT,
  `nomeFornecedor` varchar(150) NOT NULL,
  `cnpj` varchar(45) DEFAULT NULL,
  `endereco` varchar(150) DEFAULT NULL,
  `bairro` varchar(45) DEFAULT NULL,
  `cidade` varchar(45) DEFAULT NULL,
  `estado` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`codFornecedor`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.fornecedores: ~6 rows (aproximadamente)
INSERT INTO `fornecedores` (`codFornecedor`, `nomeFornecedor`, `cnpj`, `endereco`, `bairro`, `cidade`, `estado`) VALUES
	(2, 'Pães & Cia LTDA', '12.345.678/0001-90', 'Rua dos Padeiros, 123', 'Centro', 'São Paulo', 'SP'),
	(3, 'Carne Nobre Distribuidora', '23.456.789/0001-01', 'Av. do Açougue, 456', 'Industrial', 'Campinas', 'SP'),
	(4, 'Queijos Brasil Ltda', '34.567.890/0001-02', 'Rua do Laticínio, 789', 'Vila Rica', 'Belo Horizonte', 'MG'),
	(5, 'VerdeFresco Hortifruti', '45.678.901/0001-03', 'Av. das Hortas, 321', 'Jardim das Flores', 'Curitiba', 'PR'),
	(6, 'Molhos Gourmet SA', '56.789.012/0001-04', 'Rua dos Temperos, 654', 'Sabores', 'Rio de Janeiro', 'RJ'),
	(7, 'Bebidas Geladas ME', '67.890.123/0001-05', 'Av. da Bebida, 987', 'Barra Funda', 'São Pau', 'SP'),
	(8, 'a', 'a', 'a', 'a', 'a', 'RS');

-- Copiando estrutura para tabela bd_restaurante.funcionario
DROP TABLE IF EXISTS `funcionario`;
CREATE TABLE IF NOT EXISTS `funcionario` (
  `codFuncionario` int NOT NULL AUTO_INCREMENT,
  `nomeFuncionario` varchar(150) NOT NULL,
  `dataNascimento` date DEFAULT NULL,
  `senhaFuncionario` varchar(45) NOT NULL,
  `cpfFuncionario` varchar(45) DEFAULT NULL,
  `salarioFuncionario` decimal(6,2) NOT NULL,
  `turnos_codTurnos` int NOT NULL,
  `cargo_codCargo` int NOT NULL,
  `disponivel` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`codFuncionario`,`turnos_codTurnos`,`cargo_codCargo`) USING BTREE,
  KEY `fk_funcionario_turnos1_idx` (`turnos_codTurnos`),
  KEY `fk_funcionario_cargo1_idx` (`cargo_codCargo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.funcionario: ~4 rows (aproximadamente)
INSERT INTO `funcionario` (`codFuncionario`, `nomeFuncionario`, `dataNascimento`, `senhaFuncionario`, `cpfFuncionario`, `salarioFuncionario`, `turnos_codTurnos`, `cargo_codCargo`, `disponivel`) VALUES
	(2, 'Robertinho', '1900-09-20', '02392032', '210290192', 2000.00, 1, 1, 1),
	(3, 'Roberto', '2001-09-13', 'd', 'dd', 2.00, 1, 1, 1),
	(4, 'Rogerio', '1984-10-29', 'a', 'a', 1.00, 1, 1, 1),
	(5, 'Roberto Armando', '1984-08-09', 'roberto192', '092.012.323-12', 1000.00, 1, 1, 1);

-- Copiando estrutura para tabela bd_restaurante.ingrediente
DROP TABLE IF EXISTS `ingrediente`;
CREATE TABLE IF NOT EXISTS `ingrediente` (
  `codIngrediente` int NOT NULL AUTO_INCREMENT,
  `nomeIngredientes` varchar(45) NOT NULL,
  `quantiIngredientes` decimal(6,2) NOT NULL,
  `dataProducao` date NOT NULL,
  `dataVencimento` date NOT NULL,
  `valorIngrediente` decimal(6,2) NOT NULL,
  `descricaoIngrediente` varchar(300) DEFAULT NULL,
  `fornecedores_codFornecedor` int NOT NULL,
  PRIMARY KEY (`codIngrediente`,`fornecedores_codFornecedor`),
  KEY `fk_ingrediente_fornecedores1_idx` (`fornecedores_codFornecedor`),
  CONSTRAINT `fk_ingrediente_fornecedores1` FOREIGN KEY (`fornecedores_codFornecedor`) REFERENCES `fornecedores` (`codFornecedor`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.ingrediente: ~12 rows (aproximadamente)
INSERT INTO `ingrediente` (`codIngrediente`, `nomeIngredientes`, `quantiIngredientes`, `dataProducao`, `dataVencimento`, `valorIngrediente`, `descricaoIngrediente`, `fornecedores_codFornecedor`) VALUES
	(1, 'dd', 10.00, '2025-10-25', '2025-10-31', 23.00, 'sds', 6),
	(6, 'Pão', 96.00, '2025-10-01', '2026-03-28', 1.50, 'Pão artesanal de hambúrguer', 2),
	(7, 'Queijo Cheddar', 200.00, '2025-11-01', '2023-06-30', 2.00, 'Queijo cheddar derretido', 4),
	(8, 'Bacon Crocante', 149.00, '2025-12-01', '2023-05-30', 1.50, 'Bacon crocante e frito', 3),
	(9, 'Alface', 120.00, '2025-11-10', '2025-10-16', 0.50, 'Alface fresca e crocante', 5),
	(17, 'Pão Brioche', 99.00, '2025-10-01', '2026-10-01', 1.50, 'Pão brioche para hambúrguer', 8),
	(18, 'Queijo Cheddar', 200.00, '2025-10-01', '2026-10-01', 2.00, 'Queijo cheddar derretido', 2),
	(19, 'Bacon Crocante', 150.00, '2025-10-01', '2026-10-01', 1.80, 'Bacon crocante e frito', 3),
	(20, 'Alface Fresca', 120.00, '2025-10-01', '2025-12-01', 0.50, 'Alface fresca e crocante', 4),
	(21, 'Molho Especial', 100.00, '2025-10-01', '2026-10-01', 2.00, 'Molho especial para hambúrguer', 5),
	(22, 'Chocolate em pó', 56.00, '2025-10-01', '2025-12-01', 3.00, 'Chocolate em pó para milkshake', 6),
	(23, 'Creme de Leite', 54.00, '2025-10-01', '2026-10-01', 2.50, 'Creme de leite para milkshake', 7);

-- Copiando estrutura para tabela bd_restaurante.mesa
DROP TABLE IF EXISTS `mesa`;
CREATE TABLE IF NOT EXISTS `mesa` (
  `codMesa` int NOT NULL AUTO_INCREMENT,
  `numeroMesa` int NOT NULL,
  `localMesa` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`codMesa`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.mesa: ~5 rows (aproximadamente)
INSERT INTO `mesa` (`codMesa`, `numeroMesa`, `localMesa`) VALUES
	(1, 10, 'Jogar'),
	(2, 5, 'f'),
	(3, 2, 'Perto da Cozinha'),
	(4, 1, 'Perto entrada'),
	(5, 4, 'Bancada');

-- Copiando estrutura para tabela bd_restaurante.pagamento
DROP TABLE IF EXISTS `pagamento`;
CREATE TABLE IF NOT EXISTS `pagamento` (
  `codPagamento` int NOT NULL AUTO_INCREMENT,
  `formaPagamento` varchar(150) NOT NULL,
  `valorPago` decimal(10,2) NOT NULL,
  `dataPagamento` date NOT NULL,
  `statusPagamento` varchar(150) DEFAULT NULL,
  `pedido_codpedido` int NOT NULL,
  `cliente_codCliente` int NOT NULL,
  PRIMARY KEY (`codPagamento`,`pedido_codpedido`),
  KEY `fk_pagamento_pedido1_idx` (`pedido_codpedido`),
  KEY `fk_cliente_pagamento` (`cliente_codCliente`),
  CONSTRAINT `fk_cliente_pagamento` FOREIGN KEY (`cliente_codCliente`) REFERENCES `cliente` (`codCliente`),
  CONSTRAINT `fk_pagamento_pedido1` FOREIGN KEY (`pedido_codpedido`) REFERENCES `pedido` (`codpedido`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.pagamento: ~3 rows (aproximadamente)
INSERT INTO `pagamento` (`codPagamento`, `formaPagamento`, `valorPago`, `dataPagamento`, `statusPagamento`, `pedido_codpedido`, `cliente_codCliente`) VALUES
	(5, 'pix', 60.00, '2025-10-29', 'andademento', 1, 1),
	(6, 'dinheiro', 24.00, '2025-10-31', 'andamento', 3, 2),
	(7, 'pix', 18.00, '2025-11-04', 'andamento', 15, 5);

-- Copiando estrutura para tabela bd_restaurante.pedido
DROP TABLE IF EXISTS `pedido`;
CREATE TABLE IF NOT EXISTS `pedido` (
  `codpedido` int NOT NULL AUTO_INCREMENT,
  `cliente_codCliente` int NOT NULL,
  `mesa_codMesa` int NOT NULL,
  `funcionario_codFuncionario` int NOT NULL,
  `datahoraPedido` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`codpedido`,`cliente_codCliente`,`mesa_codMesa`,`funcionario_codFuncionario`),
  KEY `fk_pedido_cliente1_idx` (`cliente_codCliente`),
  KEY `fk_pedido_mesa1_idx` (`mesa_codMesa`),
  KEY `fk_pedido_funcionario1_idx` (`funcionario_codFuncionario`),
  CONSTRAINT `fk_pedido_cliente1` FOREIGN KEY (`cliente_codCliente`) REFERENCES `cliente` (`codCliente`),
  CONSTRAINT `fk_pedido_funcionario1` FOREIGN KEY (`funcionario_codFuncionario`) REFERENCES `funcionario` (`codFuncionario`),
  CONSTRAINT `fk_pedido_mesa1` FOREIGN KEY (`mesa_codMesa`) REFERENCES `mesa` (`codMesa`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.pedido: ~5 rows (aproximadamente)
INSERT INTO `pedido` (`codpedido`, `cliente_codCliente`, `mesa_codMesa`, `funcionario_codFuncionario`, `datahoraPedido`) VALUES
	(1, 1, 1, 2, '2025-09-14 11:52:40'),
	(2, 3, 3, 2, '2025-09-14 12:34:09'),
	(3, 2, 5, 2, '2025-09-14 12:34:26'),
	(4, 1, 4, 2, '2025-09-20 20:19:00'),
	(15, 5, 5, 3, '2025-10-29 09:23:34');

-- Copiando estrutura para tabela bd_restaurante.pedido_por_cardapio
DROP TABLE IF EXISTS `pedido_por_cardapio`;
CREATE TABLE IF NOT EXISTS `pedido_por_cardapio` (
  `codpedido_por_cadapio` int NOT NULL AUTO_INCREMENT,
  `pedido_idpedido` int NOT NULL,
  `cardapio_codCardapio` int NOT NULL,
  `quantidade` int NOT NULL,
  PRIMARY KEY (`codpedido_por_cadapio`,`pedido_idpedido`,`cardapio_codCardapio`),
  KEY `fk_pedido_has_cardapio_cardapio1_idx` (`cardapio_codCardapio`),
  KEY `fk_pedido_has_cardapio_pedido1_idx` (`pedido_idpedido`),
  CONSTRAINT `fk_pedido_has_cardapio_cardapio1` FOREIGN KEY (`cardapio_codCardapio`) REFERENCES `cardapio` (`codCardapio`),
  CONSTRAINT `fk_pedido_has_cardapio_pedido1` FOREIGN KEY (`pedido_idpedido`) REFERENCES `pedido` (`codpedido`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.pedido_por_cardapio: ~11 rows (aproximadamente)
INSERT INTO `pedido_por_cardapio` (`codpedido_por_cadapio`, `pedido_idpedido`, `cardapio_codCardapio`, `quantidade`) VALUES
	(1, 1, 1, 2),
	(2, 1, 1, 1),
	(3, 2, 8, 1),
	(4, 3, 5, 2),
	(5, 2, 1, 2),
	(6, 2, 5, 2),
	(12, 1, 1, 2),
	(13, 1, 1, 2),
	(17, 2, 8, 2),
	(18, 4, 8, 0),
	(19, 15, 6, 1);

-- Copiando estrutura para procedure bd_restaurante.proc_alterarCardapio
DROP PROCEDURE IF EXISTS `proc_alterarCardapio`;
DELIMITER //
CREATE PROCEDURE `proc_alterarCardapio`(
	IN `entradaCodCardapio` INT,
	IN `entradaNome` VARCHAR(150),
	IN `entradaValor` DECIMAL(6,2),
	IN `entradaDescricao` VARCHAR(500),
	IN `entradaCategoria` INT
)
BEGIN
   

    
    SELECT COUNT(*) INTO @cardapioExistente
    FROM cardapio
    WHERE codCardapio = entradaCodCardapio;

    IF (@cardapioExistente) THEN
        
        IF (entradaNome IS NOT NULL) THEN
            UPDATE cardapio
            SET nomeComida = entradaNome
            WHERE codCardapio = entradaCodCardapio;
        END IF;

        IF (entradaValor IS NOT NULL) THEN
            UPDATE cardapio
            SET valorComida = entradaValor
            WHERE codCardapio = entradaCodCardapio;
        END IF;

        IF (entradaDescricao IS NOT NULL) THEN
            UPDATE cardapio
            SET descricaoComida = entradaDescricao
            WHERE codCardapio = entradaCodCardapio;
        END IF;

        IF (entradaCategoria IS NOT NULL) THEN
            UPDATE cardapio
            SET categoria_codCategoria = entradaCategoria
            WHERE codCardapio = entradaCodCardapio;
        END IF;

        SELECT 'Cardápio atualizado com sucesso!' AS Resultado;
    ELSE
        SELECT 'Item não encontrado no cardápio!' AS Erro;
    END IF;
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_alterarCategoria
DROP PROCEDURE IF EXISTS `proc_alterarCategoria`;
DELIMITER //
CREATE PROCEDURE `proc_alterarCategoria`(
	IN `entradaCodCategoria` INT,
	IN `entradaNomeCategoria` VARCHAR(150)
)
BEGIN
    

    
    SELECT COUNT(*) INTO @categoriaExistente
    FROM categoria
    WHERE codCategoria = entradaCodCategoria;

    IF (@categoriaExistente) THEN
        UPDATE categoria
        SET nomeCategoria = entradaNomeCategoria
        WHERE codCategoria = entradaCodCategoria;

        SELECT 'Categoria atualizada com sucesso!' AS Resultado;
    ELSE
        SELECT 'Categoria não encontrada!' AS Erro;
    END IF;
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_alterarCliente
DROP PROCEDURE IF EXISTS `proc_alterarCliente`;
DELIMITER //
CREATE PROCEDURE `proc_alterarCliente`(
	IN `entradaCodCliente` INT,
	IN `entradaNome` VARCHAR(150),
	IN `entradaSenha` VARCHAR(150),
	IN `entradaCpf` VARCHAR(50),
	IN `entradaTelefone` VARCHAR(50)
)
BEGIN

    SELECT COUNT(*) INTO @clienteExistente
    FROM cliente
    WHERE codCliente = entradaCodCliente;


    IF(@clienteExistente)THEN

        IF (entradaNome IS NOT NULL) THEN
            UPDATE cliente
            SET nomeCliente = entradaNome
            WHERE codCliente = entradaCodCliente;
        END IF;


        IF (entradaSenha IS NOT NULL) THEN
            UPDATE cliente
            SET senhaCliente = entradaSenha
            WHERE codCliente = entradaCodCliente;
        END IF;

			IF (entradaCpf IS NOT NULL) THEN
            UPDATE cliente
            SET cpfCliente = entradaCpf
            WHERE codCliente = entradaCodCliente;
        END IF;

        IF (entradaTelefone IS NOT NULL) THEN
            UPDATE cliente
            SET telefone = entradaTelefone
            WHERE codCliente = entradaCodCliente;
        END IF;

			
        
			

        SELECT "Cliente atualizado com sucesso!" AS Resultado;
    ELSE

        SELECT "Cliente não encontrado!" AS Erro;
    END IF;

END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_alterarFornecedor
DROP PROCEDURE IF EXISTS `proc_alterarFornecedor`;
DELIMITER //
CREATE PROCEDURE `proc_alterarFornecedor`(
    IN `entradaCodFornecedor` INT,
    IN `entradaNomeFornecedor` VARCHAR(150),
    IN `entradaCnpj` VARCHAR(45),
    IN `entradaEndereco` VARCHAR(150),
    IN `entradaBairro` VARCHAR(45),
    IN `entradaCidade` VARCHAR(45),
    IN `entradaEstado` VARCHAR(2)
)
BEGIN
    SELECT COUNT(*) INTO @fornecedorExistente
    FROM fornecedores
    WHERE codFornecedor = entradaCodFornecedor;

    IF(@fornecedorExistente) THEN

        IF (entradaNomeFornecedor IS NOT NULL) THEN
            UPDATE fornecedores
            SET nomeFornecedor = entradaNomeFornecedor
            WHERE codFornecedor = entradaCodFornecedor;
        END IF;

        IF (entradaCnpj IS NOT NULL) THEN
            UPDATE fornecedores
            SET cnpj = entradaCnpj
            WHERE codFornecedor = entradaCodFornecedor;
        END IF;

        IF (entradaEndereco IS NOT NULL) THEN
            UPDATE fornecedores
            SET endereco = entradaEndereco
            WHERE codFornecedor = entradaCodFornecedor;
        END IF;

        IF (entradaBairro IS NOT NULL) THEN
            UPDATE fornecedores
            SET bairro = entradaBairro
            WHERE codFornecedor = entradaCodFornecedor;
        END IF;

        IF (entradaCidade IS NOT NULL) THEN
            UPDATE fornecedores
            SET cidade = entradaCidade
            WHERE codFornecedor = entradaCodFornecedor;
        END IF;

        IF (entradaEstado IS NOT NULL) THEN
            UPDATE fornecedores
            SET estado = entradaEstado
            WHERE codFornecedor = entradaCodFornecedor;
        END IF;

        SELECT "Fornecedor atualizado com sucesso!" AS Resultado;
    ELSE
        SELECT "Fornecedor não encontrado!" AS Erro;
    END IF;

END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_alterarFuncionario
DROP PROCEDURE IF EXISTS `proc_alterarFuncionario`;
DELIMITER //
CREATE PROCEDURE `proc_alterarFuncionario`(
	IN `entradaCodFuncionario` INT,
	IN `entradaNomeFuncionario` VARCHAR(150),
	IN `entradaDataFuncionario` DATE,
	IN `entradaSenhaFuncionario` VARCHAR(45),
	IN `entradaCpfFuncionario` VARCHAR(45),
	IN `entradaSalarioFuncionario` DECIMAL(6,2),
	IN `entradaCodCargo` INT
)
BEGIN
    
    SELECT COUNT(*) INTO @funcionarioExistente
    FROM funcionario
    WHERE codFuncionario = entradaCodFuncionario;
	 SELECT COUNT(*) INTO @cargoExistente
    FROM cargo
    WHERE codCargo = entradaCodCargo;

    IF(@funcionarioExistente)THEN	
        IF (entradaNomeFuncionario IS NOT NULL) THEN
            UPDATE funcionario
            SET nomeFuncionario = entradaNomeFuncionario
            WHERE codFuncionario = entradaCodFuncionario;
        END IF;

        IF (entradaDataFuncionario IS NOT NULL) THEN
            UPDATE funcionario
            SET dataNascimento = entradaDataFuncionario
            WHERE codFuncionario = entradaCodFuncionario;
        END IF;
        
        IF (entradaSenhaFuncionario IS NOT NULL) THEN
            UPDATE funcionario
            SET senhaFuncionario = entradaSenhaFuncionario
            WHERE codFuncionario = entradaCodFuncionario;
        END IF;
        
        IF (entradaCpfFuncionario IS NOT NULL) THEN
            UPDATE funcionario
            SET senhaFuncionario = entradaCpfFuncionario
            WHERE codFuncionario = entradaCodFuncionario;
        END IF;
        
        IF (entradaSalarioFuncionario IS NOT NULL) THEN
            UPDATE funcionario
            SET salarioFuncionario = entradaSalarioFuncionario
            WHERE codFuncionario = entradaCodFuncionario;
        END IF;
			
        IF (@cargoExistente) THEN
            UPDATE funcionario
            SET cargo_codCargo = entradaCodCargo
            WHERE codFuncionario = entradaCodFuncionario;
         else
         	SELECT "Codígo Cargo errado ou não existe" AS Erro;
        END IF;
        
        SELECT "Funcionario atualizado com sucesso!" AS Resultado;
    ELSE
        
        SELECT "Funcionario não encontrado!" AS Erro;
    END IF;

END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_alterarMesa
DROP PROCEDURE IF EXISTS `proc_alterarMesa`;
DELIMITER //
CREATE PROCEDURE `proc_alterarMesa`(
    IN `entradaCodMesa` INT,
    IN `entradaNumeroMesa` INT,
    IN `entradaLocalMesa` VARCHAR(150)
)
BEGIN
    
    SELECT COUNT(*) INTO @mesaExistente
    FROM mesa
    WHERE codMesa = entradaCodMesa;

    IF (@mesaExistente) THEN
    
        IF (entradaNumeroMesa IS NOT NULL) then
            UPDATE mesa
            SET numeroMesa = entradaNumeroMesa
            WHERE codMesa = entradaCodMesa;
        END IF;

        IF (entradaLocalMesa IS NOT NULL) then
            UPDATE mesa
            SET localMesa = entradaLocalMesa
            WHERE codMesa = entradaCodMesa;
        END IF;

        SELECT "Mesa atualizada com sucesso!" AS Resultado;
    ELSE
        SELECT "Mesa não encontrada!" AS Erro;
    END IF;

END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_alterarTurnos
DROP PROCEDURE IF EXISTS `proc_alterarTurnos`;
DELIMITER //
CREATE PROCEDURE `proc_alterarTurnos`(
    IN `entradacodTurno` INT,
    IN `entradaHorarioInicial` DATE,
    IN `entradaHorarioFinal` DATE
)
BEGIN
    SELECT COUNT(*) INTO @contador FROM turnos WHERE codTurnos = entradacodTurno;
    IF (@contador) THEN
        UPDATE turnos SET horarioInicio = entradaHorarioInicial, 
        horarioFinal = entradaHorarioFinal WHERE codTurnos = entradaCodTurno;  
    ELSE
        SELECT "Não foi encontrado o codigo" AS Erro;
    END IF;
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_apagarCargo
DROP PROCEDURE IF EXISTS `proc_apagarCargo`;
DELIMITER //
CREATE PROCEDURE `proc_apagarCargo`(
	IN `entradaCodCargo` INT
)
BEGIN
	SELECT COUNT(*) INTO @existe
   FROM cargo
   WHERE codCargo = entradaCodCargo;

   IF (@existe) THEN
      DELETE FROM cargo
      WHERE codCargo = entradaCodCargo;
      SELECT 'Deu certo' AS mensagem;
   ELSE
      SELECT 'Código não encontrado.' AS mensagem;
   END IF;
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_apagarCategoria
DROP PROCEDURE IF EXISTS `proc_apagarCategoria`;
DELIMITER //
CREATE PROCEDURE `proc_apagarCategoria`(
	IN `entradaCodCategoria` INT
)
BEGIN
	SELECT COUNT(*) INTO @existe
   FROM categoria
   WHERE codCategoria = entradaCodCategoria;

   IF (@existe) THEN
      DELETE FROM categoria
      WHERE codCategoria = entradaCodCategoria;
      SELECT 'Deu certo' AS mensagem;
   ELSE
      SELECT 'Código não encontrado.' AS mensagem;
   END IF;
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_apagarCliente
DROP PROCEDURE IF EXISTS `proc_apagarCliente`;
DELIMITER //
CREATE PROCEDURE `proc_apagarCliente`(
	IN `entradaCodCliente` INT
)
BEGIN
	SELECT COUNT(*) INTO @existe
   FROM cliente
   WHERE codCliente= entradaCodCliente;

   IF (@existe) THEN
      DELETE FROM cliente
      WHERE codCliente = entradaCodCliente;
      SELECT 'Deu certo' AS mensagem;
   ELSE
      SELECT 'Código não encontrado.' AS mensagem;
   END IF;
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_apagarFornecedores
DROP PROCEDURE IF EXISTS `proc_apagarFornecedores`;
DELIMITER //
CREATE PROCEDURE `proc_apagarFornecedores`(
	IN `entradaCodFornecedores` INT
)
BEGIN
   SELECT COUNT(*) INTO @existe
   FROM fornecedores
   WHERE codFornecedor = entradaCodFornecedores;

   IF (@existe) THEN
      DELETE FROM fornecedores
      WHERE codFornecedor = entradaCodFornecedores;
      SELECT 'Deu certo' AS mensagem;
   ELSE
      SELECT 'Código não encontrado.' AS mensagem;
   END IF;
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_apagarFuncionario
DROP PROCEDURE IF EXISTS `proc_apagarFuncionario`;
DELIMITER //
CREATE PROCEDURE `proc_apagarFuncionario`(
	IN `entradaCodFuncionario` INT
)
BEGIN


    
   SELECT COUNT(*) INTO @existe
   FROM funcionario
   WHERE codFuncionario = entradaCodFuncionario;

   IF (@existe > 0) THEN
      DELETE FROM funcionario
      WHERE codFuncionario = entradaCodFuncionario;
      SELECT 'Deu certo' AS mensagem;
   ELSE
      SELECT 'Código não encontrado.' AS mensagem;
   END IF;

END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_apagarMesa
DROP PROCEDURE IF EXISTS `proc_apagarMesa`;
DELIMITER //
CREATE PROCEDURE `proc_apagarMesa`(
	IN `entradaCodMesa` INT
)
BEGIN
   SELECT COUNT(*) INTO @existe
   FROM mesa
   WHERE codMesa = entradaCodMesa;

   IF (@existe > 0) THEN
      DELETE FROM mesa
      WHERE codMesa = entradaCodMesa;
      SELECT 'Deu certo' AS mensagem;
   ELSE
      SELECT 'Código não encontrado.' AS mensagem;
   END IF;
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_apagarTurnos
DROP PROCEDURE IF EXISTS `proc_apagarTurnos`;
DELIMITER //
CREATE PROCEDURE `proc_apagarTurnos`(
	IN `entradaCodTurnos` INT
)
BEGIN
	  SELECT COUNT(*) INTO @existe
   FROM turnos
   WHERE codTurnos = entradaCodTurnos;

   IF (@existe > 0) THEN
      DELETE FROM turnos
      WHERE codTurnos = entradaCodTurnos;
      SELECT 'Deu certo' AS mensagem;
   ELSE
      SELECT 'Código não encontrado.' AS mensagem;
   END IF;
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_insereCardapio
DROP PROCEDURE IF EXISTS `proc_insereCardapio`;
DELIMITER //
CREATE PROCEDURE `proc_insereCardapio`(
	IN `entradaNomeComida` VARCHAR(150),
	IN `entradaValorComida` DECIMAL(6,2),
	IN `entradaDescricaoComida` VARCHAR(500),
	IN `entradaCodCategoria` INT
)
BEGIN
    INSERT INTO cardapio (nomeComida, valorComida, descricaoComida, categoria_codCategoria)
    VALUES(entradaNomeComida, entradaValorComida, entradaDescricaoComida, entradaCodCategoria);

    SELECT 'Novo item do cardápio inserido com sucesso!' AS Resultado;
    
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_insereCategoria
DROP PROCEDURE IF EXISTS `proc_insereCategoria`;
DELIMITER //
CREATE PROCEDURE `proc_insereCategoria`(
	IN `entradaCategoria` VARCHAR(500)
)
BEGIN
    INSERT INTO categoria(nomeCategoria) VALUES(entradaCategoria);
    SELECT * FROM categoria;
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_insereCliente
DROP PROCEDURE IF EXISTS `proc_insereCliente`;
DELIMITER //
CREATE PROCEDURE `proc_insereCliente`(
	IN `entradaNome` VARCHAR(150),
	IN `entradaSenha` VARCHAR(150),
	IN `entradaData` DATE
)
BEGIN
    INSERT INTO cliente(nomeCliente, senhaCliente)
    VALUES(entradaNome, entradaSenha);
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_insereEstoque
DROP PROCEDURE IF EXISTS `proc_insereEstoque`;
DELIMITER //
CREATE PROCEDURE `proc_insereEstoque`(
	IN `p_nomeItem` VARCHAR(150),
	IN `p_quant` DECIMAL(6,2),
	IN `p_dataProducao` DATE,
	IN `p_dataVencimento` DATE,
	IN `p_descricao` VARCHAR(300)
)
BEGIN
    INSERT INTO estoque (
        nomeItem,
        quant,
        dataProducao,
        dataVencimento,
        descricao
    ) VALUES (
        p_nomeItem,
        p_quant,
        p_dataProducao,
        p_dataVencimento,
        p_descricao
    );
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_insereFornecedor
DROP PROCEDURE IF EXISTS `proc_insereFornecedor`;
DELIMITER //
CREATE PROCEDURE `proc_insereFornecedor`(
    IN `entradaNomeFornecedor` VARCHAR(150),
    IN `entradaCnpj` VARCHAR(45),
    IN `entradaEndereco` VARCHAR(150),
    IN `entradaBairro` VARCHAR(45),
    IN `entradaCidade` VARCHAR(45),
    IN `entradaEstado` VARCHAR(2)
)
BEGIN
    INSERT INTO fornecedores(nomeFornecedor, cnpj, endereco, bairro, cidade, estado)
    VALUES(entradaNomeFornecedor, entradaCnpj, entradaEndereco, entradaBairro, entradaCidade, entradaEstado);
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_insereFuncionario
DROP PROCEDURE IF EXISTS `proc_insereFuncionario`;
DELIMITER //
CREATE PROCEDURE `proc_insereFuncionario`(
	IN `entradaNome` VARCHAR(150),
	IN `entradaNascimento` DATE,
	IN `entradaSenha` VARCHAR(45),
	IN `entradaCpf` VARCHAR(45),
	IN `entradaSalario` DECIMAL(6,2),
	IN `entradaCargo` VARCHAR(150),
	IN `entradacodTurno` INT
)
BEGIN
	SELECT COUNT(*) INTO @contadorTurno FROM turnos WHERE codTurnos = entradacodTurno;
  SELECT COUNT(*) INTO @contadorCargo FROM cargo WHERE codCargo = entradaCargo;

  IF (@contadorTurno > 0 AND @contadorCargo > 0) THEN
    INSERT INTO funcionario (
      nomeFuncionario,
      dataNascimento,
      senhaFuncionario,
      cpfFuncionario,
      salarioFuncionario,
      turnos_codTurnos,
      cargo_codCargo,
      disponivel
    ) VALUES (
      entradaNome,
      entradaNascimento,
      entradaSenha,
      entradaCpf,
      entradaSalario,
      entradacodTurno,
      entradaCargo,
      1
    );
    SELECT 'Funcionário inserido com sucesso!' AS Resultado;
  		ELSEIF (@contadorTurno = 0) THEN
    		SELECT 'Turno não cadastrado' AS Erro;
  ELSE
    	SELECT 'Cargo não cadastrado' AS Erro;
  END IF;
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_insereMesa
DROP PROCEDURE IF EXISTS `proc_insereMesa`;
DELIMITER //
CREATE PROCEDURE `proc_insereMesa`(
	IN `entradaNumeroMesa` INT,
	IN `entradaLocalMesa` VARCHAR(150)
)
BEGIN
    INSERT INTO mesa(numeroMesa, localMesa) 
    VALUES(entradaNumeroMesa, entradaLocalMesa);
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_insereTurnos
DROP PROCEDURE IF EXISTS `proc_insereTurnos`;
DELIMITER //
CREATE PROCEDURE `proc_insereTurnos`(
    IN `entradaHorarioInicio` TIME,
    IN `entradaHorarioFinal` TIME
)
BEGIN
    INSERT INTO turnos(horarioInicio , horarioFinal)
    VALUES(entradaHorarioInicio, entradaHorarioFinal);
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_relatorioCardapio
DROP PROCEDURE IF EXISTS `proc_relatorioCardapio`;
DELIMITER //
CREATE PROCEDURE `proc_relatorioCardapio`(
	IN `entradaOpcao` INT
)
BEGIN
	CASE entradaOpcao
        WHEN 1 THEN
            -- 1) Catálogo básico: produto + categoria + preço, ordem alfabética
            SELECT 'Ordem alfabetica' AS criterio, c.codCardapio, c.nomeComida AS produto, cat.nomeCategoria AS categoria,
                CONCAT('R$ ', FORMAT(c.valorComida, 2, 'pt_BR')) AS preco,
                CONCAT(LEFT(IFNULL(c.descricaoComida,''), 60),
                       IF(LENGTH(IFNULL(c.descricaoComida,''))>60,'...','')) AS descricao_curta
            FROM cardapio c
            JOIN categoria cat ON cat.codCategoria = c.categoria_codCategoria
            ORDER BY produto;

        WHEN 2 THEN
            -- 2) Do mais barato ao mais caro, com faixa de preço
            SELECT
                c.codCardapio,
                c.nomeComida AS produto,
                CONCAT('R$ ', FORMAT(c.valorComida, 2)) AS preco,
                CASE
                    WHEN c.valorComida < 10  THEN 
								'Barato'
                    WHEN c.valorComida < 20  THEN 
						  		'Medio'
                    WHEN c.valorComida < 30  THEN 
						  		'Premium'
                    ELSE 'Especial'
                END AS faixa_preco,
                cat.nomeCategoria AS categoria
            FROM cardapio c
            INNER JOIN categoria cat ON cat.codCategoria = c.categoria_codCategoria
            ORDER BY c.valorComida;

        WHEN 3 THEN
        		#3 total de pedidos saídos
				SELECT c.codCardapio, c.nomeComida AS produto, COALESCE(SUM(pc.quantidade), 0) AS total_vendido
      		FROM cardapio c
      		LEFT JOIN pedido_por_cardapio pc ON pc.cardapio_codCardapio = c.codCardapio
      		GROUP BY c.codCardapio, c.nomeComida
      		ORDER BY total_vendido DESC, produto;
  
            

        ELSE
            SELECT 'Opcao invalida. Use 1 a 3.' AS Erro;
    END CASE;
END//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_relatorioClientes
DROP PROCEDURE IF EXISTS `proc_relatorioClientes`;
DELIMITER //
CREATE PROCEDURE `proc_relatorioClientes`(
	IN `entradaOpcao` INT
)
BEGIN
	CASE entradaOpcao
        WHEN 1 THEN
            SELECT codCliente, nomeCliente, cpfCliente, telefone
            FROM cliente
            ORDER BY nomeCliente;
            
        when 2 then 
      		SELECT codCliente, nomeCliente, cpfCliente, telefone
      		FROM cliente
      		ORDER BY nomeCliente DESC;
        WHEN 3 THEN
         	SELECT codCliente, nomeCliente, DATE(dataCadastro) AS dataCadastro
         	FROM cliente
            ORDER BY dataCadastro;
            
        WHEN 4 THEN
           SELECT codCliente, nomeCliente, DATE(dataCadastro) AS dataCadastro
         	FROM cliente
            ORDER BY dataCadastro DESC;

        WHEN 5 THEN
            SELECT c.nomeCliente, p.codpedido, p.mesa_codMesa, p.datahoraPedido 
				FROM cliente AS c INNER JOIN pedido AS p ON
				c.codCliente = p.cliente_codCliente ; 
        ELSE
            SELECT 'Opção inválida. Use 1 a 5.' AS Erro;
    END CASE;
   end//
DELIMITER ;

-- Copiando estrutura para procedure bd_restaurante.proc_relatorioFuncionario
DROP PROCEDURE IF EXISTS `proc_relatorioFuncionario`;
DELIMITER //
CREATE PROCEDURE `proc_relatorioFuncionario`(
	IN `entradaOpcao` INT
)
BEGIN
	CASE entradaOpcao
    WHEN 1 THEN
      SELECT 
        f.codFuncionario, f.nomeFuncionario AS funcionario, ca.nomeCargo AS cargo, f.salarioFuncionario AS salario, t.horarioInicio, t.horarioFinal,
        CASE 
				WHEN f.disponivel = 1 THEN 
					'Disponível' 
				ELSE 'Indisponível' 
			END AS status
      FROM funcionario f
      INNER JOIN cargo ca ON ca.codCargo = f.cargo_codCargo
      INNER JOIN turnos t  ON t.codTurnos = f.turnos_codTurnos
      ORDER BY funcionario;

    WHEN 2 THEN
      SELECT f.codFuncionario, f.nomeFuncionario AS funcionario, ca.nomeCargo AS cargo, f.salarioFuncionario AS salario,
        CASE
          WHEN f.salarioFuncionario < 1500 THEN 'Baixo'
          WHEN f.salarioFuncionario < 3000 THEN 'Médio'
          WHEN f.salarioFuncionario < 5000 THEN 'Alto'
          ELSE 'Top'
        END AS faixa_salarial
      FROM funcionario f
      INNER JOIN cargo ca ON ca.codCargo = f.cargo_codCargo
      ORDER BY salario DESC, funcionario;

    WHEN 3 THEN
      SELECT
        f.codFuncionario,
        f.nomeFuncionario AS funcionario,
        ca.nomeCargo      AS cargo,
        COALESCE(COUNT(p.codpedido), 0) AS qtdPedidos
      FROM funcionario f
      LEFT JOIN pedido p ON p.funcionario_codFuncionario = f.codFuncionario
      INNER JOIN cargo ca ON ca.codCargo = f.cargo_codCargo
      GROUP BY f.codFuncionario, f.nomeFuncionario, ca.nomeCargo
      ORDER BY qtdPedidos DESC, funcionario;

    ELSE
      SELECT 'Opção inválida. Use 1, 2 ou 3.' AS Erro;
   END case;
END//
DELIMITER ;

-- Copiando estrutura para tabela bd_restaurante.turnos
DROP TABLE IF EXISTS `turnos`;
CREATE TABLE IF NOT EXISTS `turnos` (
  `codTurnos` int NOT NULL AUTO_INCREMENT,
  `horarioInicio` time DEFAULT NULL,
  `horarioFinal` time DEFAULT NULL,
  PRIMARY KEY (`codTurnos`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

-- Copiando dados para a tabela bd_restaurante.turnos: ~0 rows (aproximadamente)
INSERT INTO `turnos` (`codTurnos`, `horarioInicio`, `horarioFinal`) VALUES
	(1, '09:20:00', '20:30:00');

-- Copiando estrutura para view bd_restaurante.vi_diasclientes
DROP VIEW IF EXISTS `vi_diasclientes`;
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `vi_diasclientes` (
	`nomeCliente` VARCHAR(1) NOT NULL COLLATE 'utf8mb3_general_ci',
	`cpfCliente` VARCHAR(1) NOT NULL COLLATE 'utf8mb3_general_ci',
	`telefone` VARCHAR(1) NULL COLLATE 'utf8mb3_general_ci',
	`dataCadastro_formatada` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`dias_cadastrado` INT NULL
) ENGINE=MyISAM;

-- Copiando estrutura para view bd_restaurante.vi_feedback
DROP VIEW IF EXISTS `vi_feedback`;
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `vi_feedback` (
	`nomeCliente` VARCHAR(1) NOT NULL COLLATE 'utf8mb3_general_ci',
	`telefone` VARCHAR(1) NULL COLLATE 'utf8mb3_general_ci',
	`DATA_Feedback` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci',
	`nota` INT NOT NULL,
	`descricao` VARCHAR(1) NULL COLLATE 'utf8mb3_general_ci'
) ENGINE=MyISAM;

-- Copiando estrutura para view bd_restaurante.vi_funcionarioinformacoes
DROP VIEW IF EXISTS `vi_funcionarioinformacoes`;
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `vi_funcionarioinformacoes` (
	`nomeFuncionario` VARCHAR(1) NOT NULL COLLATE 'utf8mb3_general_ci',
	`dataNascimento` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci',
	`idade` BIGINT NULL,
	`salarioFuncionario` DECIMAL(6,2) NOT NULL,
	`nomeCargo` VARCHAR(1) NULL COLLATE 'utf8mb3_general_ci'
) ENGINE=MyISAM;

-- Copiando estrutura para view bd_restaurante.vi_ingredientesfornecedores
DROP VIEW IF EXISTS `vi_ingredientesfornecedores`;
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `vi_ingredientesfornecedores` (
	`nomeItem` VARCHAR(1) NOT NULL COLLATE 'utf8mb3_general_ci',
	`quant` DECIMAL(6,2) NOT NULL,
	`descricao` VARCHAR(1) NULL COLLATE 'utf8mb3_general_ci',
	`data_producao` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci',
	`Produtos_Vencendo` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci',
	`nomeFornecedor` VARCHAR(1) NOT NULL COLLATE 'utf8mb3_general_ci',
	`endereco` VARCHAR(1) NULL COLLATE 'utf8mb3_general_ci'
) ENGINE=MyISAM;

-- Copiando estrutura para view bd_restaurante.vi_pedidoscardapio
DROP VIEW IF EXISTS `vi_pedidoscardapio`;
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `vi_pedidoscardapio` (
	`nomeCliente` VARCHAR(1) NOT NULL COLLATE 'utf8mb3_general_ci',
	`codpedido` INT NOT NULL,
	`nomeComida` VARCHAR(1) NOT NULL COLLATE 'utf8mb3_general_ci',
	`valorComida` DECIMAL(6,2) NOT NULL,
	`quantidade` INT NOT NULL,
	`totalItem` DECIMAL(16,2) NOT NULL
) ENGINE=MyISAM;

-- Copiando estrutura para view bd_restaurante.vi_visualizarcardapio
DROP VIEW IF EXISTS `vi_visualizarcardapio`;
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `vi_visualizarcardapio` (
	`nomeComida` VARCHAR(1) NOT NULL COLLATE 'utf8mb3_general_ci',
	`valorComida` DECIMAL(6,2) NOT NULL,
	`descricaoComida` VARCHAR(1) NULL COLLATE 'utf8mb3_general_ci',
	`nomeCategoria` VARCHAR(1) NOT NULL COLLATE 'utf8mb3_general_ci'
) ENGINE=MyISAM;

-- Copiando estrutura para trigger bd_restaurante.tri_atualizarIngredientesInsert
DROP TRIGGER IF EXISTS `tri_atualizarIngredientesInsert`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tri_atualizarIngredientesInsert` AFTER INSERT ON `pedido_por_cardapio` FOR EACH ROW BEGIN
    UPDATE ingrediente i
    JOIN cardapio_por_ingrediente cpi 
        ON i.codIngrediente = cpi.ingrediente_codIngrediente
    SET i.quantiIngredientes = i.quantiIngredientes - (cpi.quantidadePorComida * NEW.quantidade)
    WHERE cpi.cardapio_codCardapio = NEW.cardapio_codCardapio;


END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger bd_restaurante.tri_atualizarIngredientesUPDATE
DROP TRIGGER IF EXISTS `tri_atualizarIngredientesUPDATE`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tri_atualizarIngredientesUPDATE` AFTER UPDATE ON `pedido_por_cardapio` FOR EACH ROW BEGIN
	 DECLARE p_codCardapio INT;
    DECLARE p_quantidade INT;
    DECLARE p_quantidadeAntiga INT;
    
    
    SET p_codCardapio = NEW.cardapio_codCardapio;
    SET p_quantidade = NEW.quantidade;
    SET p_quantidadeAntiga = OLD.quantidade;

 
    IF p_quantidade <> p_quantidadeAntiga THEN
        
        UPDATE ingrediente i
        inner JOIN cardapio_por_ingrediente cpi 
            ON i.codIngrediente = cpi.ingrediente_codIngrediente
        SET i.quantiIngredientes = i.quantiIngredientes + (cpi.quantidadePorComida * p_quantidadeAntiga)
            - (cpi.quantidadePorComida * p_quantidade)
        WHERE cpi.cardapio_codCardapio = p_codCardapio;
     END if;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger bd_restaurante.tri_valorTotalPagamento
DROP TRIGGER IF EXISTS `tri_valorTotalPagamento`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tri_valorTotalPagamento` BEFORE INSERT ON `pagamento` FOR EACH ROW BEGIN
	DECLARE totalPedido DECIMAL(10,2) DEFAULT 0;
    DECLARE statusPagamento VARCHAR(50);
     DECLARE cliente_codCliente INT;

    -- Verifica o status do pagamento (se já foi pago anteriormente)
    SELECT p.statusPagamento INTO statusPagamento
    FROM pagamento p
    WHERE p.pedido_codpedido = NEW.pedido_codpedido;
    
    

    -- Se o pagamento já foi realizado, não permite inserir o pagamento novamente
    IF statusPagamento = 'pago' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Este pedido já foi pago.';
    ELSE
        -- Calcula o total do pedido
        SELECT SUM(c.valorComida * p.quantidade) INTO totalPedido
        FROM pedido_por_cardapio p
        inner JOIN cardapio c ON p.cardapio_codCardapio = c.codCardapio
        WHERE p.pedido_idpedido = NEW.pedido_codpedido;
		
        -- Atribui o valor do pagamento ao total calculado
        SET NEW.valorPago = totalPedido;
        
      	SELECT p.cliente_codCliente INTO cliente_codCliente
        FROM pedido p
        WHERE p.codpedido = NEW.pedido_codpedido;
        
        SET NEW.cliente_codCliente = cliente_codCliente;
   END if;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `vi_diasclientes`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vi_diasclientes` AS select `c`.`nomeCliente` AS `nomeCliente`,`c`.`cpfCliente` AS `cpfCliente`,`c`.`telefone` AS `telefone`,date_format(`c`.`dataCadastro`,'%d/%m/%Y') AS `dataCadastro_formatada`,(to_days(curdate()) - to_days(`c`.`dataCadastro`)) AS `dias_cadastrado` from `cliente` `c`
;

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `vi_feedback`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vi_feedback` AS select `c`.`nomeCliente` AS `nomeCliente`,`c`.`telefone` AS `telefone`,date_format(`f`.`dataFeedback`,'%d/%m/%Y %H:%i:%s') AS `DATA_Feedback`,`f`.`nota` AS `nota`,`f`.`descricao` AS `descricao` from (`cliente` `c` join `feedback` `f` on((`c`.`codCliente` = `f`.`cliente_codCliente`))) order by `f`.`dataFeedback` desc WITH CASCADED CHECK OPTION
;

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `vi_funcionarioinformacoes`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vi_funcionarioinformacoes` AS select `f`.`nomeFuncionario` AS `nomeFuncionario`,date_format(`f`.`dataNascimento`,'%d/%m/%Y') AS `dataNascimento`,floor(((to_days(curdate()) - to_days(`f`.`dataNascimento`)) / 365)) AS `idade`,`f`.`salarioFuncionario` AS `salarioFuncionario`,`c`.`nomeCargo` AS `nomeCargo` from (`funcionario` `f` join `cargo` `c` on((`f`.`cargo_codCargo` = `c`.`codCargo`)))
;

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `vi_ingredientesfornecedores`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vi_ingredientesfornecedores` AS select `i`.`nomeIngredientes` AS `nomeItem`,`i`.`quantiIngredientes` AS `quant`,`i`.`descricaoIngrediente` AS `descricao`,date_format(`i`.`dataProducao`,'%d/%m/%Y') AS `data_producao`,date_format(`i`.`dataVencimento`,'%d/%m/%Y') AS `Produtos_Vencendo`,`f`.`nomeFornecedor` AS `nomeFornecedor`,`f`.`endereco` AS `endereco` from (`ingrediente` `i` join `fornecedores` `f` on((`i`.`fornecedores_codFornecedor` = `f`.`codFornecedor`))) order by `i`.`dataVencimento`
;

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `vi_pedidoscardapio`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vi_pedidoscardapio` AS select `cl`.`nomeCliente` AS `nomeCliente`,`p`.`codpedido` AS `codpedido`,`c`.`nomeComida` AS `nomeComida`,`c`.`valorComida` AS `valorComida`,`pc`.`quantidade` AS `quantidade`,(`c`.`valorComida` * `pc`.`quantidade`) AS `totalItem` from (((`pedido` `p` join `pedido_por_cardapio` `pc` on((`p`.`codpedido` = `pc`.`pedido_idpedido`))) join `cardapio` `c` on((`pc`.`cardapio_codCardapio` = `c`.`codCardapio`))) join `cliente` `cl` on((`p`.`cliente_codCliente` = `cl`.`codCliente`)))
;

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `vi_visualizarcardapio`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vi_visualizarcardapio` AS select `c`.`nomeComida` AS `nomeComida`,`c`.`valorComida` AS `valorComida`,`c`.`descricaoComida` AS `descricaoComida`,`cat`.`nomeCategoria` AS `nomeCategoria` from (`cardapio` `c` join `categoria` `cat` on((`c`.`categoria_codCategoria` = `cat`.`codCategoria`)))
;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
