-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bd_restaurante
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cardapio`
--

DROP TABLE IF EXISTS `cardapio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cardapio` (
  `codCardapio` int NOT NULL AUTO_INCREMENT,
  `nomeComida` varchar(150) NOT NULL,
  `valorComida` decimal(6,2) NOT NULL,
  `descricaoComida` varchar(500) DEFAULT NULL,
  `categoria_codCategoria` int NOT NULL,
  PRIMARY KEY (`codCardapio`,`categoria_codCategoria`),
  KEY `fk_cardapio_categoria1_idx` (`categoria_codCategoria`),
  CONSTRAINT `fk_cardapio_categoria1` FOREIGN KEY (`categoria_codCategoria`) REFERENCES `categoria` (`codCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cardapio`
--

LOCK TABLES `cardapio` WRITE;
/*!40000 ALTER TABLE `cardapio` DISABLE KEYS */;
INSERT INTO `cardapio` VALUES (1,'BIGTITES',12.20,'Grande molho cheddar',3),(2,'Cheeseburger Clássico',7.99,'Pão, hambúrguer artesanal, queijo prato, alface, tomate e molho especial',1),(3,'Cheesebacon',22.50,'Hambúrguer artesanal, queijo cheddar, bacon crocante e maionese da casa',1),(4,'Smash Duplo',26.90,'Dois hambúrgueres smash 100g, queijo cheddar, cebola caramelizada e pão brioche',1),(5,'Batata Frita Tradicional',7.98,'Porção média de batata frita crocante',4),(6,'Batata com Cheddar e Bacon',18.00,'Batata frita coberta com cheddar cremoso e bacon em cubos',4),(7,'Refrigerante Lata',6.00,'Coca-Cola, Guaraná ou Fanta (350ml)',2),(8,'Milkshake de Chocolate',15.00,'Milkshake cremoso com calda de chocolate',3),(9,'Brownie com Sorvete',16.50,'Brownie caseiro com bola de sorvete de creme e calda de chocolate',3),(10,'Sorvete',20.00,'2 bolasde chocolate',3),(13,'GRANDE BIGTITES',20.00,'sdas',1);
/*!40000 ALTER TABLE `cardapio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cardapio_por_ingrediente`
--

DROP TABLE IF EXISTS `cardapio_por_ingrediente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cardapio_por_ingrediente` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cardapio_por_ingrediente`
--

LOCK TABLES `cardapio_por_ingrediente` WRITE;
/*!40000 ALTER TABLE `cardapio_por_ingrediente` DISABLE KEYS */;
INSERT INTO `cardapio_por_ingrediente` VALUES (1,2,6,4.00),(2,1,6,2.00),(3,1,8,3.00),(4,1,6,2.00),(5,1,7,3.00),(6,1,8,2.00),(11,1,6,2.00),(12,1,7,3.00),(13,1,8,2.00),(18,1,6,2.00),(19,1,7,3.00),(20,1,8,2.00),(25,1,17,2.00),(26,1,7,3.00),(27,1,8,2.00),(28,2,17,2.00),(29,2,7,2.00),(30,2,9,1.00),(31,2,21,1.50),(32,5,17,1.00),(33,5,8,1.00),(34,8,22,2.00),(35,8,23,3.00);
/*!40000 ALTER TABLE `cardapio_por_ingrediente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cargo`
--

DROP TABLE IF EXISTS `cargo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cargo` (
  `codCargo` int NOT NULL AUTO_INCREMENT,
  `nomeCargo` varchar(150) DEFAULT NULL,
  `perfil` enum('ADMIN','GARCOM','COZINHA','OUTRO') NOT NULL DEFAULT 'OUTRO',
  PRIMARY KEY (`codCargo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cargo`
--

LOCK TABLES `cargo` WRITE;
/*!40000 ALTER TABLE `cargo` DISABLE KEYS */;
INSERT INTO `cargo` VALUES (1,'Cozinheiro ','COZINHA'),(2,'Garçom','GARCOM'),(3,'Gerente','ADMIN'),(4,'Atentende','GARCOM'),(7,'sdad','OUTRO'),(11,'dd','OUTRO'),(12,'as','OUTRO');
/*!40000 ALTER TABLE `cargo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categoria`
--

DROP TABLE IF EXISTS `categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria` (
  `codCategoria` int NOT NULL AUTO_INCREMENT,
  `nomeCategoria` varchar(150) NOT NULL,
  PRIMARY KEY (`codCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria`
--

LOCK TABLES `categoria` WRITE;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` VALUES (1,'Hamburguer'),(2,'Bebida'),(3,'Sobremesa'),(4,'Petiscos');
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `codCliente` int NOT NULL AUTO_INCREMENT,
  `nomeCliente` varchar(150) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `emailVerificado` tinyint(1) NOT NULL DEFAULT '0',
  `cadastroCompleto` tinyint(1) NOT NULL DEFAULT '0',
  `cpfCliente` varchar(45) DEFAULT NULL,
  `senhaCliente` varchar(60) NOT NULL,
  `telefone` varchar(50) DEFAULT NULL,
  `dataCadastro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`codCliente`),
  UNIQUE KEY `uk_cliente_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'YUJI','yuji.1@exemplo.test',1,1,'21331231323','$2a$12$tGwOwCTN8660K4jRRTj4ru.pgkvy5VFgtL.A8n1fSisyg/JXY.2qq','293821','2025-09-13 19:15:50'),(2,'Otavio','otavio.2@exemplo.test',1,0,'','$2a$12$cZ6A.jSGzyR383C3XGnvc.kuOzqzVDO.GHTorFZWrmS0qFD5PduWu','(35)99999-9999','2025-09-14 12:30:38'),(3,'Pedro','pedro.3@exemplo.test',1,1,'luquinhas','$2a$12$LOh/N3Oa8h8USMff5FQFzu1txZZAp6rAnj3vOog8UGvc./Mj5wIvS','(35)91022-1202','2025-09-14 12:31:02'),(5,'rogerio','rogerio.5@exemplo.test',1,1,'dsd','$2a$12$bdBsJbvay4fdDMKbFZ0Lxe4TVSv7sqLgbHknuE1yrRHD5wmoOuTX6','23131','2025-10-29 09:15:35'),(7,'Yamamoto','yamamoto.7@exemplo.test',1,1,'000.000.000-00','$2a$12$ujg0SJB3SSB/e41Rtu8Hi.ktOM8StTowjQV3J96UKBb.w.y2k2Hu2','(32)99999-9999','2025-11-11 15:03:28'),(9,'Vinicius','vinicius.9@exemplo.test',1,1,'11144477735','$2a$12$z2KJhV3SU.TCR5ji3DwmhOtKHkErAMkdo.dQsppxQZALD0z0G0w.K','(35)99999-9999','2025-11-17 12:46:38'),(10,'Arthur Miranda','arthur.miranda.10@exemplo.test',1,1,'145.552.656-07','$2a$12$f9hPGSanOQLh06UIcT7w9.65H96McYd9jsov3GMKQReISf7uiwmR6','(35)99999-9999','2025-11-19 09:42:47'),(13,'Roberto Soares','roberto.soares.13@exemplo.test',1,1,'123.213.433-21','$2a$12$JVzfc2OtVmIawh9Rioq4uOJovGBrszbl8sYlxJbbpDS7/WQSgfLpi','359921-2321','2026-08-02 17:11:12'),(23,'Otavio Grande','otavio.cliente.23@exemplo.test',1,1,'12312312312','$2a$12$a/z/aRoCi3rfobh/eqQvcumPuiDz.3KN0fpHq0PrRoiCzlc4MuCY.','35 99123-1234','2026-09-27 20:08:10');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `codFeedback` int NOT NULL AUTO_INCREMENT,
  `nota` int NOT NULL,
  `descricao` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `dataFeedback` datetime NOT NULL DEFAULT (now()),
  `cliente_codCliente` int NOT NULL,
  PRIMARY KEY (`codFeedback`,`cliente_codCliente`),
  KEY `fk_feedback_cliente1_idx` (`cliente_codCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (1,10,'Lanche muito Bom','2025-09-20 17:52:44',3),(2,4,'Mediana','2025-09-20 17:53:00',2),(3,2,'Mal atendimento','2025-11-01 00:37:38',1),(4,2,'a','2025-11-17 12:37:43',2),(5,10,'muito legar','2025-11-17 12:48:51',9);
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fornecedores`
--

DROP TABLE IF EXISTS `fornecedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fornecedores` (
  `codFornecedor` int NOT NULL AUTO_INCREMENT,
  `nomeFornecedor` varchar(150) NOT NULL,
  `cnpj` varchar(45) DEFAULT NULL,
  `endereco` varchar(150) DEFAULT NULL,
  `bairro` varchar(45) DEFAULT NULL,
  `cidade` varchar(45) DEFAULT NULL,
  `estado` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`codFornecedor`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fornecedores`
--

LOCK TABLES `fornecedores` WRITE;
/*!40000 ALTER TABLE `fornecedores` DISABLE KEYS */;
INSERT INTO `fornecedores` VALUES (2,'Pães & Cia LTDA','12.345.678/0001-90','Rua dos Padeiros, 123','Centro','São Paulo','SP'),(3,'Carne Nobre Distribuidora','23.456.789/0001-01','Av. do Açougue, 456','Industrial','Campinas','SP'),(4,'Queijos Brasil Ltda','34.567.890/0001-02','Rua do Laticínio, 789','Vila Rica','Belo Horizonte','MG'),(5,'VerdeFresco Hortifruti','45.678.901/0001-03','Av. das Hortas, 321','Jardim das Flores','Curitiba','PR'),(6,'Molhos Gourmet SA','56.789.012/0001-04','Rua dos Temperos, 654','Sabores','Rio de Janeiro','RJ'),(7,'Bebidas Geladas ME','67.890.123/0001-05','Av. da Bebida, 987','Barra Funda','São Pau','SP'),(8,'a','a','a','a','ads','RS');
/*!40000 ALTER TABLE `fornecedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `funcionario`
--

DROP TABLE IF EXISTS `funcionario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funcionario` (
  `codFuncionario` int NOT NULL AUTO_INCREMENT,
  `nomeFuncionario` varchar(150) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `dataNascimento` date DEFAULT NULL,
  `senhaFuncionario` varchar(60) NOT NULL,
  `cpfFuncionario` varchar(45) DEFAULT NULL,
  `salarioFuncionario` decimal(6,2) NOT NULL,
  `turnos_codTurnos` int NOT NULL,
  `cargo_codCargo` int NOT NULL,
  `disponivel` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`codFuncionario`,`turnos_codTurnos`,`cargo_codCargo`) USING BTREE,
  UNIQUE KEY `uk_funcionario_email` (`email`),
  KEY `fk_funcionario_turnos1_idx` (`turnos_codTurnos`),
  KEY `fk_funcionario_cargo1_idx` (`cargo_codCargo`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funcionario`
--

LOCK TABLES `funcionario` WRITE;
/*!40000 ALTER TABLE `funcionario` DISABLE KEYS */;
INSERT INTO `funcionario` VALUES (2,'Robertinho','robertinho.2@exemplo.test','1900-09-20','$2a$12$gmaZ6ATK1deBG6NO8Vfl3u5W2opRT2rq5U7hkGNNkWAgdn1hiN.8e','210290192',2000.00,1,1,0),(3,'Roberto','roberto.3@exemplo.test','2001-09-13','$2a$12$tPkRw9Nb/.Ox7wJ2cyqATOoLutceQMtK50LjdxQHLCdOmehV/CS8K','dd',2.00,1,1,0),(4,'Rogerio','rogerio.4@exemplo.test','1984-10-29','$2a$12$MfZ3J4lzMAXp2MccIqUV3eLjKdMh2jnIYWj16w3a4rz9ICtT1BFFW','a',1.00,1,1,0),(5,'Roberto Armando','roberto.armando.5@exemplo.test','1984-08-09','$2a$12$itzm4PPlSFAxuLrl9pSdhe6aD4vvca6rnh.TOvV.DSjyFMoQDPUly','092.012.323-12',1000.00,1,3,0),(8,'Vinicius Ozawa','vinicius.ozawa@alunos.ifsuldeminas.edu.br','2005-03-14','$2a$12$/unx8OL8xlNcHWtOU9wUY.8G34EyZC0ExpDWdOGxolt//zOWAwhn2',NULL,4500.00,1,3,0);
/*!40000 ALTER TABLE `funcionario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingrediente`
--

DROP TABLE IF EXISTS `ingrediente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingrediente` (
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
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingrediente`
--

LOCK TABLES `ingrediente` WRITE;
/*!40000 ALTER TABLE `ingrediente` DISABLE KEYS */;
INSERT INTO `ingrediente` VALUES (1,'dd',10.00,'2025-10-25','2025-10-31',23.00,'sds',6),(6,'Pão',62.00,'2025-10-01','2026-03-28',1.50,'Pão artesanal de hambúrguer',2),(7,'Queijo Cheddar',149.00,'2025-11-01','2023-06-30',2.00,'Queijo cheddar derretido',4),(8,'Bacon Crocante',87.00,'2025-12-01','2023-05-30',1.50,'Bacon crocante e frito',3),(9,'Alface',120.00,'2025-11-10','2025-10-16',0.50,'Alface fresca e crocante',5),(17,'Pão Brioche',54.00,'2025-10-01','2026-10-01',1.50,'Pão brioche para hambúrguer',8),(18,'Queijo Cheddar',200.00,'2025-10-01','2026-10-01',2.00,'Queijo cheddar derretido',2),(19,'Bacon Crocante',150.00,'2025-10-01','2026-10-01',1.80,'Bacon crocante e frito',3),(20,'Alface Fresca',120.00,'2025-10-01','2025-12-01',0.50,'Alface fresca e crocante',4),(21,'Molho Especial',100.00,'2025-10-01','2026-10-01',2.00,'Molho especial para hambúrguer',5),(22,'Chocolate em pó',26.00,'2025-10-01','2025-12-01',3.00,'Chocolate em pó para milkshake',6),(23,'Creme de Leite',9.00,'2025-10-01','2026-10-01',2.50,'Creme de leite para milkshake',7),(26,'s',11.00,'2025-11-19','2025-11-19',1.00,'s',3);
/*!40000 ALTER TABLE `ingrediente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesa`
--

DROP TABLE IF EXISTS `mesa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mesa` (
  `codMesa` int NOT NULL AUTO_INCREMENT,
  `numeroMesa` int NOT NULL,
  `localMesa` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`codMesa`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesa`
--

LOCK TABLES `mesa` WRITE;
/*!40000 ALTER TABLE `mesa` DISABLE KEYS */;
INSERT INTO `mesa` VALUES (1,10,'Jogar'),(3,2,'Perto da Cozinha'),(4,1,'Perto entrada'),(5,4,'Bancada'),(7,1,'e'),(8,23,'dsdsds');
/*!40000 ALTER TABLE `mesa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagamento`
--

DROP TABLE IF EXISTS `pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagamento` (
  `codPagamento` int NOT NULL AUTO_INCREMENT,
  `formaPagamento` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `valorPago` decimal(10,2) DEFAULT NULL,
  `dataPagamento` date DEFAULT (now()),
  `statusPagamento` varchar(150) DEFAULT NULL,
  `pedido_codpedido` int NOT NULL,
  `cliente_codCliente` int NOT NULL,
  PRIMARY KEY (`codPagamento`,`pedido_codpedido`),
  KEY `fk_pagamento_pedido1_idx` (`pedido_codpedido`),
  KEY `fk_cliente_pagamento` (`cliente_codCliente`),
  CONSTRAINT `fk_cliente_pagamento` FOREIGN KEY (`cliente_codCliente`) REFERENCES `cliente` (`codCliente`),
  CONSTRAINT `fk_pagamento_pedido1` FOREIGN KEY (`pedido_codpedido`) REFERENCES `pedido` (`codpedido`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagamento`
--

LOCK TABLES `pagamento` WRITE;
/*!40000 ALTER TABLE `pagamento` DISABLE KEYS */;
INSERT INTO `pagamento` VALUES (5,'pix',60.00,'2025-10-29','andademento',1,1),(6,'dinheiro',24.00,'2025-10-31','andamento',3,2),(7,'pix',18.00,'2025-11-04','andamento',15,5),(8,'pix',10.20,'2025-11-18','andamento',17,1),(9,'pix',10.20,'2025-11-18','andamento',18,9),(10,NULL,18.00,'2025-11-23',NULL,40,9),(11,NULL,7.98,'2025-11-24',NULL,43,9),(12,'Dinheiro',36.50,'2025-11-24','pago',44,9),(13,'Dinheiro',269.00,'2025-11-24','andamento',45,9),(14,NULL,16.50,'2025-11-24','andamenento',46,9),(15,NULL,32.90,'2025-11-24','andamenento',47,9),(16,'Dinheiro',252.00,'2025-12-03','pago',48,7),(17,'Dinheiro',102.00,'2025-12-03','pago',49,7),(18,'Pix',16.50,'2026-06-21','andamento',46,9),(23,'pix',24.20,'2026-10-24','pago',53,13);
/*!40000 ALTER TABLE `pagamento` ENABLE KEYS */;
UNLOCK TABLES;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tri_valorTotalPagamento` BEFORE INSERT ON `pagamento` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `codpedido` int NOT NULL AUTO_INCREMENT,
  `cliente_codCliente` int DEFAULT NULL,
  `mesa_codMesa` int NOT NULL,
  `funcionario_codFuncionario` int NOT NULL,
  `datahoraPedido` datetime DEFAULT (now()),
  PRIMARY KEY (`codpedido`),
  KEY `fk_pedido_cliente1_idx` (`cliente_codCliente`),
  KEY `fk_pedido_mesa1_idx` (`mesa_codMesa`),
  KEY `fk_pedido_funcionario1_idx` (`funcionario_codFuncionario`),
  CONSTRAINT `fk_pedido_cliente1` FOREIGN KEY (`cliente_codCliente`) REFERENCES `cliente` (`codCliente`) ON DELETE SET NULL,
  CONSTRAINT `fk_pedido_funcionario1` FOREIGN KEY (`funcionario_codFuncionario`) REFERENCES `funcionario` (`codFuncionario`) ON DELETE CASCADE,
  CONSTRAINT `fk_pedido_mesa1` FOREIGN KEY (`mesa_codMesa`) REFERENCES `mesa` (`codMesa`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
INSERT INTO `pedido` VALUES (1,1,1,2,'2025-09-14 11:52:40'),(2,3,3,2,'2025-09-14 12:34:09'),(3,2,5,2,'2025-09-14 12:34:26'),(4,1,4,2,'2025-09-20 20:19:00'),(15,5,5,3,'2025-10-29 09:23:34'),(17,1,3,2,'2025-11-18 20:44:19'),(18,9,5,3,'2025-11-18 20:56:22'),(21,9,1,2,'2025-11-23 01:09:01'),(22,9,1,2,'2025-11-23 01:26:33'),(25,9,1,2,'2025-11-23 09:33:45'),(26,9,1,2,'2025-11-23 09:37:30'),(27,9,4,4,'2025-11-23 12:19:07'),(29,9,4,2,'2025-11-23 12:21:35'),(31,9,1,2,'2025-11-23 12:23:52'),(34,9,1,2,'2025-11-23 12:32:41'),(35,9,1,2,'2025-11-23 12:37:01'),(36,9,1,2,'2025-11-23 12:41:55'),(37,9,1,2,'2025-11-23 12:44:57'),(38,9,1,2,'2025-11-23 12:53:48'),(39,9,1,2,'2025-11-23 13:00:22'),(40,9,1,2,'2025-11-23 13:01:41'),(41,7,1,2,'2025-11-23 13:51:14'),(42,9,1,2,'2025-11-24 07:16:08'),(43,9,1,2,'2025-11-24 07:55:52'),(44,9,1,2,'2025-11-24 08:13:17'),(45,9,4,4,'2025-11-24 08:19:05'),(46,9,1,2,'2025-11-24 16:31:38'),(47,9,3,4,'2025-11-24 16:36:56'),(48,7,5,5,'2025-12-03 09:09:35'),(49,7,4,2,'2025-12-03 09:48:08'),(53,13,7,4,'2026-08-02 17:16:13');
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_por_cardapio`
--

DROP TABLE IF EXISTS `pedido_por_cardapio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_por_cardapio` (
  `codpedido_por_cardapio` int NOT NULL AUTO_INCREMENT,
  `pedido_idpedido` int NOT NULL,
  `cardapio_codCardapio` int NOT NULL,
  `quantidade` int NOT NULL,
  PRIMARY KEY (`codpedido_por_cardapio`,`pedido_idpedido`,`cardapio_codCardapio`) USING BTREE,
  KEY `fk_pedido_has_cardapio_cardapio1_idx` (`cardapio_codCardapio`),
  KEY `fk_pedido_has_cardapio_pedido1_idx` (`pedido_idpedido`),
  CONSTRAINT `fk_pedido_has_cardapio_cardapio1` FOREIGN KEY (`cardapio_codCardapio`) REFERENCES `cardapio` (`codCardapio`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pedido_has_cardapio_pedido1` FOREIGN KEY (`pedido_idpedido`) REFERENCES `pedido` (`codpedido`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_por_cardapio`
--

LOCK TABLES `pedido_por_cardapio` WRITE;
/*!40000 ALTER TABLE `pedido_por_cardapio` DISABLE KEYS */;
INSERT INTO `pedido_por_cardapio` VALUES (1,1,1,2),(2,1,1,1),(3,2,8,1),(4,3,5,2),(5,2,1,2),(6,2,5,2),(12,1,1,2),(13,1,1,2),(17,2,8,2),(19,15,6,1),(20,17,1,1),(21,18,1,1),(22,25,6,1),(23,26,8,1),(24,26,10,1),(25,26,7,1),(26,29,4,1),(27,31,7,1),(29,34,6,1),(30,35,6,1),(31,35,9,1),(32,36,10,1),(33,37,7,1),(34,37,10,1),(35,37,9,1),(36,38,6,1),(37,39,7,1),(38,40,6,1),(39,41,6,1),(40,42,4,1),(41,43,5,1),(42,44,10,1),(43,44,9,1),(44,45,4,10),(45,46,9,1),(46,47,4,1),(47,47,7,1),(48,48,7,7),(49,48,8,7),(50,48,8,7),(51,49,1,10),(53,15,1,1),(54,1,10,1),(55,1,13,1),(56,1,10,1),(57,53,7,2),(58,53,1,1),(59,4,1,1);
/*!40000 ALTER TABLE `pedido_por_cardapio` ENABLE KEYS */;
UNLOCK TABLES;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tri_atualizarIngredientesInsert` AFTER INSERT ON `pedido_por_cardapio` FOR EACH ROW BEGIN
    UPDATE ingrediente i
    JOIN cardapio_por_ingrediente cpi 
        ON i.codIngrediente = cpi.ingrediente_codIngrediente
    SET i.quantiIngredientes = i.quantiIngredientes - (cpi.quantidadePorComida * NEW.quantidade)
    WHERE cpi.cardapio_codCardapio = NEW.cardapio_codCardapio;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tri_atualizarIngredientesUPDATE` AFTER UPDATE ON `pedido_por_cardapio` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;

--
-- Table structure for table `token_senha`
--

DROP TABLE IF EXISTS `token_senha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_senha` (
  `codToken` int NOT NULL AUTO_INCREMENT,
  `tipoDono` enum('CLIENTE','FUNCIONARIO') NOT NULL,
  `codDono` int NOT NULL,
  `tokenHash` char(64) NOT NULL,
  `criadoEm` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiraEm` datetime NOT NULL,
  `usadoEm` datetime DEFAULT NULL,
  PRIMARY KEY (`codToken`),
  UNIQUE KEY `uk_token_senha_hash` (`tokenHash`),
  KEY `idx_token_senha_dono` (`tipoDono`,`codDono`),
  KEY `idx_token_senha_expira` (`expiraEm`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_senha`
--

LOCK TABLES `token_senha` WRITE;
/*!40000 ALTER TABLE `token_senha` DISABLE KEYS */;
/*!40000 ALTER TABLE `token_senha` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token_verificacao`
--

DROP TABLE IF EXISTS `token_verificacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_verificacao` (
  `codToken` int NOT NULL AUTO_INCREMENT,
  `cliente_codCliente` int NOT NULL,
  `tokenHash` char(64) NOT NULL,
  `criadoEm` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiraEm` datetime NOT NULL,
  `usadoEm` datetime DEFAULT NULL,
  PRIMARY KEY (`codToken`),
  UNIQUE KEY `uk_token_hash` (`tokenHash`),
  KEY `idx_token_cliente` (`cliente_codCliente`),
  CONSTRAINT `fk_token_cliente` FOREIGN KEY (`cliente_codCliente`) REFERENCES `cliente` (`codCliente`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_verificacao`
--

LOCK TABLES `token_verificacao` WRITE;
/*!40000 ALTER TABLE `token_verificacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `token_verificacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `turnos`
--

DROP TABLE IF EXISTS `turnos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `turnos` (
  `codTurnos` int NOT NULL AUTO_INCREMENT,
  `horarioInicio` time DEFAULT NULL,
  `horarioFinal` time DEFAULT NULL,
  PRIMARY KEY (`codTurnos`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `turnos`
--

LOCK TABLES `turnos` WRITE;
/*!40000 ALTER TABLE `turnos` DISABLE KEYS */;
INSERT INTO `turnos` VALUES (1,'09:20:00','20:30:00'),(3,'11:28:00','17:28:00');
/*!40000 ALTER TABLE `turnos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vi_diasclientes`
--

DROP TABLE IF EXISTS `vi_diasclientes`;
/*!50001 DROP VIEW IF EXISTS `vi_diasclientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vi_diasclientes` AS SELECT 
 1 AS `nomeCliente`,
 1 AS `cpfCliente`,
 1 AS `telefone`,
 1 AS `dataCadastro_formatada`,
 1 AS `dias_cadastrado`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vi_feedback`
--

DROP TABLE IF EXISTS `vi_feedback`;
/*!50001 DROP VIEW IF EXISTS `vi_feedback`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vi_feedback` AS SELECT 
 1 AS `nomeCliente`,
 1 AS `telefone`,
 1 AS `DATA_Feedback`,
 1 AS `nota`,
 1 AS `descricao`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vi_funcionarioinformacoes`
--

DROP TABLE IF EXISTS `vi_funcionarioinformacoes`;
/*!50001 DROP VIEW IF EXISTS `vi_funcionarioinformacoes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vi_funcionarioinformacoes` AS SELECT 
 1 AS `nomeFuncionario`,
 1 AS `dataNascimento`,
 1 AS `idade`,
 1 AS `salarioFuncionario`,
 1 AS `nomeCargo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vi_ingredientesfornecedores`
--

DROP TABLE IF EXISTS `vi_ingredientesfornecedores`;
/*!50001 DROP VIEW IF EXISTS `vi_ingredientesfornecedores`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vi_ingredientesfornecedores` AS SELECT 
 1 AS `nomeItem`,
 1 AS `quant`,
 1 AS `descricao`,
 1 AS `data_producao`,
 1 AS `Produtos_Vencendo`,
 1 AS `nomeFornecedor`,
 1 AS `endereco`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vi_pedidoscardapio`
--

DROP TABLE IF EXISTS `vi_pedidoscardapio`;
/*!50001 DROP VIEW IF EXISTS `vi_pedidoscardapio`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vi_pedidoscardapio` AS SELECT 
 1 AS `nomeCliente`,
 1 AS `codpedido`,
 1 AS `nomeComida`,
 1 AS `valorComida`,
 1 AS `quantidade`,
 1 AS `totalItem`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vi_visualizarcardapio`
--

DROP TABLE IF EXISTS `vi_visualizarcardapio`;
/*!50001 DROP VIEW IF EXISTS `vi_visualizarcardapio`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vi_visualizarcardapio` AS SELECT 
 1 AS `nomeComida`,
 1 AS `valorComida`,
 1 AS `descricaoComida`,
 1 AS `nomeCategoria`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'bd_restaurante'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `event_disponibilidadeTrabalho` */;
DELIMITER ;;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `event_disponibilidadeTrabalho` ON SCHEDULE EVERY 1 MINUTE STARTS '2025-10-29 09:35:26' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
-- Verifica se o horário atual está dentro do horário do turno
	UPDATE funcionario f
    inner JOIN turnos t ON f.turnos_codTurnos = t.codTurnos
    SET f.disponivel = 
        CASE
            
            WHEN NOW() BETWEEN t.horarioInicio AND t.horarioFinal THEN TRUE
            ELSE FALSE
   END;
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'bd_restaurante'
--
/*!50003 DROP PROCEDURE IF EXISTS `inserirFeedback` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserirFeedback`(
    IN p_nota INT,
    IN p_descricao VARCHAR(255),
    IN p_cliente_codCliente INT
)
BEGIN
    INSERT INTO feedback (
        nota,
        descricao,
        dataFeedback,
        cliente_codCliente
    )
    VALUES (
        p_nota,
        p_descricao,
        NOW(),
        p_cliente_codCliente
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_alterarCardapio` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_alterarCardapio`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_alterarCategoria` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_alterarCategoria`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_alterarCliente` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_alterarCliente`(
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_alterarFornecedor` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_alterarFornecedor`(
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_alterarFuncionario` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_alterarFuncionario`(
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_alterarMesa` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_alterarMesa`(
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_alterarTurnos` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_alterarTurnos`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_apagarCargo` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_apagarCargo`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_apagarCategoria` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_apagarCategoria`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_apagarCliente` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_apagarCliente`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_apagarFornecedores` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_apagarFornecedores`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_apagarFuncionario` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_apagarFuncionario`(
	IN `entradaCodFuncionario` INT
)
BEGIN


    
   SELECT COUNT(*) INTO @existe
   FROM funcionario
   WHERE codFuncionario = entradaCodFuncionario;

   IF (@existe > 0) THEN
      DELETE FROM funcionario
      WHERE codFuncionario = entradaCodFuncionario;
      

      
   END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_apagarMesa` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_apagarMesa`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_apagarTurnos` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_apagarTurnos`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_insereCardapio` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_insereCardapio`(
	IN `entradaNomeComida` VARCHAR(150),
	IN `entradaValorComida` DECIMAL(6,2),
	IN `entradaDescricaoComida` VARCHAR(500),
	IN `entradaCodCategoria` INT
)
BEGIN
    INSERT INTO cardapio (nomeComida, valorComida, descricaoComida, categoria_codCategoria)
    VALUES(entradaNomeComida, entradaValorComida, entradaDescricaoComida, entradaCodCategoria);

    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_insereCategoria` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_insereCategoria`(
	IN `entradaCategoria` VARCHAR(500)
)
BEGIN
    INSERT INTO categoria(nomeCategoria) VALUES(entradaCategoria);
    SELECT * FROM categoria;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_insereCliente` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_insereCliente`(
	IN `entradaNome` VARCHAR(150),
	IN `entradaCpf` VARCHAR(45),
	IN `entradaSenha` VARCHAR(150),
	IN `entradaTelefone` VARCHAR(50)
)
BEGIN
    INSERT INTO cliente(nomeCliente, cliente.cpfCliente, cliente.senhaCliente, cliente.telefone)
    VALUES(entradaNome, entradaCpf, entradaSenha, entradaTelefone);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_insereFornecedor` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_insereFornecedor`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_insereFuncionario` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_insereFuncionario`(
	IN `entradaNome` VARCHAR(150),
	IN `entradaNascimento` DATE,
	IN `entradaSenha` VARCHAR(45),
	IN `entradaCpf` VARCHAR(45),
	IN `entradaSalario` DECIMAL(6,2),
	IN `entradaCargo` INT,
	IN `entradacodTurno` INT,
	IN `entradaDisponivel` TINYTEXT
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
      entradaDisponivel
    );
    SELECT 'Funcionário inserido com sucesso!' AS Resultado;
  		ELSEIF (@contadorTurno = 0) THEN
    		SELECT 'Turno não cadastrado' AS Erro;
  ELSE
    	SELECT 'Cargo não cadastrado' AS Erro;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_insereIngrediente` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_insereIngrediente`(
	IN `p_nomeItem` VARCHAR(150),
	IN `p_quant` DECIMAL(6,2),
	IN `p_dataProducao` DATE,
	IN `p_dataVencimento` DATE,
	IN `p_valor` DECIMAL(6,2),
	IN `p_descricao` VARCHAR(300),
	IN `p_Fornecedores` INT
)
BEGIN
    INSERT INTO ingrediente (
      	ingrediente.nomeIngredientes,
        ingrediente.quantiIngredientes,
        ingrediente.dataProducao,
        ingrediente.dataVencimento,
        ingrediente.valorIngrediente,
        ingrediente.descricaoIngrediente,
        ingrediente.fornecedores_codFornecedor
    ) VALUES (
        p_nomeItem,
        p_quant,
        p_dataProducao,
        p_dataVencimento,
        p_valor,
        p_descricao,
        p_Fornecedores
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_insereMesa` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_insereMesa`(
	IN `entradaNumeroMesa` INT,
	IN `entradaLocalMesa` VARCHAR(150)
)
BEGIN
    INSERT INTO mesa(numeroMesa, localMesa) 
    VALUES(entradaNumeroMesa, entradaLocalMesa);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_inserePedido` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_inserePedido`(
	IN `p_codCliente` INT,
	IN `p_codMesa` INT,
	IN `p_codFuncionario` INT
)
BEGIN
    INSERT INTO pedido (
        cliente_codCliente,
        mesa_codMesa,
        funcionario_codFuncionario,
        datahoraPedido
    ) VALUES (
        p_codCliente,
        p_codMesa,
        p_codFuncionario,
        NOW()  -- ou CURRENT_TIMESTAMP
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_insereTurnos` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_insereTurnos`(
    IN `entradaHorarioInicio` TIME,
    IN `entradaHorarioFinal` TIME
)
BEGIN
    INSERT INTO turnos(horarioInicio , horarioFinal)
    VALUES(entradaHorarioInicio, entradaHorarioFinal);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_relatorioCardapio` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_relatorioCardapio`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_relatorioClientes` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_relatorioClientes`(
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
   end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_relatorioFuncionario` */;
ALTER DATABASE `bd_restaurante` CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_relatorioFuncionario`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `bd_restaurante` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;

--
-- Final view structure for view `vi_diasclientes`
--

/*!50001 DROP VIEW IF EXISTS `vi_diasclientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vi_diasclientes` AS select `c`.`nomeCliente` AS `nomeCliente`,`c`.`cpfCliente` AS `cpfCliente`,`c`.`telefone` AS `telefone`,date_format(`c`.`dataCadastro`,'%d/%m/%Y') AS `dataCadastro_formatada`,(to_days(curdate()) - to_days(`c`.`dataCadastro`)) AS `dias_cadastrado` from `cliente` `c` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vi_feedback`
--

/*!50001 DROP VIEW IF EXISTS `vi_feedback`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vi_feedback` AS select `c`.`nomeCliente` AS `nomeCliente`,`c`.`telefone` AS `telefone`,date_format(`f`.`dataFeedback`,'%d/%m/%Y %H:%i:%s') AS `DATA_Feedback`,`f`.`nota` AS `nota`,`f`.`descricao` AS `descricao` from (`cliente` `c` join `feedback` `f` on((`c`.`codCliente` = `f`.`cliente_codCliente`))) order by `f`.`dataFeedback` desc */
/*!50002 WITH CASCADED CHECK OPTION */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vi_funcionarioinformacoes`
--

/*!50001 DROP VIEW IF EXISTS `vi_funcionarioinformacoes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vi_funcionarioinformacoes` AS select `f`.`nomeFuncionario` AS `nomeFuncionario`,date_format(`f`.`dataNascimento`,'%d/%m/%Y') AS `dataNascimento`,floor(((to_days(curdate()) - to_days(`f`.`dataNascimento`)) / 365)) AS `idade`,`f`.`salarioFuncionario` AS `salarioFuncionario`,`c`.`nomeCargo` AS `nomeCargo` from (`funcionario` `f` join `cargo` `c` on((`f`.`cargo_codCargo` = `c`.`codCargo`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vi_ingredientesfornecedores`
--

/*!50001 DROP VIEW IF EXISTS `vi_ingredientesfornecedores`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vi_ingredientesfornecedores` AS select `i`.`nomeIngredientes` AS `nomeItem`,`i`.`quantiIngredientes` AS `quant`,`i`.`descricaoIngrediente` AS `descricao`,date_format(`i`.`dataProducao`,'%d/%m/%Y') AS `data_producao`,date_format(`i`.`dataVencimento`,'%d/%m/%Y') AS `Produtos_Vencendo`,`f`.`nomeFornecedor` AS `nomeFornecedor`,`f`.`endereco` AS `endereco` from (`ingrediente` `i` join `fornecedores` `f` on((`i`.`fornecedores_codFornecedor` = `f`.`codFornecedor`))) order by `i`.`dataVencimento` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vi_pedidoscardapio`
--

/*!50001 DROP VIEW IF EXISTS `vi_pedidoscardapio`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vi_pedidoscardapio` AS select `cl`.`nomeCliente` AS `nomeCliente`,`p`.`codpedido` AS `codpedido`,`c`.`nomeComida` AS `nomeComida`,`c`.`valorComida` AS `valorComida`,`pc`.`quantidade` AS `quantidade`,(`c`.`valorComida` * `pc`.`quantidade`) AS `totalItem` from (((`pedido` `p` join `pedido_por_cardapio` `pc` on((`p`.`codpedido` = `pc`.`pedido_idpedido`))) join `cardapio` `c` on((`pc`.`cardapio_codCardapio` = `c`.`codCardapio`))) join `cliente` `cl` on((`p`.`cliente_codCliente` = `cl`.`codCliente`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vi_visualizarcardapio`
--

/*!50001 DROP VIEW IF EXISTS `vi_visualizarcardapio`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vi_visualizarcardapio` AS select `c`.`nomeComida` AS `nomeComida`,`c`.`valorComida` AS `valorComida`,`c`.`descricaoComida` AS `descricaoComida`,`cat`.`nomeCategoria` AS `nomeCategoria` from (`cardapio` `c` join `categoria` `cat` on((`c`.`categoria_codCategoria` = `cat`.`codCategoria`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
