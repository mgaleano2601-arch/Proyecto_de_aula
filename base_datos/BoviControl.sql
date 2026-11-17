-- MySQL dump 10.13  Distrib 8.4.4, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bovicontrol_taller
-- ------------------------------------------------------
-- Server version	8.4.4

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
-- Table structure for table `cuenta_estado_usuario`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuenta_estado_usuario` (
  `usuario_id` bigint NOT NULL,
  `estado` varchar(30) NOT NULL,
  `creada_en` datetime NOT NULL,
  `aprobada_en` datetime DEFAULT NULL,
  PRIMARY KEY (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuenta_estado_usuario`
--

/*!40000 ALTER TABLE `cuenta_estado_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `cuenta_estado_usuario` ENABLE KEYS */;

--
-- Table structure for table `ganado`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ganado` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `codigo_identificacion` varchar(50) NOT NULL,
  `edad` double NOT NULL,
  `estado_salud` varchar(50) NOT NULL,
  `marca_hierro` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `numero_arete` varchar(30) NOT NULL,
  `peso` double NOT NULL,
  `propietario` varchar(100) NOT NULL,
  `raza` varchar(50) NOT NULL,
  `sexo` varchar(20) NOT NULL,
  `unidad_tiempo_edad` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKacqogf9327p7d6r917tl00rp9` (`codigo_identificacion`),
  UNIQUE KEY `UKmb48b5auvidgfnimlumm3w2jm` (`numero_arete`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ganado`
--

/*!40000 ALTER TABLE `ganado` DISABLE KEYS */;
INSERT INTO `ganado` VALUES (1,'BOV-2026-F9B666',3,'Demostración','DEMO','Bovino demo 1','DEMO-01',400,'Datos sintéticos del taller','Demostración','Hembra','años'),(2,'BOV-2026-65CD89',3,'Demostración','DEMO','Bovino demo 2','DEMO-02',400,'Datos sintéticos del taller','Demostración','Hembra','años'),(3,'BOV-2026-4F01EE',3,'Demostración','DEMO','Bovino demo 3','DEMO-03',400,'Datos sintéticos del taller','Demostración','Hembra','años'),(4,'BOV-2026-90CB5F',3,'Demostración','DEMO','Bovino demo 4','DEMO-04',400,'Datos sintéticos del taller','Demostración','Hembra','años'),(5,'BOV-2026-5B8B3A',3,'Demostración','DEMO','Bovino demo 5','DEMO-05',400,'Datos sintéticos del taller','Demostración','Hembra','años'),(6,'BOV-2026-3CFABA',3,'Demostración','DEMO','Bovino demo 6','DEMO-06',400,'Datos sintéticos del taller','Demostración','Hembra','años');
/*!40000 ALTER TABLE `ganado` ENABLE KEYS */;

--
-- Table structure for table `invitacion`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invitacion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) NOT NULL,
  `correo` varchar(254) NOT NULL,
  `token_hash` varchar(64) NOT NULL,
  `creada_en` datetime NOT NULL,
  `expira_en` datetime NOT NULL,
  `usada_en` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_invitacion_token_hash` (`token_hash`),
  KEY `ix_invitacion_correo` (`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invitacion`
--

/*!40000 ALTER TABLE `invitacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `invitacion` ENABLE KEYS */;

--
-- Table structure for table `io_atencion`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `io_atencion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `duration_minutes` int NOT NULL,
  `fecha` date NOT NULL,
  `name` varchar(120) NOT NULL,
  `priority` int NOT NULL,
  `topic` varchar(60) NOT NULL,
  `vacuna_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKfs3psbng034tw7ns9qo2eqwa7` (`fecha`,`vacuna_id`),
  CONSTRAINT `io_atencion_chk_1` CHECK (((`duration_minutes` <= 480) and (`duration_minutes` >= 1))),
  CONSTRAINT `io_atencion_chk_2` CHECK (((`priority` <= 3) and (`priority` >= 1)))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `io_atencion`
--

/*!40000 ALTER TABLE `io_atencion` DISABLE KEYS */;
INSERT INTO `io_atencion` VALUES (1,40,'2026-11-04','BOV-DEMO-01 / dosis A',3,'Norte',1),(2,30,'2026-11-04','BOV-DEMO-02 / dosis B',2,'Norte',2),(3,20,'2026-11-04','BOV-DEMO-03 / dosis C',1,'Norte',3),(4,30,'2026-11-04','BOV-DEMO-04 / dosis D',3,'Sur',4),(5,30,'2026-11-04','BOV-DEMO-05 / dosis E',2,'Sur',5),(6,20,'2026-11-04','BOV-DEMO-06 / dosis F',3,'Oriente',6);
/*!40000 ALTER TABLE `io_atencion` ENABLE KEYS */;

--
-- Table structure for table `io_run`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `io_run` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `creada_en` datetime(6) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `request_json` longtext,
  `response_json` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `io_run`
--

/*!40000 ALTER TABLE `io_run` DISABLE KEYS */;
INSERT INTO `io_run` VALUES (1,'2026-11-04 13:54:26.943893','2026-11-04','{\"attentions\":[{\"id\":1,\"name\":\"BOV-DEMO-01 / dosis A\",\"topic\":\"Norte\",\"priority\":3,\"durationMinutes\":40},{\"id\":2,\"name\":\"BOV-DEMO-02 / dosis B\",\"topic\":\"Norte\",\"priority\":2,\"durationMinutes\":30},{\"id\":3,\"name\":\"BOV-DEMO-03 / dosis C\",\"topic\":\"Norte\",\"priority\":1,\"durationMinutes\":20},{\"id\":4,\"name\":\"BOV-DEMO-04 / dosis D\",\"topic\":\"Sur\",\"priority\":3,\"durationMinutes\":30},{\"id\":5,\"name\":\"BOV-DEMO-05 / dosis E\",\"topic\":\"Sur\",\"priority\":2,\"durationMinutes\":30},{\"id\":6,\"name\":\"BOV-DEMO-06 / dosis F\",\"topic\":\"Oriente\",\"priority\":3,\"durationMinutes\":20}],\"veterinarians\":[{\"id\":1,\"name\":\"Veterinaria demo Norte\",\"specialty\":\"Norte\",\"maxCapacity\":2,\"availableMinutes\":60,\"available\":true},{\"id\":2,\"name\":\"Veterinario demo Sur\",\"specialty\":\"Sur\",\"maxCapacity\":1,\"availableMinutes\":30,\"available\":true},{\"id\":3,\"name\":\"Veterinaria demo sin turno\",\"specialty\":\"Oriente\",\"maxCapacity\":2,\"availableMinutes\":60,\"available\":false}]}','{\"status\":\"Optimal\",\"objectiveValue\":7,\"assignments\":[{\"attentionId\":1,\"attentionName\":\"BOV-DEMO-01 / dosis A\",\"veterinarianId\":1,\"veterinarianName\":\"Veterinaria demo Norte\",\"score\":3,\"durationMinutes\":40},{\"attentionId\":3,\"attentionName\":\"BOV-DEMO-03 / dosis C\",\"veterinarianId\":1,\"veterinarianName\":\"Veterinaria demo Norte\",\"score\":1,\"durationMinutes\":20},{\"attentionId\":4,\"attentionName\":\"BOV-DEMO-04 / dosis D\",\"veterinarianId\":2,\"veterinarianName\":\"Veterinario demo Sur\",\"score\":3,\"durationMinutes\":30}],\"unassigned\":[{\"attentionId\":2,\"attentionName\":\"BOV-DEMO-02 / dosis B\",\"reason\":\"No seleccionada en esta solución óptima con los recursos disponibles\"},{\"attentionId\":5,\"attentionName\":\"BOV-DEMO-05 / dosis E\",\"reason\":\"No seleccionada en esta solución óptima con los recursos disponibles\"},{\"attentionId\":6,\"attentionName\":\"BOV-DEMO-06 / dosis F\",\"reason\":\"Sin veterinario disponible y compatible\"}],\"loads\":[{\"veterinarianId\":1,\"veterinarianName\":\"Veterinaria demo Norte\",\"assignedCount\":2,\"usedMinutes\":60,\"maxCapacity\":2,\"availableMinutes\":60},{\"veterinarianId\":2,\"veterinarianName\":\"Veterinario demo Sur\",\"assignedCount\":1,\"usedMinutes\":30,\"maxCapacity\":1,\"availableMinutes\":30},{\"veterinarianId\":3,\"veterinarianName\":\"Veterinaria demo sin turno\",\"assignedCount\":0,\"usedMinutes\":0,\"maxCapacity\":2,\"availableMinutes\":60}]}');
/*!40000 ALTER TABLE `io_run` ENABLE KEYS */;

--
-- Table structure for table `io_turno`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `io_turno` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `available` bit(1) NOT NULL,
  `available_minutes` int NOT NULL,
  `fecha` date NOT NULL,
  `max_capacity` int NOT NULL,
  `name` varchar(120) NOT NULL,
  `specialty` varchar(60) NOT NULL,
  `usuario_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKeddthjbng8tefgrgq86qxbr3h` (`fecha`,`usuario_id`),
  CONSTRAINT `io_turno_chk_1` CHECK (((`available_minutes` >= 0) and (`available_minutes` <= 480))),
  CONSTRAINT `io_turno_chk_2` CHECK (((`max_capacity` <= 100) and (`max_capacity` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `io_turno`
--

/*!40000 ALTER TABLE `io_turno` DISABLE KEYS */;
INSERT INTO `io_turno` VALUES (1,_binary '',60,'2026-11-04',2,'Veterinaria demo Norte','Norte',2),(2,_binary '',30,'2026-11-04',1,'Veterinario demo Sur','Sur',3),(3,_binary '\0',60,'2026-11-04',2,'Veterinaria demo sin turno','Oriente',4);
/*!40000 ALTER TABLE `io_turno` ENABLE KEYS */;

--
-- Table structure for table `leche_registro`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leche_registro` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ganado_id` bigint NOT NULL,
  `fecha_registro` date NOT NULL,
  `turno` varchar(20) NOT NULL,
  `litros` decimal(10,2) NOT NULL,
  `observacion` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_leche_registro` (`ganado_id`,`fecha_registro`,`turno`),
  CONSTRAINT `fk_leche_registro_ganado` FOREIGN KEY (`ganado_id`) REFERENCES `ganado` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leche_registro`
--

/*!40000 ALTER TABLE `leche_registro` DISABLE KEYS */;
/*!40000 ALTER TABLE `leche_registro` ENABLE KEYS */;

--
-- Table structure for table `usuario`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `correo` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `rol` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'admin@bovicontrol.test','Administrador demo','$2a$10$8PZIHhRvulEDO9YlIcoS1edExtBlKdt8ZWV/HsF7sgFyVbaFVKfTy','ADMIN'),(2,'vet1@bovicontrol.test','Veterinaria demo Norte','$2a$10$kS0YVEVuuVm0s/IYIG.FVulk.upIk.uiJKEzbFLbdhNoHMDNsfu3K','VETERINARIO'),(3,'vet2@bovicontrol.test','Veterinario demo Sur','$2a$10$PnVgcVR/Y9bFAjrdjGKD0OkpVZ17Dy.TdIBZrcpD34L3hArLjVn0O','VETERINARIO'),(4,'vet3@bovicontrol.test','Veterinaria demo sin turno','$2a$10$mUEzX/mz9C.seYtshUp7iuk8PPsxzeeP.b587nd7hEoDtFbrS6HsK','VETERINARIO');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;

--
-- Table structure for table `vacuna`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vacuna` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `estado` varchar(50) DEFAULT NULL,
  `fecha_aplicacion` date NOT NULL,
  `intervalo_cantidad` int DEFAULT NULL,
  `intervalo_meses` int DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `proxima_dosis` date DEFAULT NULL,
  `unidad_tiempo` varchar(20) DEFAULT NULL,
  `ganado_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKtimv81mxb9b10p8g0389s73ye` (`ganado_id`),
  CONSTRAINT `FKtimv81mxb9b10p8g0389s73ye` FOREIGN KEY (`ganado_id`) REFERENCES `ganado` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vacuna`
--

/*!40000 ALTER TABLE `vacuna` DISABLE KEYS */;
INSERT INTO `vacuna` VALUES (1,'Vencida','2026-05-04',6,6,'Dosis demo A','2026-11-03','meses',1),(2,'Vencida','2026-05-04',6,6,'Dosis demo B','2026-11-02','meses',2),(3,'Vencida','2026-05-04',6,6,'Dosis demo C','2026-11-01','meses',3),(4,'Vencida','2026-05-04',6,6,'Dosis demo D','2026-10-31','meses',4),(5,'Vencida','2026-05-04',6,6,'Dosis demo E','2026-10-30','meses',5),(6,'Vencida','2026-05-04',6,6,'Dosis demo F','2026-10-29','meses',6);
/*!40000 ALTER TABLE `vacuna` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-05 16:10:40
