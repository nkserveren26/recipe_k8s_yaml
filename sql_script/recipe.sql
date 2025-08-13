-- MySQL dump 10.13  Distrib 8.3.0, for Win64 (x86_64)
--
-- Host: localhost    Database: recipe
-- ------------------------------------------------------
-- Server version	8.3.0

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
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'fish'),(2,'beef'),(3,'vegetable'),(4,'soup');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipe`
--

DROP TABLE IF EXISTS `recipe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipe` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `servings` int NOT NULL,
  `image` varchar(2000) DEFAULT NULL,
  `video_url` varchar(2000) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `recipe_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipe`
--

LOCK TABLES `recipe` WRITE;
/*!40000 ALTER TABLE `recipe` DISABLE KEYS */;
INSERT INTO `recipe` VALUES (3,1,'アクアパッツァ',1,'https://testbucket-kn.s3.ap-northeast-1.amazonaws.com/d65ab0cf-cdc0-41f7-8585-bb60b84df6a7-aqqua_pazza.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250306T234730Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIA35VNPSRFWP6IVIHI%2F20250306%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Expires=604800&X-Amz-Signature=ba7fa736a4c0fa9166acf6033841a2439f1f2f0a6350e427fc675d79e61b0307','https://www.youtube.com/watch?v=b06xfSfwqjc','2024-09-13 08:22:12'),(24,1,'ブリの照り焼き',2,'https://testbucket-kn.s3.ap-northeast-1.amazonaws.com/29ae1527-0425-4ba3-8316-867a3fe5415b-buri_teriyaki.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250306T234742Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIA35VNPSRFWP6IVIHI%2F20250306%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Expires=604800&X-Amz-Signature=e7db097f39341b34b6cab7f0a43ba222f68edd5726e208c964473b05ee56fbff','https://www.kurashiru.com/recipes/6d35d433-54de-4123-907c-9e4204e8a746','2025-02-14 08:39:26'),(25,1,'アボカドとサーモンのユッケ丼',1,'https://testbucket-kn.s3.ap-northeast-1.amazonaws.com/4beb22ed-4f39-47d0-86d5-76cc87f793ea-salmon_abocado.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250306T234744Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIA35VNPSRFWP6IVIHI%2F20250306%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Expires=604800&X-Amz-Signature=7e8153e569afe821e2782295380a76647ad82d0d6da67b1e4f70a6c27e43c654','https://www.kurashiru.com/recipes/99e2a4a7-b3ae-491a-a1c9-8be68bf10fd1','2025-02-14 08:46:00'),(26,2,'簡単ふわとろ！親子丼',1,'https://testbucket-kn.s3.ap-northeast-1.amazonaws.com/66604b1a-171f-4828-b56c-39f2f1500e05-2025-02-16_09h47_56.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250216T004850Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIA35VNPSRFWP6IVIHI%2F20250216%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Expires=604800&X-Amz-Signature=f84e66417a03a010b74e53b8b0d39159bdbddac25b29c253a94ecdeb6f0187b0','https://www.youtube.com/watch?v=b06xfSfwqjc','2025-02-16 09:48:47'),(27,2,'ご飯が進む！豚肉の生姜焼き',1,'https://testbucket-kn.s3.ap-northeast-1.amazonaws.com/df449905-259f-4428-a316-fdd3c16528d4-2025-02-16_09h51_06.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250216T005202Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIA35VNPSRFWP6IVIHI%2F20250216%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Expires=604800&X-Amz-Signature=4787cece6a9c99725e20332bc941215c412db1a042949923570c58ef20a5ec26','https://www.kurashiru.com/recipes/6c351dfe-0252-4506-bafa-1e03169052d2','2025-02-16 09:52:01'),(28,2,'優しい味がしみる！肉じゃが',1,'https://testbucket-kn.s3.ap-northeast-1.amazonaws.com/4cb51ec7-fc2f-468f-98c9-f5520a766238-2025-02-16_09h54_36.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250216T010157Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIA35VNPSRFWP6IVIHI%2F20250216%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Expires=604800&X-Amz-Signature=9b1d1947b3cd9a89aae91f1febe5b8a798f2d317a34b27d50b2d32ad1999d2c8','https://www.kurashiru.com/recipes/f7d94909-d3e2-4eb0-8838-a60edc674ccd','2025-02-16 10:01:55'),(29,3,'ピーマンの炒めナムル',1,'https://testbucket-kn.s3.ap-northeast-1.amazonaws.com/d578ff48-c74e-4a1e-b5f8-6ed0b98bbbea-green_pepper.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250218T234404Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIA35VNPSRFWP6IVIHI%2F20250218%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Expires=604800&X-Amz-Signature=5c25225d304705ec1ab6eb2511f5a4cb63e395335b4c8006c34dfd1220e5ea71','https://www.youtube.com/watch?v=Hg4ZTVBhCO4&list=WL','2025-02-19 08:43:57'),(30,3,'ほうれん草とベーコンのバターソテー',1,'https://testbucket-kn.s3.ap-northeast-1.amazonaws.com/e60990aa-a013-456a-89b5-40264cce8e5f-2025-02-19_08h47_14.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250218T234757Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIA35VNPSRFWP6IVIHI%2F20250218%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Expires=604800&X-Amz-Signature=aab661d93a3238d09488a97f9820014b191ffb3078617f0097ec8ca39d9ace22','https://www.youtube.com/watch?v=D4HKdMb70c0','2025-02-19 08:47:55'),(31,3,'さつまいもの甘辛煮',1,'https://testbucket-kn.s3.ap-northeast-1.amazonaws.com/5296f8c0-9475-4787-8792-961d18bf786e-2025-02-19_08h51_21.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250218T235152Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIA35VNPSRFWP6IVIHI%2F20250218%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Expires=604800&X-Amz-Signature=24e35f890ea3479b0bbe94edd62879250e849091ac35abfea5eeae7497e118db','https://www.youtube.com/watch?v=FA_Cusv-DVU','2025-02-19 08:51:52'),(32,4,'卵とわかめの春雨スープ',1,'https://testbucket-kn.s3.ap-northeast-1.amazonaws.com/07d5dcf0-d67e-4d3e-925c-e6ad162e86d0-2025-02-20_08h15_49.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250219T231633Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIA35VNPSRFWP6IVIHI%2F20250219%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Expires=604800&X-Amz-Signature=c7a66302413f718060b02cf0098dc8c62e5112bdb89c49614b373177678a9996','https://www.youtube.com/watch?v=qhMojLDUNqQ','2025-02-20 08:16:30'),(33,4,'具沢山ミネストローネ',1,'https://testbucket-kn.s3.ap-northeast-1.amazonaws.com/daaa67f6-ae5b-41aa-b83e-0b5dd0eb3ad7-2025-02-20_08h18_18.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250219T231925Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIA35VNPSRFWP6IVIHI%2F20250219%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Expires=604800&X-Amz-Signature=2b37c49d7f11a52471f54b49167a1d5766bdf04775ba493c762d1eecee261fa5','https://www.youtube.com/watch?v=b06xfSfwqjc','2025-02-20 08:19:25'),(34,4,'ポカポカあたたまる 飴色玉ねぎスープ',1,'https://testbucket-kn.s3.ap-northeast-1.amazonaws.com/922d0a45-140c-4ce7-84db-68b5c239b669-2025-02-20_08h20_06.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250219T232054Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIA35VNPSRFWP6IVIHI%2F20250219%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Expires=604800&X-Amz-Signature=a6e98f0d77eea4122d060364daf05836342d1a88905b1c2af838bc0c5091a8aa','https://www.youtube.com/watch?v=b06xfSfwqjc','2025-02-20 08:20:53');
/*!40000 ALTER TABLE `recipe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipe_ingredient`
--

DROP TABLE IF EXISTS `recipe_ingredient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipe_ingredient` (
  `id` int NOT NULL AUTO_INCREMENT,
  `recipe_id` int DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `amount` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `recipe_ingredient_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipe_ingredient`
--

LOCK TABLES `recipe_ingredient` WRITE;
/*!40000 ALTER TABLE `recipe_ingredient` DISABLE KEYS */;
INSERT INTO `recipe_ingredient` VALUES (1,3,'カレイ','200g'),(2,3,'塩','小さじ1/2'),(3,3,'アサリ (170g)','10個'),(4,3,'ミニトマト','6個'),(5,3,'水','400ml'),(6,3,'EVオリーブオイル (焼く用)','大さじ1'),(7,3,'EVオリーブオイル (仕上げ用)','50ml'),(8,3,'イタリアンパセリ','適量'),(34,24,'ブリ','2切れ'),(35,25,'ごはん','200g'),(36,26,'もも肉','10g'),(37,27,'豚ロース (薄切り)','300g'),(38,28,'肉','10g'),(39,29,'ピーマン','3個'),(40,30,'ほうれん草','3束'),(41,31,'さつまいも','200g'),(42,32,'わかめ','10g'),(43,33,'たまねぎ','2個'),(44,34,'玉ねぎ','1個');
/*!40000 ALTER TABLE `recipe_ingredient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipe_point`
--

DROP TABLE IF EXISTS `recipe_point`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipe_point` (
  `id` int NOT NULL AUTO_INCREMENT,
  `recipe_id` int DEFAULT NULL,
  `point` varchar(400) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `recipe_point_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipe_point`
--

LOCK TABLES `recipe_point` WRITE;
/*!40000 ALTER TABLE `recipe_point` DISABLE KEYS */;
INSERT INTO `recipe_point` VALUES (1,3,'塩加減は、お好みで調整してください。手順7で煮汁が少なくなった場合は、水を加えて調整してください。'),(21,24,''),(22,25,''),(23,26,''),(24,27,''),(25,28,''),(26,29,'ああああ'),(27,30,'ううううう'),(28,31,'おおおおお'),(29,32,''),(30,33,''),(31,34,'');
/*!40000 ALTER TABLE `recipe_point` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipe_step`
--

DROP TABLE IF EXISTS `recipe_step`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipe_step` (
  `id` int NOT NULL AUTO_INCREMENT,
  `recipe_id` int DEFAULT NULL,
  `step_number` int NOT NULL,
  `description` varchar(400) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `recipe_step_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipe_step`
--

LOCK TABLES `recipe_step` WRITE;
/*!40000 ALTER TABLE `recipe_step` DISABLE KEYS */;
INSERT INTO `recipe_step` VALUES (1,3,0,'あさりは砂抜きし、貝同士を擦り合わせて洗っておきます。 イタリアンパセリはみじん切りにしておきます。 ミニトマトはヘタを取っておきます。'),(2,3,1,'ミニトマトは横半分に切ります。'),(3,3,2,'カレイは両面に1本ずつ切りこみを入れ、塩を全体にふり、まんべんなくまぶします。'),(4,3,3,'フライパンを強火で熱しEVオリーブオイルをひいたら2を入れます。'),(5,3,4,'弱火で焼き色がつくまで3分ほど焼きます。'),(6,3,5,'焼き色がついたら裏返して反対面を弱火で2分ほど焼きます。'),(7,3,6,'両面に焼き色が付いたら強火にして水を加えます。カレイに煮汁をかけながら2分ほど加熱し、アサリを加えます。'),(8,3,7,'煮汁をカレイにかけながら強火で3分ほど煮込み、カレイに火が通り、アサリの殻が開いたら1を加えます。'),(9,3,8,'全体がなじむまで1分ほど煮込んだら、EVオリーブオイルを加え、煮汁を全体にかけながら乳化するまで30秒ほど強火で煮込みます。'),(10,3,9,'弱火にしてイタリアンパセリを加えたら火から下ろし、お皿に盛り付けて完成です。'),(35,24,1,'ブリは塩をふり、10分ほど置きます。'),(36,25,0,'アボカドは皮をむき、種を取っておきます。'),(37,26,0,'かいわれ大根の根元は切り落としておきます。'),(38,27,0,'キャベツは芯を切り落としておきます。'),(39,28,0,'じゃがいもは芽を取り除き、皮を剥いておきます。 にんじんは皮を剥いておきます。しらたきは水気を切っておきます。'),(40,29,1,'ピーマンを千切りにする。'),(41,30,1,'おおおおお'),(42,31,1,'おおおおお'),(43,32,1,'おおおおお'),(44,33,1,'ううううう'),(45,34,1,'あああああ');
/*!40000 ALTER TABLE `recipe_step` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-29  9:13:11
